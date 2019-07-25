import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';

class TrendingDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'DateRange',
          style: YZConstant.normalTextWhite,
        ),
      ),
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
