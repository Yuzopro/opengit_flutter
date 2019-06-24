import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/loading_status.dart';
import 'package:open_git/refresh_status.dart';

class HomeState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<Entrylist> homes;
  final int page;
  final ReleaseBean releaseBean; //处理升级时用

  HomeState(
      {this.status,
      this.refreshStatus,
      this.homes,
      this.page,
      this.releaseBean});

  factory HomeState.initial() {
    return HomeState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      homes: [],
      page: 1,
      releaseBean: null,
    );
  }

  HomeState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<Entrylist> homes,
      int page,
      ReleaseBean releaseBean}) {
    return HomeState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      homes: homes ?? this.homes,
      page: page ?? this.page,
      releaseBean: releaseBean ?? this.releaseBean,
    );
  }

  @override
  String toString() {
    return 'HomeState{page: $page}';
  }
}
