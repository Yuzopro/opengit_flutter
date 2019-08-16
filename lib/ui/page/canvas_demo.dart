import 'dart:async';
import 'dart:ui' as ui show Image, Codec, FrameInfo;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

class CanvasDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CanvasDemoState();
  }
}

class _CanvasDemoState extends State<CanvasDemo> {
  ui.Image _image;

  static const _url =
      'https://flutter.github.io/assets-for-api-docs/assets/dart-ui/blend_mode_dst.png';

  @override
  void initState() {
    super.initState();
    _prepareImg();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Canvas Demo'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomPaint(
      painter: _DemoCustomPainter(_image),
    );
  }

  Future<ui.Image> _loadImage(var path, bool isUrl) async {
    ImageStream stream;
    if (isUrl) {
      stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    } else {
      stream = AssetImage(path, bundle: rootBundle)
          .resolve(ImageConfiguration.empty);
    }
    Completer<ui.Image> completer = Completer<ui.Image>();
    ImageStreamListener listener;
    listener = ImageStreamListener((ImageInfo frame, bool synchronousCall) {
      LogUtil.v('ImageStreamListener');
      final ui.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(listener);
    });

    stream.addListener(listener);
    return completer.future;
  }

  _prepareImg() {
    _loadImage(_url, true).then((image) {
      LogUtil.v('_loadImage');
      _image = image;
    }).whenComplete(() {
      LogUtil.v('whenComplete');
      if (this.mounted) {
        setState(() {});
      }
    });
  }
}

class _DemoCustomPainter extends CustomPainter {
  Paint _paint;

  ui.Image _image;

  _DemoCustomPainter(ui.Image image) {
    _image = image;

    _paint = Paint();
    _paint.strokeWidth = 5.0;
    _paint.color = Colors.blue;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (_image != null) {
      canvas.saveLayer(Rect.fromLTRB(0, 0, 400, 400), _paint);
      canvas.drawCircle(Offset(200, 200), 100, _paint);
      _paint.blendMode = BlendMode.srcIn;
      canvas.drawImage(_image, Offset(0, 0), _paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
