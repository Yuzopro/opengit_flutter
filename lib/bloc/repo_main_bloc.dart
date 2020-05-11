import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoMainBloc extends RepoBloc {
  RepoMainBloc(String userName) : super(userName);

  @override
  fetchRepos(int page) async {
    return await ReposManager.instance.getRepos(page, null);
  }
}
