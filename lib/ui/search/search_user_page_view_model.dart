import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/ui/search/search_page_view_model.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';
import 'package:redux/redux.dart';

class SearchUserPageViewModel extends SearchPageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<UserBean> users;
  final Function onRefresh;
  final Function onLoad;

  SearchUserPageViewModel(OnQuery onFetch,
      {this.status,
      this.refreshStatus,
      this.users,
      this.onRefresh,
      this.onLoad})
      : super(onFetch);

  static SearchUserPageViewModel fromStore(Store<AppState> store) {
    return SearchUserPageViewModel(
      (text) {},
      status: store.state.searchState.status_user,
      refreshStatus: store.state.searchState.refreshStatus_user,
      users: store.state.searchState.users,
      onRefresh: () {},
      onLoad: () {},
    );
  }
}
