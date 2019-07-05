import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/status/status.dart';

class ReposUserStarBloc extends ReposBloc {
  ReposUserStarBloc(String userName) : super(userName, isStar: true);

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_user_star;
  }
}
