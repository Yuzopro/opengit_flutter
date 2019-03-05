import 'package:markdown/markdown.dart';

class MarkdownUtil {
  static String getGitHubEmojHtml(String text) {
    var syntaxes = [new EmojiSyntax()];
    String html = markdownToHtml(text, inlineSyntaxes: syntaxes);
    return html.replaceAll("<p>", "").replaceAll("<\/p>", "");
  }
}