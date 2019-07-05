import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/repos_event_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/event_item_widget.dart';

class ReposEventPage
    extends BaseListStatelessWidget<EventBean, ReposEventBloc> {
  @override
  String getTitle(BuildContext context) {
    ReposEventBloc bloc = BlocProvider.of<ReposEventBloc>(context);
    return bloc.reposName;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_event;
  }

  @override
  Widget builderItem(BuildContext context, EventBean item) {
    return EventItemWidget(item);
  }
}
