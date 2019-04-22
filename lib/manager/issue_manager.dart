import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class IssueManager {
  factory IssueManager() => _getInstance();

  static IssueManager get instance => _getInstance();
  static IssueManager _instance;

  IssueManager._internal() {}

  static IssueManager _getInstance() {
    if (_instance == null) {
      _instance = new IssueManager._internal();
    }
    return _instance;
  }

  getIssue(q, state, sort, order, userName, page) async {
    String url = Api.getIssue(q, state, sort, order, userName) +
        Api.getPageParams("&", page);
    final response = await HttpManager.doGet(
        url,
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        });
    if (response != null && response.data != null) {
      List<IssueBean> list = new List();
      var items = response.data["items"];
      if (items != null && items.length > 0) {
        for (int i = 0; i < items.length; i++) {
          list.add(IssueBean.fromJson(items[i]));
        }
      }
      return list;
    }
    return null;
  }

  getIssueComment(repoUrl, issueNumber, page) async {
    String url = Api.getIssueComment(repoUrl, issueNumber) +
        Api.getPageParams("&", page);
    final response = await HttpManager.doGet(
        url,
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        });
    if (response != null && response.data != null && response.data.length > 0) {
      List<IssueBean> list = new List();
      int length = response.data.length;
      for (int i = 0; i < length; i++) {
        list.add(IssueBean.fromJson(response.data[i]));
      }
      return list;
    }
    return null;
  }

  addIssueComment(repoUrl, issueNumber, comment) async {
    String url = Api.addIssueComment(repoUrl, issueNumber);
    final response =
        await HttpManager.doPost(url, {"body": comment}, null);
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  deleteIssueComment(repoUrl, comment_id) async {
    String url = Api.editComment(repoUrl, comment_id);
    return await HttpManager.doDelete(url, null, null);
  }

  editIssueComment(repoUrl, issueNumber, comment) async {
    String url = Api.editComment(repoUrl, issueNumber);
    final response = await HttpManager.doPatch(
        url,
        {"body": comment},
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        });
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
    return await HttpManager.doPost(
        url,
        {"content": comment},
        {"Accept": 'application/vnd.github.squirrel-girl-preview+json'});
  }

  deleteReactions(reaction_id) {
    String url = Api.deleteReactions(reaction_id);
    return HttpManager.doDelete(
        url,
        null,
        {
          "Accept":
              'application/vnd.github.echo-preview+json, application/vnd.github.squirrel-girl-preview+json'
        });
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
    final response = await HttpManager.doGet(
        url,
        {"Accept": 'application/vnd.github.squirrel-girl-preview+json'});
    if (response.data != null && response.data != null && response.data.length > 0) {
      List<ReactionDetailBean> list = new List();
      int length = response.data.length;
      for (int i = 0; i < length; i++) {
        list.add(ReactionDetailBean.fromJson(response.data[i]));
      }
      return list;
    }
    return null;
  }

  getSingleIssue(repoUrl, number) async {
    String url = Api.getSingleIssue(repoUrl, number);
    final response = await HttpManager.doGet(
        url,
        {"Accept": 'application/vnd.github.squirrel-girl-preview+json'});
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }

  editIssue(repoUrl, number, title, body) async {
    String url = Api.getSingleIssue(repoUrl, number);
    final response = await HttpManager.doPatch(
        url,
        {"body": body, "title": title},
        {"Accept": 'application/vnd.github.squirrel-girl-preview+json'});
    if (response != null && response.data != null) {
      return IssueBean.fromJson(response.data);
    }
    return null;
  }
}
