import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/ui/status/loading_status.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class TrendState {
  final LoadingStatus dayStatus;
  final List<TrendBean> dayTrends;
  final RefreshStatus dayRefreshStatus;
  final LoadingStatus weekStatus;
  final List<TrendBean> weekTrends;
  final RefreshStatus weekRefreshStatus;
  final LoadingStatus monthStatus;
  final List<TrendBean> monthTrends;
  final RefreshStatus monthRefreshStatus;

  TrendState({
    this.dayStatus,
    this.dayTrends,
    this.dayRefreshStatus,
    this.weekStatus,
    this.weekTrends,
    this.weekRefreshStatus,
    this.monthStatus,
    this.monthTrends,
    this.monthRefreshStatus,
  });

  factory TrendState.initial() {
    return TrendState(
      dayStatus: LoadingStatus.idle,
      dayTrends: [],
      dayRefreshStatus: RefreshStatus.idle,
      weekStatus: LoadingStatus.idle,
      weekTrends: [],
      weekRefreshStatus: RefreshStatus.idle,
      monthStatus: LoadingStatus.idle,
      monthTrends: [],
      monthRefreshStatus: RefreshStatus.idle,
    );
  }

  TrendState copyWith({
    LoadingStatus dayStatus,
    List<TrendBean> dayTrends,
    RefreshStatus dayRefreshStatus,
    LoadingStatus weekStatus,
    List<TrendBean> weekTrends,
    RefreshStatus weekRefreshStatus,
    LoadingStatus monthStatus,
    List<TrendBean> monthTrends,
    RefreshStatus monthRefreshStatus,
  }) {
    return TrendState(
      dayStatus: dayStatus ?? this.dayStatus,
      dayTrends: dayTrends ?? this.dayTrends,
      dayRefreshStatus: dayRefreshStatus ?? this.dayRefreshStatus,
      weekStatus: weekStatus ?? this.weekStatus,
      weekTrends: weekTrends ?? this.weekTrends,
      weekRefreshStatus: weekRefreshStatus ?? this.weekRefreshStatus,
      monthStatus: monthStatus ?? this.monthStatus,
      monthTrends: monthTrends ?? this.monthTrends,
      monthRefreshStatus: monthRefreshStatus ?? this.monthRefreshStatus,
    );
  }
}
