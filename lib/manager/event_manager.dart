import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class EventManager {
  factory EventManager() => _getInstance();

  static EventManager get instance => _getInstance();
  static EventManager _instance;

  EventManager._internal() {}

  static EventManager _getInstance() {
    if (_instance == null) {
      _instance = new EventManager._internal();
    }
    return _instance;
  }

  getEventReceived(
      userName, page, Function successCallback, Function errorCallback) {
    String url = Api.getEventReceived(userName) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }

  getEvent(userName, page, Function successCallback, Function errorCallback) {
    String url = Api.getEvent(userName) + Api.getPageParams("&", page);
    return HttpManager.doGet(url, null, successCallback, errorCallback);
  }
}
