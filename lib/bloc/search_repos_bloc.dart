import 'dart:collection';

import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/markdown_util.dart';

class SearchReposBloc extends SearchBloc<Repository> {
  SearchReposBloc() : super('repositories');

  @override
  ListPageType getListPageType() {
    return ListPageType.search_repos;
  }

  @override
  void dealResult(result) {
    if (list == null) {
      list = List();
    }
    if (page == 1) {
      list.clear();
    }

    noMore = true;
    if (result != null && result.length > 0) {
      var items = result["items"];
      noMore = items.length != Config.PAGE_SIZE;
      for (int i = 0; i < items.length; i++) {
        var dataItem = items[i];
        Repository repository = Repository.fromJson(dataItem);
        repository.description =
            MarkdownUtil.getGitHubEmojHtml(repository.description ?? "暂无描述");
        list.add(repository);
      }
    }

    sink.add(UnmodifiableListView<Repository>(list));
  }
}
