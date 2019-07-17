import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';

class IssueItemWidget extends StatelessWidget {
  final IssueBean item;

  IssueItemWidget(this.item);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getItemOwner(item.user.avatarUrl, item.user.login),
              //全称
              Padding(
                padding: EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(
                  _getReposFullName(item.repoUrl) ?? "",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //描述
              Padding(
                padding: EdgeInsets.only(bottom: 6.0),
                child: Text(
                  item.title,
                  style: TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
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
                      DateUtil.getNewsTimeStr(item.createdAt)),
                  _getItemBottom(
                      Image(
                          width: 12.0,
                          height: 12.0,
                          image: AssetImage('image/ic_comment.png')),
                      item.commentNum.toString()),
                  Text(
                    "#${item.number}",
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
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
              style: TextStyle(color: Colors.grey, fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Row(
      children: <Widget>[
        ImageUtil.getImageWidget(ownerHead, 18.0),
        Padding(
          padding: EdgeInsets.only(left: 4.0),
          child: Text(
            ownerName,
            style: TextStyle(
                color: Colors.black54,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  String _getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
  }
}
