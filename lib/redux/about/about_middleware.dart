import 'package:flutter/widgets.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/about/about_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/util/toast_util.dart';
import 'package:open_git/util/update_util.dart';
import 'package:package_info/package_info.dart';
import 'package:redux/redux.dart';

class AboutMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "AboutMiddleware";

  @override
  void call(Store store, action, NextDispatcher next) {
    next(action);
    if (action is FetchAction && action.type == ListPageType.about) {
      _fetchVersion(next);
    } else if (action is FetchUpdateAction) {
      _handleUpdate(next, action.context);
    }
  }

  void _fetchVersion(NextDispatcher next) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo != null) {
      next(ReceivedVersionAction(packageInfo.version));
    }
  }

  void _handleUpdate(NextDispatcher next, BuildContext context) {
    next(RequestingUpdateAction());
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
                next(ReceivedUpdateAction());
                String url = "";
                if (bean.assets != null && bean.assets.length > 0) {
                  ReleaseAssetBean assetBean = bean.assets[0];
                  if (assetBean != null) {
                    url = assetBean.downloadUrl;
                  }
                }
                UpdateUtil.showUpdateDialog(context, bean.name, bean.body, url);
              } else {
                next(ReceivedUpdateAction());
                ToastUtil.showToast('已经是最新版本');
              }
            }
          });
        }
      } else {
        next(ReceivedUpdateAction());
        ToastUtil.showToast('已经是最新版本');
      }
    }).catchError((_) {
      next(ErrorLoadingUpdateAction());
    });
  }
}
