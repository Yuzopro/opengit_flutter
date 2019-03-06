import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownUtil {
  static String getGitHubEmojHtml(String text) {
    var syntaxes = [new EmojiSyntax()];
    String html = markdownToHtml(text, inlineSyntaxes: syntaxes);
    return html.replaceAll("<p>", "").replaceAll("<\/p>", "");
  }

  static Widget markdownBody(String text) {
    return new MarkdownBody(data: text);
  }
}
