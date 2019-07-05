import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/status/status.dart';

class ReposMainBloc extends ReposBloc {
  ReposMainBloc(String userName) : super(userName, isStar: false);

  @override
  ListPageType getListPageType() {
    return ListPageType.repos;
  }
}
