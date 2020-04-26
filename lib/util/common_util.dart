import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:open_git/route/navigator_util.dart';

class CommonUtil {
  static Widget getRedPoint() {
    return ClipOval(
      child: Container(
        color: Color(YZColors.redPointColor),
        width: 6.0,
        height: 6.0,
      ),
    );
  }

  static AppBar getAppBar(String title, {List<Widget> actions}) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: YZStyle.normalTextWhite,
      ),
      actions: actions,
    );
  }

  static Widget getLoading(BuildContext context, bool isLoading) {
    return Offstage(
      offstage: !isLoading,
      child: Container(
        width: ScreenUtil.getScreenWidth(context),
        height: ScreenUtil.getScreenHeight(context),
        color: Colors.black54,
        child: Center(
          child: SpinKitCircle(
            color: Theme.of(context).primaryColor,
            size: 25.0,
          ),
        ),
      ),
    );
  }

  static launchUrl(context, String url) {
    if (url == null && url.length == 0) return;
    Uri parseUrl = Uri.parse(url);
    bool isImage = ImageUtil.isImage(parseUrl.toString());
    if (parseUrl.toString().endsWith("?raw=true")) {
      isImage =
          ImageUtil.isImage(parseUrl.toString().replaceAll("?raw=true", ""));
    }
    if (isImage) {
      NavigatorUtil.goPhotoView(context, '', url);
      return;
    }

    if (parseUrl != null &&
        parseUrl.host == "github.com" &&
        parseUrl.path.length > 0) {
      List<String> pathnames = TextUtil.split(parseUrl.path, '/');
      if (pathnames.length == 2) {
        //解析人
        String userName = pathnames[1];
        NavigatorUtil.goUserProfile(context, userName, "", "");
      } else if (pathnames.length >= 3) {
        String userName = pathnames[1];
        String repoName = pathnames[2];
        //解析仓库
        if (pathnames.length == 3) {
          NavigatorUtil.goReposDetail(context, userName, repoName);
        } else {
          launchWebView(context, "", url);
        }
      }
    } else if (url != null && url.startsWith("http")) {
      launchWebView(context, "", url);
    }
  }

  static void launchWebView(BuildContext context, String title, String url) {
    if (url.startsWith("http")) {
      NavigatorUtil.goWebView(context, title, url);
    } else {
      NavigatorUtil.goWebView(
        context,
        title,
        Uri.dataFromString(url,
                mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
            .toString(),
      );
    }
  }
}
