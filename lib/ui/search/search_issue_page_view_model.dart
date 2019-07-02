import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/ui/search/search_page_view_model.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class SearchIssuePageViewModel extends SearchPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<IssueBean> issues;
  final Function onRefresh;
  final Function onLoad;

  SearchIssuePageViewModel(OnQuery onFetch,
      {this.status,
      this.refreshStatus,
      this.issues,
      this.onRefresh,
      this.onLoad})
      : super(onFetch);

  static SearchIssuePageViewModel fromStore(Store<AppState> store) {
    return SearchIssuePageViewModel(
      (text) {},
      status: store.state.searchState.status_issue,
      refreshStatus: store.state.searchState.refreshStatus_issue,
      issues: store.state.searchState.issues,
      onRefresh: () {},
      onLoad: () {},
    );
  }
}
