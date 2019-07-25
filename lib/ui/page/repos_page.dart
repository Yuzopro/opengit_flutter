import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/repos_item_widget.dart';

class ReposPage extends BaseListStatelessWidget<Repository, ReposBloc> {
  static final String TAG = "ReposPage";

  final PageType type;

  ReposPage(this.type);

  @override
  PageType getPageType() {
    return type;
  }

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  Widget builderItem(BuildContext context, Repository item) {
    return ReposItemWidget(item);
  }
}
