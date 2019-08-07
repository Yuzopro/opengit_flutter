import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/sp_const.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/util/common_util.dart';

class CachePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CachePageState();
  }
}

class _CachePageState extends State<CachePage> {
  double _discreteValue = 4.0;

  @override
  void initState() {
    super.initState();
    int time = SpUtil.instance.getInt(SP_KEY_CACHE_TIME, defValue: 4);
    _discreteValue = time.roundToDouble();
  }

  @override
  void dispose() {
    SpUtil.instance.putInt(SP_KEY_CACHE_TIME, _discreteValue.round());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonUtil.getAppBar(AppLocalizations.of(context).currentlocal.cache),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              '缓存时间最长为4小时，当应用退出时，所有缓存会被清空，缓存过期前可通过下拉刷新手动更新页面。',
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Slider.adaptive(
              value: _discreteValue,
              min: 0.0,
              max: 4.0,
              divisions: 4,
              activeColor: Colors.black,
              inactiveColor: Colors.black26,
              label: _getLabel(_discreteValue.round()),
              onChanged: (double value) {
                setState(() {
                  _discreteValue = value;
                });
              },
            ),
            SizedBox(
              height: 24.0,
            ),
            _buildClearButton(context),
          ],
        ),
      ),
    );
  }

  Align _buildClearButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            '清除缓存',
            style: YZConstant.normalTextWhite,
          ),
          color: Colors.black,
          onPressed: _clearCache,
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  void _clearCache() async {
    CacheProvider provider = CacheProvider();
    await provider.delete();
    ToastUtil.showMessgae('缓存已清除');
  }

  String _getLabel(int value) {
    if (value == 0) {
      return '禁用缓存';
    } else {
      return '$value小时';
    }
  }
}
