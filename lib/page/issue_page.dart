import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/contract/issue_contract.dart';
import 'package:open_git/presenter/issue_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/navigator_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class IssuePage extends StatefulWidget {
  final String userName;

  IssuePage(this.userName);

  @override
  State<StatefulWidget> createState() {
    return _IssuePageState(userName);
  }
}

class _IssuePageState
    extends PullRefreshListState<IssuePage, IssueBean, IssuePresenter, IIssueView>
    with AutomaticKeepAliveClientMixin
    implements IIssueView {
  static List<String> _p = ["involves", "assignee", "author", "mentions"];
  static List<String> _state = ["open", "closed"];
  static List<String> _sort = ["created", "updated", "comments"];
  static List<String> _direction = ["asc", "desc"];

  String _pValue = "involves",
      _stateValue = "open",
      _sortValue = "created",
      _direationValue = "asc";

  final String userName;

  _IssuePageState(this.userName);

  @override
  bool get wantKeepAlive => true;

  List<PopupMenuItem<String>> _getPopupMenuItemList(
      List<String> list, String value) {
    return list
        .map(
          (String text) => PopupMenuItem<String>(
                value: text,
                enabled: value != text,
                child: Text(
                  text,
                  style: TextStyle(color: _getMenuSelectColor(text)),
                ),
              ),
        )
        .toList();
  }

  @override
  Widget getHeader() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _getIssueItem(_pValue, _getPopupMenuItemList(_p, _pValue)),
        _getIssueItem(_stateValue, _getPopupMenuItemList(_state, _stateValue)),
        _getIssueItem(_sortValue, _getPopupMenuItemList(_sort, _sortValue)),
        _getIssueItem(_direationValue,
            _getPopupMenuItemList(_direction, _direationValue)),
      ],
    );
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: buildBody(context),
    );
  }

  Widget _getIssueItem(text, items) {
    return new Expanded(
      child: PopupMenuButton<String>(
        onSelected: _showMenuSelection,
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: new TextStyle(color: Colors.grey, fontSize: 12.0),
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

  void _showMenuSelection(String value) {
    if (_p.contains(value)) {
      _pValue = value;
    } else if (_state.contains(value)) {
      _stateValue = value;
    } else if (_sort.contains(value)) {
      _sortValue = value;
    } else if (_direction.contains(value)) {
      _direationValue = value;
    }
    setState(() {});

    showRefreshLoading();
  }

  Color _getMenuSelectColor(String value) {
    if (_pValue == value ||
        _stateValue == value ||
        _sortValue == value ||
        _direationValue == value) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget getItemRow(IssueBean item) {
    return new InkWell(
        child: Padding(
          padding: EdgeInsets.all(12.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getItemOwner(item.user.avatarUrl, item.user.login),
              //全称
              Padding(
                padding: new EdgeInsets.only(top: 6.0, bottom: 6.0),
                child: Text(
                  presenter.getReposFullName(item.repoUrl) ?? "",
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              //描述
              Padding(
                padding: new EdgeInsets.only(bottom: 6.0),
                child: Text(
                  item.title,
                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
              ),
              //底部数据
              Row(
                children: <Widget>[
                  _getItemBottom(
                      Icon(
                        Icons.timer,
                        color: Colors.black,
                        size: 12.0,
                      ),
                      DateUtil.getNewsTimeStr(item.createdAt)),
                  _getItemBottom(
                      Icon(
                        Icons.comment,
                        color: Colors.black,
                        size: 12.0,
                      ),
                      item.commentNum.toString()),
                  Text(
                    "#${item.number}",
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () {
          NavigatorUtil.goIssueDetail(context, item);
        });
  }

  Widget _getItemBottom(Widget icon, String count) {
    return new Padding(
      padding: new EdgeInsets.only(right: 12.0),
      child: Row(
        children: <Widget>[
          icon,
          Text(
            count,
            style: new TextStyle(color: Colors.black, fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getIssue(_pValue, _stateValue, _sortValue, _direationValue,
          userName, page, true);
    }
  }

  @override
  IssuePresenter initPresenter() {
    return new IssuePresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getIssue(_pValue, _stateValue, _sortValue,
          _direationValue, userName, page, false);
    }
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Row(
      children: <Widget>[
        ClipOval(
          child: ImageUtil.getImageWidget(ownerHead, 18.0),
        ),
        Padding(
          padding: new EdgeInsets.only(left: 4.0),
          child: Text(
            ownerName,
            style: new TextStyle(
                color: Colors.black54,
                fontSize: 12.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
