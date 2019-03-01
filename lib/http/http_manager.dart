import 'dart:collection';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:open_git/manager/login_manager.dart';

class HttpManager {
  static const _GET = "GET";
  static const _POST = "POST";

  static doGet(url, Function successCallback, Function errorCallback) {
    return _doRequest(url, null, successCallback, errorCallback,
        new Options(method: _GET));
  }

  static doPost(url, params, Function successCallback, Function errorCallback) {
    return _doRequest(url, params, successCallback, errorCallback,
        new Options(method: _POST));
  }

  static void _doRequest(url, params, Function successCallback,
      Function errorCallback, Options options) async {
    print("[HttpRequest] url is " + url);
    //检查网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (errorCallback != null) {
        errorCallback(HttpStatus.badGateway, "无网络");
      }
      return;
    }
    //封装网络请求头
    Map<String, String> headers = _getHeaders();
    if (options != null) {
      options.headers = headers;
    } else {
      options = new Options(method: _GET);
      options.headers = headers;
    }
    options.contentType = ContentType.parse("application/json");

    //设置请求超时时间
    options.connectTimeout = 15 * 1000;

    Dio dio = new Dio();
    //证书认证
    dio.onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return true;
      };
    };

    //开始请求
    Response response;
    try {
      //因为contenttype是application/json，不用在进行json转换
      response = await dio.request(url, data: params, options: options);
    } on DioError catch (e) {
      if (e.response != null) {
        response = e.response;
      } else {
        print(e.message);
      }
    }

    //处理返回结果
    if (response != null) {
      print("[HttpRequest] response is " +
          response.toString() +
          "@statusCode is " +
          response.statusCode.toString());
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        if (successCallback != null) {
          successCallback(response.data);
        }
      } else {
        if (errorCallback != null) {
          errorCallback(response.statusCode, response.data["message"]);
        }
      }
    }
  }

  static _getHeaders() {
    Map<String, String> headers = new HashMap();
    headers["Authorization"] = LoginManager.instance.getToken();
    return headers;
  }
}
