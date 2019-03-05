import 'package:flutter/material.dart';

class SharePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SharePageState();
  }
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("Share page"),
      ),
    );
  }
}
