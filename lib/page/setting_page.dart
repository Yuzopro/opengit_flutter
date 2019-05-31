import 'package:flutter/material.dart';
import 'package:open_git/route/navigator_util.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('设置'),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.color_lens),
            title: new Text('主题'),
            trailing: new Icon(Icons.arrow_right),
            onTap: () {
              NavigatorUtil.goTheme(context);
            },
          )
        ],
      ),
    );
  }
}
