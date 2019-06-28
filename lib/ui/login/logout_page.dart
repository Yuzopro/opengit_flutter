import 'package:flutter/material.dart';

class LogoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LogoutPageState();
  }
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("Logout page"),
      ),
    );
  }
}
