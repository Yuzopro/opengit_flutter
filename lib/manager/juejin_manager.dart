import 'package:open_git/bean/juejin_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_manager.dart';

class JueJinManager {
  factory JueJinManager() => _getInstance();

  static JueJinManager get instance => _getInstance();
  static JueJinManager _instance;

  JueJinManager._internal() {}

  static JueJinManager _getInstance() {
    if (_instance == null) {
      _instance = new JueJinManager._internal();
    }
    return _instance;
  }

  Future<List<Entrylist>> getJueJinList(int page) async {
    final response = await HttpManager.doGet(Api.getJueJinApi(page), null);
    if (response != null && response.data != null) {
      juejin_bean bean = juejin_bean.fromJson(response.data);
      if (bean != null && bean.d != null) {
        return bean.d.entrylist;
      }
    }
    return null;
  }
}