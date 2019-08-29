import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/event_util.dart';

class EventItemWidget extends StatelessWidget {
  final EventBean item;

  EventItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context),
      ),
      onTap: () {
        if (item.payload != null && item.payload.issue != null) {
          NavigatorUtil.goIssueDetail(context, item.payload.issue);
        } else if (item.repo != null && item.repo.name != null) {
          String repoUser, repoName;
          if (item.repo.name.isNotEmpty && item.repo.name.contains("/")) {
            List<String> repos = TextUtil.split(item.repo.name, '/');
            repoUser = repos[0];
            repoName = repos[1];
          }
          NavigatorUtil.goReposDetail(context, repoUser, repoName);
        }
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
              EventUtil.getAction(item) ?? "--",
              style: YZStyle.middleTextBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              EventUtil.getDesc(item) ?? "--",
              style: YZStyle.smallTextT65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: ImageUtil.getCircleNetworkImage(
                item.actor.avatarUrl, 36.0, ImagePath.image_default_head),
            onTap: () {
              NavigatorUtil.goUserProfile(context, item.actor.login);
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.actor.login,
                style: YZStyle.smallText,
              ),
            ),
          ),
          Text(
            DateUtil.getMultiDateStr(item.createdAt),
            style: YZStyle.smallSubText,
          ),
        ],
      );
}
