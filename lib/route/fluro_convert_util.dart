import 'dart:convert';

class FluroConvertUtil {
  static String encode(String originalCn) {
    return Uri.encodeComponent(originalCn);
  }

  static String fluroCnParamsEncode(String originalCn) {
    return jsonEncode(Utf8Encoder().convert(originalCn));
  }

  static String fluroCnParamsDecode(String encodeCn) {
    var list = List<int>();

    ///字符串解码
    jsonDecode(encodeCn).forEach(list.add);
    String value = Utf8Decoder().convert(list);
    return value;
  }

  static String object2String<T>(T t) {
    return fluroCnParamsEncode(jsonEncode(t));
  }

  static Map<String, dynamic> string2Map(String str) {
    return json.decode(fluroCnParamsDecode(str));
  }
}
