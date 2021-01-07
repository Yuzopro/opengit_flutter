import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';
import 'package:package_info/package_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SharePageState();
  }
}

class _SharePageState extends State<SharePage> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    double size = ScreenUtil.getScreenWidth(context) - 100;
    double qrSize = size - 80;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: CommonUtil.getAppBar(
          AppLocalizations.of(context).currentlocal.share,
          actions: _getAction(context)),
      body: Center(
          child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 12.0),
                child: Row(
                  children: <Widget>[
                    Image(
                        width: 32.0,
                        height: 32.0,
                        image: AssetImage(ImagePath.image_app)),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('OpenGit',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                          Text(_version,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12.0))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              QrImage(
                data: OPEN_GIT_HOME,
                size: qrSize,
              ),
              Text(AppLocalizations.of(context).currentlocal.download_app_tips,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ],
          ),
        ),
      )),
    );
  }

  List<Widget> _getAction(BuildContext context) {
    return [
      PopupMenuButton(
        padding: const EdgeInsets.all(0.0),
        onSelected: (value) {
          _onPopSelected(context, value);
        },
        itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
          _getPopupMenuItem('browser', Icons.language, '浏览器打开'),
          _getPopupMenuItem('share', Icons.share, '分享'),
        ],
      )
    ];
  }

  PopupMenuItem _getPopupMenuItem(String value, IconData icon, String title) {
    return PopupMenuItem<String>(
      value: value,
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        dense: false,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Icon(
                icon,
                color: Color(YZColors.textColor),
                size: 22.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                title,
                style: YZStyle.middleText,
              )
            ],
          ),
        ),
      ),
    );
  }

  _getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (packageInfo != null) {
      setState(() {
        _version = packageInfo.version;
      });
    }
  }

  void _onPopSelected(BuildContext context, String value) {
    switch (value) {
      case 'browser':
        NavigatorUtil.goWebView(
            context,
            AppLocalizations.of(context).currentlocal.app_home_page,
            OPEN_GIT_HOME);
        break;
      case 'share':
        ShareUtil.share(OPEN_GIT_HOME);
        break;
    }
  }
}
