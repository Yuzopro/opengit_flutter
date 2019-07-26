import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/ui/widget/user_item_widget.dart';


class FollowPage extends BaseListStatelessWidget<UserBean, FollowBloc> {
  final PageType type;

  FollowPage(this.type);

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  PageType getPageType() {
    return type;
  }

  @override
  Widget builderItem(BuildContext context, UserBean item) {
    return UserItemWidget(item);
  }
}
