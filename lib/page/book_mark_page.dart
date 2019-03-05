import 'package:flutter/material.dart';

class BookMarkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BookMarkPageState();
  }
}

class _BookMarkPageState extends State<BookMarkPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Text("BookMark page"),
      ),
    );
  }
}
