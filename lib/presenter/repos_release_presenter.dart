import 'dart:math';

import 'package:open_git/contract/repos_release_contract.dart';
import 'package:open_git/manager/repos_manager.dart';

class ReposReleasePresenter extends IReposReleasePresenter {
  @override
  getReposReleases(userName, repos, {isShowLoading = true}) async {
    if (view != null && isShowLoading) {
      view.showLoading();
    }
    final response =
        await ReposManager.instance.getReposReleases(userName, repos);
    if (view != null) {
      if (isShowLoading) {
        view.hideLoading();
      }
      view.getReposReleasesSuccess(response);
    }
    return response;
  }

  /**
   * 0：相等
   * 1：localVersion > serverVersion
   * -1: localVersion < serverVersion
   */
  @override
  int compareVersion(String localVersion, String serverVersion) {
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
    while (index < minLen
        && (diff = int.parse(version1Array[index])
            - int.parse(version2Array[index])) == 0) {
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

}
