import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/user_bean.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/profile/follow_actions.dart';
import 'package:open_git/ui/profile/follow_page_view_model.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/image_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FollowPage extends StatelessWidget {
  final ListPageType type;

  const FollowPage(this.type);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, FollowPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchFollowsAction(type)),
      converter: (store) => FollowPageViewModel.fromStore(store, type),
      builder: (_, viewModel) => FollowPageContent(viewModel),
    );
  }

}

//class FollowPageState extends State<FollowPage> {
//  RefreshController controller;
//
//  @override
//  void initState() {
//    super.initState();
//    controller = new RefreshController();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, FollowPageViewModel>(
//      distinct: true,
//      onInit: (store) => store.dispatch(FetchFollowsAction(widget.type)),
//      converter: (store) => FollowPageViewModel.fromStore(store, widget.type),
//      builder: (_, viewModel) => FollowPageContent(viewModel, controller),
//    );
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    if (controller != null) {
//      controller.dispose();
//      controller = null;
//    }
//  }
//}

class FollowPageContent extends StatelessWidget {
  static final String TAG = "FollowPageContent";

  FollowPageContent(this.viewModel);

  final FollowPageViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.users == null ? 0 : viewModel.users.length,
//      controller: controller,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.users[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, UserBean item) {
    return ListTile(
      leading: ImageUtil.getImageWidget(item.avatarUrl, 36.0),
      title: Text(item.login),
    );
  }
}
