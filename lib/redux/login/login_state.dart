import 'package:open_git/ui/status/loading_status.dart';

class LoginState {
  final LoadingStatus status;
  final String token;

  LoginState({this.status, this.token});

  factory LoginState.initial() {
    return LoginState(
      status: LoadingStatus.idle,
      token: '',
    );
  }

  LoginState copyWith({LoadingStatus status, String token}) {
    return LoginState(
      status: status ?? this.status,
      token: token ?? this.token,
    );
  }
}
