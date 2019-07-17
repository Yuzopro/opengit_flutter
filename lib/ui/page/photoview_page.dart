import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatelessWidget {
  final String title;
  final String url;

  PhotoViewPage(this.title, this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
          color: Colors.black,
          child: PhotoView(
            imageProvider: NetworkImage(url),
            loadingChild: Container(
              child: Stack(
                children: <Widget>[
                  Center(
                      child: Image.asset('image/ic_default_head.png',
                          height: 180.0, width: 180.0)),
                  Center(
                    child: SpinKitCircle(color: Colors.white30, size: 25.0),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
