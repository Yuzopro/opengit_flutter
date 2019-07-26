import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_repos_bean.dart';
import 'package:open_git/bloc/trending_repos_bloc.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class TrendingReposPage
    extends BaseListStatelessWidget<TrendingReposBean, TrendingReposBloc> {
  static final String TAG = "TrendingReposPage";

  final String since;

  TrendingReposPage(this.since);

  @override
  PageType getPageType() {
    return PageType.trending_repos;
  }

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  Widget builderItem(BuildContext context, TrendingReposBean item) {
    List<Widget> _bottomViews = List();
    _bottomViews.add(_buildCurrentStarWidget(item));
    _bottomViews.add(_buildAllStarWidget(item));
    _bottomViews.add(_buildForkWidget(item));
    _bottomViews.add(_getBuiltByWidget(item));

    return InkWell(
      child: Container(
        color: Color(YZColors.white),
        margin: EdgeInsets.only(bottom: 8.0),
        padding: EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                CommonUtil.getNameAndAvatarWidget(item.name, item.avatar,
                    context: context),
                CommonUtil.getLanguageWidget(item.language),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              item.description,
              style: YZConstant.smallSubText,
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: _bottomViews,
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.author, item.name);
      },
    );
  }

  Widget _buildCurrentStarWidget(TrendingReposBean item) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(
            width: 12.0,
            height: 12.0,
            image: AssetImage('assets/images/ic_star.png'),
          ),
          Text(
            '${item.currentPeriodStars.toString()} stars $since',
            style: YZConstant.minSubText,
          ),
        ],
      ),
    );
  }

  Widget _buildAllStarWidget(TrendingReposBean item) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(
            width: 12.0,
            height: 12.0,
            image: AssetImage('assets/images/ic_star.png'),
          ),
          Text(
            item.stars.toString(),
            style: YZConstant.minSubText,
          ),
        ],
      ),
    );
  }

  Widget _buildForkWidget(TrendingReposBean item) {
    return Row(
      children: <Widget>[
        Image(
          width: 12.0,
          height: 12.0,
          image: AssetImage('assets/images/ic_branch.png'),
        ),
        Text(
          item.forks.toString(),
          style: YZConstant.minSubText,
        ),
      ],
    );
  }

  Widget _getBuiltByWidget(TrendingReposBean item) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "Built by",
            style: YZConstant.minSubText,
          ),
          Row(
            children: item.builtBy
                .map(
                  (BuiltBy url) => Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: ImageUtil.getCircleNetworkImage(url.avatar ?? "",
                        12.0, "assets/images/ic_default_head.png"),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      flex: 1,
    );
  }
}
