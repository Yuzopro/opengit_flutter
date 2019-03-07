import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/contract/repository_contract.dart';
import 'package:open_git/presenter/repository_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';
//import 'package:markdown/markdown.dart' as md;

class RepositoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RepositoryPageState();
  }
}

class _RepositoryPageState extends PullRefreshListState<Repository,
        RepositoryPresenter, IRepositoryView>
    with AutomaticKeepAliveClientMixin
    implements IRepositoryView {
  int _page = 1;

  @override
  bool get wantKeepAlive => true;

  @override
  RepositoryPresenter initPresenter() {
    return new RepositoryPresenter();
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    return new Scaffold(
      body: buildBody(context),
    );
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      _page = 1;
      await presenter.getUserRepos(_page, false);
    }
  }

  @override
  getMoreData() {
    if (presenter != null) {
      _page++;
      presenter.getUserRepos(_page, true);
    }
  }

  @override
  Widget getItemRow(Repository item) {
    String ownerHead = "";
    String ownerName = "";
    String description = "暂无描述";
    String stargazersCount = "0";
    String openIssuesCount = "0";
    String forksCount = "0";
    String fork = "";
    String language = "";
    String fullName = "";
    if (item != null) {
      if (item.owner != null) {
        ownerHead = item.owner.avatarUrl;
        ownerName = item.owner.login;
      }
      description = item.description ?? "暂无描述";
      stargazersCount = item.stargazersCount.toString();
      openIssuesCount = item.openIssuesCount.toString();
      forksCount = item.forksCount.toString();
      fork = item.fork ? "Forked" : "";
      language = item.language ?? "";
      fullName = item.fullName ?? "";
    }

    return new FlatButton(
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: 12.0, right: 12.0, top: 12.0, bottom: 8.0),
            width: MediaQuery.of(context).size.width,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _getItemOwner(ownerHead, ownerName),
                    _getItemLanguage(language),
                  ],
                ),
                //全称
                Padding(
                  padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                  child: Text(
                    fullName,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                //描述
                Text(
                  MarkdownUtil.getGitHubEmojHtml(description),
                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
                //底部数据
                Padding(
                  padding: new EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: <Widget>[
                      _getItemBottom(
                          Icon(
                            Icons.star_border,
                            color: Colors.black,
                            size: 12.0,
                          ),
                          stargazersCount),
                      _getItemBottom(
                          Icon(
                            Icons.info_outline,
                            color: Colors.black,
                            size: 12.0,
                          ),
                          openIssuesCount),
                      _getItemBottom(
                          Image.asset(
                            "image/ic_branch.png",
                            width: 10.0,
                            height: 10.0,
                          ),
                          forksCount),
                      Text(
                        fork,
                        style:
                            new TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 0.3,
          ),
        ],
      ),
      onPressed: () {
        NavigatorUtil.goReposDetail(context, ownerName, item.name);
      },
    );
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Row(
      children: <Widget>[
        ClipOval(
          child: ImageUtil.getImageWidget(ownerHead, 18.0),
        ),
        Padding(
          padding: new EdgeInsets.only(left: 4.0),
          child: Text(
            ownerName,
            style: new TextStyle(color: Colors.black54, fontSize: 12.0),
          ),
        ),
      ],
    );
  }

  Widget _getItemLanguage(String language) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Colors.black87,
              width: 8.0,
              height: 8.0,
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              language,
              style: new TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
          ),
        ],
      ),
      flex: 1,
    );
  }

  Widget _getItemBottom(Widget icon, String count) {
    return new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          icon,
          Text(
            count,
            style: new TextStyle(color: Colors.black, fontSize: 12.0),
          ),
        ],
      ),
    );
  }
}
