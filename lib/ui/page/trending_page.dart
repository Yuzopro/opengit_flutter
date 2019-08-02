import 'package:flutter/material.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_base_ui/style/common_style.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bloc/trending_repos_bloc.dart';
import 'package:open_git/bloc/trending_user_bloc.dart';
import 'package:open_git/common/sp_const.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/page/trending_repos_page.dart';
import 'package:open_git/ui/page/trending_user_page.dart';

import 'main_page.dart';

class TrendingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrendingPageState();
  }
}

class _TrendingPageState extends State<TrendingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  TabController _tabController;

  String _language, _since;

  TrendingReposBloc _reposBloc;
  TrendingUserBloc _userBloc;

  int _currentIndex = 0;

  bool _isChange = false;

  @override
  void initState() {
    super.initState();

    _language = SpUtil.instance.getString(SP_KEY_TRENDING_LANGUAGE);

    _since = SpUtil.instance.getString(SP_KEY_TRENDING_DATE, defValue: 'daily');

    _tabController = new TabController(vsync: this, length: 2);

    _reposBloc = TrendingReposBloc(_language, _since);
    _userBloc = TrendingUserBloc(_language, _since);
  }

  @override
  void dispose() {
    super.dispose();
    SpUtil.instance.putString(SP_KEY_TRENDING_LANGUAGE, _language);
    SpUtil.instance.putString(SP_KEY_TRENDING_DATE, _since);
  }

  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = List(2);
    choices[0] = Choice(
      title: AppLocalizations.of(context).currentlocal.repository,
    );
    choices[1] = Choice(
      title: AppLocalizations.of(context).currentlocal.developers,
    );

    return DefaultTabController(
      length: choices.length,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TabBar(
            controller: _tabController,
            labelPadding: EdgeInsets.all(8.0),
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: choices.map((Choice choice) {
              return Tab(
                text: choice.title,
              );
            }).toList(),
            onTap: (index) {
              _currentIndex = index;
              _pageController
                  .jumpTo(ScreenUtil.getScreenWidth(context) * index);
              if (_isChange) {
                _refreshData();
              }
            },
          ),
          actions: <Widget>[
            PopupMenuButton(
              padding: const EdgeInsets.all(0.0),
              onSelected: _onPopSelected,
              itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
                _buildLanguageMenu(),
                _buildDateRangeMenu(),
              ],
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            BlocProvider<TrendingReposBloc>(
              child: TrendingReposPage(_since),
              bloc: _reposBloc,
            ),
            BlocProvider<TrendingUserBloc>(
              child: TrendingUserPage(),
              bloc: _userBloc,
            ),
          ],
          onPageChanged: (index) {
            _currentIndex = index;
            _tabController.animateTo(index);
            if (_isChange) {
              _refreshData();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLanguageMenu() {
    return PopupMenuItem<String>(
      value: "language",
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        dense: false,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.text_rotate_vertical,
                color: Color(YZColors.mainTextColor),
                size: 22.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Language ${TextUtil.isEmpty(_language) ? 'all' : _language}',
                style: YZConstant.middleText,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateRangeMenu() {
    return PopupMenuItem<String>(
      value: "daterange",
      child: ListTile(
        contentPadding: EdgeInsets.all(0.0),
        dense: false,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            children: <Widget>[
              Icon(
                Icons.date_range,
                color: Color(YZColors.mainTextColor),
                size: 22.0,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                'Date Range $_since',
                style: YZConstant.middleText,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onPopSelected(String value) async {
    switch (value) {
      case "language":
        String language = await NavigatorUtil.goTrendingLanguage(context);
        if (!TextUtil.isEmpty(language) &&
            !TextUtil.equals(_language, language)) {
          if (TextUtil.equals(language, 'All code language')) {
            language = '';
          }
          _language = language;
          _refreshData();
          _isChange = true;
        }
        break;
      case "daterange":
        String since = await NavigatorUtil.goTrendingDate(context);
        if (!TextUtil.isEmpty(since) && !TextUtil.equals(_since, since)) {
          _since = since;
          _refreshData();
          _isChange = true;
        }
        break;
      default:
        break;
    }
  }

  void _refreshData() {
    _isChange = false;
    if (_currentIndex == 0) {
      _reposBloc.refreshData(language: _language, since: _since);
    } else {
      _userBloc.refreshData(language: _language, since: _since);
    }
  }
}
