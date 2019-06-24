import 'package:flutter/material.dart';
import 'package:open_git/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/trend_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/trend_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/ui/main_page.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/image_util.dart';

class TrendPage extends StatelessWidget {
  final String trending;

  TrendPage(this.trending);

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
            title: Text(trending),
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
              new BlocProvider<TrendBloc>(
                child: _Page("daily", trending),
                bloc: new TrendBloc(),
              ),
              new BlocProvider<TrendBloc>(
                child: _Page("weekly", trending),
                bloc: new TrendBloc(),
              ),
              new BlocProvider<TrendBloc>(
                child: _Page("monthly", trending),
                bloc: new TrendBloc(),
              ),
            ],
          ),
        ));
  }
}

class _Page extends BaseListStatelessWidget<TrendBean, TrendBloc> {
  static final String TAG = "TrendItemPage";

  final String since;
  final String trend;

  _Page(this.since, this.trend);

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  void initData() {
    if (bloc != null) {
      bloc.initData(since, trend);
    }
  }

  @override
  Widget builderItem(BuildContext context, TrendBean item) {
    List<Widget> _bottomViews = new List();
    if (item.language != null && item.language.isNotEmpty) {
      _bottomViews.add(_getItemLanguage(item.language));
    }

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
            Text(item.fullName,
                style: new TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
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
        NavigatorUtil.goReposDetail(
            context, item.name, item.reposName, trend.toLowerCase() == "all");
      },
    );
  }

  Widget _getItemLanguage(String language) {
    return new Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: new Row(
        children: <Widget>[
          ClipOval(
            child: Container(
              color: Colors.grey,
              width: 8.0,
              height: 8.0,
            ),
          ),
          Padding(
            padding: new EdgeInsets.only(left: 4.0),
            child: Text(
              language,
              style: new TextStyle(color: Colors.grey, fontSize: 10.0),
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
