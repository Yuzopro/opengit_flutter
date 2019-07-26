import 'package:flutter/material.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/route/navigator_util.dart';

class UserItemWidget extends StatelessWidget {
  final UserBean item;

  UserItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        height: 56.0,
        child: Row(
          children: <Widget>[
            ImageUtil.getCircleNetworkImage(
                item.avatarUrl, 36.0, "assets/images/ic_default_head.png"),
            Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: Text(
                item.login,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goUserProfile(context, item.login, item.avatarUrl);
      },
    );
  }
}
