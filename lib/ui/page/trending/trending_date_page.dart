import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/util/common_util.dart';

class TrendingDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar('DateRange'),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('daily', style: YZStyle.middleText),
            onTap: () {
              Navigator.pop(context, 'daily');
            },
          ),
          ListTile(
            title: Text('weekly', style: YZStyle.middleText),
            onTap: () {
              Navigator.pop(context, 'weekly');
            },
          ),
          ListTile(
            title: Text('monthly', style: YZStyle.middleText),
            onTap: () {
              Navigator.pop(context, 'monthly');
            },
          ),
        ],
      ),
    );
  }
}
