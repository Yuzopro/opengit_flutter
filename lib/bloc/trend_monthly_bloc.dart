import 'package:open_git/bloc/trend_bloc.dart';
import 'package:open_git/status/status.dart';

class TrendMonthlyBloc extends TrendBloc {
  TrendMonthlyBloc(String trend) : super(trend, since: 'monthly');

  @override
  ListPageType getListPageType() {
    return ListPageType.week_trend;
  }
}
