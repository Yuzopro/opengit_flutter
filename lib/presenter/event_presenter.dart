import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/contract/event_contract.dart';
import 'package:open_git/manager/event_manager.dart';

class EventPresenter extends IEventPresenter {
  @override
  getEvent(userName, page, isFromMore) {
    return EventManager.instance.getEvent(userName, page, (data) {
      if (data != null && data.length > 0) {
        List<EventBean> list = new List();
        for (int i = 0; i < data.length; i++) {
          var dataItem = data[i];
          list.add(EventBean.fromJson(dataItem));
        }
        if (view != null) {
          view.setList(list, isFromMore);
        }
      }
    }, (code, msg) {});
  }

  @override
  getEventReceived(userName, page, isFromMore) {
    return EventManager.instance.getEventReceived(userName, page, (data) {
      if (data != null && data.length > 0) {
        List<EventBean> list = new List();
        for (int i = 0; i < data.length; i++) {
          var dataItem = data[i];
          list.add(EventBean.fromJson(dataItem));
        }
        print(list.length);
        if (view != null) {
          view.setList(list, isFromMore);
        }
      }
    }, (code, msg) {});
  }
}
