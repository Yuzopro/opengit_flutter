import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/push_event_commit_bean.dart';

class EventUtil {
  static String getAction(EventBean model) {
    String actionStr = '';
    String repoName = model.repo.name;
    if (model.repo.name.isNotEmpty && model.repo.name.contains("/")) {
      List<String> repos = TextUtil.split(model.repo.name, '/');
      repoName = repos[1];
    }
    String refType = model.payload != null ? model.payload.refType : '';
    String action = model.payload != null ? model.payload.action : '';

    switch (model.type) {
      case 'CommitCommentEvent':
        actionStr = 'Created comment on commit in $repoName';
        break;
      case 'CreateEvent':
        if (TextUtil.equals('repository', refType)) {
          actionStr = 'Create repository $repoName';
        } else if (TextUtil.equals('branch', refType)) {
          actionStr = 'Create branch ${model.payload.ref} at $repoName';
        } else if (TextUtil.equals('tag', refType)) {
          actionStr = 'Create tag ${model.payload.ref} at $repoName';
        }
        break;
      case 'DeleteEvent':
        if (TextUtil.equals('branch', refType)) {
          actionStr = 'Delete branch ${model.payload.ref} at $repoName';
        } else if (TextUtil.equals('tag', refType)) {
          actionStr = 'Delete tag ${model.payload.ref} at $repoName';
        }
        break;
      case 'ForkEvent':
        String oriRepo = model.repo.name;
        String newRepo = model.actor.login + "/" + repoName;
        actionStr = 'Forked $oriRepo to $newRepo';
        break;
      case 'GollumEvent':
        actionStr = action + " a wiki page ";
        break;

      case 'InstallationEvent':
        actionStr = action + " an GitHub App ";
        break;
      case 'InstallationRepositoriesEvent':
        actionStr = action + " repository from an installation ";
        break;
      case 'IssueCommentEvent':
        actionStr =
            'Created comment on issue ${model.payload.issue.number} in $repoName';
        break;
      case 'IssuesEvent':
        actionStr =
            _getIssueEventStr(action, model.payload.issue.number, repoName);
        break;
      case 'MarketplacePurchaseEvent':
        actionStr = action + " marketplace plan ";
        break;
//      case 'MemberEvent':
//        String memberEventStr = getMemberEventStr(action);
//        actionStr = String.format(memberEventStr,
//            model.getPayload().getMember().getLogin(), fullName);
//        break;
//      case 'OrgBlockEvent':
//        String orgBlockEventStr;
//        if (TextUtil.equals('blocked', action)) {
//          orgBlockEventStr = 'Org '
//        } else {
//          orgBlockEventStr = getString(R.string.org_unblocked_user);
//        }
//        actionStr = String.format(
//            orgBlockEventStr,
//            model.getPayload().getOrganization().getLogin(),
//            model.getPayload().getBlockedUser().getLogin());
//        break;
      case 'ProjectCardEvent':
        actionStr = action + " a project ";
        break;
      case 'ProjectColumnEvent':
        actionStr = action + " a project ";
        break;
      case 'ProjectEvent':
        actionStr = action + " a project ";
        break;
      case 'PublicEvent':
        actionStr = 'Made $repoName public';
        break;
      case 'PullRequestEvent':
        actionStr = action + " pull request " + repoName;
        break;
      case 'PullRequestReviewEvent':
        actionStr = _getPullRequestReviewEventStr(action, repoName);
        break;
      case 'PullRequestReviewCommentEvent':
        actionStr = _getPullRequestReviewCommentEventStr(action, repoName);
        break;
      case 'PushEvent':
        String ref = model.payload.ref;
        String branch = TextUtil.isEmpty(ref)
            ? ''
            : ref.substring(ref.lastIndexOf('/') + 1);
        actionStr = 'Push to $branch at $repoName';
        break;
      case 'ReleaseEvent':
        actionStr =
            'Published release ${model.payload.release.tagName} at $repoName';
        break;
      case 'WatchEvent':
        actionStr = 'Starred $repoName';
        break;
    }
    return actionStr;
  }

  static String getDesc(EventBean model) {
    String desc = '';
    switch (model.type) {
      case 'CommitCommentEvent':
        desc = model.payload.comment.body;
        break;
      case 'IssueCommentEvent':
        desc = model.payload.comment.body;
        break;
      case 'IssuesEvent':
        desc = model.payload.issue.title;
        break;
      case 'PullRequestReviewCommentEvent':
        desc = model.payload.comment.body;
        break;
      case 'PushEvent':
        int count = model.payload.commits.length;
        int maxLines = 4;
        int max = count > maxLines ? maxLines - 1 : count;

        for (int i = 0; i < max; i++) {
          PushEventCommitBean commit = model.payload.commits[i];
          if (i != 0) {
            desc += '\n';
          }

          String sha = commit.sha.substring(0, 7);
          desc += sha;
          desc += ' ';
          desc += _getFirstLine(commit.message);
        }
        if (count > maxLines) {
          desc += '\n';
          desc += '...';
        }
        break;
    }
    return desc;
  }

  static String _getFirstLine(String str) {
    if (str == null || !str.contains("\n")) {
      return str;
    }
    return str.substring(0, str.indexOf("\n"));
  }

  static String _getPullRequestReviewCommentEventStr(
      String action, String fullName) {
    switch (action) {
      case 'created':
        return 'Created pull request review comment at $fullName';
      case 'edited':
        return 'Edited pull request review comment at $fullName';
      case 'deleted':
        return 'Deleted pull request review comment at $fullName';
      default:
        return 'Created pull request review comment at $fullName';
    }
  }

  static String _getPullRequestReviewEventStr(String action, String fullName) {
    switch (action) {
      case 'submitted':
        return 'Submitted pull request review at $fullName';
      case 'edited':
        return 'Edited pull request review at $fullName';
      case 'dismissed':
        return 'Dismissed pull request review at $fullName';
      default:
        return 'Submitted pull request review at $fullName';
    }
  }

  static String _getIssueEventStr(String action, int num, String fullName) {
    switch (action) {
      case 'assigned':
        return 'Assigned issue $num in $fullName';
      case 'unassigned':
        return 'Unassigned issue $num in $fullName';
      case 'labeled':
        return 'Labeled issue $num in $fullName';
      case 'unlabeled':
        return 'Unlabeled issue $num in $fullName';
      case 'opened':
        return 'Opened issue $num in $fullName';
      case 'edited':
        return 'Edited issue $num in $fullName';
      case 'milestoned':
        return 'Milestoned issue $num in $fullName';
      case 'demilestoned':
        return 'Demilestoned issue $num in $fullName';
      case 'closed':
        return 'Closed issue $num in $fullName';
      case 'reopened':
        return 'Reopened issue $num in $fullName';
      default:
        return 'Assigned issue $num in $fullName';
    }
  }
}
