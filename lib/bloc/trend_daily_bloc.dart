import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bloc/trend_bloc.dart';

class TrendDailyBloc extends TrendBloc {
  TrendDailyBloc(String trend) : super(trend, since: 'daily');

  @override
  PageType getPageType() {
    return PageType.day_trend;
  }
}
