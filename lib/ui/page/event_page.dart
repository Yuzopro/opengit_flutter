import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/event_item_widget.dart';


class EventPage extends BaseListStatelessWidget<EventBean, EventBloc> {
  static final String TAG = "EventPage";

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.event;
  }

  @override
  Widget builderItem(BuildContext context, EventBean item) {
    return EventItemWidget(item);
  }
}
