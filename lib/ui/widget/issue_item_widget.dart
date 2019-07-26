import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class IssueItemWidget extends StatelessWidget {
  final IssueBean item;

  IssueItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
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
              CommonUtil.getNameAndAvatarWidget(item.user.login, item.user.avatarUrl, context: context),
              //全称
              SizedBox(
                height: 5.0,
              ),
              Text(
                _getReposFullName(item.repoUrl) ?? "",
                style: YZConstant.middleTextBold,
              ),
              SizedBox(
                height: 5.0,
              ),
              //描述
              Text(
                item.title,
                style: YZConstant.smallSubText,
              ),
              SizedBox(
                height: 5.0,
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      Icon(
                        Icons.timer,
                        color: Colors.grey,
                        size: 14.0,
                      ),
                      DateUtil.getMultiDateStr(item.createdAt)),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: AssetImage('assets/images/ic_comment.png')),
                      item.commentNum.toString()),
                  Text(
                    "#${item.number}",
                    style: YZConstant.minSubText,
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goIssueDetail(context, item);
        });
  }

  Widget _getItemBottom(Widget icon, String count) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          icon,
          Padding(
            padding: EdgeInsets.only(left: 3.0),
            child: Text(
              count,
              style: YZConstant.minSubText,
            ),
          ),
        ],
      ),
    );
  }

  String _getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
  }
}
