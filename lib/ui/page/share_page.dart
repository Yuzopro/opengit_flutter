import 'package:flutter/material.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/localizations/app_localizations.dart';
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
  String _version = "";

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
      appBar:
          CommonUtil.getAppBar(AppLocalizations.of(context).currentlocal.share),
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
                  onError: (ex) {
                    print("[QR] ERROR - $ex");
                  }),
              Text(AppLocalizations.of(context).currentlocal.download_app_tips,
                  style: TextStyle(color: Colors.grey, fontSize: 12.0)),
            ],
          ),
        ),
      )),
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
}
