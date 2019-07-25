import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/trend_bloc.dart';

class TrendWeeklyBloc extends TrendBloc {
  TrendWeeklyBloc(String trend) : super(trend, since: 'weekly');

  @override
  PageType getPageType() {
    return PageType.month_trend;
  }
}
