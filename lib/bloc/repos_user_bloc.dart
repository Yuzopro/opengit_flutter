import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/status/status.dart';

class ReposUserBloc extends ReposBloc {
  ReposUserBloc(String userName) : super(userName, isStar: false);

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_user;
  }
}
