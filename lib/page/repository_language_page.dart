import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/contract/repository_language_contract.dart';
import 'package:open_git/presenter/repository_language_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class RepositoryLanguagePage extends StatefulWidget {
  final String language;

  RepositoryLanguagePage(this.language);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryLanguagePageState(language);
  }
}

class _RepositoryLanguagePageState extends PullRefreshListState<
    RepositoryLanguagePage,
    Repository,
    RepositoryLanguagePresenter,
    IRepositoryLanguageView> implements IRepositoryLanguageView {
  final String language;

  _RepositoryLanguagePageState(this.language);

  @override
  String getTitle() {
    return language;
  }

  @override
  Widget getItemRow(Repository item) {
    return new InkWell(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
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
              MarkdownUtil.getGitHubEmojHtml(item.description ?? "暂无描述"),
              style: new TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            //底部数据
            Row(
              children: <Widget>[
                _getItemBottom(
                    Image(
                        width: 16.0,
                        height: 16.0,
                        image: new AssetImage('image/ic_star.png')),
                    item.stargazersCount.toString()),
                _getItemBottom(
                    Image(
                        width: 16.0,
                        height: 16.0,
                        image: new AssetImage('image/ic_issue.png')),
                    item.openIssuesCount.toString()),
                _getItemBottom(
                    Image(
                        width: 16.0,
                        height: 16.0,
                        image: new AssetImage('image/ic_branch.png')),
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
        NavigatorUtil.goReposDetail(context, item.owner.login, item.name, true);
      },
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getLanguages(language, page, true);
    }
  }

  @override
  RepositoryLanguagePresenter initPresenter() {
    return new RepositoryLanguagePresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getLanguages(language, page, false);
    }
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
