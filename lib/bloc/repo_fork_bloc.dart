import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoForkBloc extends UserBloc {
  final String owner, repo;

  RepoForkBloc(this.owner, this.repo) : super('');

  @override
  PageType getPageType() {
    return PageType.repo_fork;
  }

  @override
  fetchList(int page) async {
    return await ReposManager.instance.getRepoForks(owner, repo, page);
  }
}
