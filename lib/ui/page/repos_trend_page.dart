import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/repos_trend_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/repos_item_widget.dart';

class ReposTrendPage
    extends BaseListStatelessWidget<Repository, ReposTrendBloc> {
  @override
  String getTitle(BuildContext context) {
    ReposTrendBloc bloc = BlocProvider.of<ReposTrendBloc>(context);
    return bloc.language;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_trend;
  }

  @override
  Widget builderItem(BuildContext context, Repository item) {
    return ReposItemWidget(item);
  }
}
