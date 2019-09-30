import 'package:flutter/widgets.dart';
import 'package:flutter_base_ui/bloc/base_list_bloc.dart';
import 'package:open_git/manager/search_manager.dart';

abstract class SearchBloc<T> extends BaseListBloc<T> {
  static final String TAG = "SearchBloc";

  final String type;
  String searchText;

  SearchBloc(this.type);

  void dealResult(result);

  @override
  Future getData() async {
    await _searchText();
  }

  @override
  void onReload() async {
    showLoading();
    await _searchText();
    hideLoading();
  }

  @override
  void initData(BuildContext context) {}

  void startSearch(String text) async {
    searchText = text;
    showLoading();
    await _searchText();
    hideLoading();
  }

  Future _searchText() async {
    final response =
        await SearchManager.instance.getIssue(type, searchText, page);
    if (response != null && response.result) {
      dealResult(response.data);
    }
  }
}
