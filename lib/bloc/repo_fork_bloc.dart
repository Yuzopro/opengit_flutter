import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoForkBloc extends UserBloc {
  final String owner, repo;

  RepoForkBloc(this.owner, this.repo) : super('');

  @override
  fetchList(int page) async {
    return await ReposManager.instance.getRepoForks(owner, repo, page);
  }
}
