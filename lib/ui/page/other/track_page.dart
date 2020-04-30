import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/track_bean.dart';
import 'package:open_git/bloc/track_bloc.dart';
import 'package:open_git/db/read_record_provider.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/ui/widget/flutter_hot_item_widget.dart';
import 'package:open_git/ui/widget/issue_item_widget.dart';
import 'package:open_git/ui/widget/repos_item_widget.dart';

class TrackPage extends BaseListStatelessWidget<TrackBean, TrackBloc> {
  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.track;
  }

  @override
  Widget builderItem(BuildContext context, TrackBean item) {
    if (item.type == ReadRecordProvider.TYPE_H5) {
      var bean = Entrylist.fromJson(jsonDecode(item.data1));
      return FlutterHotItemWidget(bean);
    } else  if (item.type == ReadRecordProvider.TYPE_REPO) {
      var bean = Repository.fromJson(jsonDecode(item.data1));
      return ReposItemWidget(bean);
    } else  if (item.type == ReadRecordProvider.TYPE_ISSUE) {
      var bean = IssueBean.fromJson(jsonDecode(item.data1));
      return IssueItemWidget(bean);
    }
  }
}
