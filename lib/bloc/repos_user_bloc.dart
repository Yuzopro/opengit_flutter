import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/repos_bloc.dart';

class ReposUserBloc extends ReposBloc {
  ReposUserBloc(String userName) : super(userName, isStar: false);

  @override
  PageType getPageType() {
    return PageType.repos_user;
  }
}
