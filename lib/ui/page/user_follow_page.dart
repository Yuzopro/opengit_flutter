import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/user_item_widget.dart';


class FollowPage extends BaseListStatelessWidget<UserBean, FollowBloc> {
  final ListPageType type;

  FollowPage(this.type);

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  ListPageType getListPageType() {
    return type;
  }

  @override
  Widget builderItem(BuildContext context, UserBean item) {
    return UserItemWidget(item);
  }
}
