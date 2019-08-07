import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar(
          AppLocalizations.of(context).currentlocal.setting),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text(AppLocalizations.of(context).currentlocal.theme,
                style: YZConstant.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goTheme(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(AppLocalizations.of(context).currentlocal.language,
                style: YZConstant.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goLanguage(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.cached),
            title: Text(AppLocalizations.of(context).currentlocal.cache,
                style: YZConstant.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goCache(context);
            },
          ),
        ],
      ),
    );
  }
}
