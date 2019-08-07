import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/route/navigator_util.dart';

class IssueItemWidget extends StatelessWidget {
  final IssueBean item;

  IssueItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postCard(context),
      ),
      onTap: () {
        NavigatorUtil.goIssueDetail(context, item);
      },
    );
  }

  String _getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
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
              _getReposFullName(item.repoUrl) ?? "--",
              style: YZConstant.middleTextBold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.title,
              style: YZConstant.smallTextT65,
            ),
          ),
          _actionColumn(),
        ],
      ),
    );
  }

  //column1
  Widget _profileColumn(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ImageUtil.getCircleNetworkImage(
              item.user.avatarUrl, 36.0, ImagePath.image_default_head),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                item.user.login,
                style: YZConstant.smallText,
              ),
            ),
          ),
          Text(
            DateUtil.getMultiDateStr(item.createdAt),
            style: YZConstant.smallSubText,
          ),
        ],
      );

  //column last
  Widget _actionColumn() => ButtonBar(
        alignment: MainAxisAlignment.start,
        children: <Widget>[
          LabelIcon(
            label: item.commentNum.toString(),
            image: ImagePath.image_comment,
          ),
          LabelIcon(
            label: item.labels != null ? item.labels.length.toString() : '0',
            image: ImagePath.image_issue_label,
          ),
          Text(
            "#${item.number}",
            style: YZConstant.smallSubText,
          ),
        ],
      );
}
