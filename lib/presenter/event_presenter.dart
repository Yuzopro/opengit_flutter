import 'package:open_git/contract/event_contract.dart';
import 'package:open_git/manager/event_manager.dart';

class EventPresenter extends IEventPresenter {
  @override
  getEvent(userName, page, isFromMore) async {
//    return EventManager.instance.getEvent(userName, page, (data) {
//      if (data != null && data.length > 0) {
//        List<EventBean> list = new List();
//        for (int i = 0; i < data.length; i++) {
//          var dataItem = data[i];
//          list.add(EventBean.fromJson(dataItem));
//        }
//        if (view != null) {
//          view.setList(list, isFromMore);
//        }
//      }
//    }, (code, msg) {});
    final response = await EventManager.instance.getEvent(userName, page);
    if (response != null && view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }

  @override
  getEventReceived(userName, page, isFromMore) async {
//    return EventManager.instance.getEventReceived(userName, page, (data) {
//      if (data != null && data.length > 0) {
//        List<EventBean> list = new List();
//        for (int i = 0; i < data.length; i++) {
//          var dataItem = data[i];
//          list.add(EventBean.fromJson(dataItem));
//        }
//        if (view != null) {
//          view.setList(list, isFromMore);
//        }
//      }
//    }, (code, msg) {});
    final response =
        await EventManager.instance.getEventReceived(userName, page);
    if (response != null && view != null) {
      view.setList(response, isFromMore);
    }
    return response;
  }
}
