import 'package:flutter/material.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class OtherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.other),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: new Text('Github API'),
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
            title: new Text('界面参考Gitme'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'Gitme', 'https://flutterchina.club/app/gm.html');
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
