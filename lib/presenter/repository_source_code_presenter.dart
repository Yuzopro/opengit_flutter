import 'dart:convert';

import 'package:open_git/contract/repository_source_code_contract.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/html_util.dart';
import 'package:open_git/util/markdown_util.dart';

class RepositorySourceCodePresenter extends IRepositorySourceCodePresenter {
  @override
  getFileAsStream(url) {
    ReposManager.instance.getFileAsStream(url, (data) {
      if (data != null && view != null) {
        String result;
        bool isMarkdown;
        if (MarkdownUtil.isMarkdown(url)) {
          result = data;
          isMarkdown = true;
        } else {
          String html = HtmlUtil.generateCodeHtml(
              data, null, false, "#ffffff", false, true);
          result = new Uri.dataFromString(html,
              mimeType: 'text/html', encoding: Encoding.getByName("utf-8"))
              .toString();
          isMarkdown = false;
        }
        view.getReposSourceCodeSuccess(result, isMarkdown);
      }
    }, (code, msg) {});
  }
}
