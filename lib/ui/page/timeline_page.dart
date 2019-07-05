import 'package:flutter/material.dart';
import 'package:open_git/ui/base/base_list_stateless_widget.dart';
import 'package:open_git/bean/release_bean.dart';
import 'package:open_git/bloc/timeline_bloc.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/route/navigator_util.dart';
import 'package:open_git/status/status.dart';
import 'package:open_git/util/date_util.dart';

class TimelinePage extends BaseListStatelessWidget<ReleaseBean, TimelineBloc> {
  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).currentlocal.timeline;
  }

  @override
  Widget builderItem(BuildContext context, ReleaseBean item) {
    return ListTile(
      title: new Text(item.name),
      subtitle: new Text(DateUtil.getNewsTimeStr(item.createdAt)),
      onTap: () {
        NavigatorUtil.goTimelineDetail(context, item.name, item.body);
      },
    );
  }

  @override
  ListPageType getListPageType() {
    return ListPageType.timeline;
  }
}

//class TimelinePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, TimelineViewModel>(
//      distinct: true,
//      onInit: (store) => store.dispatch(FetchAction(ListPageType.timeline)),
//      converter: (store) => TimelineViewModel.fromStore(store),
//      builder: (_, viewModel) => TimelinePageContent(viewModel),
//    );
//  }
//}
//
//class TimelinePageContent extends StatelessWidget {
//  static final String TAG = "TimelinePageContent";
//
//  TimelinePageContent(this.viewModel);
//
//  final TimelineViewModel viewModel;
//
//  @override
//  Widget build(BuildContext context) {
//    LogUtil.v('build', tag: TAG);
//
//    return new YZPullRefreshList(
//      title: AppLocalizations.of(context).currentlocal.timeline,
//      status: viewModel.status,
//      refreshStatus: viewModel.refreshStatus,
//      itemCount: viewModel.releases == null ? 0 : viewModel.releases.length,
////      controller: controller,
//      onRefreshCallback: viewModel.onRefresh,
//      onLoadCallback: viewModel.onLoad,
//      itemBuilder: (context, index) {
//        return _buildItem(context, viewModel.releases[index]);
//      },
//    );
//  }
//
//  Widget _buildItem(BuildContext context, ReleaseBean item) {
//    return ListTile(
//      title: new Text(item.name),
//      subtitle: new Text(DateUtil.getNewsTimeStr(item.createdAt)),
//      onTap: () {
//        NavigatorUtil.goTimelineDetail(context, item.name, item.body);
//      },
//    );
//  }
//}
//
//class TimelineViewModel {
//  final LoadingStatus status;
//  final RefreshStatus refreshStatus;
//  final List<ReleaseBean> releases;
//  final Function onRefresh;
//  final Function onLoad;
//
//  TimelineViewModel(
//      {@required this.status,
//        @required this.refreshStatus,
//        @required this.releases,
//        @required this.onRefresh,
//        @required this.onLoad});
//
//  static TimelineViewModel fromStore(Store<AppState> store) {
//    return TimelineViewModel(
//      status: store.state.timelineState.status,
//      refreshStatus: store.state.timelineState.refreshStatus,
//      releases: store.state.timelineState.releases,
//      onRefresh: () {
//        store.dispatch(
//            RefreshAction(RefreshStatus.refresh, ListPageType.timeline));
//      },
//      onLoad: () {
//        store.dispatch(
//            RefreshAction(RefreshStatus.loading, ListPageType.timeline));
//      },
//    );
//  }
//}
