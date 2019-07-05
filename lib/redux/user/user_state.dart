import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';


class UserState {
  final LoginStatus status;
  final UserBean currentUser;
  final String token;

  UserState({this.status, this.currentUser, this.token});

  factory UserState.initial() {
    return UserState(
      status: LoginStatus.idle,
      currentUser: null,
      token: "",
    );
  }

  UserState copyWith({LoginStatus status, UserBean currentUser, String token}) {
    return UserState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      token: token ?? this.token,
    );
  }
}
