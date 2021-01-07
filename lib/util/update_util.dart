import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:install_apk_plugin/install_apk_plugin.dart';
import 'package:open_git/http/http_request.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateUtil {
  static int compareVersion(String localVersion, String serverVersion) {
    if (localVersion == serverVersion) {
      return 0;
    }
    List<String> version1Array = localVersion.split(".");
    List<String> version2Array = serverVersion.split(".");
    int index = 0;
    // 获取最小长度值
    int minLen = min(version1Array.length, version2Array.length);
    int diff = 0;
    // 循环判断每位的大小
    while (index < minLen &&
        (diff = int.parse(version1Array[index]) -
                int.parse(version2Array[index])) ==
            0) {
      index++;
    }
    if (diff == 0) {
      // 如果位数不一致，比较多余位数
      for (int i = index; i < version1Array.length; i++) {
        if (int.parse(version1Array[i]) > 0) {
          return 1;
        }
      }

      for (int i = index; i < version2Array.length; i++) {
        if (int.parse(version2Array[i]) > 0) {
          return -1;
        }
      }
      return 0;
    } else {
      return diff > 0 ? 1 : -1;
    }
  }

  static void showUpdateDialog(
      BuildContext context, title, content, String url) {
    bool isDownload = false;
    double progress = 0;

    showDialog(
      context: context,
      builder: (context) =>
          new StatefulBuilder(builder: (context, StateSetter setState) {
        List<Widget> contentWidget = [];
        List<Widget> actionWidget;
        contentWidget.add(Text(content));
        contentWidget.add(SizedBox(
          height: 10.0,
        ));

        if (isDownload) {
          contentWidget.add(LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.black,
          ));
        } else {
          actionWidget = [
            FlatButton(
              child: Text(
                AppLocalizations.of(context).currentlocal.cancel,
                style: YZStyle.smallSubText,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(
                AppLocalizations.of(context).currentlocal.update,
                style: YZStyle.smallText,
              ),
              onPressed: () {
                if (url != null && url.contains('.apk')) {
                  _getLocalPath().then((appDir) {
                    if (appDir == null) {
                      return;
                    }
                    setState(() {
                      isDownload = true;
                    });
                    String path = appDir.path + title + ".apk";
                    HttpRequest().download(url, path, (received, total) {
                      setState(() {
                        progress = received / total;
                        if (progress == 1) {
                          Navigator.of(context).pop();
                          InstallApkPlugin.installApk(path);
                        } else {
                          isDownload = true;
                        }
                      });
                    });
                  });
                }
              },
            ),
          ];
        }

        return new AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: contentWidget,
            ),
          ),
          actions: actionWidget,
        );
      }),
    );
  }

  static _getLocalPath() async {
    var status = await Permission.storage.status;
    if (status != PermissionStatus.granted) {
      if (await Permission.contacts.request().isGranted) {
        return null;
      }
    }

    Directory appDir;
    if (Platform.isIOS) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      appDir = await getExternalStorageDirectory();
    }
    String appDocPath = appDir.path + "/opengit_flutter";
    Directory appPath = Directory(appDocPath);
    await appPath.create(recursive: true);
    return appPath;
  }
}
