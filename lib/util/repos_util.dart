import 'package:markdown/markdown.dart';

class ReposUtil {
  static String getGitHubEmojHtml(String text) {
    String html = markdownToHtml(text, inlineSyntaxes: [EmojiSyntax()]);
    return html.replaceAll("<p>", "").replaceAll("<\/p>", "");
  }
}
