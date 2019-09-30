import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_list_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bloc/issue_bloc.dart';
import 'package:open_git/common/sp_const.dart';
import 'package:open_git/ui/widget/issue_item_widget.dart';

class IssuePage extends BaseListStatelessWidget<IssueBean, IssueBloc> {
  static final String TAG = 'IssuePage';

  static List<String> _filter = [
    'assigned',
    'created',
    'mentioned',
    'subscribed',
    'all'
  ];
  static List<String> _state = ['open', 'closed', 'all'];
  static List<String> _sort = ['created', 'updated', 'comments'];
  static List<String> _direction = ['asc', 'desc'];

  @override
  bool isShowAppBar() {
    return false;
  }

  @override
  Widget getHeader(BuildContext context, LoadingBean<List<IssueBean>> data) {
    IssueBloc bloc = BlocProvider.of<IssueBloc>(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getIssueItem(
            bloc.filter, _getPopupMenuItemList(_filter, bloc.filter), bloc,
            isFilter: true),
        _getIssueItem(
            bloc.state, _getPopupMenuItemList(_state, bloc.state), bloc),
        _getIssueItem(bloc.sort, _getPopupMenuItemList(_sort, bloc.sort), bloc),
        _getIssueItem(bloc.direction,
            _getPopupMenuItemList(_direction, bloc.direction), bloc),
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

  Widget _getIssueItem(text, items, IssueBloc bloc, {bool isFilter: false}) {
    return Expanded(
      child: PopupMenuButton<String>(
        onSelected: (value) {
          _onSelected(value, bloc, isFilter);
        },
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: YZStyle.minSubText,
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
    );
  }

  void _onSelected(String value, IssueBloc bloc, bool isFilter) {
    if (isFilter && _filter.contains(value)) {
      SpUtil.instance.putString(SP_KEY_ISSUE_FILTER, value);
      bloc.refreshData(filter: value);
    } else if (_state.contains(value)) {
      SpUtil.instance.putString(SP_KEY_ISSUE_STATE, value);
      bloc.refreshData(state: value);
    } else if (_sort.contains(value)) {
      SpUtil.instance.putString(SP_KEY_ISSUE_SORT, value);
      bloc.refreshData(sort: value);
    } else if (_direction.contains(value)) {
      SpUtil.instance.putString(SP_KEY_ISSUE_DIRECTION, value);
      bloc.refreshData(direction: value);
    }
  }

  Color _getMenuSelectColor(String text, String value) {
    if (text == value) {
      return Color(YZColors.textColor);
    }
    return Color(YZColors.subTextColor);
  }
}
