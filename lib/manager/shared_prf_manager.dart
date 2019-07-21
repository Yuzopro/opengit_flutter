import 'package:shared_preferences/shared_preferences.dart';

class SharedPrfManager {
  factory SharedPrfManager() => _getInstance();

  static SharedPrfManager get instance => _getInstance();
  static SharedPrfManager _instance;

  SharedPrfManager._internal();

  static SharedPreferences _prefs;

  static SharedPrfManager _getInstance() {
    if (_instance == null) {
      _instance = new SharedPrfManager._internal();
    }
    return _instance;
  }

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  saveInt(String key, value) {
    _prefs.setInt(key, value);
  }

  saveString(String key, value) {
    _prefs.setString(key, value);
  }

  saveList(String key, List<String> value) {
    _prefs.setStringList(key, value);
  }

  get(String key) {
    return _prefs.get(key);
  }

  remove(String key) {
    _prefs.remove(key);
  }
}
