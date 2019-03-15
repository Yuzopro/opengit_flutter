import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/issue_contract.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/presenter/issue_presenter.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class IssuePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IssuePageState();
  }
}

class _IssuePageState
    extends PullRefreshListState<IssueBean, IssuePresenter, IIssueView>
    with AutomaticKeepAliveClientMixin
    implements IIssueView {
  static List<String> _p = ["involves", "assignee", "author", "mentions"];
  static List<String> _state = ["open", "closed"];
  static List<String> _sort = ["created", "updated", "comments"];
  static List<String> _direction = ["asc", "desc"];

  String _userName = "";
  int _page = 1;

  String _pValue = "involves",
      _stateValue = "open",
      _sortValue = "created",
      _direationValue = "asc";

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    UserBean userBean = LoginManager.instance.getUserBean();
    if (userBean != null) {
      _userName = userBean.login ?? "";
    }
  }

  List<PopupMenuItem<String>> _getPopupMenuItemList(
      List<String> list, String value) {
    return list
        .map(
          (String text) => PopupMenuItem<String>(
                value: text,
                enabled: value.compareTo(text) != 0,
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
    if (_pValue.compareTo(value) == 0 ||
        _stateValue.compareTo(value) == 0 ||
        _sortValue.compareTo(value) == 0 ||
        _direationValue.compareTo(value) == 0) {
      return Colors.blue;
    }
    return Colors.grey;
  }

  @override
  Widget getItemRow(IssueBean item) {
    return new FlatButton(
      child: new Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 12.0, bottom: 8.0),
            width: MediaQuery.of(context).size.width,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _getItemOwner(item.user.avatarUrl, item.user.login),
                    Text(
                      DateUtil.getNewsTimeStr(item.createdAt),
                      style: TextStyle(color: Colors.grey, fontSize: 12.0),
                    ),
                  ],
                ),
                //描述
                Text(
                  item.title,
                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        presenter.getReposFullName(item.repoUrl) +
                            "#" +
                            item.number.toString(),
                        style: new TextStyle(
                            color: Colors.black54, fontSize: 12.0),
                      ),
                      flex: 1,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.comment,
                          color: Colors.grey,
                          size: 12.0,
                        ),
                        Text(
                          item.commentNum.toString(),
                          style: TextStyle(color: Colors.grey, fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 0.3,
          ),
        ],
      ),
      onPressed: () {
      },
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      _page++;
      presenter.getIssue(_pValue, _stateValue, _sortValue, _direationValue,
          _userName, _page, true);
    }
  }

  @override
  IssuePresenter initPresenter() {
    return new IssuePresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      _page = 1;
      await presenter.getIssue(_pValue, _stateValue, _sortValue,
          _direationValue, _userName, _page, false);
    }
  }

  Widget _getItemOwner(String ownerHead, String ownerName) {
    return Expanded(
      child: Row(
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
      ),
      flex: 1,
    );
  }
}
