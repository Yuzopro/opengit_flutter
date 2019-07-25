import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trend_bean.dart';

class TrendingUtil {
  static const TAGS = {
    "meta": {
      "start": '<span class="d-inline-block float-sm-right">',
      "end": '</span>'
    },
    "starCount": {
      "start": '<a class="muted-link d-inline-block mr-3"',
      "flag": '/stargazers">',
      "end": '</a>'
    },
    "forkCount": {
      "start": '<a class="muted-link d-inline-block mr-3"',
      "flag": '/network/members">',
      "end": '</a>'
    }
  };

  static htmlToRepo(String responseData) {
    try {
      responseData = responseData.replaceAll(RegExp('\n'), '');
    } catch (e) {}
    var repos = List();
    var splitWithH3 =
        TextUtil.split(responseData, '<h1 class="h3 lh-condensed">');
    splitWithH3.removeAt(0);
    for (var i = 0; i < splitWithH3.length; i++) {
      var repo = TrendBean.empty();
      var html = splitWithH3[i];

      parseRepoBaseInfo(repo, html);

      var metaNoteContent = parseContentWithNote(
          html, 'class="f6 text-gray mt-2">', '<\/article>');
      repo.meta = parseRepoLabelWithTag(repo, metaNoteContent, TAGS["meta"]);
      repo.starCount =
          parseRepoLabelWithTag(repo, metaNoteContent, TAGS["starCount"]);
      repo.forkCount =
          parseRepoLabelWithTag(repo, metaNoteContent, TAGS["forkCount"]);

      parseRepoLang(repo, metaNoteContent);
      parseRepoContributors(repo, metaNoteContent);
      repos.add(repo);
    }
    return repos;
  }

  static parseContentWithNote(htmlStr, startFlag, endFlag) {
    var noteStar = htmlStr.indexOf(startFlag);
    if (noteStar == -1) {
      return '';
    } else {
      noteStar += startFlag.length;
    }

    var noteEnd = htmlStr.indexOf(endFlag, noteStar);
    var content = htmlStr.substring(noteStar, noteEnd);
    return trim(content);
  }

  static parseRepoBaseInfo(repo, htmlBaseInfo) {
    var urlIndex = htmlBaseInfo.indexOf('<a href="') + '<a href="'.length;
    var url =
        htmlBaseInfo.substring(urlIndex, htmlBaseInfo.indexOf('">', urlIndex));
    repo.url = url;
    repo.fullName = url.substring(1, url.length);
    if (repo.fullName != null && repo.fullName.indexOf('/') != -1) {
      var repos = TextUtil.split(repo.fullName, '/');
      repo.name = repos[0];
      repo.reposName = repos[1];
    }

    String description = parseContentWithNote(
        htmlBaseInfo, '<p class="col-9 text-gray my-1 pr-4">', '</p>');
    if (description != null) {
      String reg = "<g-emoji.*?>.+?</g-emoji>";
      RegExp tag = RegExp(reg);
      Iterable<Match> tags = tag.allMatches(description);
      for (Match m in tags) {
        String match = m
            .group(0)
            .replaceAll(RegExp("<g-emoji.*?>"), "")
            .replaceAll(RegExp("</g-emoji>"), "");
        description = description.replaceAll(RegExp(m.group(0)), match);
      }
    }
    repo.description = description;
  }

  static parseRepoLabelWithTag(repo, noteContent, tag) {
    var startFlag;
    if (TAGS["starCount"] == tag || TAGS["forkCount"] == tag) {
      startFlag = tag["start"] + ' href="/' + repo.fullName + tag["flag"];
    } else {
      startFlag = tag["start"];
    }
    var content = parseContentWithNote(noteContent, startFlag, tag["end"]);
    if (content.indexOf('</svg>') != -1 &&
        (content.indexOf('</svg>') + '</svg>'.length <= content.length)) {
      var metaContent = content.substring(
          content.indexOf('</svg>') + '</svg>'.length, content.length);
      return trim(metaContent);
    } else {
      return trim(content);
    }
  }

  static parseRepoLang(repo, metaNoteContent) {
    var content = parseContentWithNote(
        metaNoteContent, 'programmingLanguage">', '</span>');
    repo.language = trim(content);
  }

  static parseRepoContributors(repo, htmlContributors) {
    htmlContributors =
        parseContentWithNote(htmlContributors, 'Built by', '<\/span>');
    var splitWitSemicolon = TextUtil.split(htmlContributors, '\"');
    if (splitWitSemicolon.length > 1) {
      repo.contributorsUrl = splitWitSemicolon[1];
    }
    var contributors = List<String>();
    for (var i = 0; i < splitWitSemicolon.length; i++) {
      String url = splitWitSemicolon[i];
      if (url.indexOf('http') != -1) {
        contributors.add(url);
      }
    }
    repo.contributors = contributors;
  }

  static trim(text) {
    if (text is String) {
      return text.trim();
    } else {
      return text.toString().trim();
    }
  }
}
