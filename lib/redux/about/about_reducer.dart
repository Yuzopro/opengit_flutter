import 'package:open_git/redux/about/about_actions.dart';
import 'package:open_git/redux/about/about_state.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/util/log_util.dart';
import 'package:redux/redux.dart';

const String TAG = "aboutReducer";

final aboutReducer = combineReducers<AboutState>([
  TypedReducer<AboutState, RequestingUpdateAction>(_requestingEvents),
  TypedReducer<AboutState, ReceivedVersionAction>(_receivedVersionEvents),
  TypedReducer<AboutState, ReceivedUpdateAction>(_receivedUpdateEvents),
  TypedReducer<AboutState, ErrorLoadingUpdateAction>(_errorLoadingEvents),
]);

AboutState _requestingEvents(AboutState state, action) {
  LogUtil.v('_requestingEvents', tag: TAG);
  return state.copyWith(status: LoadingStatus.loading, version: '');
}

AboutState _receivedVersionEvents(AboutState state, action) {
  LogUtil.v('_receivedVersionEvents', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
    version: action.version,
  );
}

AboutState _receivedUpdateEvents(AboutState state, action) {
  LogUtil.v('_receivedVersionEvents', tag: TAG);
  return state.copyWith(
    status: LoadingStatus.success,
  );
}

AboutState _errorLoadingEvents(AboutState state, action) {
  LogUtil.v('_errorLoadingEvents', tag: TAG);
  return state.copyWith(status: LoadingStatus.error);
}
