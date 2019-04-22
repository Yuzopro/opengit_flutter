import 'package:flutter/material.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/contract/user_follow_contract.dart';
import 'package:open_git/presenter/user_follow_presenter.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/widget/pull_refresh_list.dart';

class UserFollowPage extends StatefulWidget {
  bool isFollower;
  final UserBean userBean;

  UserFollowPage(this.userBean, this.isFollower);

  @override
  State<StatefulWidget> createState() {
    return _UserFollowState(userBean, isFollower);
  }
}

class _UserFollowState extends PullRefreshListState<UserFollowPage, UserBean,
        UserFollowPresenter, IUserFollowView>
    with AutomaticKeepAliveClientMixin
    implements IUserFollowView {
  bool isFollower;
  final UserBean userBean;

  String _userName;

  _UserFollowState(this.userBean, this.isFollower);

  @override
  void initState() {
    super.initState();
    if (userBean != null) {
      print(userBean.toString());
      _userName = userBean.login ?? "";
    }
  }

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    super.build(context);
    return new Scaffold(
      body: buildBody(context),
    );
  }

  @override
  Widget getItemRow(UserBean item) {
    return ListTile(
      leading: ImageUtil.getImageWidget(item.avatarUrl, 36.0),
      title: Text(item.login),
    );
  }

  @override
  getMoreData() {
    if (presenter != null) {
      page++;
      presenter.getUserFollow(_userName, page, isFollower, true);
    }
  }

  @override
  UserFollowPresenter initPresenter() {
    return new UserFollowPresenter();
  }

  @override
  Future<Null> onRefresh() async {
    if (presenter != null) {
      page = 1;
      await presenter.getUserFollow(_userName, page, isFollower, false);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
