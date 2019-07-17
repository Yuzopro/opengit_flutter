import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

class ImageUtil {
  static const _IMAGE_END = [".png", ".jpg", ".jpeg", ".gif", ".svg"];

  static Widget getImageWidget(String url, double size) {
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url ?? "",
        placeholder: (context, url) {
          return Image.asset("image/ic_default_head.png",
              width: size, height: size);
        },
        errorWidget: (context, url, error) {
          return Image.asset("image/ic_default_head.png",
              width: size, height: size);
        },
        width: size,
        height: size,
      ),
    );
  }

  static isImageEnd(String path) {
    for (String item in _IMAGE_END) {
      if (path.contains(item)) {
        return true;
      }
    }
    return false;
  }
}
