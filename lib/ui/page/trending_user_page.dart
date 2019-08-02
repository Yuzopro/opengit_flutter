import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_user_bean.dart';
import 'package:open_git/bloc/trending_user_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.username, item.repo.name);
      },
    );
  }

  Widget _postCard(BuildContext context, TrendingUserBean item) =>
      Card(
        elevation: 2.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _profileColumn(context, item),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.repo.name ?? "--",
                style: YZConstant.middleTextBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.repo.description,
                style: YZConstant.smallTextT65,
              ),
            ),
          ],
        ),
      );

  Widget _profileColumn(BuildContext context, TrendingUserBean item) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.avatar, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.name,
                style: YZConstant.smallText,
              ),
            ),
          ),
        ],
      );
}
