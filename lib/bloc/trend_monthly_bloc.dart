import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/trend_bloc.dart';

class TrendMonthlyBloc extends TrendBloc {
  TrendMonthlyBloc(String trend) : super(trend, since: 'monthly');

  @override
  PageType getPageType() {
    return PageType.week_trend;
  }
}
