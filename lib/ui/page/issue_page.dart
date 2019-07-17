import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/loading_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/issue_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/ui/widget/issue_item_widget.dart';


class IssuePage extends BaseListStatelessWidget<IssueBean, IssueBloc> {
  static final String TAG = "IssuePage";

  static List<String> _q = ["involves", "assignee", "author", "mentions"];
  static List<String> _state = ["open", "closed"];
  static List<String> _sort = ["created", "updated", "comments"];
  static List<String> _direction = ["asc", "desc"];

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.issue;
  }

  @override
  Widget getHeader(BuildContext context, LoadingBean<List<IssueBean>> data) {
    IssueBloc bloc = BlocProvider.of<IssueBloc>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getIssueItem(bloc.q, _getPopupMenuItemList(_q, bloc.q), bloc),
        _getIssueItem(
            bloc.state, _getPopupMenuItemList(_state, bloc.state), bloc),
        _getIssueItem(bloc.sort, _getPopupMenuItemList(_sort, bloc.sort), bloc),
        _getIssueItem(
            bloc.order, _getPopupMenuItemList(_direction, bloc.order), bloc),
      ],
    );
  }

  @override
  Widget builderItem(BuildContext context, IssueBean item) {
    return IssueItemWidget(item);
  }

  List<PopupMenuItem<String>> _getPopupMenuItemList(
      List<String> list, String value) {
    return list
        .map(
          (String text) => PopupMenuItem<String>(
                value: text,
                enabled: value != text,
                child: Text(
                  text,
                  style: TextStyle(color: _getMenuSelectColor(text, value)),
                ),
              ),
        )
        .toList();
  }

  Widget _getIssueItem(text, items, IssueBloc bloc) {
    return Expanded(
      child: PopupMenuButton<String>(
        onSelected: (value) {
          _onSelected(value, bloc);
        },
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
              Icon(
                Icons.arrow_drop_down,
                size: 12.0,
                color: Colors.grey,
              ),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) => items,
      ),
      flex: 1,
    );
  }

  void _onSelected(String value, IssueBloc bloc) {
    if (_q.contains(value)) {
      bloc.refreshData(q: value);
    } else if (_state.contains(value)) {
      bloc.refreshData(state: value);
    } else if (_sort.contains(value)) {
      bloc.refreshData(sort: value);
    } else if (_direction.contains(value)) {
      bloc.refreshData(order: value);
    }
  }

  Color _getMenuSelectColor(String text, String value) {
    if (text == value) {
      return Colors.blue;
    }
    return Colors.grey;
  }
}
