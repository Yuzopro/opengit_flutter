import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/status/refresh_status.dart';

class RequestingTrendsAction {
  final ListPageType type;

  RequestingTrendsAction(this.type);
}

class FetchTrendsAction {
  final ListPageType type;
  final String since, trend;

  FetchTrendsAction(this.since, this.trend, this.type);
}

class RefreshTrendsAction {
  final RefreshStatus refreshStatus;
  final ListPageType type;
  final String since, trend;

  RefreshTrendsAction(this.refreshStatus, this.type, this.since, this.trend);
}

class ReceivedTrendsAction {
  ReceivedTrendsAction(this.trends, this.refreshStatus, this.type);

  final List<TrendBean> trends;
  final ListPageType type;
  final RefreshStatus refreshStatus;
}

class ErrorLoadingTrendsAction {
  final ListPageType type;

  ErrorLoadingTrendsAction(this.type);
}
