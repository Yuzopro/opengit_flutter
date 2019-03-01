class Api {
  static const String _BASE_URL = "https://api.github.com/";

  static String authorizations() {
    return "${_BASE_URL}authorizations";
  }

  ///我的用户信息 GET
  static getMyUserInfo() {
    return "${_BASE_URL}user";
  }
}