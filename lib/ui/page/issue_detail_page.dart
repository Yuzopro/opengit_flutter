import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_detail_bean.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/ui/widget/markdown_widget.dart';

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
  PageType getPageType() {
    return PageType.issue_detail;
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
      return Container();
    }
    return Column(
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
    List<Widget> listWidget = List();

    Widget line = Divider(height: 0.3);

    Widget userWidget = _getUserWidget(context, item, isIssue);
    listWidget.add(userWidget);
    listWidget.add(line);

    listWidget.add(
      Padding(
        padding: EdgeInsets.all(12.0),
        child: MarkdownWidget(
          markdownData: item.body,
        ),
      ),
    );

    Widget reactionWidget = _getReactionWidget(context, item, isIssue);
    if (reactionWidget != null) {
      listWidget.add(line);
      listWidget.add(reactionWidget);
    }

    Widget itemLine = Container(
      height: 5.0,
      color: Colors.grey[200],
    );
    listWidget.add(itemLine);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listWidget,
    );
  }

  Widget _getUserWidget(BuildContext context, IssueBean item, isIssue) {
    List<Widget> userList = List();
    userList.add(
      ImageUtil.getCircleNetworkImage(
          item.user.avatarUrl, 36.0, "image/ic_default_head.png"),
    );
    userList.add(
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.user.login),
              Text(
                DateUtil.getMultiDateStr(item.createdAt),
              ),
            ],
          ),
        ),
        flex: 1,
      ),
    );
    userList.add(
      _getReactionMenu(
          context,
          item,
          Icon(
            Icons.sentiment_satisfied,
            color: Colors.grey,
          ),
          _reactionList,
          isIssue),
    );

    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    if (bloc.isEditAndDeleteEnable(item)) {
      if (isIssue) {
        userList.add(
          Padding(
            padding: EdgeInsets.only(left: 5.0),
            child: InkWell(
                child: Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
                onTap: () {
                  bloc.goEditIssue(context);
                }),
          ),
        );
      } else {
        userList.add(
          _getCommentMenu(
              context,
              item,
              Icon(
                Icons.more_horiz,
                color: Colors.grey,
              ),
              _commentList),
        );
      }
    }

    return Container(
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
    return Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: PopupMenuButton<String>(
        onSelected: (text) {
          bloc.editReactions(item, text, isIssue);
        },
        child: child,
        itemBuilder: (BuildContext context) => list
            .map(
              (_Reaction reaction) => PopupMenuItem<String>(
                value: reaction.type,
                child:
                    ImageUtil.getImage("image/${reaction.img}.png", 24.0, 24.0),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _getCommentMenu(
      BuildContext context, IssueBean item, Widget child, List<String> list) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return Padding(
      padding: EdgeInsets.only(left: 5.0),
      child: PopupMenuButton<String>(
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
              (String text) => PopupMenuItem<String>(
                value: text,
                child: Text(text),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _getReactionWidget(BuildContext context, IssueBean item, isIssue) {
    if (item.reaction != null) {
      List<Widget> reactionWidget = List();
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
        return Container(
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
            ImageUtil.getImage(img, 12.0, 12.0),
            Padding(
              padding: EdgeInsets.only(left: 2.0),
              child: Text(
                count,
                style: TextStyle(fontSize: 10.0),
              ),
            ),
          ],
        ),
      ),
      width: 36.0,
      height: 56.0,
    );
  }
}

class _Reaction {
  final String img;
  final String type;

  _Reaction(this.img, this.type);
}
