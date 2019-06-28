import 'package:flutter/widgets.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/juejin_manager.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/redux/home/home_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:open_git/util/update_util.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';

class HomeMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "HomeMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchHomeAction) {
      _fetchHomes(store, next, 1, RefreshStatus.idle);
      _handleUpdate(next, action.context);
    } else if (action is RefreshAction && action.type == ListPageType.home) {
      _handleRefreshAction(store, action, next);
    }
  }

  //处理app升级逻辑
  void _handleUpdate(NextDispatcher next, BuildContext context) {
    ReposManager.instance
        .getReposReleases('Yuzopro', 'OpenGit_Flutter')
        .then((result) {
      if (result != null && result.length > 0) {
        ReleaseBean bean = result[0];
        if (bean != null) {
          PackageInfo.fromPlatform().then((info) {
            if (info != null) {
              String version = info.version;
              String serverVersion = bean.name;
              int compare = UpdateUtil.compareVersion(version, serverVersion);
              if (compare == -1) {
                String url = "";
                if (bean.assets != null && bean.assets.length > 0) {
                  ReleaseAssetBean assetBean = bean.assets[0];
                  if (assetBean != null) {
                    url = assetBean.downloadUrl;
                  }
                }
                UpdateUtil.showUpdateDialog(context, bean.name, bean.body, url);
              }
            }
          });
        }
      }
    }).catchError((_) {});
  }

  //处理列表页面下拉和加载更多
  void _handleRefreshAction(
      Store<AppState> store, action, NextDispatcher next) {
    RefreshStatus status = action.refreshStatus;
    ListPageType type = action.type;
    LogUtil.v(
        '_handleRefreshAction status is ' +
            status.toString() +
            "@type is " +
            type.toString(),
        tag: TAG);
    if (status == RefreshStatus.refresh) {
      next(ResetPageAction(type));
    } else if (status == RefreshStatus.loading) {
      next(IncreasePageAction(type));
    }
    _fetchHomes(store, next, store.state.homeState.page, status);
  }

  Future<void> _fetchHomes(Store<AppState> store, NextDispatcher next, int page,
      RefreshStatus status) async {
    List<Entrylist> homes = store.state.homeState.homes;

    if (status == RefreshStatus.idle) {
      next(RequestingHomesAction());
    }
    try {
      final list = await JueJinManager.instance.getJueJinList(page);
      RefreshStatus newStatus = status;
      if (status == RefreshStatus.refresh || status == RefreshStatus.idle) {
        homes.clear();
      }
      if (list != null && list.length > 0) {
        if (list.length < Config.PAGE_SIZE) {
          if (status == RefreshStatus.refresh) {
            newStatus = RefreshStatus.refresh_no_data;
          } else {
            newStatus = RefreshStatus.loading_no_data;
          }
        }
        homes.addAll(list);
      }
      next(ReceivedHomesAction(homes, newStatus));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingHomesAction());
    }
  }
}
