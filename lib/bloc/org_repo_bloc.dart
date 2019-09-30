import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoOrgBloc extends RepoBloc {
  RepoOrgBloc(String userName) : super(userName);

  @override
  fetchRepos(int page) async {
    return await ReposManager.instance.getOrgRepos(userName, page, null);
  }
}
