import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/trend/trend_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/main_page.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/trend/trend_page_view_model.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';

String trend = 'all';

class TrendPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Choice> choices = new List(3);
    choices[0] =
        new Choice(title: AppLocalizations.of(context).currentlocal.today);
    choices[1] =
        new Choice(title: AppLocalizations.of(context).currentlocal.week);
    choices[2] =
        new Choice(title: AppLocalizations.of(context).currentlocal.month);

    return new DefaultTabController(
        length: choices.length,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text(trend),
            bottom: new TabBar(
              indicatorColor: Colors.white,
              tabs: choices
                  .map(
                    (Choice choice) => new Tab(text: choice.title),
                  )
                  .toList(),
            ),
          ),
          body: new TabBarView(
            children: <Widget>[
              TrendItemPage(
                since: 'daily',
                trend: trend,
                type: ListPageType.day_trend,
              ),
              TrendItemPage(
                since: 'weekly',
                trend: trend,
                type: ListPageType.week_trend,
              ),
              TrendItemPage(
                since: 'monthly',
                trend: trend,
                type: ListPageType.month_trend,
              ),
            ],
          ),
        ));
  }
}

class TrendItemPage extends StatelessWidget {
  final String since;
  final String trend;
  final ListPageType type;

  TrendItemPage({this.since, this.trend, this.type});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TrendPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchTrendsAction(since, trend, type)),
      converter: (store) =>
          TrendPageViewModel.fromStore(store, type, since, trend),
      builder: (_, viewModel) => TrendPageContent(viewModel),
    );
  }
}

class TrendPageContent extends StatelessWidget {
  static final String TAG = "TrendPageContent";

  final TrendPageViewModel viewModel;

  const TrendPageContent(this.viewModel);

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      itemCount: viewModel.trends == null ? 0 : viewModel.trends.length,
      refreshStatus: viewModel.refreshStatus,
      enablePullUp: false,
      onRefreshCallback: viewModel.onRefresh,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.trends[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, TrendBean item) {
    List<Widget> _bottomViews = new List();

    Widget _starView = new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          Image(
              width: 12.0,
              height: 12.0,
              image: new AssetImage('image/ic_star.png')),
          Text(
            item.starCount,
            style: new TextStyle(color: Colors.grey, fontSize: 12.0),
          ),
        ],
      ),
    );
    _bottomViews.add(_starView);

    Widget _forkView = new Row(
      children: <Widget>[
        Image(
            width: 12.0,
            height: 12.0,
            image: new AssetImage('image/ic_branch.png')),
        Text(
          item.forkCount,
          style: new TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ],
    );
    _bottomViews.add(_forkView);

    Widget _builtByView = _getBuiltByWidget(item);
    _bottomViews.add(_builtByView);

    return new InkWell(
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(item.fullName,
                    style: new TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                _getItemLanguage(item.language ?? ""),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Text(item.description,
                    style:
                        new TextStyle(color: Colors.black54, fontSize: 12.0))),
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

  Widget _getBuiltByWidget(TrendBean item) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text("Built by",
              style: new TextStyle(color: Colors.grey, fontSize: 10.0)),
          Row(
            children: item.contributors
                .map(
                  (String url) => new Padding(
                        padding: EdgeInsets.only(left: 2.0),
                        child: new ClipOval(
                          child: ImageUtil.getImageWidget(url ?? "", 12.0),
                        ),
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
