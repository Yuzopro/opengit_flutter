import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/status/status.dart';

class UserState {
  final LoginStatus status;
  final UserBean currentUser;
  final String token;
  final bool isGuide;
  final int countdown;

  UserState(
      {this.status,
      this.currentUser,
      this.token,
      this.isGuide,
      this.countdown});

  factory UserState.initial() {
    return UserState(
      status: LoginStatus.idle,
      currentUser: null,
      token: "",
      isGuide: false,
      countdown: 5,
    );
  }

  UserState copyWith({
    LoginStatus status,
    UserBean currentUser,
    String token,
    bool isGuide,
    int countdown,
  }) {
    return UserState(
      status: status ?? this.status,
      currentUser: currentUser ?? this.currentUser,
      token: token ?? this.token,
      isGuide: isGuide ?? this.isGuide,
      countdown: countdown ?? this.countdown,
    );
  }
}
