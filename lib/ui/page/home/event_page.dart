import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/ui/widget/event_item_widget.dart';

class EventPage extends BaseListStatelessWidget<EventBean, EventBloc> {
  static final String TAG = "EventPage";

  final bool showBar;

  EventPage(this.showBar);

  @override
  bool isShowAppBar() {
    return showBar;
  }

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.event;
  }

  @override
  Widget builderItem(BuildContext context, EventBean item) {
    return EventItemWidget(item);
  }
}
