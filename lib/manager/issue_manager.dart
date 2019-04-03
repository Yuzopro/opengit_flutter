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

  getIssue(q, state, sort, order, userName, page, Function successCallback,
      Function errorCallback) {
    String url = Api.getIssue(q, state, sort, order, userName) +
        Api.getPageParams("&", page);
    return HttpManager.doGet(
        url,
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        },
        successCallback,
        errorCallback);
  }

  getIssueComment(repoUrl, issueNumber, page, Function successCallback,
      Function errorCallback) {
    String url = Api.getIssueComment(repoUrl, issueNumber) +
        Api.getPageParams("&", page);
    return HttpManager.doGet(
        url,
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        },
        successCallback,
        errorCallback);
  }

  addIssueComment(repoUrl, issueNumber, comment, Function successCallback,
      Function errorCallback) {
    String url = Api.addIssueComment(repoUrl, issueNumber);
    HttpManager.doPost(
        url, {"body": comment}, null, successCallback, errorCallback);
  }

  deleteIssueComment(repoUrl, issueNumber, comment, Function successCallback,
      Function errorCallback) {
    String url = Api.editComment(repoUrl, issueNumber);
    HttpManager.doDelete(
        url, {"body": comment}, null, successCallback, errorCallback);
  }

  editIssueComment(repoUrl, issueNumber, comment, Function successCallback,
      Function errorCallback) {
    String url = Api.editComment(repoUrl, issueNumber);
    return HttpManager.doPatch(
        url,
        {"body": comment},
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        },
        successCallback,
        errorCallback);
  }

  editReactions(repoUrl, issueNumber, comment, Function successCallback,
      Function errorCallback) {
    String url = Api.addCommentReactions(repoUrl, issueNumber);
    HttpManager.doPost(
        url,
        {"content": comment},
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        },
        successCallback,
        errorCallback);
  }

  deleteReactions(reaction_id, Function successCallback, Function errorCallback) {
    String url = Api.deleteReactions(reaction_id);
    return HttpManager.doDelete(
        url,
        null,
        {
          "Accept":
              'application/vnd.github.echo-preview+json, application/vnd.github.squirrel-girl-preview+json'
        },
        successCallback,
        errorCallback);
  }

  getCommentReactions(repoUrl, commentId, content, page, isIssue,
      Function successCallback, Function errorCallback) {
    String url;
    if (isIssue) {
      url = Api.getIssueReactions(repoUrl, commentId, content) +
          Api.getPageParams("&", page);
    } else {
      url = Api.getCommentReactions(repoUrl, commentId, content) +
          Api.getPageParams("&", page);
    }
    return HttpManager.doGet(
        url,
        {
          "Accept":
              'application/vnd.github.html, application/vnd.github.VERSION.raw,application/vnd.github.squirrel-girl-preview'
        },
        successCallback,
        errorCallback);
  }
}
