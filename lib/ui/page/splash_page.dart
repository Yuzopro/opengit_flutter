import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:redux/redux.dart';
import 'package:rxdart/rxdart.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SplashPageViewModel>(
      distinct: true,
      converter: (store) => SplashPageViewModel.fromStore(store),
      builder: (_, viewModel) {
        return SplashPageContent(viewModel: viewModel);
      },
    );
  }
}

class SplashPageContent extends StatelessWidget {
  final SplashPageViewModel viewModel;

  const SplashPageContent({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Observable.just(1).delay(Duration(milliseconds: 500)).listen((_) {
      if (viewModel.status == LoginStatus.success) {
        NavigatorUtil.goMain(context);
      } else if (viewModel.status == LoginStatus.error) {
        NavigatorUtil.goLogin(context);
      }
    });

    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.only(bottom: 30.0),
        child: Image(
          width: 64.0,
          height: 64.0,
          image: AssetImage('image/ic_launcher.png'),
        ),
      ),
    );
  }
}

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
