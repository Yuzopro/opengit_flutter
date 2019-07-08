import 'package:flutter/material.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';

class ReactionPage
    extends BaseListStatelessWidget<ReactionDetailBean, ReactionBloc> {
  @override
  String getTitle(BuildContext context) {
    ReactionBloc bloc = BlocProvider.of<ReactionBloc>(context);
    return bloc.content;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.reaction;
  }

  @override
  Widget builderItem(BuildContext context, ReactionDetailBean item) {
    UserBean userBean = LoginManager.instance.getUserBean();
    bool isYou = false;
    if (item != null &&
        userBean != null &&
        item.user != null &&
        userBean.login == item.user.login) {
      isYou = true;
    }

    ReactionBloc bloc = BlocProvider.of<ReactionBloc>(context);

    return new ListTile(
      leading: ImageUtil.getImageWidget(item.user.avatarUrl, 36.0),
      title: Text(item.user.login),
      subtitle: Text(DateUtil.getNewsTimeStr(item.createdAt) +
          (isYou ? "(it's you)" : "")),
      trailing: isYou
          ? InkWell(
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onTap: () {
                bloc.deleteReactions(context, item.id);
              },
            )
          : null,
    );
  }
}
