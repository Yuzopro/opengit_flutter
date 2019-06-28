import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/repos/repos_source_code_actions.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:redux/redux.dart';

class ReposSourceCodeMiddleware extends MiddlewareClass<AppState> {
  static final String TAG = "ReposSourceFileMiddleware";

  @override
  void call(Store<AppState> store, action, NextDispatcher next) {
    next(action);
    if (action is FetchReposCodeAction) {
      _fetchReposCode(store, next, action.url);
    }
  }

  Future<void> _fetchReposCode(
      Store<AppState> store, NextDispatcher next, String url) async {
    next(RequestingCodeAction());
    try {
      bool isImage = ImageUtil.isImageEnd(url);
      var repos;
      if (!isImage) {
        repos = await ReposManager.instance.getFileAsStream(url, true);
      }
      LogUtil.v(repos, tag: TAG);
      LogUtil.v('isMarkdown is ' + MarkdownUtil.isMarkdown(url).toString(),
          tag: TAG);
      next(ReceivedCodeAction(repos, isImage, MarkdownUtil.isMarkdown(url)));
    } catch (e) {
      LogUtil.v(e, tag: TAG);
      next(ErrorLoadingCodeAction());
    }
  }
}
