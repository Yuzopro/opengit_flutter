import 'package:flutter/material.dart';
import 'package:open_git/localizations/app_localizations.dart';
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
    double size = MediaQuery.of(context).size.width - 100;
    double qrSize = size - 80;
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.share),
      ),
      body: new Center(
          child: new DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: SizedBox(
          width: size,
          height: size,
          child: new Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 12.0, top: 12.0),
                child: Row(
                  children: <Widget>[
                    Image(
                        width: 32.0,
                        height: 32.0,
                        image: new AssetImage('image/ic_launcher.png')),
                    Padding(
                      padding: EdgeInsets.only(left: 3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text('OpenGit',
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 12.0)),
                          new Text(_version,
                              style: new TextStyle(
                                  color: Colors.grey, fontSize: 12.0))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              QrImage(
                  data: "https://yuzopro.github.io/",
                  size: qrSize,
                  onError: (ex) {
                    print("[QR] ERROR - $ex");
                  }),
              Text(AppLocalizations.of(context).currentlocal.download_app_tips,
                  style: new TextStyle(color: Colors.grey, fontSize: 12.0)),
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
