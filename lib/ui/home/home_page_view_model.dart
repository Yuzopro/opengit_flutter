import 'package:flutter/widgets.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/list_page_type.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/refresh_status.dart';
import 'package:redux/redux.dart';

class HomePageViewModel {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Entrylist> homes;
  final Function onRefresh;
  final Function onLoad;
  final ReleaseBean releaseBean;

  HomePageViewModel(
      {@required this.status,
      @required this.refreshStatus,
      @required this.homes,
      @required this.onRefresh,
      @required this.onLoad,
      this.releaseBean});

  static HomePageViewModel fromStore(Store<AppState> store) {
    return HomePageViewModel(
        status: store.state.homeState.status,
        refreshStatus: store.state.homeState.refreshStatus,
        homes: store.state.homeState.homes,
        onRefresh: () {
          store.dispatch(RefreshAction(RefreshStatus.refresh, ListPageType.home));
        },
        onLoad: () {
          store.dispatch(RefreshAction(RefreshStatus.loading, ListPageType.home));
        },
        releaseBean: store.state.homeState.releaseBean);
  }
}
