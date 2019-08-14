import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class AuthorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar(
          AppLocalizations.of(context).currentlocal.author),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Yuzo Blog', style: YZStyle.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, 'Yuzo Blog', BLOG);
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: Text('Github', style: YZStyle.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, 'Github', GITHUB);
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: Text('掘金', style: YZStyle.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, '掘金', JUEJIN);
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: Text('简书', style: YZStyle.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, '简书', JIANSHU);
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: Text('CSDN', style: YZStyle.middleText),
            trailing: Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, 'CSDN', CSDN);
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
