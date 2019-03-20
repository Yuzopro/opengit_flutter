import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownUtil {
  static final List<String> _MARKDOWN_EXTENSIONS = [
    ".md",
    ".mkdn",
    ".mdwn",
    ".mdown",
    ".markdown",
    ".mkd",
    ".mkdown",
    ".ron",
    ".rst",
    "adoc"
  ];

  static String getGitHubEmojHtml(String text) {
    var syntaxes = [new EmojiSyntax()];
    String html = markdownToHtml(text, inlineSyntaxes: syntaxes);
    return html.replaceAll("<p>", "").replaceAll("<\/p>", "");
  }

  static Widget markdownBody(String text) {
    return new MarkdownBody(data: text);
  }

  static bool isMarkdown(String name) {
    if (name.isEmpty) {
      return false;
    }
    name = name.toLowerCase();
    int length = _MARKDOWN_EXTENSIONS.length;
    for (int i = 0; i < length; i++) {
      String value = _MARKDOWN_EXTENSIONS[i];
      if (name.contains(value)) {
        return true;
      }
    }
    return false;
  }
}
