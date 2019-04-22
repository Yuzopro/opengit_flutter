import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/bean/event_payload_bean.dart';
import 'package:open_git/contract/event_contract.dart';
import 'package:open_git/presenter/event_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/event_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class EventPage extends StatefulWidget {
  final String userName;

  EventPage(this.userName);

  @override
  State<StatefulWidget> createState() {
    return _EventPageState(userName);
  }
}

class _EventPageState extends PullRefreshListState<
    EventPage,
    EventBean,
    EventPresenter,
    IEventView> with AutomaticKeepAliveClientMixin implements IEventView {
  final String userName;

  _EventPageState(this.userName);

  @override
  bool get wantKeepAlive => true;

  @override
  EventPresenter initPresenter() {
    return new EventPresenter();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: buildBody(context),
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getEventReceived(userName, page, true);
    }
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getEventReceived(userName, page, false);
    }
  }

  @override
  Widget getItemRow(EventBean item) {
    String repoUser, repoName;
    if (item.repo.name.isNotEmpty && item.repo.name.contains("/")) {
      List<String> repos = item.repo.name.split("/");
      repoUser = repos[0];
      repoName = repos[1];
    }

    List<Widget> columnWidgets = [];
    _buildTitleWidget(columnWidgets, item, repoName);
    _buildDescWidget(columnWidgets, item);
    _buildCreatedAtWidget(columnWidgets, item.createdAt);
    _buildIssueWidget(columnWidgets, item.payload, repoName);

    return new InkWell(
      child: new Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //头像
              ImageUtil.getImageWidget(item.actor.avatarUrl ?? "", 36.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: columnWidgets,
                  ),
                ),
                flex: 1,
              ),
              EventUtil.getTypeIcon(item),
            ],
          )),
      onTap: () {
        if (item.payload != null && item.payload.issue != null) {
          NavigatorUtil.goIssueDetail(context, item.payload.issue);
        } else if (item.repo != null && item.repo.name != null) {
          NavigatorUtil.goReposDetail(context, repoUser, repoName, true);
        }
      },
    );
  }

  void _buildTitleWidget(List<Widget> column, EventBean item, repoName) {
    String type = EventUtil.getTypeDesc(item);

    Text title = Text.rich(
      TextSpan(children: [
        TextSpan(
            text: item.actor.login,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        TextSpan(text: " $type ", style: TextStyle(color: Colors.grey)),
        TextSpan(
            text: repoName ?? item.repo.name,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ]),
    );
    column.add(title);
  }

  void _buildDescWidget(List<Widget> column, EventBean item) {
    String desc = EventUtil.getEventDes(item);
    if (desc != null && desc.isNotEmpty) {
      column.add(Text(desc, style: TextStyle(color: Colors.black87)));
    }
  }

  void _buildCreatedAtWidget(List<Widget> column, createdAt) {
    Padding createdAtWidget = new Padding(
      padding: EdgeInsets.only(top: 6.0),
      child: new Text(
        DateUtil.getNewsTimeStr(createdAt),
        style: TextStyle(color: Colors.grey, fontSize: 12.0),
      ),
    );
    column.add(createdAtWidget);
  }

  void _buildIssueWidget(
      List<Widget> column, EventPayloadBean payload, repoName) {
    if (payload == null) {
      return;
    }
    if (payload.issue != null) {
      if (payload.comment != null) {
        Padding commentWidget = new Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: new Text(
            payload.comment.body,
            style: new TextStyle(color: Colors.grey),
          ),
        );
        column.add(commentWidget);

        Row issueWidget = new Row(
          children: <Widget>[
            ImageUtil.getImageWidget(payload.issue.user.avatarUrl ?? "", 24.0),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: new Text(
                  repoName + " #${payload.issue.number}",
                  style: new TextStyle(color: Colors.grey),
                ),
              ),
              flex: 1,
            ),
            Icon(
              Icons.comment,
              color: Colors.grey,
              size: 16.0,
            ),
            Text(
              "${payload.issue.commentNum}",
              style: new TextStyle(color: Colors.grey),
            ),
          ],
        );
        Container issueContainer = new Container(
          padding: EdgeInsets.all(6.0),
          color: Colors.grey[350],
          child: issueWidget,
        );
        column.add(issueContainer);
      } else {
        Padding issueWidget = new Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: new Text(
            payload.issue.title,
            style: new TextStyle(color: Colors.grey),
          ),
        );
        column.add(issueWidget);
      }
    }
  }
}
