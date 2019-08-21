import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trending_repos_bean.dart';
import 'package:open_git/bloc/trending_repo_bloc.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/route/navigator_util.dart';

class TrendingReposPage
    extends BaseListStatelessWidget<TrendingReposBean, TrendingRepoBloc> {
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
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context, item),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.author, item.name);
      },
    );
  }

  Widget _postCard(BuildContext context, TrendingReposBean item) =>
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
                item.name ?? "--",
                style: YZStyle.middleTextBold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                item.description,
                style: YZStyle.smallTextT65,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${item.currentPeriodStars.toString()} stars $since',
                style: YZStyle.smallSubText,
              ),
            ),
            _actionColumn(item),
          ],
        ),
      );

  Widget _profileColumn(BuildContext context, TrendingReposBean item) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.avatar, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.author,
                style: YZStyle.smallText,
              ),
            ),
          ),
          ClipOval(
            child: Container(
              color: ReposManager.instance.getLanguageColor(item.language),
              width: 8.0,
              height: 8.0,
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          Text(
            item.language ?? 'Unkown',
            style: YZStyle.smallSubText,
          ),
        ],
      );

  //column last
  Widget _actionColumn(TrendingReposBean item) =>
      ButtonBar(
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          LabelIcon(
            label: item.stars.toString(),
            image: ImagePath.image_star,
          ),
          LabelIcon(
            label: item.forks.toString(),
            image: ImagePath.image_fork,
          ),
          _getBuiltByWidget(item),
        ],
      );

  Widget _getBuiltByWidget(TrendingReposBean item) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "built by",
            style: YZStyle.smallSubText,
          ),
          SizedBox(
            width: 5.0,
          ),
          Row(
            children: item.builtBy
                .map(
                  (BuiltBy url) =>
                  Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: ImageUtil.getCircleNetworkImage(url.avatar ?? "",
                        14.0, ImagePath.image_default_head),
                  ),
            )
                .toList(),
          ),
        ],
      );
}
