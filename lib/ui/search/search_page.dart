import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/presenter/search_issue_presenter.dart';
import 'package:open_git/presenter/search_presenter.dart';
import 'package:open_git/presenter/search_repository_presenter.dart';
import 'package:open_git/presenter/search_user_presenter.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/search/search_issue_page_view_model.dart';
import 'package:open_git/ui/search/search_page_view_model.dart';
import 'package:open_git/ui/search/search_repos_page_view_model.dart';
import 'package:open_git/ui/search/search_user_page_view_model.dart';
import 'package:open_git/ui/widget/pull_refresh_list.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = new TextEditingController();

  final List<_Page> _allPages = [
    new _Page("repositories", label:"项目"),
    new _Page("users", label:"用户"),
    new _Page("issues", label:"问题")
  ];

  int _index = 0;

  String _query = "";

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      String text = _controller.text;
      _query = text;
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
              indicatorColor: Colors.white,
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
  }
}

abstract class SearchItemPage extends StatelessWidget {
  final String since;
  final String label;

  SearchPageViewModel parentModel;

  SearchItemPage(this.since, this.label);

  void startQuery(String text) {
    if (parentModel != null) {
      parentModel.onFetch(text);
    }
  }
}

class SearchReposPage extends SearchItemPage {
  SearchReposPage(String since, String label) : super(since, label);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SearchReposPageViewModel>(
      distinct: true,
      converter: (store) => SearchReposPageViewModel.fromStore(store),
      builder: (_, viewModel) {
        parentModel = viewModel;
        return SearchReposItemPage(viewModel);
      },
    );
  }
}

class SearchReposItemPage extends StatelessWidget {
  static final String TAG = "SearchReposItemPage";

  final SearchReposPageViewModel viewModel;

  SearchReposItemPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.repos == null ? 0 : viewModel.repos.length,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.repos[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, Repository item) {
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
          NavigatorUtil.goReposDetail(context, item.owner.login, item.name);
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

class SearchUserPage extends SearchItemPage {
  SearchUserPage(String since, String label) : super(since, label);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SearchUserPageViewModel>(
      distinct: true,
      converter: (store) => SearchUserPageViewModel.fromStore(store),
      builder: (_, viewModel) {
        parentModel = viewModel;
        return SearchUserItemPage(viewModel);
      },
    );
  }
}

class SearchUserItemPage extends StatelessWidget {
  static final String TAG = "SearchUserItemPage";

  final SearchUserPageViewModel viewModel;

  SearchUserItemPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.users == null ? 0 : viewModel.users.length,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.users[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, UserBean item) {
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
}

class SearchIssuePage extends SearchItemPage {
  SearchIssuePage(String since, String label) : super(since, label);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SearchIssuePageViewModel>(
      distinct: true,
      converter: (store) => SearchIssuePageViewModel.fromStore(store),
      builder: (_, viewModel) {
        parentModel = viewModel;
        return SearchIssueItemPage(viewModel);
      },
    );
  }
}

class SearchIssueItemPage extends StatelessWidget {
  static final String TAG = "SearchUserItemPage";

  final SearchIssuePageViewModel viewModel;

  SearchIssueItemPage(this.viewModel);

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.issues == null ? 0 : viewModel.issues.length,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.issues[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, IssueBean item) {
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
                    getReposFullName(item.repoUrl) +
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

  String getReposFullName(String repoUrl) {
    return (repoUrl.isNotEmpty && repoUrl.contains("repos/"))
        ? repoUrl.substring(repoUrl.lastIndexOf("repos/") + 6)
        : "";
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
          NavigatorUtil.goReposDetail(context, item.owner.login, item.name);
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
    super.build(context);
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
