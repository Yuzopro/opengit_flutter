import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/repos_bloc.dart';

class ReposUserStarBloc extends ReposBloc {
  ReposUserStarBloc(String userName) : super(userName, isStar: true);

  @override
  PageType getPageType() {
    return PageType.repos_user_star;
  }
}
