import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/release_asset_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/repos_release_contract.dart';
import 'package:open_git/http/http_manager.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/page/drawer_page.dart';
import 'package:open_git/page/event_page.dart';
import 'package:open_git/page/home_page.dart';
import 'package:open_git/page/issue_page.dart';
import 'package:open_git/page/repository_page.dart';
import 'package:open_git/presenter/repos_release_presenter.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:package_info/package_info.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState
    extends BaseState<MainPage, ReposReleasePresenter, IReposReleaseView>
    with SingleTickerProviderStateMixin
    implements IReposReleaseView {
  UserBean _userBean;

  TabController _tabController;
  final PageController _pageController = new PageController();

  final List<Choice> choices = new List(4);

  @override
  void initData() {
    super.initData();
    _tabController = new TabController(vsync: this, length: choices.length);
    _userBean = LoginManager.instance.getUserBean();
    //检查更新
    if (presenter != null) {
      presenter.getReposReleases('Yuzopro', 'OpenGit_Flutter',
          isShowLoading: false);
    }
  }

  @override
  ReposReleasePresenter initPresenter() {
    return new ReposReleasePresenter();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget buildBody(BuildContext context) {
    choices[0] =
        new Choice(title: AppLocalizations.of(context).currentlocal.home);
    choices[1] =
        new Choice(title: AppLocalizations.of(context).currentlocal.repository);
    choices[2] =
        new Choice(title: AppLocalizations.of(context).currentlocal.event);
    choices[3] =
        new Choice(title: AppLocalizations.of(context).currentlocal.issue);

    String userName = LoginManager.instance.getUserBean() != null
        ? LoginManager.instance.getUserBean().login
        : "";

    return new WillPopScope(
        child: new DefaultTabController(
          length: choices.length,
          child: new Scaffold(
            drawer: new Drawer(
                child: new DrawerPage(
              name: _userBean.login ?? "--",
              email: _userBean.blog ?? "--",
              headUrl: _userBean.avatarUrl ?? "",
            )),
            appBar: new AppBar(
              leading: Builder(builder: (BuildContext context) {
                return new IconButton(
                  tooltip: 'Open Drawer',
                  icon: new ClipOval(
                    child: ImageUtil.getImageWidget(
                        _userBean.avatarUrl ?? "", 24.0),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              }),
              centerTitle: true,
              title: new TabBar(
                labelPadding: EdgeInsets.all(8.0),
                controller: _tabController,
                isScrollable: true,
                indicatorColor: Colors.white,
                tabs: choices.map((Choice choice) {
                  return new Tab(
                    text: choice.title,
                  );
                }).toList(),
                onTap: (index) {
                  _pageController.jumpToPage(index);
                },
              ),
              actions: <Widget>[
                new IconButton(
                  tooltip: 'Search',
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    NavigatorUtil.goSearch(context);
                  },
                ),
              ],
            ),
            body: new PageView(
              controller: _pageController,
              children: <Widget>[
                HomePage(),
                RepositoryPage(LoginManager.instance.getUserBean(), false),
                EventPage(userName),
                IssuePage(userName),
              ],
            ),
          ),
        ),
        onWillPop: () {
          return _handleExitApp(context);
        });
  }

  Future<bool> _handleExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => new AlertDialog(
              title: Text(
                  AppLocalizations.of(context).currentlocal.dialog_exit_title),
              content: Text(AppLocalizations.of(context)
                  .currentlocal
                  .dialog_exit_content),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).currentlocal.cancel,
                      style: TextStyle(color: Colors.grey)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text(
                    AppLocalizations.of(context).currentlocal.ok,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ));
  }

  @override
  void getReposReleasesSuccess(List<ReleaseBean> list) {
    if (list != null && list.length > 0) {
      ReleaseBean bean = list[0];
      if (bean != null) {
        String serverVersion = bean.name;
        if (presenter != null) {
          PackageInfo.fromPlatform().then((info) {
            if (info != null) {
              String version = info.version;
              int compare = presenter.compareVersion(version, serverVersion);
              if (compare == -1) {
                String url = "";
                if (bean.assets != null && bean.assets.length > 0) {
                  ReleaseAssetBean assetBean = bean.assets[0];
                  if (assetBean != null) {
                    url = assetBean.downloadUrl;
                  }
                }
                _showUpdateDialog(context, serverVersion, bean.body, url);
              }
            }
          });
        }
      }
    }
  }

  _showUpdateDialog(BuildContext context, title, content, String url) {
    bool isDownload = false;
    double progress = 0;

    return showDialog(
        context: context,
        builder: (context) =>
            new StatefulBuilder(builder: (context, StateSetter setState) {
              print("StatefulBuilder");
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
                        setState(() {
                          isDownload = true;
                        });
                        //todo 权限以及安装还未处理
                        HttpManager.download(
                            url, "/storage/emulated/0/Download/release.apk",
                            (received, total) {
                          setState(() {
                            progress = received / total;
                            if (progress == 1) {
                              Navigator.of(context).pop();
                            } else {
                              isDownload = true;
                            }
                          });
                        });
                      }
                    },
                  ),
                ];
              }

              return new AlertDialog(
                title: Text(title),
                content: SizedBox(
                  height: 80.0,
                  child: ListView(
                    children: contentWidget,
                  ),
                ),
                actions: actionWidget,
              );
            }));
  }
}

class Choice {
  const Choice({this.title});

  final String title;
}
