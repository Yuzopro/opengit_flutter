import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/push_event_commit_bean.dart';

class EventUtil {
  static getEventDes(EventBean event) {
    String des;
    switch (event.type) {
      case "CommitCommentEvent":
        break;
      case "CreateEvent":
        break;
      case "DeleteEvent":
        break;
      case "ForkEvent":
        break;
      case "GollumEvent":
        break;
      case "InstallationEvent":
        break;
      case "InstallationRepositoriesEvent":
        break;
      case "IssueCommentEvent":
        break;
      case "IssuesEvent":
        break;
      case "MarketplacePurchaseEvent":
        break;
      case "MemberEvent":
        break;
      case "OrgBlockEvent":
        break;
      case "ProjectCardEvent":
        break;
      case "ProjectColumnEvent":
        break;
      case "ProjectEvent":
        break;
      case "PublicEvent":
        break;
      case "PullRequestEvent":
        break;
      case "PullRequestReviewEvent":
        break;
      case "PullRequestReviewCommentEvent":
        break;
      case "PushEvent":
        des = "";
        int count = event.payload.commits.length;
        int maxLines = 4;
        int max = count > maxLines ? maxLines - 1 : count;

        for (int i = 0; i < max; i++) {
          PushEventCommitBean commit = event.payload.commits[i];
          if (i != 0) {
            des += ("\n");
          }
          String sha = commit.sha.substring(0, 7);
          des += sha;
          des += " ";
          des += commit.message;
        }
        if (count > maxLines) {
          des = des + "\n" + "...";
        }
        break;
      case "ReleaseEvent":
        break;
      case "WatchEvent":
        break;
    }
    return des;
  }

  static getTypeDesc(EventBean event) {
    String postfix = "";
    switch (event.type) {
      case "CreateEvent":
        if (event.payload != null) {
          postfix += (event.payload.ref + " " + event.payload.refType + " in");
        }
        break;
    }
    return event.type.toLowerCase().replaceAll("event", "") + " $postfix";
  }
}
