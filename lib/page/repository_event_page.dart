import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/contract/repository_event_contract.dart';
import 'package:open_git/presenter/repository_event_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/event_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class RepositoryEventPage extends StatefulWidget {
  final String reposOwner;
  final String reposName;

  RepositoryEventPage(this.reposOwner, this.reposName);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryEventPageState(reposOwner, reposName);
  }
}

class _RepositoryEventPageState extends PullRefreshListState<
    EventBean,
    RepositoryEventPresenter,
    IRepositoryEventView> implements IRepositoryEventView {
  final String reposOwner;
  final String reposName;

  _RepositoryEventPageState(this.reposOwner, this.reposName);

  @override
  String getTitle() {
    return "动态";
  }

  @override
  Widget getItemRow(EventBean item) {
    String desc = EventUtil.getEventDes(item);
    String type = EventUtil.getTypeDesc(item);
    String repoName;
    if (item.repo.name.isNotEmpty && item.repo.name.contains("/")) {
      repoName = item.repo.name.split("/")[1];
    }

    List<Widget> centerWidgets = [];
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
    centerWidgets.add(title);
    if (desc != null && desc.isNotEmpty) {
      centerWidgets.add(Text(desc, style: TextStyle(color: Colors.black87)));
    }

    return new Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              //头像
              ClipOval(
                child:
                    ImageUtil.getImageWidget(item.actor.avatarUrl ?? "", 36.0),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: centerWidgets,
                  ),
                ),
                flex: 1,
              ),
              Text(
                DateUtil.getNewsTimeStr(item.createdAt),
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
      ],
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getReposEvent(reposOwner, reposName, page, true);
    }
  }

  @override
  RepositoryEventPresenter initPresenter() {
    return new RepositoryEventPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getReposEvent(reposOwner, reposName, page, false);
    }
  }
}
