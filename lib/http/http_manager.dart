import 'dart:collection';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:open_git/http/response_result_data.dart';
import 'package:open_git/manager/login_manager.dart';

class HttpManager {
  static const _GET = "GET";
  static const _POST = "POST";
  static const _PUT = "PUT";
  static const _DELETE = "DELETE";
  static const _PATCH = "patch";

  static doGet(url, Map<String, String> header) {
    return _doRequest(url, null, header, new Options(method: _GET));
  }

  static doPut(url) {
    return _doRequest(url, null, null, new Options(method: _PUT));
  }

  static doDelete(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, new Options(method: _DELETE));
  }

  static doPatch(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, new Options(method: _PATCH));
  }

  static doPost(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, new Options(method: _POST));
  }

  static _doRequest(
      url, params, Map<String, String> header, Options options) async {
//    debugPrint("[HttpRequest] url is " + url);
    //检查网络
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return new ResponseResultData(null, false, -1);
    }
    //封装网络请求头
    Map<String, String> headers = _getHeaders(header);
    if (options != null) {
      options.headers = headers;
    } else {
      options = new Options(method: _GET);
      options.headers = headers;
    }
    options.contentType = ContentType.parse("application/json");

    //设置请求超时时间
    options.connectTimeout = 15 * 1000;

    Dio _dio = new Dio();
    //开始请求
    Response response;
    try {
      //因为contenttype是application/json，不用在进行json转换
      response = await _dio.request(url, data: params, options: options);
//      debugPrint("[HttpRequest] response is " +
//          response.toString() +
//          "@statusCode is " +
//          response.statusCode.toString());
      if (response.statusCode >= HttpStatus.ok &&
          response.statusCode < HttpStatus.multipleChoices) {
        return new ResponseResultData(response.data, true, response.statusCode);
      } else {
        return new ResponseResultData(
            response.data["message"], false, response.statusCode);
      }
    } on DioError catch (e) {
      print(e);
      return new ResponseResultData(null, false, -2);
    }
  }

  static _getHeaders(Map<String, String> header) {
    Map<String, String> headers = new HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    headers["Authorization"] = LoginManager.instance.getToken();
    return headers;
  }

  static download(url, savePath, progress) async {
    try {
      Dio _dio = new Dio();
      Response response =
          await _dio.download(url, savePath, onReceiveProgress: progress);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}
