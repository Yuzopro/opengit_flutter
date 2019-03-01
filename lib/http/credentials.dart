import 'dart:convert';

class Credentials {
  static String basic(String userName, String password) {
    String usernameAndPassword = userName + ":" + password;
    var base64Encode = base64.encode(utf8.encode(usernameAndPassword));
    return "Basic " + base64Encode;
  }
}
