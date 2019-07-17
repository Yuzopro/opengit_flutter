import 'package:flutter/material.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.setting),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text(AppLocalizations.of(context).currentlocal.theme),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goTheme(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(AppLocalizations.of(context).currentlocal.language),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goLanguage(context);
            },
          )
        ],
      ),
    );
  }
}
