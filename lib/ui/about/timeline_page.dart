import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/common_actions.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/ui/about/timeline_page_view_model.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:open_git/ui/widget/yz_pull_refresh_list.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/log_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TimelinePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TimelineViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchAction(ListPageType.timeline)),
      converter: (store) => TimelineViewModel.fromStore(store),
      builder: (_, viewModel) => TimelinePageContent(viewModel),
    );
  }
}

//class TimelinePageState extends State<TimelinePage> {
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
//    return StoreConnector<AppState, TimelineViewModel>(
//      distinct: true,
//      onInit: (store) => store.dispatch(FetchAction(ListPageType.timeline)),
//      converter: (store) => TimelineViewModel.fromStore(store),
//      builder: (_, viewModel) => TimelinePageContent(viewModel, controller),
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
//
//  @override
//  bool get wantKeepAlive => true;
//}

class TimelinePageContent extends StatelessWidget {
  static final String TAG = "TimelinePageContent";

  TimelinePageContent(this.viewModel);

  final TimelineViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    LogUtil.v('build', tag: TAG);

    return new YZPullRefreshList(
      title: AppLocalizations.of(context).currentlocal.timeline,
      status: viewModel.status,
      refreshStatus: viewModel.refreshStatus,
      itemCount: viewModel.releases == null ? 0 : viewModel.releases.length,
//      controller: controller,
      onRefreshCallback: viewModel.onRefresh,
      onLoadCallback: viewModel.onLoad,
      itemBuilder: (context, index) {
        return _buildItem(context, viewModel.releases[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, ReleaseBean item) {
    return ListTile(
      title: new Text(item.name),
      subtitle: new Text(DateUtil.getNewsTimeStr(item.createdAt)),
      onTap: () {
        NavigatorUtil.goTimelineDetail(context, item.name, item.body);
      },
    );
  }
}
