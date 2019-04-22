import 'package:open_git/contract/event_contract.dart';
import 'package:open_git/manager/event_manager.dart';

class EventPresenter extends IEventPresenter {
  @override
  getEvent(userName, page, isFromMore) async {
    final response = await EventManager.instance.getEvent(userName, page);
    if (response != null && view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }

  @override
  getEventReceived(userName, page, isFromMore) async {
    final response =
        await EventManager.instance.getEventReceived(userName, page);
    if (response != null && view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }
}
