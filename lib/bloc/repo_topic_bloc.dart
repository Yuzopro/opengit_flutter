import 'package:open_git/bloc/repo_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoTopicBloc extends RepoBloc {
  RepoTopicBloc(String userName) : super(userName);

  @override
  fetchRepos(int page) async {
    return await ReposManager.instance.searchTopic(userName, page);
  }
}
