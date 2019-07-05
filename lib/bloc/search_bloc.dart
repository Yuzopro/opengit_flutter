import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:open_git/bloc/base_list_bloc.dart';
import 'package:open_git/common/config.dart';
import 'package:open_git/manager/search_manager.dart';
import 'package:open_git/util/log_util.dart';

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
  void initData(BuildContext context) {}

  void startSearch(String text) {
    searchText = text;
    sink.add(null);
    onRefresh();
  }

  Future _searchText() async {
    final response =
        await SearchManager.instance.getIssue(type, searchText, page);
    if (response != null && response.result) {
      dealResult(response.data);
    }
  }
}
