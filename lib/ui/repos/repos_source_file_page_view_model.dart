import 'package:flutter/widgets.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_source_file_actions.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

typedef OnNext = void Function(String file);

class ReposSourceFilePageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<SourceFileBean> files;
  final List<String> fileStack;
  final Function onRefresh;
  final WillPopCallback onWillPop;
  final OnNext onNext;

  ReposSourceFilePageViewModel(
      {this.status,
      this.refreshStatus,
      this.files,
      this.onRefresh,
      this.onWillPop,
      this.onNext,
      this.fileStack});

  static ReposSourceFilePageViewModel fromStore(
      Store<AppState> store, String reposOwner, String reposName) {
    return ReposSourceFilePageViewModel(
        status: store.state.reposSourceFileState.status,
        refreshStatus: store.state.reposSourceFileState.refreshStatus,
        files: store.state.reposSourceFileState.files,
        fileStack: store.state.reposSourceFileState.fileStack,
        onRefresh: () {
          store.dispatch(FetchReposFileAction(
              reposOwner, reposName, RefreshStatus.refresh));
        },
        onWillPop: () {
          int length = store.state.reposSourceFileState.fileStack.length;
          if (length > 0) {
            store.dispatch(FetchPreAction(reposOwner, reposName));
            return new Future.value(false);
          }
          return new Future.value(true);
        },
        onNext: (file) {
          store.dispatch(FetchNextAction(reposOwner, reposName, file));
        });
  }
}
