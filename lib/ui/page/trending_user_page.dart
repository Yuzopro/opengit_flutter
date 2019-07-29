import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_user_bean.dart';
import 'package:open_git/bloc/trending_user_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class TrendingUserPage
    extends BaseListStatelessWidget<TrendingUserBean, TrendingUserBloc> {
  static final String TAG = "TrendingUserPage";

  @override
  PageType getPageType() {
    return PageType.trending_user;
  }

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  Widget builderItem(BuildContext context, TrendingUserBean item) {
    return InkWell(
      child: Container(
        color: Color(YZColors.white),
        margin: EdgeInsets.only(bottom: 8.0),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonUtil.getNameAndAvatarWidget(item.name, item.avatar, context: context),
            //全称
            SizedBox(
              height: 5.0,
            ),
            Text(
              item.repo.name ?? "",
              style: YZConstant.middleTextBold,
            ),
            SizedBox(
              height: 5.0,
            ),
            //描述
            Text(
              item.repo.description,
              style: YZConstant.smallTextT65,
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.username, item.repo.name);
      },
    );
  }
}
