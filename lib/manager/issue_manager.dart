import 'dart:collection';

import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/common/url_const.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';

class IssueManager {
  factory IssueManager() => _getInstance();

  static IssueManager get instance => _getInstance();
  static IssueManager _instance;

  IssueManager._internal();

  List<Labels> _labels;

  static IssueManager _getInstance() {
    if (_instance == null) {
      _instance = new IssueManager._internal();
    }
    return _instance;
  }

  void setLabels(List<Labels> labels) {
    this._labels = labels;
  }

  List<Labels> getLabels() {
    return _labels;
  }

  getIssue(filter, state, sort, direction, page) async {
    String url = Api.getIssue(filter, state, sort, direction) +
        Api.getPageParams("&", page);

    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<IssueBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        int length = response.data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(response.data[i]));
        }
      }
      return list;
    }
    return null;
  }

  getRepoIssues(owner, repo, page) async {
    String url = Api.getRepoIssues(owner, repo) + Api.getPageParams("&", page);

    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<IssueBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        int length = response.data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(response.data[i]));
        }
      }
      return list;
    }
    return null;
  }

  getIssueComment(repoUrl, issueNumber, page) async {
    String url = Api.getIssueComment(repoUrl, issueNumber) +
        Api.getPageParams("&", page);

    Map<String, dynamic> header = HashMap();
    header['Accept'] =
        'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview';
    RequestBuilder builder = RequestBuilder()
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.GET)
      ..header(header);
    final response = await HttpRequest().builder(builder);
    if (response != null && response.result) {
      List<IssueBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        int length = response.data.length;
        for (int i = 0; i < length; i++) {
          list.add(IssueBean.fromJson(response.data[i]));
        }
      }
      return list;
    }
    return null;
  }

  addIssueComment(repoUrl, issueNumber, comment) async {
    if (!TextUtil.contains(comment, '[From OpenGit Android]($OPEN_GIT_HOME)')) {
      comment += '\n[From OpenGit Android]($OPEN_GIT_HOME)';
    }

    String url = Api.addIssueComment(repoUrl, issueNumber);
    final response = await HttpRequest().post(url, {"body": comment});
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  deleteIssueComment(repoUrl, comment_id) async {
    String url = Api.editComment(repoUrl, comment_id);
    return await HttpRequest().delete(url, isCache: false);
  }

  editIssueComment(repoUrl, issueNumber, comment) async {
    String url = Api.editComment(repoUrl, issueNumber);

    if (!TextUtil.contains(comment, '[From OpenGit Android]($OPEN_GIT_HOME)')) {
      comment += '\n[From OpenGit Android]($OPEN_GIT_HOME)';
    }

    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.PATCH)
      ..data({"body": comment});
    final response = await HttpRequest().builder(builder);
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  editReactions(repoUrl, issueNumber, comment, isIssue) async {
    String url;
    if (isIssue) {
      url = Api.addIssueReactions(repoUrl, issueNumber);
    } else {
      url = Api.addCommentReactions(repoUrl, issueNumber);
    }

    Map<String, dynamic> header = HashMap();
    header['Accept'] = 'application/vnd.github.squirrel-girl-preview+json';

    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.POST)
      ..header(header)
      ..data({"content": comment});
    return await HttpRequest().builder(builder);
  }

  deleteReactions(reaction_id) async {
    String url = Api.deleteReactions(reaction_id);

    Map<String, dynamic> header = HashMap();
    header['Accept'] =
        'application/vnd.github.echo-preview+json, application/vnd.github.squirrel-girl-preview+json';
    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.DELETE)
      ..header(header);
    return await HttpRequest().builder(builder);
  }

  getCommentReactions(repoUrl, commentId, content, page, isIssue) async {
    String url;
    if (isIssue) {
      url = Api.getIssueReactions(repoUrl, commentId, content) +
          Api.getPageParams("&", page);
    } else {
      url = Api.getCommentReactions(repoUrl, commentId, content) +
          Api.getPageParams("&", page);
    }

    Map<String, dynamic> header = HashMap();
    header['Accept'] = 'application/vnd.github.squirrel-girl-preview+json';
    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.GET)
      ..header(header);
    final response = await HttpRequest().builder(builder);
    if (response != null && response.result) {
      List<ReactionDetailBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        int length = response.data.length;
        for (int i = 0; i < length; i++) {
          list.add(ReactionDetailBean.fromJson(response.data[i]));
        }
      }
      return list;
    }
    return null;
  }

  getSingleIssue(repoUrl, number) async {
    String url = Api.getSingleIssue(repoUrl, number);

    Map<String, dynamic> header = HashMap();
    header['Accept'] = 'application/vnd.github.squirrel-girl-preview+json';
    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.GET)
      ..header(header);
    final response = await HttpRequest().builder(builder);
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  editIssue(repoUrl, number, title, body) async {
    String url = Api.getSingleIssue(repoUrl, number);

    if (!TextUtil.contains(body, '[From OpenGit Android]($OPEN_GIT_HOME)')) {
      body += '\n[From OpenGit Android]($OPEN_GIT_HOME)';
    }

    Map<String, dynamic> header = HashMap();
    header['Accept'] = 'application/vnd.github.squirrel-girl-preview+json';
    RequestBuilder builder = RequestBuilder();
    builder
      ..url(url)
      ..isCache(false)
      ..method(HttpMethod.PATCH)
      ..header(header)
      ..data({"body": body, "title": title});
    final response = await HttpRequest().builder(builder);
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  getLabel(owner, repo, page) async {
    String url = Api.getLabel(owner, repo) + Api.getPageParams("&", page);

    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<Labels> list = new List();
      if (response.data != null && response.data.length > 0) {
        int length = response.data.length;
        for (int i = 0; i < length; i++) {
          list.add(Labels.fromJson(response.data[i]));
        }
      }
      return list;
    }
    return null;
  }

  createLabel(owner, repo, name, color, desc) async {
    String url = Api.createLabel(owner, repo);

    Map<String, dynamic> data = new HashMap();
    data['name'] = name;
    data['color'] = color;
    data['description'] = desc;

    return await HttpRequest().post(url, data);
  }

  deleteLabel(owner, repo, name) async {
    String url = Api.deleteLabel(owner, repo, name);

    return await HttpRequest().delete(url, isCache: false);
  }

  updateLabel(owner, repo, currentName, name, color, desc) async {
    String url = Api.updateLabel(owner, repo, currentName);

    Map<String, dynamic> data = new HashMap();
    data['name'] = name;
    data['color'] = color;
    data['description'] = desc;

    return await HttpRequest().patch(url, data);
  }

  addIssueLabel(owner, repo, issueNumber, name) async {
    String url = Api.addIssueLabel(owner, repo, issueNumber);

    Map<String, dynamic> data = new HashMap();
    data['labels'] = [name];

    return await HttpRequest().post(url, data);
  }

  deleteIssueLabel(owner, repo, issueNumber, name) async {
    String url = Api.deleteIssueLabel(owner, repo, issueNumber, name);

    return await HttpRequest().delete(url);
  }
}
