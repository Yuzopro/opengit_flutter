import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class FollowingBloc extends FollowBloc {
  FollowingBloc(String userName) : super(userName);

  @override
  PageType getPageType() {
    return PageType.following;
  }

  @override
  fetchList(String userName, int page) async {
    return await UserManager.instance.getUserFollowing(userName, page);
  }
}
