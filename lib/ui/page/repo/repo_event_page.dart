import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bloc/repo_event_bloc.dart';
import 'package:open_git/ui/widget/event_item_widget.dart';

class RepoEventPage
    extends BaseListStatelessWidget<EventBean, RepoEventBloc> {
  @override
  String getTitle(BuildContext context) {
    RepoEventBloc bloc = BlocProvider.of<RepoEventBloc>(context);
    return bloc.reposName;
  }

  @override
  Widget builderItem(BuildContext context, EventBean item) {
    return EventItemWidget(item);
  }
}
