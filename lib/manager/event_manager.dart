import 'package:open_git/bean/event_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';

class EventManager {
  factory EventManager() => _getInstance();

  static EventManager get instance => _getInstance();
  static EventManager _instance;

  EventManager._internal();

  static EventManager _getInstance() {
    if (_instance == null) {
      _instance = new EventManager._internal();
    }
    return _instance;
  }

  getEventReceived(userName, page) async {
    String url = Api.getEventReceived(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<EventBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(EventBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getEvent(userName, page) async {
    String url = Api.getEvent(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<EventBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(EventBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }

  getOrgEvent(userName, page) async {
    String url = Api.getOrgEvent(userName) + Api.getPageParams("&", page);
    final response = await HttpRequest().get(url);
    if (response != null && response.result) {
      List<EventBean> list = new List();
      if (response.data != null && response.data.length > 0) {
        for (int i = 0; i < response.data.length; i++) {
          var dataItem = response.data[i];
          list.add(EventBean.fromJson(dataItem));
        }
      }
      return list;
    }
    return null;
  }
}
