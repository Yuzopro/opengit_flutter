import 'package:flutter/material.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:package_info/package_info.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AboutState();
  }
}

class _AboutState extends State<AboutPage> {
  String _version = "";

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text(AppLocalizations.of(context).currentlocal.about),
      ),
      body: new Padding(
        padding: EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
        child: new Column(
          children: <Widget>[
            Image(
                width: 64.0,
                height: 64.0,
                image: new AssetImage('image/ic_launcher.png')),
            Text(
              "OpenGit",
              style: new TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),
            Text(
              "Version $_version",
              style: new TextStyle(color: Colors.black, fontSize: 16.0),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Divider(
                height: 0.3,
              ),
            ),
            ListTile(
              title: new Text(
                  AppLocalizations.of(context).currentlocal.introduction),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {},
            ),
            Divider(
              height: 0.3,
            ),
            ListTile(
              title: new Text(AppLocalizations.of(context).currentlocal.update),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {},
            ),
            Divider(
              height: 0.3,
            )
          ],
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
}
