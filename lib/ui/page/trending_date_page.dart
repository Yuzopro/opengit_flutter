import 'package:flutter/material.dart';
import 'package:open_git/util/common_util.dart';

class TrendingDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonUtil.getAppBar('DateRange'),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('daily'),
            onTap: () {
              Navigator.pop(context, 'daily');
            },
          ),
          ListTile(
            title: Text('weekly'),
            onTap: () {
              Navigator.pop(context, 'weekly');
            },
          ),
          ListTile(
            title: Text('monthly'),
            onTap: () {
              Navigator.pop(context, 'monthly');
            },
          ),
        ],
      ),
    );
  }
}
