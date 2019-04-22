import 'package:flutter/material.dart';
import 'package:open_git/bean/source_file_bean.dart';
import 'package:open_git/contract/repository_source_file_contract.dart';
import 'package:open_git/presenter/repository_source_file_presenter.dart';
import 'package:open_git/util/file_size_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class RepositorySourceFilePage extends StatefulWidget {
  String reposOwner, reposName;

  RepositorySourceFilePage(this.reposOwner, this.reposName);

  @override
  State<StatefulWidget> createState() {
    return _RepositorySourceFilePage(reposOwner, reposName);
  }
}

class _RepositorySourceFilePage extends PullRefreshListState<
    RepositorySourceFilePage,
    SourceFileBean,
    RepositorySourceFilePresenter,
    IRepositorySourceFileView> implements IRepositorySourceFileView {
  String reposOwner, reposName;

  String _headerPath = "";

  List<String> _stack = [];

  _RepositorySourceFilePage(this.reposOwner, this.reposName);

  @override
  String getTitle() {
    return reposName;
  }

  @override
  RepositorySourceFilePresenter initPresenter() {
    return new RepositorySourceFilePresenter();
  }

  @override
  bool isSupportLoadMore() {
    return false;
  }

  @override
  Widget getHeader() {
    return ListTile(
      title: Text(_getHeaderPath()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: super.build(context),
        onWillPop: () {
          return _onKeyboardBack();
        });
  }

  @override
  Widget getItemRow(SourceFileBean item) {
    return ListTile(
      leading: Icon(item.type == "file" ? Icons.attach_file : Icons.folder),
      title: Text(item.name),
      subtitle: item.type == "file"
          ? Text(FileSizeUtil.formetFileSize(item.size))
          : null,
      onTap: () {
        _onItemClick(item);
      },
    );
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      await presenter.getReposFileDir(reposOwner, reposName, _headerPath);
    }
  }

  void _onItemClick(SourceFileBean item) {
    if (item.type == "dir") {
      _stack.add(item.name);
      setState(() {});
      showRefreshLoading();
    } else {
      NavigatorUtil.goReposSourceCode(context, item.name,
          ImageUtil.isImageEnd(item.url) ? item.downloadUrl : item.url);
    }
  }

  Future<bool> _onKeyboardBack() {
    int length = _stack.length;
    if (length > 0) {
      _stack.removeAt(length - 1);
      setState(() {});
      showRefreshLoading();
      return new Future.value(false);
    }
    return new Future.value(true);
  }

  String _getHeaderPath() {
    int length = _stack.length;
    _headerPath = "";
    for (int i = 0; i < length; i++) {
      _headerPath += ("/" + _stack[i]);
    }
    return reposName + _headerPath;
  }
}
