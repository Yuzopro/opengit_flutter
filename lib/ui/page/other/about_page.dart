import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/manager/red_point_manager.dart';
import 'package:open_git/redux/about/about_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/common_util.dart';
import 'package:redux/redux.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AboutPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchVersionAction()),
      converter: (store) => AboutPageViewModel.fromStore(store, context),
      builder: (_, viewModel) => AboutPageContent(viewModel),
    );
  }
}

class AboutPageContent extends StatefulWidget {
  final AboutPageViewModel viewModel;

  AboutPageContent(this.viewModel);

  @override
  State<StatefulWidget> createState() {
    return _AboutPageState();
  }
}

class _AboutPageState extends State<AboutPageContent> {
  @override
  void initState() {
    super.initState();
    RedPointManager.instance.addState(this);
  }

  @override
  void dispose() {
    super.dispose();
    RedPointManager.instance.removeState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonUtil.getAppBar(AppLocalizations.of(context).currentlocal.about),
      body: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
            child: Column(
              children: <Widget>[
                Image(
                    width: 64.0,
                    height: 64.0,
                    image: AssetImage(ImagePath.image_app)),
                Text(
                  "OpenGit",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
                Text(
                  "Version ${widget.viewModel.version}",
                  style: TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Divider(
                    height: 0.3,
                  ),
                ),
                ListTile(
                  title: Text('Github', style: YZStyle.middleText),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(
                        context, 'OpenGit', OPEN_GIT_GITHUB);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).currentlocal.author,
                      style: YZStyle.middleText),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goUserProfile(context, 'Yuzopro');
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).currentlocal.app_home_page,
                      style: YZStyle.middleText),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(
                        context,
                        AppLocalizations.of(context).currentlocal.app_home_page,
                        OPEN_GIT_HOME);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).currentlocal.introduction,
                      style: YZStyle.middleText),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goTimeline(context);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Stack(
                    alignment: Alignment.centerLeft,
                    children: <Widget>[
                      Text(
                          AppLocalizations.of(context)
                              .currentlocal
                              .update_title,
                          style: YZStyle.middleText),
                      Offstage(
                        offstage: !RedPointManager.instance.isUpgrade,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: CommonUtil.getRedPoint(),
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next),
                  onTap: widget.viewModel.onLoad,
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).currentlocal.other,
                      style: YZStyle.middleText),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goOther(context);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
              ],
            ),
          ),
          CommonUtil.getLoading(
              context, widget.viewModel.status == LoadingStatus.loading),
        ],
      ),
    );
  }
}

class AboutPageViewModel {
  final LoadingStatus status;
  final String version;
  final Function onLoad;

  AboutPageViewModel({this.status, this.version, this.onLoad});

  static AboutPageViewModel fromStore(
      Store<AppState> store, BuildContext context) {
    return AboutPageViewModel(
      status: store.state.aboutState.status,
      version: store.state.aboutState.version,
      onLoad: () {
        store.dispatch(FetchUpdateAction(context));
      },
    );
  }
}
