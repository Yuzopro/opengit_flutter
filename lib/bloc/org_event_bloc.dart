import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/manager/event_manager.dart';

class OrgEventBloc extends EventBloc {
  OrgEventBloc(String name) : super(name);

  @override
  fetchEvent(int page) async {
    return await EventManager.instance.getOrgEvent(userName, page);
  }

  @override
  PageType getPageType() => PageType.org_event;
}
