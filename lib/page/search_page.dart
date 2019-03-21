import 'package:flutter/material.dart';
import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/base_state.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/search_contract.dart';
import 'package:open_git/presenter/search_issue_presenter.dart';
import 'package:open_git/presenter/search_presenter.dart';
import 'package:open_git/presenter/search_repository_presenter.dart';
import 'package:open_git/presenter/search_user_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController _controller = new TextEditingController();

  final List<_Page> _allPages = [
    new _Page("repositories", new _RepositoriesState("repositories"), label: "项目"),
    new _Page("users", new _UsersState("users"), label: "用户"),
    new _Page("issues", new _IssuesState("issues"), label: "问题")
  ];

  int _index = 0;

  String _query = "";

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      String text = _controller.text;
      int length = _allPages.length;
      for (int i = 0; i < length; i++) {
        _allPages[i].state.setQueryText(text, false);
      }
      setState(() {
        _query = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _actionViews = [];

    Widget clearWidget = new IconButton(
      tooltip: 'Clear',
      icon: const Icon(Icons.clear),
      onPressed: () {
        _controller.clear();
      },
    );
    _actionViews.add(clearWidget);

    Widget searchWidget = new IconButton(
      tooltip: 'Search',
      icon: const Icon(Icons.search),
      onPressed: () {
        _allPages[_index].state.setQueryText(_query, true);
      },
    );
    _actionViews.add(searchWidget);

    return new DefaultTabController(
        length: _allPages.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                _allPages[_index].state.setQueryText(_query, true);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "搜索${_allPages[_index].label}",
                  hintStyle: TextStyle(color: Colors.white)),
              autofocus: true,
              style: TextStyle(color: Colors.white),
            ),
            actions: _query.isNotEmpty ? _actionViews : null,
            bottom: new TabBar(
              tabs: _allPages
                  .map(
                    (_Page page) => new Tab(text: page.label),
                  )
                  .toList(),
              onTap: (index) {
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
          body: new TabBarView(
            children: _allPages.map((_Page page) {
              return page;
            }).toList(),
          ),
        ));
    ;
  }
}

class _Page extends StatefulWidget {
  _Page(this.since, this.state,{this.label});

  final String label;
  final String since;
  final _PageState state;

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _RepositoriesState
    extends _PageState<Repository, SearchRepositoryPresenter> {
  _RepositoriesState(String since) : super(since);

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

  @override
  SearchRepositoryPresenter initPresenter() {
    return new SearchRepositoryPresenter();
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

class _UsersState extends _PageState<UserBean, SearchUserPresenter> {
  _UsersState(String since) : super(since);

  @override
  Widget getItemRow(UserBean item) {
    return null;
  }

  @override
  SearchUserPresenter initPresenter() {
    return new SearchUserPresenter();
  }
}

class _IssuesState extends _PageState<IssueBean, SearchIssuePresenter> {
  _IssuesState(String since) : super(since);

  @override
  Widget getItemRow(IssueBean item) {
    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                _getItemOwner(item.user.avatarUrl, item.user.login),
                Text(
                  DateUtil.getNewsTimeStr(item.createdAt),
                  style: TextStyle(color: Colors.grey, fontSize: 12.0),
                ),
              ],
            ),
            //描述
            Text(
              item.title,
              style: new TextStyle(color: Colors.black54, fontSize: 12.0),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    presenter.getReposFullName(item.repoUrl) +
                        "#" +
                        item.number.toString(),
                    style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                  ),
                  flex: 1,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.comment,
                      color: Colors.grey,
                      size: 12.0,
                    ),
                    Text(
                      item.commentNum.toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  SearchIssuePresenter initPresenter() {
    return new SearchIssuePresenter();
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Expanded(
      child: Row(
        children: <Widget>[
          ClipOval(
            child: ImageUtil.getImageWidget(ownerHead, 18.0),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              ownerName,
              style: new TextStyle(
                  color: Colors.black54,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      flex: 1,
    );
  }
}

abstract class _PageState<T, P extends SearchPresenter>
    extends PullRefreshListState<T, P, IBasePullListView>
    with AutomaticKeepAliveClientMixin {
  final String since;

  String _queryText = "";

  int _page = 1;

  _PageState(this.since);

  void setQueryText(text, bool isRefresh) {
    _queryText = text;
    if (isRefresh) {
      showRefreshLoading();
    }
  }

  @override
  bool isFirstLoading() {
    print("_queryText is $_queryText");
    return _queryText.isNotEmpty;
  }
  
  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  @override
  getMoreData() {
    if (presenter != null) {
      _page++;
      presenter.search(since, _queryText, _page, true);
    }
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      _page = 1;
      await presenter.search(since, _queryText, _page, false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
