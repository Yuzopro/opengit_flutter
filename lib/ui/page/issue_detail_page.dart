import 'package:flutter/material.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_detail_bean.dart';
import 'package:open_git/bean/loading_bean.dart';
import 'package:open_git/bloc/bloc_provider.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/base/base_stateless_widget.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/image_util.dart';

class IssueDetailPage
    extends BaseStatelessWidget<LoadingBean<IssueDetailBean>, IssueDetailBloc> {
  final List<_Reaction> _reactionList = [
    _Reaction("1f44d", "+1"),
    _Reaction("1f44e", "-1"),
    _Reaction("1f389", "hooray"),
    _Reaction("1f440", "eyes"),
    _Reaction("1f604", "laugh"),
    _Reaction("1f615", "confused"),
    _Reaction("1f680", "rocket"),
    _Reaction("2764", "heart")
  ];

  final List<String> _commentList = [
    "编辑",
    "删除",
  ];

  @override
  ListPageType getListPageType() {
    return ListPageType.issue_detail;
  }

  @override
  String getTitle(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return bloc.getTitle();
  }

  @override
  bool isLoading(LoadingBean<IssueDetailBean> data) {
    return data != null ? data.isLoading : true;
  }

  @override
  bool enablePullUp() {
    return true;
  }

  @override
  Widget getHeader(BuildContext context, LoadingBean<IssueDetailBean> data) {
    if (data == null || data.data == null || data.data.issueBean == null) {
      return new Container();
    }
    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: InkWell(
                  child: Text(data.data.issueBean.state),
                ),
                flex: 1,
              ),
              Text("#${data.data.issueBean.number}"),
            ],
          ),
        ),
        Divider(
          height: 0.3,
        ),
        Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            data.data.issueBean.title,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        Divider(
          height: 0.3,
        ),
        _getItemRow(context, data.data.issueBean, true),
      ],
    );
  }

  @override
  int getItemCount(LoadingBean<IssueDetailBean> data) {
    if (data == null) {
      return 0;
    }
    if (data.data == null) {
      return 0;
    }
    return data.data.comments == null ? 0 : data.data.comments.length;
  }

  @override
  Widget buildItemBuilder(
      BuildContext context, LoadingBean<IssueDetailBean> data, int index) {
    IssueBean model = data.data.comments[index];
    return _getItemRow(context, model, false);
  }

  Widget _getItemRow(BuildContext context, IssueBean item, bool isIssue) {
    List<Widget> listWidget = new List();

    Widget line = new Divider(height: 0.3);

    Widget userWidget = _getUserWidget(context, item, isIssue);
    listWidget.add(userWidget);
    listWidget.add(line);

    listWidget.add(
        new Padding(padding: EdgeInsets.all(12.0), child: Text(item.body)));

    Widget reactionWidget = _getReactionWidget(context, item, isIssue);
    if (reactionWidget != null) {
      listWidget.add(line);
      listWidget.add(reactionWidget);
    }

    Widget itemLine = new Container(
      height: 5.0,
      color: Colors.grey[200],
    );
    listWidget.add(itemLine);

    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listWidget,
    );
  }

  Widget _getUserWidget(BuildContext context, IssueBean item, isIssue) {
    List<Widget> userList = new List();
    userList.add(ImageUtil.getImageWidget(item.user.avatarUrl, 36.0));
    userList.add(Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.user.login),
            Text(DateUtil.getNewsTimeStr(item.createdAt)),
          ],
        ),
      ),
      flex: 1,
    ));
    userList.add(_getReactionMenu(
        context,
        item,
        Icon(
          Icons.sentiment_satisfied,
          color: Colors.grey,
        ),
        _reactionList,
        isIssue));

    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    if (bloc.isEditAndDeleteEnable(item)) {
      if (isIssue) {
        userList.add(Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: InkWell(
              child: Icon(
                Icons.edit,
                color: Colors.grey,
              ),
              onTap: () {
                bloc.goEditIssue(context);
              }),
        ));
      } else {
        userList.add(_getCommentMenu(
            context,
            item,
            Icon(
              Icons.more_horiz,
              color: Colors.grey,
            ),
            _commentList));
      }
    }

    return new Container(
      height: 56.0,
      padding: EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        children: userList,
      ),
    );
  }

  Widget _getReactionMenu(BuildContext context, IssueBean item, Widget child,
      List<_Reaction> list, isIssue) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return new Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: new PopupMenuButton<String>(
        onSelected: (text) {
          bloc.editReactions(item, text, isIssue);
        },
        child: child,
        itemBuilder: (BuildContext context) => list
            .map(
              (_Reaction reaction) => PopupMenuItem<String>(
                  value: reaction.type,
                  child: Image.asset(
                    "image/${reaction.img}.png",
                    width: 24.0,
                    height: 24.0,
                  )),
            )
            .toList(),
      ),
    );
  }

  Widget _getCommentMenu(
      BuildContext context, IssueBean item, Widget child, List<String> list) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return new Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: new PopupMenuButton<String>(
        onSelected: (text) {
          if (text == _commentList[0]) {
            bloc.enterCommentEditor(context, item, false);
          } else {
            bloc.deleteIssueComment(item);
          }
        },
        child: child,
        itemBuilder: (BuildContext context) => list
            .map(
              (String text) =>
                  PopupMenuItem<String>(value: text, child: Text(text)),
            )
            .toList(),
      ),
    );
  }

  Widget _getReactionWidget(BuildContext context, IssueBean item, isIssue) {
    if (item.reaction != null) {
      List<Widget> reactionWidget = new List();
      if (item.reaction.like > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f44d.png",
            item.reaction.like.toString(), item, "+1", isIssue));
      }

      if (item.reaction.noLike > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f44e.png",
            item.reaction.noLike.toString(), item, "-1", isIssue));
      }

      if (item.reaction.laugh > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f604.png",
            item.reaction.laugh.toString(), item, "laugh", isIssue));
      }

      if (item.reaction.hooray > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f389.png",
            item.reaction.hooray.toString(), item, "hooray", isIssue));
      }

      if (item.reaction.confused > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f615.png",
            item.reaction.confused.toString(), item, "confused", isIssue));
      }

      if (item.reaction.heart > 0) {
        reactionWidget.add(_getReactionItem(context, "image/2764.png",
            item.reaction.heart.toString(), item, "heart", isIssue));
      }

      if (item.reaction.rocket > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f680.png",
            item.reaction.rocket.toString(), item, "rocket", isIssue));
      }

      if (item.reaction.eyes > 0) {
        reactionWidget.add(_getReactionItem(context, "image/1f440.png",
            item.reaction.eyes.toString(), item, "eyes", isIssue));
      }

      if (reactionWidget.length > 0) {
        return new Container(
          height: 56.0,
          padding: EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            children: reactionWidget,
          ),
        );
      }
    }
    return null;
  }

  Widget _getReactionItem(BuildContext context, String img, String count,
      IssueBean item, content, isIssue) {
    return Container(
      child: InkWell(
          onTap: () {
            IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
            bloc.goDeleteReaction(context, item, content, isIssue);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                img,
                width: 12.0,
                height: 12.0,
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.0),
                child: Text(
                  count,
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
            ],
          )),
      width: 36.0,
      height: 56.0,
    );
  }
}

