import 'package:open_git/base/base_presenter.dart';
import 'package:open_git/base/i_base_pull_list_view.dart';
import 'package:open_git/bean/user_bean.dart';

abstract class IUserFollowPresenter<V extends IUserFollowView>
    extends BasePresenter<V> {
  getUserFollow(String userName, int page, bool isFollower, bool isFromMore);
}

abstract class IUserFollowView extends IBasePullListView<UserBean> {}
