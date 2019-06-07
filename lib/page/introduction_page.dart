import 'package:flutter/material.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/contract/introduction_contract.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/presenter/introduction_presenter.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class IntroductionPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IntroductionPage();
  }
}

class _IntroductionPage extends PullRefreshListState<
    IntroductionPage,
    ReleaseBean,
    IntroductionPresenter,
    IIntroductionView> implements IIntroductionView {
  @override
  String getTitle() {
    return '功能介绍';
  }

  @override
  Widget getItemRow(ReleaseBean item) {
    return ListTile(
      title: new Text(item.name),
      subtitle: new Text(DateUtil.getNewsTimeStr(item.createdAt)),
      onTap: () {
        NavigatorUtil.goIntroductionDetail(context, item.name, item.body);
      },
    );
  }

  @override
  IntroductionPresenter initPresenter() {
    return new IntroductionPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getReposReleases(
          'Yuzopro', 'OpenGit_Flutter', page, false);
    }
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getReposReleases('Yuzopro', 'OpenGit_Flutter', page, true);
    }
  }
}
