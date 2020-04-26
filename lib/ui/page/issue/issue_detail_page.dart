import 'package:flutter/material.dart';
import 'package:flutter_base_ui/bloc/base_stateless_widget.dart';
import 'package:flutter_base_ui/bloc/bloc_provider.dart';
import 'package:flutter_base_ui/bloc/loading_bean.dart';
import 'package:flutter_base_ui/flutter_base_ui.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/issue_bean.dart';
import 'package:open_git/bean/issue_detail_bean.dart';
import 'package:open_git/bean/label_bean.dart';
import 'package:open_git/bloc/issue_detail_bloc.dart';
import 'package:open_git/common/gradient_const.dart';
import 'package:open_git/common/image_path.dart';
import 'package:open_git/manager/user_manager.dart';
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
  String getTitle(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return bloc.getTitle();
  }

  @override
  bool isShowAppBarActions() => true;

  @override
  void openWebView(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    NavigatorUtil.goWebView(
        context, bloc.getTitle(), bloc.bean.data?.issueBean?.htmlUrl);
  }

  @override
  String getShareText(BuildContext context) {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    return bloc.bean.data?.issueBean?.htmlUrl;
  }

  @override
  bool isLoading(LoadingBean<IssueDetailBean> data) =>
      data != null ? data.isLoading : true;

  @override
  bool isShowEmpty(LoadingBean<IssueDetailBean> data) {
    return data == null || data.data == null || data.data.issueBean == null;
  }

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
  Widget buildItemBuilder(
      BuildContext context, LoadingBean<IssueDetailBean> data, int index) {
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
                _buildState(item.state),
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
              style: YZStyle.largeTextBold,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          _getItemRow(context, item, true),
          _buildLabel(item),
        ],
      ),
    );
  }

  Widget _buildState(String state) {
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
          style: YZStyle.smallTextWhite,
        ),
      ),
    );
  }

  Widget _postHeadItem(BuildContext context, IssueBean item, bool isIssue) {
    List<Widget> _reactions = [];

    _reactions.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: _profileColumn(context, item, isIssue),
    ));

    _reactions.add(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: MarkdownWidget(
        markdownData: item.body,
      ),
    ));

    if (item != null && item.reaction != null) {
      _reactions.add(_reactionColumn(context, item, isIssue));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _reactions,
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
        item.user.avatar_url, 36.0, ImagePath.image_default_head);
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
              style: YZStyle.smallText,
            ),
            Text(
              DateUtil.getMultiDateStr(item.createdAt),
              style: YZStyle.smallSubText,
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
      child: ImageUtil.getImage(ImagePath.image_comment_face,
          YZSize.NORMAL_IMAGE_SIZE, YZSize.NORMAL_IMAGE_SIZE),
      itemBuilder: (BuildContext context) => _reactionList
          .map(
            (_Reaction reaction) => PopupMenuItem<String>(
              value: reaction.type,
              child: ImageUtil.getImage(
                  'assets/images/comment/${reaction.img}.png',
                  YZSize.NORMAL_IMAGE_SIZE,
                  YZSize.NORMAL_IMAGE_SIZE),
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
      child: ImageUtil.getImage(ImagePath.image_comment_edit,
          YZSize.NORMAL_IMAGE_SIZE, YZSize.NORMAL_IMAGE_SIZE),
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
      child: ImageUtil.getImage(ImagePath.image_comment_menu,
          YZSize.NORMAL_IMAGE_SIZE, YZSize.NORMAL_IMAGE_SIZE),
      itemBuilder: (BuildContext context) => _commentList
          .map(
            (String text) => PopupMenuItem<String>(
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
    if (bloc.bean.data.issueBean == null) {
      return null;
    }
    return new FloatingActionButton(
      onPressed: () {
        bloc.enterCommentEditor(context, bloc.bean.data.issueBean, true);
      },
      backgroundColor: Colors.black,
      tooltip: 'add comment',
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  List<Widget> getAction(BuildContext context) {
    if (!isShowAppBarActions()) {
      return null;
    }

    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    String authorName = bloc.getRepoAuthorName();
    if (UserManager.instance.isYou(authorName)) {
      return [
        PopupMenuButton(
          padding: const EdgeInsets.all(0.0),
          onSelected: (value) {
            onPopSelected(context, value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            getPopupMenuItem('browser', Icons.language, '浏览器打开'),
            getPopupMenuItem('share', Icons.share, '分享'),
            getPopupMenuItem('label', Icons.label, '标签'),
          ],
        )
      ];
    } else {
      return super.getAction(context);
    }
  }

  void onPopSelected(BuildContext context, String value) async {
    IssueDetailBloc bloc = BlocProvider.of<IssueDetailBloc>(context);
    switch (value) {
      case "label":
        String repoUrl = bloc.url;
        LogUtil.v(repoUrl);
        String title = (repoUrl.isNotEmpty && repoUrl.contains("/"))
            ? repoUrl.substring(repoUrl.lastIndexOf("/") + 1)
            : "";
        await NavigatorUtil.goLabel(
            context, title, bloc.bean.data?.issueBean?.labels, bloc.num);
        bloc.updateLabels();
        break;
      default:
        super.onPopSelected(context, value);
        break;
    }
  }

  Widget _buildLabel(IssueBean item) {
    final List<Widget> chips = item?.labels.map<Widget>((Labels labels) {
      return Chip(
        key: ValueKey<Labels>(labels),
        backgroundColor: ColorUtil.str2Color(labels.color),
        label: Text(labels.name),
      );
    }).toList();

    return Wrap(
        children: chips.map<Widget>((Widget chip) {
      return Padding(
        padding: const EdgeInsets.all(2.0),
        child: chip,
      );
    }).toList());
  }
}

class _Reaction {
  final String img;
  final String type;

  _Reaction(this.img, this.type);
}
