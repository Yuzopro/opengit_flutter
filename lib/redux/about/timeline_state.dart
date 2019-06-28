import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class TimelineState {
  final LoadingStatus status;
  final RefreshStatus refreshStatus;
  final List<ReleaseBean> releases;
  final int page;

  TimelineState({this.status, this.refreshStatus, this.releases, this.page});

  factory TimelineState.initial() {
    return TimelineState(
      status: LoadingStatus.idle,
      refreshStatus: RefreshStatus.idle,
      releases: [],
      page: 1,
    );
  }

  TimelineState copyWith(
      {LoadingStatus status,
      RefreshStatus refreshStatus,
      List<ReleaseBean> releases,
      int page}) {
    return TimelineState(
      status: status ?? this.status,
      refreshStatus: refreshStatus ?? this.refreshStatus,
      releases: releases ?? this.releases,
      page: page ?? this.page,
    );
  }

  @override
  String toString() {
    return 'TimelineState{page: $page}';
  }
}
