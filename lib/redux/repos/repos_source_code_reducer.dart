import 'package:open_git/redux/repos/repos_source_code_actions.dart';
import 'package:open_git/redux/repos/repos_source_code_state.dart';
import 'package:open_git/redux/repos/repos_source_file_actions.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:redux/redux.dart';

const String TAG = "reposSourceCodeReducer";

final reposSourceCodeReducer = combineReducers<ReposSourceCodeState>([
  TypedReducer<ReposSourceCodeState, RequestingCodeAction>(
      _requestingReposCode),
  TypedReducer<ReposSourceCodeState, ReceivedCodeAction>(_receivedReposCode),
  TypedReducer<ReposSourceCodeState, ErrorLoadingFilesAction>(
      _errorLoadingReposCode),
]);

ReposSourceCodeState _requestingReposCode(ReposSourceCodeState state, action) {
  return state.copyWith(
      status: LoadingStatus.loading,
      data: '',
      isImage: false,
      isMarkdown: false);
}

ReposSourceCodeState _receivedReposCode(ReposSourceCodeState state, action) {
  return state.copyWith(
      status: LoadingStatus.success,
      data: action.data,
      isImage: action.isImage,
      isMarkdown: action.isMarkdown);
}

ReposSourceCodeState _errorLoadingReposCode(
    ReposSourceCodeState state, action) {
  return state.copyWith(
    status: LoadingStatus.error,
  );
}
