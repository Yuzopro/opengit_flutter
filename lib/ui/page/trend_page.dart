import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/bloc/trend_bloc.dart';
import 'package:open_git/bloc/trend_daily_bloc.dart';
import 'package:open_git/bloc/trend_monthly_bloc.dart';
import 'package:open_git/bloc/trend_weekly_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/page/main_page.dart';

class TrendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TrendPageState();
  }
}

class _TrendPageState extends State<TrendPage>
    with SingleTickerProviderStateMixin {
  static final String TAG = "TrendPage";

  TrendBloc dayBloc;
  TrendBloc weekBloc;
  TrendBloc monthBloc;

  String trend = 'all';

  final PageController _pageController = PageController();

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);

    dayBloc = TrendDailyBloc(trend);
    weekBloc = TrendWeeklyBloc(trend);
    monthBloc = TrendMonthlyBloc(trend);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = List(3);
    choices[0] = Choice(title: AppLocalizations.of(context).currentlocal.today);
    choices[1] = Choice(title: AppLocalizations.of(context).currentlocal.week);
    choices[2] = Choice(title: AppLocalizations.of(context).currentlocal.month);

    return DefaultTabController(
        length: choices.length,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              trend,
              style: YZConstant.normalTextWhite,
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              tabs: choices
                  .map(
                    (Choice choice) => Tab(text: choice.title),
                  )
                  .toList(),
              onTap: (index) {
                _pageController
                    .jumpTo(MediaQuery.of(context).size.width * index);
              },
            ),
          ),
          body: PageView(
            controller: _pageController,
            children: <Widget>[
              BlocProvider<TrendBloc>(
                child: _Page(PageType.day_trend),
                bloc: dayBloc,
              ),
              BlocProvider<TrendBloc>(
                child: _Page(PageType.week_trend),
                bloc: weekBloc,
              ),
              BlocProvider<TrendBloc>(
                child: _Page(PageType.month_trend),
                bloc: monthBloc,
              ),
            ],
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
          ),
        ));
  }
}

class _Page extends BaseListStatelessWidget<TrendBean, TrendBloc> {
  static final String TAG = "TrendItemPage";

  final PageType type;

  _Page(this.type);

  @override
  PageType getPageType() {
    return type;
  }

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  bool enablePullUp() {
    return false;
  }

  @override
  Widget builderItem(BuildContext context, TrendBean item) {
    List<Widget> _bottomViews = List();
    if (item.language != null && item.language.isNotEmpty) {
      _bottomViews.add(_getItemLanguage(item.language));
    }

    Widget _starView = Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(
              width: 12.0,
              height: 12.0,
              image: AssetImage('image/ic_star.png')),
          Text(
            item.starCount,
            style: TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
    _bottomViews.add(_starView);

    Widget _forkView = Row(
      children: <Widget>[
        Image(
            width: 12.0,
            height: 12.0,
            image: AssetImage('image/ic_branch.png')),
        Text(
          item.forkCount,
          style: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ],
    );
    _bottomViews.add(_forkView);

    Widget _builtByView = _getBuiltByWidget(item);
    _bottomViews.add(_builtByView);

    return InkWell(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.fullName,
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(item.description,
                    style: TextStyle(color: Colors.black54, fontSize: 12.0))),
            Row(
              children: _bottomViews,
            ),
          ],
        ),
      ),
      onTap: () {
        NavigatorUtil.goReposDetail(context, item.name, item.reposName);
      },
    );
  }

  Widget _getItemLanguage(String language) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Colors.grey,
              width: 8.0,
              height: 8.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(
              language,
              style: TextStyle(color: Colors.grey, fontSize: 10.0),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBuiltByWidget(TrendBean item) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Built by",
              style: TextStyle(color: Colors.grey, fontSize: 10.0)),
          Row(
            children: item.contributors
                .map(
                  (String url) => Padding(
                    padding: EdgeInsets.only(left: 2.0),
                    child: ImageUtil.getCircleNetworkImage(
                        url ?? "", 12.0, "image/ic_default_head.png"),
                  ),
                )
                .toList(),
          )
        ],
      ),
      flex: 1,
    );
  }
}
