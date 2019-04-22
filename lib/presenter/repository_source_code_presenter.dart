import 'package:open_git/contract/repository_source_code_contract.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/util/markdown_util.dart';

class RepositorySourceCodePresenter extends IRepositorySourceCodePresenter {
  @override
  getFileAsStream(url) async {
    final result = await ReposManager.instance.getFileAsStream(url, true);
    if (result != null && view != null) {
      bool isMarkdown;
      if (MarkdownUtil.isMarkdown(url)) {
        isMarkdown = true;
      } else {
        isMarkdown = false;
      }
      view.getReposSourceCodeSuccess(result, isMarkdown);
    }
  }
}
