class HtmlUtil {
  static List<String> _SUPPORTED_CODE_FILE_EXTENSIONS = [
    "bsh",
    "c",
    "cc",
    "cpp",
    "cs",
    "csh",
    "cyc",
    "cv",
    "htm",
    "html",
    "java",
    "js",
    "m",
    "mxml",
    "perl",
    "pl",
    "pm",
    "py",
    "rb",
    "sh",
    "xhtml",
    "xml",
    "xsl"
  ];

  static String generateImageHtml(String imageUrl, String backgroundColor) {
    return "<html>" +
        "<head>" +
        "<style>" +
        "img{height: auto; width: 100%;}" +
        "body{background: " +
        backgroundColor +
        ";}" +
        "</style>" +
        "</head>" +
        "<body><img src=\"" +
        imageUrl +
        "\"/></body>" +
        "</html>";
  }

  static String generateHtmlSourceHtml(
      String htmlSource, String backgroundColor, String accentColor) {
    return "<html>" +
        "<head>" +
        "<meta charset=\"utf-8\" />\n" +
        "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0;\"/>" +
        "<style>" +
        "body{background: " +
        backgroundColor +
        ";}" +
        "a {color:" +
        accentColor +
        " !important;}" +
        "</style>" +
        "</head>" +
        "<body>" +
        htmlSource +
        "</body>" +
        "</html>";
  }

  static String generateCodeHtml(String codeSource, String extension,
      bool isDark, String backgroundColor, bool wrap, bool lineNums) {
    String skin = isDark ? "sons-of-obsidian" : "prettify";
    return "<html>\n" +
        "<head>\n" +
        "<meta charset=\"utf-8\" />\n" +
        "<title>Code View</title>\n" +
        "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0;\"/>" +
        "<script src=\"./core/run_prettify.js?autoload=true&amp;" +
        "skin=" +
        skin +
        "&amp;" +
        "lang=" +
        _getExtension(extension) +
        "&amp;\" defer></script>\n" +
        "<style>" +
        "body {background: " +
        backgroundColor +
        ";}" +
        ".prettyprint {background: " +
        backgroundColor +
        ";}" +
        "pre.prettyprint {" +
        " word-wrap: " +
        (wrap ? "break-word" : "normal") +
        "; " +
        " white-space: " +
        (wrap ? "pre-wrap" : "no-wrap") +
        "; " +
        "}" +
        "</style>" +
        "</head>\n" +
        "<body>\n" +
        "<?prettify lang=" +
        _getExtension(extension) +
        " linenums=" +
        lineNums.toString() +
        "?>\n" +
        "<pre class=\"prettyprint\">\n" +
        _formatCode(codeSource) +
        "</pre>\n" +
        "</body>\n" +
        "</html>";
  }

  static String generateMdHtml(String mdSource, String baseUrl, bool isDark,
      String backgroundColor, String accentColor, bool wrapCode) {
    String skin = isDark ? "markdown_dark.css" : "markdown_white.css";
    mdSource = baseUrl.isEmpty ? mdSource : _fixLinks(mdSource, baseUrl);
    //fix wiki inner url like this "href="/robbyrussell/oh-my-zsh/wiki/Themes""
    mdSource = _fixWikiLinks(mdSource);
    return "<html>\n" +
        "<head>\n" +
        "<meta charset=\"utf-8\" />\n" +
        "<title>MD View</title>\n" +
        "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;\"/>" +
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"./" +
        skin +
        "\">\n" +
        "<style>" +
        "body{background: " +
        backgroundColor +
        ";}" +
        "a {color:" +
        accentColor +
        " !important;}" +
        ".highlight pre, pre {" +
        " word-wrap: " +
        (wrapCode ? "break-word" : "normal") +
        "; " +
        " white-space: " +
        (wrapCode ? "pre-wrap" : "pre") +
        "; " +
        "}" +
        "</style>" +
        "</head>\n" +
        "<body>\n" +
        mdSource +
        "</body>\n" +
        "</html>";
  }

  static String _getExtension(String extension) {
    return _SUPPORTED_CODE_FILE_EXTENSIONS.contains(extension) ? extension : "";
  }

  static String _formatCode(String codeSource) {
    if (codeSource.isEmpty) return codeSource;
    return codeSource.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
  }

  static String _fixWikiLinks(String source) {
    try {
      RegExp exp = RegExp("href=\"(.*?)\"");
      Iterable<Match> tags = exp.allMatches(source);
      for (Match m in tags) {
        String oriUrl = m.group(1);
        String fixedUrl;
        if (oriUrl.startsWith("/") && oriUrl.contains("/wiki/")) {
          fixedUrl = "https://github.com" + oriUrl;
          source = source.replaceAll(
              "href=\"" + oriUrl + "\"", "href=\"" + fixedUrl + "\"");
        }
      }
    } catch (e) {
      print(e);
    }
    return source;
  }

