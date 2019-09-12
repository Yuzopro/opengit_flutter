import 'package:open_git/bloc/user_bloc.dart';
import 'package:open_git/manager/user_manager.dart';

class FollowersBloc extends UserBloc {
  FollowersBloc(String userName) : super(userName);

  @override
  fetchList(int page) async {
    return await UserManager.instance.getUserFollower(userName, page);
  }
}
