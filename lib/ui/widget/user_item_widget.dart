import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';

class UserItemWidget extends StatelessWidget {
  final UserBean item;

  UserItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context),
      ),
      onTap: () {
        NavigatorUtil.goUserProfile(context, item.login);
      },
    );
  }

  Widget _postCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _profileColumn(context),
      ),
    );
  }

  Widget _profileColumn(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.avatarUrl, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.login,
                style: YZStyle.smallText,
              ),
            ),
          ),
        ],
      );
}
