import 'package:flutter/widgets.dart';
import 'package:open_git/bean/repos_detail_bean.dart';
import 'package:open_git/bloc/base_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';

class ReposDetailBloc extends BaseBloc<ReposDetailBean> {
  final String reposOwner;
  final String reposName;

  ReposDetailBean bean;

  bool _isInit = false;

  ReposDetailBloc(this.reposOwner, this.reposName) {
    bean = ReposDetailBean(
      starStatus: ReposStatus.loading,
      watchStatus: ReposStatus.loading,
      readme: '',
    );
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_detail;
  }

  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _fetchReposDetail();
  }

  @override
  Future getData() async {
    await _fetchReposDetail();
  }

  Future _fetchReposDetail() async {
    final repos =
        await ReposManager.instance.getReposDetail(reposOwner, reposName);
    bean.repos = repos;

    sink.add(bean);

    _fetchStarStatus();
    _fetchWatchStatus();
  }

  Future _fetchStarStatus() async {
    final response =
        await ReposManager.instance.getReposStar(reposOwner, reposName);
    bean.starStatus =
        response.result ? ReposStatus.active : ReposStatus.inactive;

    sink.add(bean);
  }

  Future _fetchWatchStatus() async {
    final response =
        await ReposManager.instance.getReposWatcher(reposOwner, reposName);
    bean.watchStatus =
        response.result ? ReposStatus.active : ReposStatus.inactive;

    sink.add(bean);
  }

  void changeStarStatus() async {
    bool isEnable = bean.starStatus == ReposStatus.active;

    bean.starStatus = ReposStatus.loading;
    sink.add(bean);

    final response = await ReposManager.instance
        .doReposStarAction(reposOwner, reposName, isEnable);
    if (response.result) {
      if (isEnable) {
        bean.starStatus = ReposStatus.inactive;
      } else {
        bean.starStatus = ReposStatus.active;
      }
    }
    sink.add(bean);
  }

  void changeWatchStatus() async {
    bool isEnable = bean.watchStatus == ReposStatus.active;

    bean.watchStatus = ReposStatus.loading;
    sink.add(bean);

    final response = await ReposManager.instance
        .doRepossWatcherAction(reposOwner, reposName, isEnable);
    if (response.result) {
      if (isEnable) {
        bean.watchStatus = ReposStatus.inactive;
      } else {
        bean.watchStatus = ReposStatus.active;
      }
    }
    sink.add(bean);
  }

  void fetchReadme() async {
    final response =
        await ReposManager.instance.getReadme("$reposOwner/$reposName", null);
    bean.readme = response.data;
    sink.add(bean);
  }

  void fetchBranchs() async {
    final response =
        await ReposManager.instance.getBranches(reposOwner, reposName);
    bean.branchs = response;
    sink.add(bean);
  }
}
