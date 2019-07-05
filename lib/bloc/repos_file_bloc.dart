import 'dart:collection';

import 'package:flutter/src/widgets/framework.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/manager/repos_manager.dart';
import 'package:open_git/status/status.dart';

class ReposFileBloc extends BaseListBloc<SourceFileBean> {
  final String reposOwner, reposName;
  List<String> fileStack;

  bool _isInit = false;

  ReposFileBloc(this.reposOwner, this.reposName) {
    fileStack = [];
  }

  @override
  Future getData() {
    sink.add(null);
    _fetchSourceFile();
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.repos_source_file;
  }

  @override
  void initData(BuildContext context) {
    if (_isInit) {
      return;
    }
    _isInit = true;
    _fetchSourceFile();
  }

  void fetchNextDir(String fileName) {
    fileStack.add(fileName);

    sink.add(null);

    _fetchSourceFile();
  }

  void fetchPreDir() {
    if (fileStack.length > 0) {
      fileStack.removeAt(fileStack.length - 1);
    }
    sink.add(null);

    _fetchSourceFile();
  }

  Future _fetchSourceFile() async {
    String path = _getPath();
    final result = await ReposManager.instance
        .getReposFileDir(reposOwner, reposName, path: path);

    if (list == null) {
      list = List();
    }

    list.clear();

    if (result != null) {
      list.addAll(result);
    }

    sink.add(UnmodifiableListView<SourceFileBean>(list));
  }

  String getHeaderPath() {
    return reposName + _getPath();
  }

  String _getPath() {
    int length = fileStack.length;
    String path = "";
    for (int i = 0; i < length; i++) {
      path += ("/" + fileStack[i]);
    }
    return path;
  }
}
