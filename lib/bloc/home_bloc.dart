import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/juejin_manager.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:open_git/util/update_util.dart';
import 'package:package_info/package_info.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseListBloc<Entrylist> {
  static final String TAG = "HomeBloc";

  static bool _isInit = false;

  @override
  void initState(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;

    Observable.just(1).delay(new Duration(milliseconds: 200)).listen((_) {
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
                  UpdateUtil.showUpdateDialog(
                      context, serverVersion, bean.body, url);
                }
              }
            });
          }
        }
      }).catchError((_) {});
    });
  }

  @override
  Future getData(RefreshController controller, bool isLoad) {
    LogUtil.v("_getData", tag: TAG);
    return JueJinManager.instance.getJueJinList(page).then((result) {
      if (list == null) {
        list = new List();
      }
      if (page == 1) {
        list.clear();
      }
      list.addAll(result);
      sink.add(UnmodifiableListView<Entrylist>(list));

      if (controller != null) {
        if (!isLoad) {
          controller.refreshCompleted();
          controller.loadComplete();
        } else {
          controller.loadComplete();
        }
      }
    }).catchError((_) {
      page--;
      if (controller != null) {
        controller.loadFailed();
      }
    });
  }
}
