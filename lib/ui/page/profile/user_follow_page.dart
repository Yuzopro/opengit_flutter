import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/follow_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/widget/user_item_widget.dart';

class FollowPage extends BaseListStatelessWidget<UserBean, FollowBloc> {
  final PageType type;

  FollowPage(this.type);

  @override
  String getTitle(BuildContext context) {
    String title;
    if (type == PageType.followers) {
      title = '关注我的';
    } else if (type == PageType.following) {
      title = '我关注的';
    } else if (type == PageType.org_member) {
      title = '成员';
    }
    return title;
  }

  @override
  PageType getPageType() {
    return type;
  }

  @override
  bool isShowAppBarActions() {
    return type != PageType.org_member;
  }

  @override
  void openWebView(BuildContext context) {
    FollowBloc bloc = BlocProvider.of<FollowBloc>(context);
    String url;
    if (type == PageType.followers) {
      url = 'https://github.com/${bloc.userName}?tab=followers';
    } else {
      url = 'https://github.com/${bloc.userName}?tab=following';
    }
    NavigatorUtil.goWebView(context, bloc.userName, url);
  }

  @override
  Widget builderItem(BuildContext context, UserBean item) {
    return UserItemWidget(item);
  }
}
