import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/search_bloc.dart';
import 'package:open_git/bloc/search_issue_bloc.dart';
import 'package:open_git/bloc/search_repos_bloc.dart';
import 'package:open_git/bloc/search_user_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/issue_item_widget.dart';
import 'package:open_git/ui/widget/repos_item_widget.dart';
import 'package:open_git/ui/widget/user_item_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = new TextEditingController();

  final PageController _pageController = PageController();

  TabController _tabController;

  List<SearchBloc> _blocList;
  List<String> _labelList = [
    '项目',
    '用户',
    '问题',
  ];

  int _index = 0;

  String _query = "";

  @override
  void initState() {
    super.initState();

    _blocList = [
      SearchReposBloc(),
      SearchUserBloc(),
      SearchIssueBloc(),
    ];

    _tabController = new TabController(vsync: this, length: _labelList.length);

    _controller.addListener(() {
      _query = _controller.text;
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
        _blocList[_index].startSearch(_query);
      },
    );
    _actionViews.add(searchWidget);

    return new DefaultTabController(
        length: _labelList.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                _blocList[_index].startSearch(_query);
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "搜索${_labelList[_index]}",
                  hintStyle: TextStyle(color: Colors.white)),
              autofocus: true,
              style: TextStyle(color: Colors.white),
            ),
            actions: _query.isNotEmpty ? _actionViews : null,
            bottom: new TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: _labelList
                  .map(
                    (String label) => new Tab(text: label),
                  )
                  .toList(),
              onTap: (index) {
                _index = index;
                _pageController
                    .jumpTo(MediaQuery.of(context).size.width * index);
              },
            ),
          ),
          body: new PageView(
            controller: _pageController,
            children: <Widget>[
              BlocProvider<SearchReposBloc>(
                child: _SearchReposItem(),
                bloc: _blocList[0],
              ),
              BlocProvider<SearchUserBloc>(
                child: _SearchUserItem(),
                bloc: _blocList[1],
              ),
              BlocProvider<SearchIssueBloc>(
                child: _SearchIssueItem(),
                bloc: _blocList[2],
              ),
            ],
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
          ),
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

abstract class _SearchItem<T, B extends BaseListBloc<T>>
    extends BaseListStatelessWidget<T, B> {
  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  List<T> initialData() {
    return [];
  }
}

class _SearchReposItem extends _SearchItem<Repository, SearchReposBloc> {
  @override
  ListPageType getListPageType() {
    return ListPageType.search_repos;
  }

  @override
  Widget builderItem(BuildContext context, Repository item) {
    return ReposItemWidget(item);
  }
}

class _SearchUserItem extends _SearchItem<UserBean, SearchUserBloc> {
  @override
  ListPageType getListPageType() {
    return ListPageType.search_user;
  }

  @override
  Widget builderItem(BuildContext context, UserBean item) {
    return UserItemWidget(item);
  }
}

class _SearchIssueItem extends _SearchItem<IssueBean, SearchIssueBloc> {
  @override
  ListPageType getListPageType() {
    return ListPageType.search_issue;
  }

  @override
  Widget builderItem(BuildContext context, IssueBean item) {
    return IssueItemWidget(item);
  }
}
