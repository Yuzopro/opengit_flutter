import 'dart:convert';

import 'package:flutter_common_util/flutter_common_util.dart';

class FluroUtil {
  static String encode(String text) {
    return jsonEncode(Utf8Encoder().convert(text));
  }

  static String decode(String text) {
    if (TextUtil.isEmpty(text)) {
      return null;
    }
    var list = List<int>();
    jsonDecode(text).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  static String object2String<T>(T t) {
    return encode(jsonEncode(t));
  }

  static Map<String, dynamic> string2Map(String text) {
    return json.decode(decode(text));
  }

  static bool string2Bool(String text) {
    if (decode(text) == 'true') {
      return true;
    } else {
      return false;
    }
  }
}