//class IssueDetailPage
//    extends BaseListStatelessWidget<IssueBean, IssueDetailBloc> {
//  final List<_Reaction> _reactionList = [
//    _Reaction("1f44d", "+1"),
//    _Reaction("1f44e", "-1"),
//    _Reaction("1f389", "hooray"),
//    _Reaction("1f440", "eyes"),
//    _Reaction("1f604", "laugh"),
//    _Reaction("1f615", "confused"),
//    _Reaction("1f680", "rocket"),
//    _Reaction("2764", "heart")
//  ];
//
//  final List<String> _commentList = [
//    "编辑",
//    "删除",
//  ];
//
//  @override
//  String getTitle(BuildContext context) {
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    return bloc.getTitle();
//  }
//
//  @override
//  ListPageType getListPageType() {
//    return ListPageType.issue_detail;
//  }
//
//  @override
//  Widget getHeader(BuildContext context) {
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    IssueBean issueBean = bloc.issueBean;
//    if (issueBean == null) {
//      return new Container();
//    }
//    return new Column(
//      children: <Widget>[
//        Padding(
//          padding: EdgeInsets.all(12.0),
//          child: Row(
//            children: <Widget>[
//              Expanded(
//                child: InkWell(
//                  child: Text(issueBean.state),
//                ),
//                flex: 1,
//              ),
//              Text("#${issueBean.number}"),
//            ],
//          ),
//        ),
//        Divider(
//          height: 0.3,
//        ),
//        Padding(
//          padding: EdgeInsets.all(12.0),
//          child: Text(
//            issueBean.title,
//            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//          ),
//        ),
//        Divider(
//          height: 0.3,
//        ),
//        _getItemRow(context, issueBean, true),
//      ],
//    );
//  }
//
//  @override
//  Widget buildFloatingActionButton(BuildContext context) {
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    if (bloc.issueBean == null) {
//      return null;
//    }
//    return new FloatingActionButton(
//      onPressed: () {
//        bloc.enterCommentEditor(context, bloc.issueBean, true);
//      },
//      backgroundColor: Colors.black,
//      tooltip: 'add comment',
//      child: Icon(
//        Icons.add,
//        color: Colors.white,
//      ),
//    );
//  }
//
//  @override
//  Widget builderItem(BuildContext context, IssueBean item) {
//    return _getItemRow(context, item, false);
//  }
//
//  Widget _getItemRow(BuildContext context, IssueBean item, bool isIssue) {
//    List<Widget> listWidget = new List();
//
//    Widget line = new Divider(height: 0.3);
//
//    Widget userWidget = _getUserWidget(context, item, isIssue);
//    listWidget.add(userWidget);
//    listWidget.add(line);
//
//    listWidget.add(
//        new Padding(padding: EdgeInsets.all(12.0), child: Text(item.body)));
//
//    Widget reactionWidget = _getReactionWidget(context, item, isIssue);
//    if (reactionWidget != null) {
//      listWidget.add(line);
//      listWidget.add(reactionWidget);
//    }
//
//    Widget itemLine = new Container(
//      height: 5.0,
//      color: Colors.grey[200],
//    );
//    listWidget.add(itemLine);
//
//    return new Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: listWidget,
//    );
//  }
//
//  Widget _getUserWidget(BuildContext context, IssueBean item, isIssue) {
//    List<Widget> userList = new List();
//    userList.add(ImageUtil.getImageWidget(item.user.avatarUrl, 36.0));
//    userList.add(Expanded(
//      child: Padding(
//        padding: EdgeInsets.only(left: 5.0),
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          crossAxisAlignment: CrossAxisAlignment.start,
//          children: <Widget>[
//            Text(item.user.login),
//            Text(DateUtil.getNewsTimeStr(item.createdAt)),
//          ],
//        ),
//      ),
//      flex: 1,
//    ));
//    userList.add(_getReactionMenu(
//        context,
//        item,
//        Icon(
//          Icons.sentiment_satisfied,
//          color: Colors.grey,
//        ),
//        _reactionList,
//        isIssue));
//
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    if (bloc.isEditAndDeleteEnable(item)) {
//      if (isIssue) {
//        userList.add(Padding(
//          padding: EdgeInsets.only(left: 5.0),
//          child: InkWell(
//              child: Icon(
//                Icons.edit,
//                color: Colors.grey,
//              ),
//              onTap: () {
//                bloc.goEditIssue(context);
//              }),
//        ));
//      } else {
//        userList.add(_getCommentMenu(
//            context,
//            item,
//            Icon(
//              Icons.more_horiz,
//              color: Colors.grey,
//            ),
//            _commentList));
//      }
//    }
//
//    return new Container(
//      height: 56.0,
//      padding: EdgeInsets.only(left: 12.0, right: 12.0),
//      child: Row(
//        children: userList,
//      ),
//    );
//  }
//
//  Widget _getReactionMenu(BuildContext context, IssueBean item, Widget child,
//      List<_Reaction> list, isIssue) {
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    return new Padding(
//      padding: EdgeInsets.only(left: 5.0),
//      child: new PopupMenuButton<String>(
//        onSelected: (text) {
//          bloc.editReactions(item, text, isIssue);
//        },
//        child: child,
//        itemBuilder: (BuildContext context) => list
//            .map(
//              (_Reaction reaction) => PopupMenuItem<String>(
//                  value: reaction.type,
//                  child: Image.asset(
//                    "image/${reaction.img}.png",
//                    width: 24.0,
//                    height: 24.0,
//                  )),
//            )
//            .toList(),
//      ),
//    );
//  }
//
//  Widget _getCommentMenu(
//      BuildContext context, IssueBean item, Widget child, List<String> list) {
//    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//    return new Padding(
//      padding: EdgeInsets.only(left: 5.0),
//      child: new PopupMenuButton<String>(
//        onSelected: (text) {
//          if (text == _commentList[0]) {
//            bloc.enterCommentEditor(context, item, false);
//          } else {
//            bloc.deleteIssueComment(item);
//          }
//        },
//        child: child,
//        itemBuilder: (BuildContext context) => list
//            .map(
//              (String text) =>
//                  PopupMenuItem<String>(value: text, child: Text(text)),
//            )
//            .toList(),
//      ),
//    );
//  }
//
//  Widget _getReactionWidget(BuildContext context, IssueBean item, isIssue) {
//    if (item.reaction != null) {
//      List<Widget> reactionWidget = new List();
//      if (item.reaction.like > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f44d.png",
//            item.reaction.like.toString(), item, "+1", isIssue));
//      }
//
//      if (item.reaction.noLike > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f44e.png",
//            item.reaction.noLike.toString(), item, "-1", isIssue));
//      }
//
//      if (item.reaction.laugh > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f604.png",
//            item.reaction.laugh.toString(), item, "laugh", isIssue));
//      }
//
//      if (item.reaction.hooray > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f389.png",
//            item.reaction.hooray.toString(), item, "hooray", isIssue));
//      }
//
//      if (item.reaction.confused > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f615.png",
//            item.reaction.confused.toString(), item, "confused", isIssue));
//      }
//
//      if (item.reaction.heart > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/2764.png",
//            item.reaction.heart.toString(), item, "heart", isIssue));
//      }
//
//      if (item.reaction.rocket > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f680.png",
//            item.reaction.rocket.toString(), item, "rocket", isIssue));
//      }
//
//      if (item.reaction.eyes > 0) {
//        reactionWidget.add(_getReactionItem(context, "image/1f440.png",
//            item.reaction.eyes.toString(), item, "eyes", isIssue));
//      }
//
//      if (reactionWidget.length > 0) {
//        return new Container(
//          height: 56.0,
//          padding: EdgeInsets.only(left: 12.0, right: 12.0),
//          child: Row(
//            children: reactionWidget,
//          ),
//        );
//      }
//    }
//    return null;
//  }
//
//  Widget _getReactionItem(BuildContext context, String img, String count,
//      IssueBean item, content, isIssue) {
//    return Container(
//      child: InkWell(
//          onTap: () {
//            IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
//            bloc.goDeleteReaction(context, item, content, isIssue);
//          },
//          child: Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Image.asset(
//                img,
//                width: 12.0,
//                height: 12.0,
//              ),
//              Padding(
//                padding: EdgeInsets.only(left: 2.0),
//                child: Text(
//                  count,
//                  style: TextStyle(fontSize: 10.0),
//                ),
//              ),
//            ],
//          )),
//      width: 36.0,
//      height: 56.0,
//    );
//  }
//}
//
////class IssueDetailPage extends StatefulWidget {
////  final IssueBean issueBean;
////
////  IssueDetailPage(this.issueBean);
////
////  @override
////  State<StatefulWidget> createState() {
////    return _IssueDetailState(issueBean);
////  }
////}
//
////class _IssueDetailState extends PullRefreshListState<IssueDetailPage, IssueBean,
////    IssueDetailPresenter, IIssueDetailView> implements IIssueDetailView {
////  final IssueBean issueBean;
////  String _repoUrl = "";
////
////  IssueBean _editIssueBean;
////  IssueBean _signalIssueBean;
////
////  _IssueDetailState(this.issueBean);
////
////  final List<_Reaction> _reactionList = [
////    _Reaction("1f44d", "+1"),
////    _Reaction("1f44e", "-1"),
////    _Reaction("1f389", "hooray"),
////    _Reaction("1f440", "eyes"),
////    _Reaction("1f604", "laugh"),
////    _Reaction("1f615", "confused"),
////    _Reaction("1f680", "rocket"),
////    _Reaction("2764", "heart")
////  ];
////
////  final List<String> _commentList = [
////    "编辑",
////    "删除",
////  ];
////
////  @override
////  void initData() {
////    super.initData();
////    if (presenter != null && issueBean != null) {
////      _repoUrl = issueBean.repoUrl;
////    }
////  }
////
////  @override
////  String getTitle() {
////    if (presenter != null) {
////      return "${presenter.getReposFullName(issueBean.repoUrl)} # ${issueBean.number}";
////    }
////    return "";
////  }
////
////  @override
////  Widget getHeader() {
////    if (_signalIssueBean == null) {
////      return new Container();
////    }
////    return new Column(
////      children: <Widget>[
////        Padding(
////          padding: EdgeInsets.all(12.0),
////          child: Row(
////            children: <Widget>[
////              Expanded(
////                child: InkWell(
////                  child: Text(_signalIssueBean.state),
////                ),
////                flex: 1,
////              ),
////              Text("#${_signalIssueBean.number}"),
////            ],
////          ),
////        ),
////        Divider(
////          height: 0.3,
////        ),
////        Padding(
////          padding: EdgeInsets.all(12.0),
////          child: Text(
////            _signalIssueBean.title,
////            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
////          ),
////        ),
////        Divider(
////          height: 0.3,
////        ),
////        _getItemRow(_signalIssueBean, true),
////      ],
////    );
////  }
////
////  @override
////  Widget buildFloatingActionButton() {
////    if (_signalIssueBean == null) {
////      return null;
////    }
////    return new FloatingActionButton(
////      onPressed: () {
////        _enterCommentEditor(_signalIssueBean, true);
////      },
////      backgroundColor: Colors.black,
////      tooltip: 'add comment',
////      child: Icon(
////        Icons.add,
////        color: Colors.white,
////      ),
////    );
////  }
////
////  @override
////  Widget getItemRow(IssueBean item) {
////    return _getItemRow(item, false);
////  }
////
////  Widget _getItemRow(IssueBean item, bool isIssue) {
////    if (_editIssueBean != null && _editIssueBean.id == item.id) {
////      item = _editIssueBean;
////    }
////
////    List<Widget> listWidget = new List();
////
////    Widget line = new Divider(height: 0.3);
////
////    Widget userWidget = _getUserWidget(item, isIssue);
////    listWidget.add(userWidget);
////    listWidget.add(line);
////
////    listWidget.add(
////        new Padding(padding: EdgeInsets.all(12.0), child: Text(item.body)));
////
////    Widget reactionWidget = _getReactionWidget(item, isIssue);
////    if (reactionWidget != null) {
////      listWidget.add(line);
////      listWidget.add(reactionWidget);
////    }
////
////    Widget itemLine = new Container(
////      height: 5.0,
////      color: Colors.grey[200],
////    );
////    listWidget.add(itemLine);
////
////    return new Column(
////      crossAxisAlignment: CrossAxisAlignment.start,
////      children: listWidget,
////    );
////  }
////
////  @override
////  IssueDetailPresenter initPresenter() {
////    return new IssueDetailPresenter();
////  }
////
////  @override
////  Future<Null> onRefresh() async {
////    if (presenter != null) {
////      page = 1;
////      await presenter.getIssueComment(
////          issueBean.repoUrl, issueBean.number, page, false);
////    }
////  }
////
////  @override
////  getMoreData() {
////    if (presenter != null) {
////      page++;
////      presenter.getIssueComment(
////          issueBean.repoUrl, issueBean.number, page, true);
////    }
////  }
////
////  @override
////  void onEditSuccess(IssueBean issueBean) {
////    if (issueBean != null) {
////      setState(() {
////        _editIssueBean = issueBean;
////      });
////    }
////  }
////
////  void onAddSuccess(IssueBean issueBean) {
////    if (issueBean != null) {
////      setState(() {
////        addItem(issueBean);
////      });
////    }
////  }
////
////  @override
////  void onDeleteSuccess(IssueBean issueBean) {
////    if (issueBean != null) {
////      setState(() {
////        deleteItem(issueBean);
////      });
////    }
////  }
////
////  @override
////  void onGetSingleIssueSuccess(IssueBean issueBean) {
////    if (issueBean != null) {
////      setState(() {
////        _signalIssueBean = issueBean;
////      });
////    }
////  }
////
////  Widget _getUserWidget(IssueBean item, isIssue) {
////    List<Widget> userList = new List();
////    userList.add(ImageUtil.getImageWidget(item.user.avatarUrl, 36.0));
////    userList.add(Expanded(
////      child: Padding(
////        padding: EdgeInsets.only(left: 5.0),
////        child: Column(
////          mainAxisAlignment: MainAxisAlignment.center,
////          crossAxisAlignment: CrossAxisAlignment.start,
////          children: <Widget>[
////            Text(item.user.login),
////            Text(DateUtil.getNewsTimeStr(item.createdAt)),
////          ],
////        ),
////      ),
////      flex: 1,
////    ));
////    userList.add(_getReactionMenu(
////        item,
////        Icon(
////          Icons.sentiment_satisfied,
////          color: Colors.grey,
////        ),
////        _reactionList,
////        isIssue));
////
////    if (presenter != null &&
////        presenter.isEditAndDeleteEnable(_signalIssueBean, item)) {
////      if (isIssue) {
////        userList.add(Padding(
////          padding: EdgeInsets.only(left: 5.0),
////          child: InkWell(
////              child: Icon(
////                Icons.edit,
////                color: Colors.grey,
////              ),
////              onTap: () {
////                _enterEditIssue();
////              }),
////        ));
////      } else {
////        userList.add(_getCommentMenu(
////            item,
////            Icon(
////              Icons.more_horiz,
////              color: Colors.grey,
////            ),
////            _commentList));
////      }
////    }
////
////    return new Container(
////      height: 56.0,
////      padding: EdgeInsets.only(left: 12.0, right: 12.0),
////      child: Row(
////        children: userList,
////      ),
////    );
////  }
////
////  Widget _getReactionMenu(
////      IssueBean item, Widget child, List<_Reaction> list, isIssue) {
////    return new Padding(
////      padding: EdgeInsets.only(left: 5.0),
////      child: new PopupMenuButton<String>(
////        onSelected: (text) {
////          if (presenter != null) {
////            presenter.editReactions(item, _repoUrl, text, isIssue);
////          }
////        },
////        child: child,
////        itemBuilder: (BuildContext context) => list
////            .map(
////              (_Reaction reaction) => PopupMenuItem<String>(
////                  value: reaction.type,
////                  child: Image.asset(
////                    "image/${reaction.img}.png",
////                    width: 24.0,
////                    height: 24.0,
////                  )),
////            )
////            .toList(),
////      ),
////    );
////  }
////
////  Widget _getCommentMenu(IssueBean item, Widget child, List<String> list) {
////    return new Padding(
////      padding: EdgeInsets.only(left: 5.0),
////      child: new PopupMenuButton<String>(
////        onSelected: (text) {
////          if (text == _commentList[0]) {
////            _enterCommentEditor(item, false);
////          } else {
////            if (presenter != null) {
////              presenter.deleteIssueComment(item, _repoUrl, item.id);
////            }
////          }
////        },
////        child: child,
////        itemBuilder: (BuildContext context) => list
////            .map(
////              (String text) =>
////                  PopupMenuItem<String>(value: text, child: Text(text)),
////            )
////            .toList(),
////      ),
////    );
////  }
////
////  Widget _getReactionWidget(IssueBean item, isIssue) {
////    if (item.reaction != null) {
////      List<Widget> reactionWidget = new List();
////      if (item.reaction.like > 0) {
////        reactionWidget.add(_getReactionItem("image/1f44d.png",
////            item.reaction.like.toString(), item, "+1", isIssue));
////      }
////
////      if (item.reaction.noLike > 0) {
////        reactionWidget.add(_getReactionItem("image/1f44e.png",
////            item.reaction.noLike.toString(), item, "-1", isIssue));
////      }
////
////      if (item.reaction.laugh > 0) {
////        reactionWidget.add(_getReactionItem("image/1f604.png",
////            item.reaction.laugh.toString(), item, "laugh", isIssue));
////      }
////
////      if (item.reaction.hooray > 0) {
////        reactionWidget.add(_getReactionItem("image/1f389.png",
////            item.reaction.hooray.toString(), item, "hooray", isIssue));
////      }
////
////      if (item.reaction.confused > 0) {
////        reactionWidget.add(_getReactionItem("image/1f615.png",
////            item.reaction.confused.toString(), item, "confused", isIssue));
////      }
////
////      if (item.reaction.heart > 0) {
////        reactionWidget.add(_getReactionItem("image/2764.png",
////            item.reaction.heart.toString(), item, "heart", isIssue));
////      }
////
////      if (item.reaction.rocket > 0) {
////        reactionWidget.add(_getReactionItem("image/1f680.png",
////            item.reaction.rocket.toString(), item, "rocket", isIssue));
////      }
////
////      if (item.reaction.eyes > 0) {
////        reactionWidget.add(_getReactionItem("image/1f440.png",
////            item.reaction.eyes.toString(), item, "eyes", isIssue));
////      }
////
////      if (reactionWidget.length > 0) {
////        return new Container(
////          height: 56.0,
////          padding: EdgeInsets.only(left: 12.0, right: 12.0),
////          child: Row(
////            children: reactionWidget,
////          ),
////        );
////      }
////    }
////    return null;
////  }
////
////  Widget _getReactionItem(
////      String img, String count, IssueBean item, content, isIssue) {
////    return Container(
////      child: InkWell(
////          onTap: () {
////            _enterDeleteReaction(item, content, isIssue);
////          },
////          child: Row(
////            mainAxisAlignment: MainAxisAlignment.center,
////            children: <Widget>[
////              Image.asset(
////                img,
////                width: 12.0,
////                height: 12.0,
////              ),
////              Padding(
////                padding: EdgeInsets.only(left: 2.0),
////                child: Text(
////                  count,
////                  style: TextStyle(fontSize: 10.0),
////                ),
////              ),
////            ],
////          )),
////      width: 36.0,
////      height: 56.0,
////    );
////  }
////
////  TapGestureRecognizer _recognizer(String url) {
////    return new TapGestureRecognizer()..onTap = () {};
////  }
////
////  _enterCommentEditor(IssueBean item, bool isAdd) async {
////    final result =
////        await NavigatorUtil.goMarkdownEditor(context, item, _repoUrl, isAdd);
////    if (isAdd) {
////      onAddSuccess(result);
////    } else {
////      onEditSuccess(result);
////    }
////  }
////
////  _enterDeleteReaction(IssueBean item, content, isIssue) async {
////    final result = await NavigatorUtil.goDeleteReaction(
////        context, item, _repoUrl, content, isIssue);
////    onEditSuccess(result);
////  }
////
////  _enterEditIssue() async {
////    final result =
////        await NavigatorUtil.goEditIssue(context, _signalIssueBean, _repoUrl);
////    if (result != null) {
////      setState(() {
////        _signalIssueBean = result;
////      });
////    }
////  }
////}

class _Reaction {
  final String img;
  final String type;

  _Reaction(this.img, this.type);
}
