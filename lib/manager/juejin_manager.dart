import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';
import 'package:flutter_common_util/flutter_common_util.dart';

class JueJinManager {
  factory JueJinManager() => _getInstance();

  static JueJinManager get instance => _getInstance();
  static JueJinManager _instance;

  JueJinManager._internal();

  static JueJinManager _getInstance() {
    if (_instance == null) {
      _instance = new JueJinManager._internal();
    }
    return _instance;
  }

  Future<List<Entrylist>> getJueJinList(int page) async {
    final response = await HttpRequest().get(Api.getJueJinApi(page));
    if (response != null && response.result) {
      if (response.data != null) {
        juejin_bean bean = juejin_bean.fromJson(response.data);
        if (bean != null && bean.d != null) {
          return bean.d.entrylist;
        }
      }
      return [];
    }
    return null;
  }
}
