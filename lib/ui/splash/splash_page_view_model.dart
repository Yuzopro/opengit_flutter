import 'package:flutter/widgets.dart';
import 'package:open_git/login_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:redux/redux.dart';

class SplashPageViewModel {
  final LoginStatus status;

  SplashPageViewModel({
    @required this.status,
  });

  static SplashPageViewModel fromStore(Store<AppState> store) {
    return SplashPageViewModel(
      status: store.state.userState.status,
    );
  }
}
