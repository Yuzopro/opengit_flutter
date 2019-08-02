import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/route/navigator_util.dart';

class ReposItemWidget extends StatelessWidget {
  final Repository item;

  ReposItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.owner.login, item.name);
      },
    );
  }

  Widget _postCard(BuildContext context) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _profileColumn(context),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.name ?? "--",
              style: YZConstant.middleTextBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.description,
              style: YZConstant.smallTextT65,
            ),
          ),
          _actionColumn(),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.owner.avatarUrl, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.owner.login,
                style: YZConstant.smallText,
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
            style: YZConstant.smallSubText,
          ),
        ],
      );

  Widget _actionColumn() => ButtonBar(
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          LabelIcon(
            label: item.stargazersCount.toString(),
            image: ImagePath.image_star,
          ),
          LabelIcon(
            label: item.openIssuesCount.toString(),
            image: ImagePath.image_issue,
          ),
          LabelIcon(
            label: item.forksCount.toString(),
            image: ImagePath.image_fork,
          ),
        ],
      );
}
