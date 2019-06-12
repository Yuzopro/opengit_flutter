import 'package:flutter/material.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/contract/repos_release_contract.dart';
import 'package:open_git/http/http_manager.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/presenter/repos_release_presenter.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutState();
  }
}

class _AboutState
    extends BaseState<AboutPage, ReposReleasePresenter, IReposReleaseView>
    implements IReposReleaseView {
  String _version = "";

  @override
  void initData() {
    super.initData();
    _getPackageInfo();
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo != null) {
      setState(() {
        _version = packageInfo.version;
      });
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.about),
      ),
      body: new Padding(
        padding: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
        child: new Column(
          children: <Widget>[
            Image(
                width: 64.0,
                height: 64.0,
                image: new AssetImage('image/ic_launcher.png')),
            Text(
              "OpenGit",
              style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            Text(
              "Version $_version",
              style: new TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Divider(
                height: 0.3,
              ),
            ),
            ListTile(
              title: new Text(
                  AppLocalizations.of(context).currentlocal.introduction),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                NavigatorUtil.goIntroduction(context);
              },
            ),
            Divider(
              height: 0.3,
            ),
            ListTile(
              title: new Text(
                  AppLocalizations.of(context).currentlocal.update_title),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                if (presenter != null) {
                  presenter.getReposReleases('Yuzopro', 'OpenGit_Flutter');
                }
              },
            ),
            Divider(
              height: 0.3,
            )
          ],
        ),
      ),
    );
  }

  @override
  void getReposReleasesSuccess(List<ReleaseBean> list) {
    if (list != null && list.length > 0) {
      ReleaseBean bean = list[0];
      if (bean != null) {
        String serverVersion = bean.name;
        if (presenter != null) {
          int compare = presenter.compareVersion(_version, serverVersion);
          if (compare == -1) {
            String url = "";
            if (bean.assets != null && bean.assets.length > 0) {
              ReleaseAssetBean assetBean = bean.assets[0];
              if (assetBean != null) {
                url = assetBean.downloadUrl;
              }
            }
            _showUpdateDialog(context, serverVersion, bean.body, url);
          } else {
            showToast("已经是最新版本");
          }
        }
      }
    } else {
      showToast("已经是最新版本");
    }
  }

  @override
  ReposReleasePresenter initPresenter() {
    return new ReposReleasePresenter();
  }

  void _showUpdateDialog(BuildContext context, title, content, String url) {
    bool isDownload = false;
    double progress = 0;

    showDialog(
        context: context,
        builder: (context) =>
            new StatefulBuilder(builder: (context, StateSetter setState) {
              List<Widget> contentWidget = [];
              List<Widget> actionWidget;
              contentWidget.add(Text(content));
              contentWidget.add(SizedBox(
                height: 10.0,
              ));

              if (isDownload) {
                contentWidget.add(LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.black,
                ));
              } else {
                actionWidget = [
                  FlatButton(
                    child: Text(
                        AppLocalizations.of(context).currentlocal.cancel,
                        style: TextStyle(color: Colors.grey)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      AppLocalizations.of(context).currentlocal.update,
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      if (url != null && url.contains('.apk')) {
                        CommonUtil.getLocalPath().then((appDir) {
                          if (appDir == null) {
                            return;
                          }
                          setState(() {
                            isDownload = true;
                          });
                          String path = appDir.path + title + ".apk";
                          HttpManager.download(url, path, (received, total) {
                            setState(() {
                              progress = received / total;
                              if (progress == 1) {
                                Navigator.of(context).pop();
                                InstallApkPlugin.installApk(path);
                              } else {
                                isDownload = true;
                              }
                            });
                          });
                        });
                      }
                    },
                  ),
                ];
              }

              return new AlertDialog(
                title: Text(title),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: contentWidget,
                  ),
                ),
                actions: actionWidget,
              );
            }));
  }
}
