import 'package:flutter/material.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).currentlocal.setting),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.color_lens),
            title: new Text(AppLocalizations.of(context).currentlocal.theme),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              NavigatorUtil.goTheme(context);
            },
          ),
          ListTile(
            leading: new Icon(Icons.language),
            title: new Text(AppLocalizations.of(context).currentlocal.language),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              NavigatorUtil.goLanguage(context);
            },
          )
        ],
      ),
    );
  }
}
