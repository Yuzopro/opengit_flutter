import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/reaction_detail_bean.dart';
import 'package:open_git/bloc/reaction_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/manager/user_manager.dart';

class ReactionPage
    extends BaseListStatelessWidget<ReactionDetailBean, ReactionBloc> {
  @override
  String getTitle(BuildContext context) {
    ReactionBloc bloc = BlocProvider.of<ReactionBloc>(context);
    return bloc.content;
  }

  @override
  Widget builderItem(BuildContext context, ReactionDetailBean item) {
    bool isYou = UserManager.instance.isYou(item.user.login);

    ReactionBloc bloc = BlocProvider.of<ReactionBloc>(context);

    return ListTile(
      leading: ImageUtil.getCircleNetworkImage(
          item.user.avatarUrl, 36.0, ImagePath.image_default_head),
      title: Text(item.user.login + (isYou ? " (it's you)" : "")),
      subtitle: Text(DateUtil.getMultiDateStr(item.createdAt),
          style: YZStyle.middleText),
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
