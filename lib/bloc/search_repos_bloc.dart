import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/util/repos_util.dart';

class SearchReposBloc extends SearchBloc<Repository> {
  SearchReposBloc() : super('repositories');

  @override
  PageType getPageType() {
    return PageType.search_repos;
  }

  @override
  void dealResult(result) {
    if (bean.data == null) {
      bean.data = List();
    }
    if (page == 1) {
      bean.data.clear();
    }

    noMore = true;
    if (result != null && result.length > 0) {
      var items = result["items"];
      noMore = items.length != Config.PAGE_SIZE;
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        Repository repository = Repository.fromJson(dataItem);
        repository.description =
            ReposUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
        bean.data.add(repository);
      }
    } else {
      bean.isError = true;
    }

    sink.add(bean);
  }
}
