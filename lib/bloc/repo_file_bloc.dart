import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/manager/repos_manager.dart';

class RepoFileBloc extends BaseListBloc<SourceFileBean> {
  final String reposOwner, reposName, branch;
  List<String> fileStack;

  RepoFileBloc(this.reposOwner, this.reposName, this.branch) {
    fileStack = [];
  }

  @override
  Future getData() {
    _fetchSourceFile();
  }

  @override
  void initData(BuildContext context) async {
    onReload();
  }

  @override
  void onReload() async {
    showLoading();
    await _fetchSourceFile();
    hideLoading();
  }

  void fetchNextDir(String fileName) async {
    showLoading();
    fileStack.add(fileName);
    await _fetchSourceFile();
    hideLoading();
  }

  void fetchPreDir() async {
    showLoading();
    if (fileStack.length > 0) {
      fileStack.removeAt(fileStack.length - 1);
    }
    await _fetchSourceFile();
    hideLoading();
  }

  Future _fetchSourceFile() async {
    String path = _getPath();
    final result = await ReposManager.instance
        .getReposFileDir(reposOwner, reposName, path: path, branch: branch);

    if (bean.data == null) {
      bean.data = List();
    }

    bean.data.clear();

    if (result != null) {
      bean.isError = false;
      bean.data.addAll(result);
    } else {
      bean.isError = true;
    }
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
