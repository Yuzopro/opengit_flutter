import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/repos_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
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
    return type != PageType.repos;
  }

  @override
  String getTitle(BuildContext context) {
    String title;
    if (type == PageType.repos_user_star) {
      title = 'star项目';
    } else {
      title = '项目';
    }
    return title;
  }

  @override
  bool isShowAppBarActions() {
    return type != PageType.org_repos;
  }

  @override
  void openWebView(BuildContext context) {
    ReposBloc bloc = BlocProvider.of<ReposBloc>(context);
    String url;
    if (type == PageType.repos_user) {
      url = 'https://github.com/${bloc.userName}?tab=repositories';
    } else {
      url = 'https://github.com/${bloc.userName}?tab=stars';
    }
    NavigatorUtil.goWebView(context, bloc.userName, url);
  }

  @override
  String getShareText(BuildContext context) {
    ReposBloc bloc = BlocProvider.of<ReposBloc>(context);
    String url;
    if (type == PageType.repos_user) {
      url = 'https://github.com/${bloc.userName}?tab=repositories';
    } else {
      url = 'https://github.com/${bloc.userName}?tab=stars';
    }
    return url;
  }

  @override
  Widget builderItem(BuildContext context, Repository item) {
    return ReposItemWidget(item);
  }
}
