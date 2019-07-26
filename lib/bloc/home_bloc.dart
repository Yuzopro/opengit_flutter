import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/juejin_manager.dart';
import 'package:open_git/manager/red_point_manager.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/update_util.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseListBloc<Entrylist> {
  static final String TAG = "HomeBloc";

  bool _isInit = false;

  HomeBloc() {}

  @override
  PageType getPageType() {
    return PageType.home;
  }

  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchHomeList();
    _hideLoading();

    refreshStatusEvent();

    _checkUpgrade(context);
  }

  @override
  Future getData() async {
    await _fetchHomeList();
  }

  Future _fetchHomeList() async {
    LogUtil.v('_fetchHomeList', tag: TAG);
    try {
      var result = await JueJinManager.instance.getJueJinList(page);
      if (bean.data == null) {
        bean.data = List();
      }
      if (page == 1) {
        bean.data.clear();
      }

      noMore = true;
      if (result != null) {
        noMore = result.length != Config.PAGE_SIZE;
        bean.data.addAll(result);
      } else {
        bean.isError = true;
      }

      sink.add(bean);
    } catch (_) {
      if (page != 1) {
        page--;
      }
    }
  }

  void _checkUpgrade(BuildContext context) {
    Observable.just(1).delay(Duration(milliseconds: 200)).listen((_) {
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
                  RedPointManager.instance.isUpgrade = true;
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

  void _showLoading() {
    bean.isLoading = true;
    sink.add(bean);
  }

  void _hideLoading() {
    bean.isLoading = false;
    sink.add(bean);
  }
}
