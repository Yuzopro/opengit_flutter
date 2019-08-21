import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoUserStarBloc extends RepoBloc {
  RepoUserStarBloc(String userName) : super(userName);

  @override
  PageType getPageType() {
    return PageType.repos_user_star;
  }

  @override
  fetchRepos(int page) async {
    return await ReposManager.instance.getUserRepos(userName, page, null, true);
  }
}
