import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageUtil {
  static Widget getImageWidget(String url, double size) {
    return new CachedNetworkImage(
      imageUrl: url ?? "",
      placeholder: (context, url) {
        return new Image.asset("image/ic_default_head.png", width: size, height: size);
      },
      errorWidget: (context, url, error) {
        return new Image.asset("image/ic_default_head.png", width: size, height: size);
      },
      width: size,
      height: size,
    );
  }
}
