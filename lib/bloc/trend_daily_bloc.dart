import 'package:open_git/bloc/trend_bloc.dart';
import 'package:open_git/status/status.dart';

class TrendDailyBloc extends TrendBloc {
  TrendDailyBloc(String trend) : super(trend, since: 'daily');

  @override
  ListPageType getListPageType() {
    return ListPageType.day_trend;
  }
}
