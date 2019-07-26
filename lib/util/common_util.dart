import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/route/navigator_util.dart';

class CommonUtil {
  static Widget getNameAndAvatarWidget(String name, String head,
      {BuildContext context}) {
    return InkWell(
      child: Row(
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              head, 18.0, "assets/images/ic_default_head.png"),
          SizedBox(
            width: 6.0,
          ),
          SizedBox(
            width: 200.0,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: YZConstant.smallText,
            ),
          )
        ],
      ),
      onTap: () {
        if (context != null) {
          NavigatorUtil.goUserProfile(context, name, head);
        }
      },
    );
  }

  static Widget getLanguageWidget(String language) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ClipOval(
              child: Container(
                color: ReposManager.instance.getLanguageColor(language),
                width: 8.0,
                height: 8.0,
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Text(
              TextUtil.isEmpty(language) ? 'Unkown' : language,
              style: YZConstant.smallSubText,
            ),
          ],
        ),
      ),
      flex: 1,
    );
  }

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
        style: YZConstant.normalTextWhite,
      ),
      actions: actions,
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
//        String userName = pathnames[1];
//        NavigatorUtil.goUserProfile(context, userName); //yuzo
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
