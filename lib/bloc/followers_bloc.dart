import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class FollowersBloc extends FollowBloc {
  FollowersBloc(String userName) : super(userName);

  @override
  PageType getPageType() {
    return PageType.followers;
  }

  @override
  fetchList(int page) async {
    return await UserManager.instance.getUserFollower(userName, page);
  }
}
