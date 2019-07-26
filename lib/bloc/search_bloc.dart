import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:open_git/manager/search_manager.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

abstract class SearchBloc<T> extends BaseListBloc<T> {
  static final String TAG = "SearchBloc";

  final String type;
  String searchText;

  SearchBloc(this.type) {
    LogUtil.v(type, tag: TAG);
  }

  void dealResult(result);

  @override
  Future getData() async {
    await _searchText();
  }

  @override
  void onReload() async {
    _showLoading();
    await _searchText();
    _hideLoading();

    refreshStatusEvent();
  }

  @override
  void initData(BuildContext context) {}

  void startSearch(String text) async {
    searchText = text;
    _showLoading();
    await _searchText();
    _hideLoading();

    refreshStatusEvent();
  }

  Future _searchText() async {
    final response =
        await SearchManager.instance.getIssue(type, searchText, page);
    if (response != null && response.result) {
      dealResult(response.data);
    }
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
