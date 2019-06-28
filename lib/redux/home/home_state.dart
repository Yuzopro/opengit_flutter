import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class HomeState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Entrylist> homes;
  final int page;

  HomeState(
      {this.status,
      this.refreshStatus,
      this.homes,
      this.page});

  factory HomeState.initial() {
    return HomeState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      homes: [],
      page: 1,
    );
  }

  HomeState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<Entrylist> homes,
      int page}) {
    return HomeState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      homes: homes ?? this.homes,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return 'HomeState{page: $page}';
  }
}
