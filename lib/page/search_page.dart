import 'package:flutter/material.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/presenter/search_issue_presenter.dart';
import 'package:open_git/presenter/search_presenter.dart';
import 'package:open_git/presenter/search_repository_presenter.dart';
import 'package:open_git/presenter/search_user_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPage();
  }
}

class _SearchPage extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = new TextEditingController();

  TabController _tabController;
  final PageController _pageController = new PageController();

  final List<_Page> _allPages = [
    new _Page("repositories", label: "项目"),
    new _Page("users", label: "用户"),
    new _Page("issues", label: "问题")
  ];

  int _index = 0;

  String _query = "";

  @override
  void initState() {
    super.initState();

    _tabController = new TabController(vsync: this, length: _allPages.length);

    _controller.addListener(() {
      String text = _controller.text;
      setState(() {
        _query = text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        _allPages[_index]._state.setQueryText(_query, true);
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
                _allPages[_index]._state.setQueryText(_query, true);
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
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: _allPages
                  .map(
                    (_Page page) => new Tab(text: page.label),
                  )
                  .toList(),
              onTap: (index) {
                _pageController.jumpToPage(index);
                setState(() {
                  _index = index;
                });
              },
            ),
          ),
          body: new PageView(
            controller: _pageController,
            children: _allPages.map((_Page page) {
              return page;
            }).toList(),
            onPageChanged: (page) {
              _tabController.animateTo(page);
            },
          ),
        ));
    ;
  }
}

class _Page extends StatefulWidget {
  _Page(this.since, {this.label});

  final String label;
  final String since;
  _PageState _state;

  @override
  State<StatefulWidget> createState() {
    _state = createPageState();
    return _state;
  }

  _PageState createPageState() {
    _PageState _pageState;
    if ("repositories" == since) {
      _pageState = new _RepositoriesState(since);
    } else if ("users" == since) {
      _pageState = new _UsersState(since);
    } else if ("issues" == since) {
      _pageState = new _IssuesState(since);
    }
    return _pageState;
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
    return new InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 12.0, right: 12.0),
        height: 56.0,
        child: Row(
          children: <Widget>[
            ClipOval(
              child: ImageUtil.getImageWidget(item.avatarUrl, 36.0),
            ),
            Padding(
              padding: new EdgeInsets.only(left: 4.0),
              child: Text(
                item.login,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goUserProfile(context, item);
      },
    );
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
      onTap: () {
        NavigatorUtil.goIssueDetail(context, item);
      },
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
            padding: new EdgeInsets.only(left: 8.0),
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
    extends PullRefreshListState<_Page, T, P, IBasePullListView>
    with AutomaticKeepAliveClientMixin {
  final String since;

  String _queryText = "";

  _PageState(this.since);

  void setQueryText(text, bool isRefresh) {
    _queryText = text;

    if (isRefresh) {
      showRefreshLoading();
    }
  }

  @override
  bool isFirstLoading() {
    return _queryText.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return buildBody(context);
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.search(since, _queryText, page, true);
    }
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.search(since, _queryText, page, false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
