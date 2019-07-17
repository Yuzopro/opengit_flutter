import 'package:flutter/material.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/util/date_util.dart';

class TimelinePage extends BaseListStatelessWidget<ReleaseBean, TimelineBloc> {
  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.timeline;
  }

  @override
  Widget builderItem(BuildContext context, ReleaseBean item) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(DateUtil.getNewsTimeStr(item.createdAt)),
      onTap: () {
        NavigatorUtil.goTimelineDetail(context, item.name, item.body);
      },
    );
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.timeline;
  }
}
