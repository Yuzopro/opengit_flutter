import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_detail_bean.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/common/gradient_const.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/common/size_const.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/widget/markdown_widget.dart';
import 'package:open_git/util/size_util.dart';

///https://api.github.com/repos/DylanZhuang/CircleImageView/issues/1/events
class IssueDetailPage
    extends BaseStatelessWidget<LoadingBean<IssueDetailBean>, IssueDetailBloc> {
  final List<_Reaction> _reactionList = [
    _Reaction('1f44d', '+1'),
    _Reaction('1f44e', '-1'),
    _Reaction('1f389', 'hooray'),
    _Reaction('1f440', 'eyes'),
    _Reaction('1f604', 'laugh'),
    _Reaction('1f615', 'confused'),
    _Reaction('1f680', 'rocket'),
    _Reaction('2764', 'heart')
  ];

  final List<String> _commentList = [
    '编辑',
    '删除',
  ];

  @override
  PageType getPageType() => PageType.issue_detail;

  @override
  String getTitle(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return bloc.getTitle();
  }

  @override
  bool isShowAppBarActions() => true;

  @override
  void openWebView(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    NavigatorUtil.goWebView(context, bloc.getTitle(), bloc.issueBean.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return bloc.issueBean.htmlUrl;
  }

  @override
  bool isLoading(LoadingBean<IssueDetailBean> data) =>
      data != null ? data.isLoading : true;

  @override
  Widget getHeader(BuildContext context, LoadingBean<IssueDetailBean> data) {
    if (data == null || data.data == null || data.data.issueBean == null) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _postHeadCard(context, data.data.issueBean, true),
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
  Widget buildItemBuilder(BuildContext context,
      LoadingBean<IssueDetailBean> data, int index) {
    IssueBean model = data.data.comments[index];
    return _getItemRow(context, model, false);
  }

  Widget _getItemRow(BuildContext context, IssueBean item, bool isIssue) {
    if (isIssue) {
      return _postHeadItem(context, item, isIssue);
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: _postItemCard(context, item, isIssue),
      );
    }
  }

  Widget _postHeadCard(BuildContext context, IssueBean item, bool isIssue) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                _buildLabel(item.state),
                Expanded(
                  child: Container(),
                ),
                Text('#${item.number}')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item.title,
              style: YZConstant.largeTextBold,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          _getItemRow(context, item, true),
        ],
      ),
    );
  }

  Widget _buildLabel(String state) {
    return Container(
      width: 56,
      height: 30,
      decoration: BoxDecoration(
        gradient: BUTTON_BACKGROUND,
        borderRadius: BorderRadius.circular(28.0),
      ),
      child: Center(
        child: Text(
          state,
          style: YZConstant.smallTextWhite,
        ),
      ),
    );
  }

  Widget _postHeadItem(BuildContext context, IssueBean item, bool isIssue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: _profileColumn(context, item, isIssue),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: MarkdownWidget(
            markdownData: item.body,
          ),
        ),
        _reactionColumn(context, item, isIssue),
      ],
    );
  }

  Widget _postItemCard(BuildContext context, IssueBean item, bool isIssue) {
    return Card(
      elevation: 2.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _profileColumn(context, item, isIssue),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MarkdownWidget(
              markdownData: item.body,
            ),
          ),
          _reactionColumn(context, item, isIssue),
        ],
      ),
    );
  }

  Widget _profileColumn(BuildContext context, IssueBean item, bool isIssue) {
    List<Widget> profileList = [];
    profileList.add(_buildAvatar(item));
    profileList.add(_buildNameAndDate(item));
    profileList.add(_buildReactionMenu(context, item, isIssue));
    profileList.add(
      SizedBox(
        width: 10.0,
      ),
    );

    Widget lastMenu = _buildLastMenu(context, item, isIssue);
    if (lastMenu != null) {
      profileList.add(lastMenu);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: profileList,
    );
  }

  Widget _buildAvatar(IssueBean item) {
    return ImageUtil.getCircleNetworkImage(
        item.user.avatarUrl, 36.0, ImagePath.image_default_head);
  }

  Widget _buildNameAndDate(IssueBean item) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.user.login,
              style: YZConstant.smallText,
            ),
            Text(
              DateUtil.getMultiDateStr(item.createdAt),
              style: YZConstant.smallSubText,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildReactionMenu(BuildContext context, IssueBean item, isIssue) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return PopupMenuButton<String>(
      onSelected: (text) {
        bloc.editReactions(item, text, isIssue);
      },
      child: ImageUtil.getImage(
          ImagePath.image_comment_face, NORMAL_IMAGE_SIZE, NORMAL_IMAGE_SIZE),
      itemBuilder: (BuildContext context) =>
          _reactionList
              .map(
                (_Reaction reaction) =>
                PopupMenuItem<String>(
                  value: reaction.type,
                  child: ImageUtil.getImage(
                      'assets/images/comment/${reaction.img}.png',
                      NORMAL_IMAGE_SIZE,
                      NORMAL_IMAGE_SIZE),
                ),
          )
              .toList(),
    );
  }

  Widget _buildLastMenu(BuildContext context, IssueBean item, isIssue) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    if (bloc.isEditAndDeleteEnable(item)) {
      if (isIssue) {
        return _buildEditAction(context);
      } else {
        return _buildCommentMenu(context, item);
      }
    }
    return null;
  }

  Widget _buildEditAction(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return InkWell(
      child: ImageUtil.getImage(
          ImagePath.image_comment_edit, NORMAL_IMAGE_SIZE, NORMAL_IMAGE_SIZE),
      onTap: () {
        bloc.goEditIssue(context);
      },
    );
  }

  Widget _buildCommentMenu(BuildContext context, IssueBean item) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);

    return PopupMenuButton<String>(
      onSelected: (text) {
        if (text == _commentList[0]) {
          bloc.enterCommentEditor(context, item, false);
        } else {
          bloc.deleteIssueComment(item);
        }
      },
      child: ImageUtil.getImage(
          ImagePath.image_comment_menu, NORMAL_IMAGE_SIZE, NORMAL_IMAGE_SIZE),
      itemBuilder: (BuildContext context) =>
          _commentList
              .map(
                (String text) =>
                PopupMenuItem<String>(
                  value: text,
                  child: Text(text),
                ),
          )
              .toList(),
    );
  }

  Widget _reactionColumn(BuildContext context, IssueBean item, isIssue) {
    if (item == null || item.reaction == null) {
      return Container();
    }
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);

    List<Widget> reactionWidget = List();
    if (item.reaction.like > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.like.toString(),
        image: ImagePath.image_comment_like,
        onPressed: () {
          bloc.goDeleteReaction(context, item, '+1', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.noLike > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.noLike.toString(),
        image: ImagePath.image_comment_no_like,
        onPressed: () {
          bloc.goDeleteReaction(context, item, '-1', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.laugh > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.laugh.toString(),
        image: ImagePath.image_comment_laugh,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'laugh', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.hooray > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.hooray.toString(),
        image: ImagePath.image_comment_hooray,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'hooray', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.confused > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.confused.toString(),
        image: ImagePath.image_comment_confused,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'confused', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.heart > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.heart.toString(),
        image: ImagePath.image_comment_heart,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'heart', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.rocket > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.rocket.toString(),
        image: ImagePath.image_comment_rocket,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'rocket', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    if (item.reaction.eyes > 0) {
      Widget widget = LabelIcon(
        label: item.reaction.eyes.toString(),
        image: ImagePath.image_comment_eyes,
        onPressed: () {
          bloc.goDeleteReaction(context, item, 'eyes', isIssue);
        },
      );
      reactionWidget.add(widget);
    }

    return Container(
      constraints: BoxConstraints.expand(height: SizeUtil.getAxisY(56)),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: reactionWidget,
      ),
    );
  }

  @override
  Widget buildFloatingActionButton(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    if (bloc.issueBean == null) {
      return null;
    }
    return new FloatingActionButton(
      onPressed: () {
        bloc.enterCommentEditor(context, bloc.issueBean, true);
      },
      backgroundColor: Colors.black,
      tooltip: 'add comment',
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }
}

class _Reaction {
  final String img;
  final String type;

  _Reaction(this.img, this.type);
}
