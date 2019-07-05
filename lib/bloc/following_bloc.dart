import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/status/status.dart';

class FollowingBloc extends FollowBloc {
  FollowingBloc(String userName) : super(userName);

  @override
  ListPageType getListPageType() {
    return ListPageType.following;
  }

  @override
  fetchList(String userName, int page) async {
    return await UserManager.instance.getUserFollowing(userName, page);
  }
}
