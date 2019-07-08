import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String title;
  final String url;

  PhotoViewPage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: new Container(
          color: Colors.black,
          child: new PhotoView(
            imageProvider: new NetworkImage(url),
            loadingChild: Container(
              child: new Stack(
                children: <Widget>[
                  new Center(
                      child: new Image.asset('image/ic_default_head.png',
                          height: 180.0, width: 180.0)),
                  new Center(
                      child:
                          new SpinKitCircle(color: Colors.white30, size: 25.0)),
                ],
              ),
            ),
          ),
        ));
  }
}
