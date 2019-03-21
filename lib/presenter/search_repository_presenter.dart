import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/presenter/search_presenter.dart';
import 'package:open_git/util/markdown_util.dart';

class SearchRepositoryPresenter extends SearchPresenter {
  @override
  void dealResult(data, isFromMore) {
    if (data != null && data.length > 0) {
        List<Repository> list = new List();
        var items = data["items"];
        for (int i = 0; i < items.length; i++) {
          var dataItem = items[i];
          Repository repository = Repository.fromJson(dataItem);
          repository.description =
              MarkdownUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
          list.add(repository);
        }
        if (view != null) {
          view.setList(list, isFromMore);
        }
    }
  }
}
