import 'package:open_git/redux/repos/repos_source_file_actions.dart';
import 'package:open_git/redux/repos/repos_source_file_state.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

const String TAG = "reposSourceFileReducer";

final reposSourceFileReducer = combineReducers<ReposSourceFileState>([
  TypedReducer<ReposSourceFileState, RequestingFilesAction>(
      _requestingRepoFiles),
  TypedReducer<ReposSourceFileState, ReceivedFilesAction>(_receivedRepoFiles),
  TypedReducer<ReposSourceFileState, ErrorLoadingFilesAction>(
      _errorLoadingRepoFiles),
  TypedReducer<ReposSourceFileState, PushFileAction>(_pushFile),
  TypedReducer<ReposSourceFileState, PopFileAction>(_popFile),
]);

ReposSourceFileState _requestingRepoFiles(ReposSourceFileState state, action) {
  return state.copyWith(
      status: LoadingStatus.loading,
      refreshStatus: RefreshStatus.idle,
      files: []);
}

ReposSourceFileState _receivedRepoFiles(ReposSourceFileState state, action) {
  return state.copyWith(
    status: LoadingStatus.success,
    refreshStatus: action.refreshStatus,
    files: action.files,
  );
}

ReposSourceFileState _errorLoadingRepoFiles(
    ReposSourceFileState state, action) {
  return state.copyWith(
    status: LoadingStatus.error,
    refreshStatus: RefreshStatus.idle,
  );
}

ReposSourceFileState _pushFile(ReposSourceFileState state, action) {
  List<String> stack = state.fileStack;
  stack.add(action.fileName);
  return state.copyWith(
    fileStack: stack,
  );
}

ReposSourceFileState _popFile(ReposSourceFileState state, action) {
  List<String> stack = state.fileStack;
  if (stack.length > 0) {
    stack.removeAt(stack.length - 1);
  }
  return state.copyWith(
    fileStack: stack,
  );
}
