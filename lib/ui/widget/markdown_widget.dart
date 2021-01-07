import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:open_git/ui/widget/syntax_high_lighter.dart';
import 'package:open_git/util/common_util.dart';

class MarkdownWidget extends StatelessWidget {
  static const int DARK_WHITE = 0;

  static const int DARK_LIGHT = 1;

  static const int DARK_THEME = 2;

  final String markdownData;

  final int style;

  MarkdownWidget({this.markdownData = "", this.style = DARK_WHITE});

  _getCommonSheet(BuildContext context, Color codeBackground) {
    MarkdownStyleSheet markdownStyleSheet =
        MarkdownStyleSheet.fromTheme(Theme.of(context));
    return markdownStyleSheet
        .copyWith(
            codeblockDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: codeBackground,
                border: Border.all(
                    color: Color(YZColors.subTextColor), width: 0.3)))
        .copyWith(
            blockquoteDecoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(YZColors.subTextColor),
                border: Border.all(
                    color: Color(YZColors.subTextColor), width: 0.3)),
            blockquote: YZStyle.smallTextWhite);
  }

  _getStyleSheetDark(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZStyle.smallTextWhite,
      h1: YZStyle.largeLargeTextWhite,
      h2: YZStyle.largeTextWhiteBold,
      h3: YZStyle.normalTextMitWhiteBold,
      h4: YZStyle.middleTextWhite,
      h5: YZStyle.smallTextWhite,
      h6: YZStyle.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: YZStyle.middleTextWhiteBold,
      code: YZStyle.smallSubText,
    );
  }

  _getStyleSheetWhite(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZStyle.smallText,
      h1: YZStyle.largeLargeText,
      h2: YZStyle.largeTextBold,
      h3: YZStyle.normalTextBold,
      h4: YZStyle.middleText,
      h5: YZStyle.smallText,
      h6: YZStyle.smallText,
      strong: YZStyle.middleTextBold,
      code: YZStyle.smallSubText,
    );
  }

  _getStyleSheetTheme(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZStyle.smallTextWhite,
      h1: YZStyle.largeLargeTextWhite,
      h2: YZStyle.largeTextWhiteBold,
      h3: YZStyle.normalTextMitWhiteBold,
      h4: YZStyle.middleTextWhite,
      h5: YZStyle.smallTextWhite,
      h6: YZStyle.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: YZStyle.middleTextWhiteBold,
      code: YZStyle.smallSubText,
    );
  }

  _getStyle(BuildContext context) {
    var styleSheet = _getStyleSheetWhite(context);
    switch (style) {
      case DARK_LIGHT:
        styleSheet = _getStyleSheetDark(context);
        break;
      case DARK_THEME:
        styleSheet = _getStyleSheetTheme(context);
        break;
    }
    return styleSheet;
  }

  _getMarkDownData(String markdownData) {
    ///优化图片显示
    RegExp exp = RegExp(r'!\[.*\]\((.+)\)');
    RegExp expImg = RegExp("<img.*?(?:>|\/>)");
    RegExp expSrc = RegExp("src=[\'\"]?([^\'\"]*)[\'\"]?");

    String mdDataCode = markdownData;
    try {
      Iterable<Match> tags = exp.allMatches(markdownData);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imageMatch = m.group(0);
          if (imageMatch != null && !imageMatch.contains(".svg")) {
            String match = imageMatch.replaceAll("\)", "?raw=true)");
            if (!match.contains(".svg") && match.contains("http")) {
              ///增加点击
              String src = match
                  .replaceAll(RegExp(r'!\[.*\]\('), "")
                  .replaceAll(")", "");
              String actionMatch = "[$match]($src)";
              match = actionMatch;
            } else {
              match = "";
            }
            mdDataCode = mdDataCode.replaceAll(m.group(0), match);
          }
        }
      }

      ///优化img标签的src资源
      tags = expImg.allMatches(markdownData);
      if (tags != null && tags.length > 0) {
        for (Match m in tags) {
          String imageTag = m.group(0);
          String match = imageTag;
          if (imageTag != null) {
            Iterable<Match> srcTags = expSrc.allMatches(imageTag);
            for (Match srcMatch in srcTags) {
              String srcString = srcMatch.group(0);
              if (srcString != null && srcString.contains("http")) {
                String newSrc = srcString.substring(
                    srcString.indexOf("http"), srcString.length - 1) +
                    "?raw=true";

                ///增加点击
                match = "[![]($newSrc)]($newSrc)";
              }
            }
          }
          mdDataCode = mdDataCode.replaceAll(imageTag, match);
        }
      }
    } catch(e) {
      print(e.toString());
    }
    return mdDataCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: _getBackgroundColor(context),
      padding: EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: MarkdownBody(
          styleSheet: _getStyle(context),
          syntaxHighlighter: YZHighlighter(),
          data: _getMarkDownData(markdownData),
          onTapLink: (String text, String href, String title) {
            CommonUtil.launchUrl(context, text);
          },
        ),
      ),
    );
  }
}

class YZHighlighter extends SyntaxHighlighter {
  @override
  TextSpan format(String source) {
    String showSource = source.replaceAll("&lt;", "<");
    showSource = showSource.replaceAll("&gt;", ">");
    return DartSyntaxHighlighter().format(showSource);
  }
}
