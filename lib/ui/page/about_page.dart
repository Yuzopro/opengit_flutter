import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
                    image: AssetImage('assets/images/ic_launcher.png')),
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
                  title: Text('Github'),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(context, 'Github',
                        'https://github.com/Yuzopro/OpenGit_Flutter');
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).currentlocal.author),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goAuthor(context);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).currentlocal.app_home_page),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(
                        context,
                        AppLocalizations.of(context).currentlocal.app_home_page,
                        'https://yuzopro.github.io/portfolio/work/opengit-flutter.html');
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: Text(
                      AppLocalizations.of(context).currentlocal.introduction),
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
                      Text(AppLocalizations.of(context)
                          .currentlocal
                          .update_title),
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
                  title: Text(AppLocalizations.of(context).currentlocal.other),
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
