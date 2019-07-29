import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/common_util.dart';

class ReposItemWidget extends StatelessWidget {
  final Repository item;

  ReposItemWidget(this.item);

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
              Row(
                children: <Widget>[
                  CommonUtil.getNameAndAvatarWidget(
                      item.owner.login, item.owner.avatarUrl,
                      context: context),
                  CommonUtil.getLanguageWidget(item.language ?? ""),
                ],
              ),
              //全称
              SizedBox(
                height: 5.0,
              ),
              Text(
                item.fullName ?? "",
                style: YZConstant.middleTextBold,
              ),
              SizedBox(
                height: 5.0,
              ),
              //描述
              Text(
                item.description,
                style: YZConstant.smallTextT65,
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: AssetImage('assets/images/ic_star.png')),
                      item.stargazersCount.toString()),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: AssetImage('assets/images/ic_issue.png')),
                      item.openIssuesCount.toString()),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: AssetImage('assets/images/ic_branch.png')),
                      item.forksCount.toString()),
                  Text(
                    item.fork ? "Forked" : "",
                    style: YZConstant.minSubText,
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goReposDetail(context, item.owner.login, item.name);
        });
  }

  Widget _getItemBottom(Widget icon, String count) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          icon,
          SizedBox(
            width: 4.0,
          ),
          Text(
            count,
            style: YZConstant.minSubText,
          ),
        ],
      ),
    );
  }
}
