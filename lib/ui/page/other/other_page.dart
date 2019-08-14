import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonUtil.getAppBar(AppLocalizations.of(context).currentlocal.other),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: new Text('Github API', style: YZStyle.middleText),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'Github API', 'https://developer.github.com/v3/');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: new Text('界面参考Gitme', style: YZStyle.middleText),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'Gitme', 'https://flutterchina.club/app/gm.html');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title:
                new Text('Github Trending API', style: YZStyle.middleText),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, 'Github Trending API',
                  'https://github.com/huchenme/github-trending-api');
            },
          ),
          Divider(
            height: 0.3,
          ),
        ],
      ),
    );
  }
}
