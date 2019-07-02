import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/ui/search/search_page_view_model.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class SearchReposPageViewModel extends SearchPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Repository> repos;
  final Function onRefresh;
  final Function onLoad;

  SearchReposPageViewModel(OnQuery onFetch, {this.status, this.refreshStatus, this.repos, this.onRefresh, this.onLoad}) : super(onFetch);

  static SearchReposPageViewModel fromStore(Store<AppState> store) {
    return SearchReposPageViewModel(
      (text){},
      status: store.state.searchState.status_repos,
      refreshStatus: store.state.searchState.refreshStatus_repos,
      repos: store.state.searchState.repos,
      onRefresh: () {},
      onLoad: () {},
    );
  }
}
