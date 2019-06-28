import 'package:flutter/widgets.dart';
import 'package:open_git/redux/about/about_actions.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:redux/redux.dart';

class AboutPageViewModel {
  final LoadingStatus status;
  final String version;
  final Function onLoad;

  AboutPageViewModel({this.status, this.version, this.onLoad});

  static AboutPageViewModel fromStore(
      Store<AppState> store, BuildContext context) {
    return AboutPageViewModel(
      status: store.state.aboutState.status,
      version: store.state.aboutState.version,
      onLoad: () {
        store.dispatch(FetchUpdateAction(context));
      },
    );
  }
}
