import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/repos_bean.dart';
import 'package:open_git/bean/repos_detail_bean.dart';
import 'package:open_git/db/read_record_provider.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';

class RepoDetailBloc extends BaseBloc<LoadingBean<ReposDetailBean>> {
  static final String TAG = 'ReposDetailBloc';

  final String reposOwner;
  final String reposName;

  RepoDetailBloc(this.reposOwner, this.reposName) {
    bean = LoadingBean(
        isLoading: false,
        data: ReposDetailBean(
          starStatus: ReposStatus.loading,
          watchStatus: ReposStatus.loading,
          readme: '',
        ));
  }

  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchReposDetail();
    hideLoading();
  }

  @override
  Future getData() async {
    await _fetchReposDetail();
  }

  Future _fetchReposDetail() async {
    final repos =
        await ReposManager.instance.getReposDetail(reposOwner, reposName);
    bean.data.repos = repos;

   await _saveDb(repos);

    if (repos == null) {
      bean.isError = true;
    } else {
      bean.isError = false;
    }

    _fetchStarStatus();
    _fetchWatchStatus();
  }

  Future _saveDb(Repository item) async {
    if (item != null) {
      String url = item.htmlUrl;
      String owner = item.owner.login;
      String name = item.name;

      await ReadRecordProvider().insert(
        url: url,
        repoOwner: owner,
        repoName: name,
        date: DateTime.now().millisecondsSinceEpoch,
        type: ReadRecordProvider.TYPE_REPO,
        data: jsonEncode(item.toJson),
      );
    }
  }

  Future _fetchStarStatus() async {
    final response =
        await ReposManager.instance.getReposStar(reposOwner, reposName);
    bean.data.starStatus =
        response.result ? ReposStatus.active : ReposStatus.inactive;

    notifyDataChanged();
  }

  Future _fetchWatchStatus() async {
    final response =
        await ReposManager.instance.getReposWatcher(reposOwner, reposName);
    bean.data.watchStatus =
        response.result ? ReposStatus.active : ReposStatus.inactive;

    notifyDataChanged();
  }

  void changeStarStatus() async {
    bool isEnable = bean.data.starStatus == ReposStatus.active;

    bean.data.starStatus = ReposStatus.loading;
    notifyDataChanged();

    final response = await ReposManager.instance
        .doReposStarAction(reposOwner, reposName, isEnable);
    if (response.result) {
      if (isEnable) {
        bean.data.starStatus = ReposStatus.inactive;
      } else {
        bean.data.starStatus = ReposStatus.active;
      }
    }
    notifyDataChanged();
  }

  void changeWatchStatus() async {
    bool isEnable = bean.data.watchStatus == ReposStatus.active;

    bean.data.watchStatus = ReposStatus.loading;
    notifyDataChanged();

    final response = await ReposManager.instance
        .doReposWatcherAction(reposOwner, reposName, isEnable);
    if (response.result) {
      if (isEnable) {
        bean.data.watchStatus = ReposStatus.inactive;
      } else {
        bean.data.watchStatus = ReposStatus.active;
      }
    }
    notifyDataChanged();
  }

  void fetchReadme() async {
    final response =
        await ReposManager.instance.getReadme("$reposOwner/$reposName", null);
    bean.data.readme = response.data;

    notifyDataChanged();
  }

  void fetchBranches() async {
    final response =
        await ReposManager.instance.getBranches(reposOwner, reposName);
    bean.data.branchs = response;

    notifyDataChanged();
  }
}
