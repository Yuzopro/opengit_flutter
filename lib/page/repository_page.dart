import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/repository_contract.dart';
import 'package:open_git/presenter/repository_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class RepositoryPage extends StatefulWidget {
  final bool isStar;
  final UserBean userBean;

  RepositoryPage(this.userBean, this.isStar);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryPageState(userBean, isStar);
  }
}

class _RepositoryPageState extends PullRefreshListState<RepositoryPage,
        Repository, RepositoryPresenter, IRepositoryView>
    with AutomaticKeepAliveClientMixin
    implements IRepositoryView {
  bool isStar;
  final UserBean userBean;

  @override
  bool get wantKeepAlive => true;

  _RepositoryPageState(this.userBean, this.isStar);

  @override
  RepositoryPresenter initPresenter() {
    return new RepositoryPresenter();
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
      presenter.getUserRepos(userBean, page, isStar, true);
    }
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getUserRepos(userBean, page, isStar, false);
    }
  }

  @override
  Widget getItemRow(Repository item) {
    return new InkWell(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _getItemOwner(item.owner.avatarUrl, item.owner.login),
                  _getItemLanguage(item.language ?? ""),
                ],
              ),
              //全称
              Padding(
                padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(
                  item.fullName ?? "",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //描述
              Text(
                item.description,
                style: new TextStyle(color: Colors.black54, fontSize: 12.0),
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      Icon(
                        Icons.star_border,
                        color: Colors.black,
                        size: 12.0,
                      ),
                      item.stargazersCount.toString()),
                  _getItemBottom(
                      Icon(
                        Icons.info_outline,
                        color: Colors.black,
                        size: 12.0,
                      ),
                      item.openIssuesCount.toString()),
                  _getItemBottom(
                      Image.asset(
                        "image/ic_branch.png",
                        width: 10.0,
                        height: 10.0,
                      ),
                      item.forksCount.toString()),
                  Text(
                    item.fork ? "Forked" : "",
                    style: new TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goReposDetail(
              context, item.owner.login, item.name, true);
        });
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
