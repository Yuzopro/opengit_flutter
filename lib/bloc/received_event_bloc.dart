import 'package:flutter_base_ui/bloc/page_type.dart';
import 'package:open_git/bloc/event_bloc.dart';
import 'package:open_git/manager/event_manager.dart';

class ReceivedEventBloc extends EventBloc {
  ReceivedEventBloc(String userName) : super(userName);

  @override
  PageType getPageType() => PageType.received_event;

  @override
  fetchEvent(int page) async {
    return await EventManager.instance.getEventReceived(userName, page);
  }
}
