import 'dart:async';

import 'package:flutter/material.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/bean/branch_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/contract/repository_detail_contract.dart';
import 'package:open_git/presenter/repository_detail_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/file_size_util.dart';
import 'package:open_git/util/markdown_util.dart';
import 'package:open_git/util/navigator_util.dart';

class RepositoryDetailPage extends StatefulWidget {
  final String reposOwner;
  final String reposName;

  RepositoryDetailPage(this.reposOwner, this.reposName);

  @override
  State<StatefulWidget> createState() {
    return _RepositoryDetailPageState(reposOwner, reposName);
  }
}

class _RepositoryDetailPageState
    extends BaseState<RepositoryDetailPresenter, IRepositoryDetailView>
    implements IRepositoryDetailView {
  final String reposOwner;
  final String reposName;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Repository repository;

  int _starState = RepositoryDetailPresenter.DEFAULT_STATE;
  int _watchState = RepositoryDetailPresenter.DEFAULT_STATE;

  String _markdownData = "";

  bool _isExpanded = false;

  List<BranchBean> _branchList;

  _RepositoryDetailPageState(this.reposOwner, this.reposName);

  @override
  void initData() {
    super.initData();
    _showRefreshLoading();
  }

  @override
  String getTitle() {
    return reposName ?? "";
  }

  @override
  RepositoryDetailPresenter initPresenter() {
    return new RepositoryDetailPresenter();
  }

  @override
  void getReposDetailSuccess(Repository repository, isRefresh) {
    if (presenter != null && isRefresh) {
      _starState = RepositoryDetailPresenter.DEFAULT_STATE;
      _watchState = RepositoryDetailPresenter.DEFAULT_STATE;
      presenter.getReposStar(reposOwner, reposName);
      presenter.getReposWatcher(reposOwner, reposName);
    }
    this.repository = repository;
    setState(() {});
  }

  @override
  void setStarState(int state, bool isAction) {
    _starState = state;
    //设置成功后需要刷新数据
    if (presenter != null && isAction) {
      presenter.getReposDetail(reposOwner, reposName, false);
    }
    setState(() {});
  }

  @override
  void setWatchState(int state, bool isAction) {
    _watchState = state;
    //设置成功后需要刷新数据
    if (presenter != null && isAction) {
      presenter.getReposDetail(reposOwner, reposName, false);
    }
    setState(() {});
  }

  @override
  void setReadmeContent(String markdown) {
    _markdownData = markdown;
    setState(() {});
  }

  @override
  void setBranches(List<BranchBean> list) {
    _branchList = list;
    print(_isEmptyBranches());
    setState(() {});
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: repository == null
            ? ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: 0,
                itemBuilder: (context, index) {
                  return Text("aaaa");
                },
              )
            : new ListView(
                children: <Widget>[
                  _getHeaderWidget(),
                  _getClassifyTips("互动"),
                  _getInteractWidget(),
                  _getClassifyTips("详情"),
                  _getDetailWidget(),
                  _getClassifyTips("分支"),
                  _getBranchWidget(),
                  _getClassifyTips("文档"),
                  getDocumentWidget(),
                ],
              ),
        onRefresh: _onRefresh);
  }

  Widget _getHeaderWidget() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.book, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          repository.fullName,
                          style: new TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                        ),
                      ),
                    ],
                  )),
              Text(FileSizeUtil.formetFileSize(repository.size * 1024)),
            ],
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        Container(
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text(
              MarkdownUtil.getGitHubEmojHtml(repository.description ?? "暂无描述")),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getStarAndWatch(),
      ],
    );
  }

  Widget _getStarAndWatch() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: <Widget>[
          _getStarAndWatchItem(
              _starState == RepositoryDetailPresenter.ENABLE_STATE
                  ? Icons.star_border
                  : Icons.star,
              _starState == RepositoryDetailPresenter.ENABLE_STATE
                  ? "Unstar"
                  : "Star",
              _starState, () {
            _handleStarItemClick();
          }),
          Container(width: 0.3, height: 20.0, color: Colors.grey),
          _getStarAndWatchItem(
              _watchState == RepositoryDetailPresenter.ENABLE_STATE
                  ? Icons.visibility_off
                  : Icons.visibility,
              _watchState == RepositoryDetailPresenter.ENABLE_STATE
                  ? "Unwatch"
                  : "watch",
              _watchState, () {
            _handleWatchItemClick();
          }),
        ],
      ),
    );
  }

  Widget _getStarAndWatchItem(
      IconData iconData, String text, int state, onPressed) {
    return Expanded(
      child: FlatButton(
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              state == RepositoryDetailPresenter.DEFAULT_STATE
                  ? SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(Colors.grey)),
                    )
                  : Icon(iconData, color: Colors.blue),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: new Text(
                  text,
                  style: new TextStyle(
                      color: state == RepositoryDetailPresenter.DEFAULT_STATE
                          ? Colors.grey
                          : Colors.blue),
                ),
              ),
            ],
          )),
      flex: 1,
    );
  }

  Widget _getClassifyTips(String tips) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(12.0),
      color: Colors.black12,
      child: Text(
        tips,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _getInteractWidget() {
    return new Container(
      padding: EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          _getInteractItem(repository.stargazersCount, "stars"),
          _getInteractItem(repository.openIssuesCount, "issues"),
          _getInteractItem(repository.forksCount, "forks"),
          _getInteractItem(repository.subscribersCount, "watchers"),
        ],
      ),
    );
  }

  Widget _getInteractItem(int count, String text) {
    return Expanded(
      child: Column(
        children: <Widget>[
          Text(
            count.toString() ?? "0",
            style: new TextStyle(color: Colors.blue, fontSize: 18.0),
          ),
          Text(
            text,
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
      flex: 1,
    );
  }

  Widget _getDetailWidget() {
    return new Column(
      children: <Widget>[
        _getDetailItem(Icons.language, "语言", repository.language, true, () {
          _handleLanguage();
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.alarm, "动态", "", true, () {
          _handleDynamic();
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(Icons.people, "贡献者", "", true, () {
          _handleContributor();
        }),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        _getDetailItem(
            Icons.perm_identity,
            "许可",
            repository.license != null ? repository.license.name : "",
            false,
            null),
      ],
    );
  }

  Widget _getDetailItem(IconData iconData, String text, String trailText,
      bool isShowTralIcon, onPressed) {
    return new FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(
                    iconData,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: new Text(text),
                  )
                ],
              ),
              flex: 1,
            ),
            Row(
              children: <Widget>[
                Text(
                  trailText ?? "",
                  style: TextStyle(color: Colors.grey),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 4.0),
                  child: isShowTralIcon
                      ? Icon(Icons.keyboard_arrow_right, color: Colors.grey)
                      : Text(""),
                )
              ],
            )
          ],
        ));
  }

  Widget _getBranchWidget() {
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: Row(
            children: <Widget>[
              Image.asset(
                "image/ic_branch.png",
                width: 16.0,
                height: 16.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 4.0),
                child: new Text(
                  repository.defaultBranch,
                  style: TextStyle(color: Colors.black),
                ),
              )
            ],
          ),
          children: _isEmptyBranches()
              ? <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 15.0,
                      height: 15.0,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation(Colors.black)),
                    ),
                    height: 56.0,
                  )
                ]
              : _branchList.map<Widget>((branch) {
                  return ListTile(title: Text(branch.name));
                }).toList(),
          onExpansionChanged: (isChange) {
            _isExpanded = isChange;
            if (isChange) {
              _getBranches();
            }
            setState(() {});
          },
        ),
        Divider(
          color: Colors.grey,
          height: _isExpanded ? 0.0 : 0.3,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 56.0,
          padding: EdgeInsets.all(12.0),
          child: Text("最后一次提交于" + DateUtil.getNewsTimeStr(repository.pushedAt)),
        ),
        Divider(
          color: Colors.grey,
          height: 0.3,
        ),
        Container(
          alignment: Alignment.center,
          height: 56.0,
          child: Text("查看源码"),
        ),
      ],
    );
  }

  Widget getDocumentWidget() {
    return new ExpansionTile(
      title: Row(
        children: <Widget>[
          Icon(
            Icons.chrome_reader_mode,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: new Text(
              "README.md",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
      children: _markdownData.isEmpty
          ? <Widget>[
              Container(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 15.0,
                  height: 15.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation(Colors.black)),
                ),
                height: 56.0,
              )
            ]
          : <Widget>[
              Padding(
                padding: EdgeInsets.all(12.0),
                child: MarkdownUtil.markdownBody(_markdownData),
              ),
            ],
      onExpansionChanged: (isChange) {
        if (isChange) {
          _getReadme();
        }
        setState(() {});
      },
    );
  }

  void _showRefreshLoading() async {
    await Future.delayed(const Duration(seconds: 0), () {
      _refreshIndicatorKey.currentState.show().then((e) {});
      return true;
    });
  }

  Future<Null> _onRefresh() async {
    if (presenter != null) {
      await presenter.getReposDetail(reposOwner, reposName, true);
    }
  }

  void _handleStarItemClick() {
    if (_starState == RepositoryDetailPresenter.DEFAULT_STATE) {
      return;
    }
    if (presenter != null) {
      presenter.doReposStarAction(reposOwner, reposName, _starState);
      //显示进度条
      _starState = RepositoryDetailPresenter.DEFAULT_STATE;
      setState(() {});
    }
  }

  void _handleWatchItemClick() {
    if (_watchState == RepositoryDetailPresenter.DEFAULT_STATE) {
      return;
    }
    if (presenter != null) {
      presenter.doRepossWatcherAction(reposOwner, reposName, _watchState);
      //显示进度条
      _watchState = RepositoryDetailPresenter.DEFAULT_STATE;
      setState(() {});
    }
  }

  void _getBranches() {
    if (presenter != null && _isEmptyBranches()) {
      presenter.getBranches(reposOwner, reposName);
    }
  }

  void _getReadme() {
    if (presenter != null && _markdownData.isEmpty) {
      presenter.getReadme("$reposOwner/$reposName", null);
    }
  }

  bool _isEmptyBranches() {
    return _branchList == null || _branchList.length == 0;
  }

  void _handleLanguage() {
    NavigatorUtil.goReposLanguage(context);
  }

  void _handleDynamic() {
    NavigatorUtil.goReposDynamic(context, reposOwner, reposName);
  }

  void _handleContributor() {
    NavigatorUtil.goReposContributor(context);
  }
}
