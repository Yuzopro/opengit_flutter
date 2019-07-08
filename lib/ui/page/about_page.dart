import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/about/about_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:redux/redux.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AboutPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchAction(ListPageType.about)),
      converter: (store) => AboutPageViewModel.fromStore(store, context),
      builder: (_, viewModel) => AboutPageContent(viewModel),
    );
  }
}

class AboutPageContent extends StatelessWidget {
  final AboutPageViewModel viewModel;

  AboutPageContent(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.about),
      ),
      body: Stack(
        children: <Widget>[
          new Padding(
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
                  "Version ${viewModel.version}",
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Divider(
                    height: 0.3,
                  ),
                ),
                ListTile(
                  title: new Text('Github'),
                  trailing: new Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(context, 'Github',
                        'https://github.com/Yuzopro/OpenGit_Flutter');
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: new Text(
                      AppLocalizations.of(context).currentlocal.author),
                  trailing: new Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goAuthor(context);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: new Text(
                      AppLocalizations.of(context).currentlocal.app_home_page),
                  trailing: new Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goWebView(context, AppLocalizations.of(context).currentlocal.app_home_page,
                        'https://yuzopro.github.io/portfolio/work/opengit-flutter.html');
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: new Text(
                      AppLocalizations.of(context).currentlocal.introduction),
                  trailing: new Icon(Icons.navigate_next),
                  onTap: () {
                    NavigatorUtil.goTimeline(context);
                  },
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title: new Text(
                      AppLocalizations.of(context).currentlocal.update_title),
                  trailing: new Icon(Icons.navigate_next),
                  onTap: viewModel.onLoad,
                ),
                Divider(
                  height: 0.3,
                ),
                ListTile(
                  title:
                      new Text(AppLocalizations.of(context).currentlocal.other),
                  trailing: new Icon(Icons.navigate_next),
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
          new Offstage(
            offstage: viewModel.status != LoadingStatus.loading,
            child: new Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black54,
              child: new Center(
                child: SpinKitCircle(
                  color: Theme.of(context).primaryColor,
                  size: 25.0,
                ),
              ),
            ),
          )
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
