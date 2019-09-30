import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class FollowingBloc extends UserBloc {
  FollowingBloc(String userName) : super(userName);

  @override
  fetchList(int page) async {
    return await UserManager.instance.getUserFollowing(userName, page);
  }
}
