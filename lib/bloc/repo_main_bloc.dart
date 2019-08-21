import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoMainBloc extends RepoBloc {
  RepoMainBloc(String userName) : super(userName);

  @override
  PageType getPageType() {
    return PageType.repos;
  }

  @override
  fetchRepos(int page) async {
    return await ReposManager.instance
        .getUserRepos(userName, page, null, false);
  }
}
