import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/manager/user_manager.dart';
import 'package:open_git/status/status.dart';

class FollowersBloc extends FollowBloc {
  FollowersBloc(String userName) : super(userName);

  @override
  ListPageType getListPageType() {
    return ListPageType.followers;
  }

  @override
  fetchList(String userName, int page) async {
    return await UserManager.instance.getUserFollower(userName, page);
  }
}
