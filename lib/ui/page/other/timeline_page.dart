import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';

class TimelinePage extends BaseListStatelessWidget<ReleaseBean, TimelineBloc> {
  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.timeline;
  }

  @override
  Widget builderItem(BuildContext context, ReleaseBean item) {
    return ListTile(
      title: Text(item.name, style: YZStyle.middleText),
      subtitle: Text(DateUtil.getMultiDateStr(item.createdAt), style: YZStyle.smallText),
      onTap: () {
        NavigatorUtil.goTimelineDetail(context, item.name, item.body);
      },
    );
  }
}
