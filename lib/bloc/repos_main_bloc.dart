import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/repos_bloc.dart';

class ReposMainBloc extends ReposBloc {
  ReposMainBloc(String userName) : super(userName, isStar: false);

  @override
  PageType getPageType() {
    return PageType.repos;
  }
}
