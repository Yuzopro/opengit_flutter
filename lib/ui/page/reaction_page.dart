import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/status/status.dart';

class ReactionPage
    extends BaseListStatelessWidget<ReactionDetailBean, ReactionBloc> {
  @override
  String getTitle(BuildContext context) {
    ReactionBloc bloc = BlocProvider.of<ReactionBloc>(context);
    return bloc.content;
  }

  @override
  PageType getPageType() {
    return PageType.reaction;
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

    return ListTile(
      leading: ImageUtil.getCircleNetworkImage(
          item.user.avatarUrl, 36.0, "image/ic_default_head.png"),
      title: Text(item.user.login),
      subtitle: Text(DateUtil.getMultiDateStr(item.createdAt) +
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
