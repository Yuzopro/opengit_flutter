import 'package:flutter/material.dart';
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
            title: new Text('Yuzo Blog'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'Yuzo Blog', 'https://yuzopro.github.io/');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: new Text('Github'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'Github', 'https://github.com/yuzopro');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: new Text('掘金'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(context, '掘金',
                  'https://juejin.im/user/56ea9d7ca341310054a57b7c');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: new Text('简书'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, '简书', 'https://www.jianshu.com/u/ef3cb65219d4');
            },
          ),
          Divider(
            height: 0.3,
          ),
          ListTile(
            title: new Text('CSDN'),
            trailing: new Icon(Icons.navigate_next),
            onTap: () {
              NavigatorUtil.goWebView(
                  context, 'CSDN', 'https://blog.csdn.net/Yuzopro');
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
