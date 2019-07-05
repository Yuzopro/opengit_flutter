import 'package:open_git/bloc/trend_bloc.dart';
import 'package:open_git/status/status.dart';

class TrendWeeklyBloc extends TrendBloc {
  TrendWeeklyBloc(String trend) : super(trend, since: 'weekly');

  @override
  ListPageType getListPageType() {
    return ListPageType.month_trend;
  }
}
