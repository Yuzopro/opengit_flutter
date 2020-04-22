import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';
import 'package:open_git/util/code_detail_util.dart';
import 'package:open_git/util/repos_util.dart';

class ReposManager {
  factory ReposManager() => _getInstance();

  static ReposManager get instance => _getInstance();
  static ReposManager _instance;

  Map<String, Color> _languageMap = new Map();

  ReposManager._internal();

  static ReposManager _getInstance() {
    if (_instance == null) {
      _instance = ReposManager._internal();
    }
    return _instance;
  }

  void initLanguageColors() {
    rootBundle.loadString('assets/data/language_colors.json').then((value) {
      Map map = json.decode(value);
      map.forEach((key, value) {
        String color = value['color'];
        if (!TextUtil.isEmpty(color)) {
          _languageMap.putIfAbsent(key, () => ColorUtil.str2Color(color));
        }
      });
    });
  }

  Color getLanguageColor(String language) {
    return _languageMap[language] ?? Colors.black;
  }

  Future<List<Repository>> getUserRepos(
      String userName, int page, String sort, bool isStar) async {
    String url;
    if (isStar) {
      url = Api.userStar(userName, null);
    } else {
      url = Api.userRepos(userName, sort);
    }
    url += Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<Repository> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          Repository repository = Repository.fromJson(dataItem);
          repository.description =
              ReposUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
          list.add(repository);
        }
      }
      return list;
    }
    return null;
  }

  Future<List<Repository>> getOrgRepos(
      String userName, int page, String sort) async {
    String url = Api.getOrgRepos(userName, sort);
    url += Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<Repository> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          Repository repository = Repository.fromJson(dataItem);
          repository.description =
              ReposUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
          list.add(repository);
        }
      }
      return list;
    }
    return null;
  }

  getReposDetail(reposOwner, reposName) async {
    final response =
        await HttpRequest().get(Api.getReposDetail(reposOwner, reposName));
    if (response != null && response.data != null) {
      return Repository.fromJson(response.data);
    }
    return null;
  }

  getReadme(reposFullName, branch) async {
    String url = Api.readmeFile(reposFullName, branch);
    return await _getFileAsStream(
        url, {"Accept": 'application/vnd.github.VERSION.raw'});
  }

  getReposStar(reposOwner, reposName) async {
    return await HttpRequest().get(Api.getReposStar(reposOwner, reposName));
  }

  getReposWatcher(reposOwner, reposName) async {
    return await HttpRequest().get(Api.getReposWatcher(reposOwner, reposName));
  }

  doReposStarAction(reposOwner, reposName, bool isEnable) async {
    String url = Api.getReposStar(reposOwner, reposName);
    RequestBuilder builder = new RequestBuilder();
    builder.url(url).isCache(false);
    if (isEnable) {
      builder.method(HttpMethod.DELETE);
    } else {
      builder.method(HttpMethod.PUT);
    }
    return await HttpRequest().builder(builder);
  }

  doReposWatcherAction(reposOwner, reposName, bool isEnable) async {
    String url = Api.getReposWatcher(reposOwner, reposName);
    RequestBuilder builder = new RequestBuilder();
    builder.url(url).isCache(false);
    if (isEnable) {
      builder.method(HttpMethod.DELETE);
    } else {
      builder.method(HttpMethod.PUT);
    }
    return await HttpRequest().builder(builder);
  }

  getReposEvents(reposOwner, reposName, page) async {
    String url = Api.getReposEvents(reposOwner, reposName) +
        Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<EventBean> list = List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(EventBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getBranches(reposOwner, reposName) async {
    String url = Api.getBranches(reposOwner, reposName);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<BranchBean> list = List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(BranchBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getLanguages(language, page) async {
    String url = Api.getLanguages(language + Api.getPageParams("&", page));
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<Repository> list = List();
      if (response.data != null && response.data.length > 0) {
        var items = response.data["items"];
        for (int i = 0; i < items.length; i++) {
          var dataItem = items[i];
          list.add(Repository.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getReposFileDir(userName, reposName, {path = '', branch}) async {
    String url = Api.reposDataDir(userName, reposName, path, branch);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<SourceFileBean> list = List();
      if (response.data != null && response.data.length > 0) {
        List<SourceFileBean> dirs = List();
        List<SourceFileBean> files = List();
        for (int i = 0; i < response.data.length; i++) {
          SourceFileBean file = SourceFileBean.fromJson(response.data[i]);
          if (file.type == "file") {
            files.add(file);
          } else {
            dirs.add(file);
          }
        }
        list.addAll(dirs);
        list.addAll(files);
      }
      return list;
    }
    return null;
  }

  getCodeDetail(url) async {
    final response =
        await _getFileAsStream(url, {"Accept": 'application/vnd.github.html'});
    String data = CodeDetailUtil.resolveHtmlFile(response, "java");
    String result = Uri.dataFromString(data,
            mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
        .toString();
    return result;
  }

  _getFileAsStream(url, Map<String, String> header) async {
    RequestBuilder builder = new RequestBuilder();
    builder
        .method(HttpMethod.GET)
        .url(url)
        .header(header)
        .contentType(ResponseType.stream);

    return await HttpRequest().builder(builder);
  }

  getReposReleases(userName, repos, {page = 1}) async {
    String url =
        Api.getReposReleases(userName, repos) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<ReleaseBean> list = List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(ReleaseBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getRepoForks(owner, repo, page) async {
    String url = Api.getRepoForks(owner, repo) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<UserBean> list = List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(Repository.fromJson(dataItem).owner);
        }
      }
      return list;
    }
    return null;
  }

  getTopics(owner, repo) async {
    String url = Api.getTopics(owner, repo);

    RequestBuilder builder = new RequestBuilder();
    builder
        .method(HttpMethod.GET)
        .url(url)
        .header({"Accept": 'application/vnd.github.mercy-preview+json'});

    return await HttpRequest().builder(builder);
  }
}
