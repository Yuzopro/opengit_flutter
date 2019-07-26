import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/manager/repos_manager.dart';

class ReposFileBloc extends BaseListBloc<SourceFileBean> {
  final String reposOwner, reposName;
  List<String> fileStack;

  bool _isInit = false;

  ReposFileBloc(this.reposOwner, this.reposName) {
    fileStack = [];
  }

  @override
  Future getData() {
    _fetchSourceFile();
  }

  @override
  PageType getPageType() {
    return PageType.repos_source_file;
  }

  @override
  void initData(BuildContext context) async {
    if (_isInit) {
      return;
    }
    _isInit = true;

    _showLoading();
    await _fetchSourceFile();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  void onReload() async {
    _showLoading();
    await _fetchSourceFile();
    _hideLoading();

    refreshStatusEvent();
  }

  void fetchNextDir(String fileName) async {
    _showLoading();
    fileStack.add(fileName);
    await _fetchSourceFile();
    _hideLoading();
  }

  void fetchPreDir() async {
    _showLoading();
    if (fileStack.length > 0) {
      fileStack.removeAt(fileStack.length - 1);
    }
    await _fetchSourceFile();
    _hideLoading();
  }

  Future _fetchSourceFile() async {
    String path = _getPath();
    final result = await ReposManager.instance
        .getReposFileDir(reposOwner, reposName, path: path);

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

    sink.add(bean);
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

  void _showLoading() {
    bean.isLoading = true;
    sink.add(bean);
  }

  void _hideLoading() {
    bean.isLoading = false;
    sink.add(bean);
  }
}