  static String _fixLinks(String source, String baseUrl) {
    String owner = "";
    String repo = "";
    String branch = baseUrl.substring(
        baseUrl.indexOf("blob") + 5, baseUrl.lastIndexOf("/"));

    try {
      RegExp exp = RegExp("href=\"(.*?)\"");
      Iterable<Match> tags = exp.allMatches(source);
      for (Match m in tags) {
        String oriUrl = m.group(1);
        if (oriUrl.contains("http://") ||
                oriUrl.contains("https://") ||
                oriUrl.startsWith("#") //filter markdown inner link
            ) {
          continue;
        }

        String subUrl = oriUrl.startsWith("/") ? oriUrl : "/" + oriUrl;
        String fixedUrl = "https://raw.githubusercontent.com/" +
            owner +
            "/" +
            repo +
            "/" +
            branch +
            subUrl;
        source = source.replaceAll(
            "href=\"" + oriUrl + "\"", "href=\"" + fixedUrl + "\"");
      }
    } catch (e) {
      print(e);
    }

    try {
      RegExp exp = RegExp("src=\"(.*?)\"");
      Iterable<Match> tags = exp.allMatches(source);
      for (Match m in tags) {
        String oriUrl = m.group(1);
        if (oriUrl.contains("http://") || oriUrl.contains("https://")) {
          continue;
        }

        String subUrl = oriUrl.startsWith("/") ? oriUrl : "/" + oriUrl;
        String fixedUrl = "https://raw.githubusercontent.com/" +
            owner +
            "/" +
            repo +
            "/" +
            branch +
            subUrl;
        source = source.replaceAll(
            "src=\"" + oriUrl + "\"", "src=\"" + fixedUrl + "\"");
      }
    } catch (e) {
      print(e);
    }
    return source;
  }

  static String _generateDiffHtml(
      String diffSource, bool isDark, String backgroundColor, bool wrap) {
    String skin = isDark ? "diff_dark.css" : "diff_light.css";
    return "<html>\n" +
        "<head>\n" +
        "<meta charset=\"utf-8\" />\n" +
        "<title>Diff View</title>\n" +
        "<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0;\"/>" +
        "<link rel=\"stylesheet\" type=\"text/css\" href=\"./" +
        skin +
        "\">\n" +
        "<style>" +
        "body {background: " +
        backgroundColor +
        ";}\n" +
        ".pre {\n" +
        "background: " +
        backgroundColor +
        ";\n" +
        " word-wrap: " +
        (wrap ? "break-word" : "normal") +
        ";\n" +
        " white-space: " +
        (wrap ? "pre-wrap" : "pre") +
        ";\n" +
        "}\n" +
        "</style>\n" +
        "</head>\n" +
        "<body>\n" +
        "<pre class=\"pre\">\n" +
        _parseDiffSource(_formatCode(diffSource), wrap) +
        "</pre>\n" +
        "</body>\n" +
        "</html>";
  }

  static String _parseDiffSource(String diffSource, bool wrap) {
    List<String> lines = diffSource.split("\\n");
    String source = "";

    int addStartLine = -1;
    int removeStartLine = -1;
    int addLineNum = 0;
    int removeLineNum = 0;
    int normalLineNum = 0;

    for (int i = 0; i < lines.length; i++) {
      String line = lines[i];

      String lineNumberStr = "";
      String classStr = "";
      int curAddNumber = -1;
      int curRemoveNumber = -1;

      if (line.startsWith("+")) {
        classStr = "class=\"add\";";
        curAddNumber = addStartLine + normalLineNum + addLineNum;
        addLineNum++;
      } else if (line.startsWith("-")) {
        classStr = "class=\"remove\";";
        curRemoveNumber = removeStartLine + normalLineNum + removeLineNum;
        removeLineNum++;
      } else if (line.startsWith("@@")) {
        classStr = "class=\"change\";";
        removeStartLine = _getRemoveStartLine(line);
        addStartLine = _getAddStartLine(line);
        addLineNum = 0;
        removeLineNum = 0;
        normalLineNum = 0;
      } else if (!line.startsWith("\\")) {
        curAddNumber = addStartLine + normalLineNum + addLineNum;
        curRemoveNumber = removeStartLine + normalLineNum + removeLineNum;
        normalLineNum++;
      }
      lineNumberStr = _getDiffLineNumber(
          curRemoveNumber == -1 ? "" : curRemoveNumber.toString(),
          curAddNumber == -1 ? "" : curAddNumber.toString());

      source += ("\n" +
          "<div " +
          classStr +
          ">" +
          (wrap ? "" : lineNumberStr + _getBlank(1)) +
          line +
          "</div>");
    }
    return source;
  }

  static int _getRemoveStartLine(String line) {
    try {
      return int.parse(
          line.substring(line.indexOf("-") + 1, line.indexOf(",")));
    } catch (e) {
      return 1;
    }
  }

  static int _getAddStartLine(String line) {
    try {
      return int.parse(line.substring(
          line.indexOf("+") + 1, line.indexOf(",", line.indexOf("+"))));
    } catch (Exception) {
      return 1;
    }
  }

  static String _getDiffLineNumber(String removeNumber, String addNumber) {
    int minLength = 4;
    return _getBlank(minLength - removeNumber.length) +
        removeNumber +
        _getBlank(1) +
        _getBlank(minLength - addNumber.length) +
        addNumber;
  }

  static String _getBlank(int num) {
    String source = "";
    for (int i = 0; i < num; i++) {
      source += " ";
    }
    return source;
  }
}
