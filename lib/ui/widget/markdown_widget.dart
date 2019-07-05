import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:open_git/common/common.dart';
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
            codeblockDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: codeBackground,
                border: new Border.all(
                    color: Color(YZColors.subTextColor), width: 0.3)))
        .copyWith(
            blockquoteDecoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                color: Color(YZColors.subTextColor),
                border: new Border.all(
                    color: Color(YZColors.subTextColor), width: 0.3)),
            blockquote: YZConstant.smallTextWhite);
  }

  _getStyleSheetDark(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZConstant.smallTextWhite,
      h1: YZConstant.largeLargeTextWhite,
      h2: YZConstant.largeTextWhiteBold,
      h3: YZConstant.normalTextMitWhiteBold,
      h4: YZConstant.middleTextWhite,
      h5: YZConstant.smallTextWhite,
      h6: YZConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: YZConstant.middleTextWhiteBold,
      code: YZConstant.smallSubText,
    );
  }

  _getStyleSheetWhite(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZConstant.smallText,
      h1: YZConstant.largeLargeText,
      h2: YZConstant.largeTextBold,
      h3: YZConstant.normalTextBold,
      h4: YZConstant.middleText,
      h5: YZConstant.smallText,
      h6: YZConstant.smallText,
      strong: YZConstant.middleTextBold,
      code: YZConstant.smallSubText,
    );
  }

  _getStyleSheetTheme(BuildContext context) {
    return _getCommonSheet(context, Color.fromRGBO(40, 44, 52, 1.00)).copyWith(
      p: YZConstant.smallTextWhite,
      h1: YZConstant.largeLargeTextWhite,
      h2: YZConstant.largeTextWhiteBold,
      h3: YZConstant.normalTextMitWhiteBold,
      h4: YZConstant.middleTextWhite,
      h5: YZConstant.smallTextWhite,
      h6: YZConstant.smallTextWhite,
      em: const TextStyle(fontStyle: FontStyle.italic),
      strong: YZConstant.middleTextWhiteBold,
      code: YZConstant.smallSubText,
    );
  }

  _getBackgroundColor(context) {
    Color background = Color(YZColors.white);
    switch (style) {
      case DARK_LIGHT:
        background = Color(YZColors.primaryLightValue);
        break;
      case DARK_THEME:
        background = Theme.of(context).primaryColor;
        break;
    }
    return background;
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
    RegExp exp = new RegExp(r'!\[.*\]\((.+)\)');
    RegExp expImg = new RegExp("<img.*?(?:>|\/>)");
    RegExp expSrc = new RegExp("src=[\'\"]?([^\'\"]*)[\'\"]?");

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
                  .replaceAll(new RegExp(r'!\[.*\]\('), "")
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
      color: _getBackgroundColor(context),
      padding: EdgeInsets.all(5.0),
      child: SingleChildScrollView(
        child: new MarkdownBody(
          styleSheet: _getStyle(context),
          syntaxHighlighter: new YZHighlighter(),
          data: _getMarkDownData(markdownData),
          onTapLink: (String source) {
            CommonUtil.launchUrl(context, source);
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
    return new DartSyntaxHighlighter().format(showSource);
  }
}
