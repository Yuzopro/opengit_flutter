import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:open_git/localizations/app_localizations.dart';
import 'package:open_git/redux/app_state.dart';
import 'package:open_git/redux/event/event_actions.dart';
import 'package:open_git/ui/event/event_page.dart';
import 'package:open_git/ui/event/event_page_view_model.dart';
import 'package:open_git/ui/status/list_page_type.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReposEventPage extends StatelessWidget {
  final String reposOwner;
  final String reposName;

  ReposEventPage(this.reposOwner, this.reposName);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, EventPageViewModel>(
      distinct: true,
      onInit: (store) => store.dispatch(FetchReposEventAction(
          reposOwner, reposName, ListPageType.repos_event)),
      converter: (store) => EventPageViewModel.fromStore(
          store, ListPageType.repos_event, reposOwner, reposName),
      builder: (_, viewModel) => EventPageContent(
            viewModel,
            title: AppLocalizations.of(context).currentlocal.event,
          ),
    );
  }
}

//class ReposPageState extends State<ReposEventPage> {
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
//    return StoreConnector<AppState, EventPageViewModel>(
//      distinct: true,
//      onInit: (store) => store.dispatch(FetchReposEventAction(
//          widget.reposOwner, widget.reposName, ListPageType.repos_event)),
//      converter: (store) => EventPageViewModel.fromStore(
//          store, ListPageType.repos_event, widget.reposOwner, widget.reposName),
//      builder: (_, viewModel) => EventPageContent(
//            viewModel,
//            controller,
//            title: AppLocalizations.of(context).currentlocal.event,
//          ),
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
