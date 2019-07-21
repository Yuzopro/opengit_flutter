import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/http/response_result_data.dart';
import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/util/date_util.dart';
import 'package:open_git/util/log_util.dart';

class HttpManager {
  static final String TAG = "HttpManager";

  static const _GET = "GET";
  static const _POST = "POST";
  static const _PUT = "PUT";
  static const _DELETE = "DELETE";
  static const _PATCH = "patch";

  static doGet(url, Map<String, String> header, {bool isText: false}) {
    return _doRequest(url, null, header, Options(method: _GET), isText: isText);
  }

  static doPut(url) {
    return _doRequest(url, null, null, Options(method: _PUT));
  }

  static doDelete(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, Options(method: _DELETE));
  }

  static doPatch(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, Options(method: _PATCH));
  }

  static doPost(url, params, Map<String, String> header) {
    return _doRequest(url, params, header, Options(method: _POST));
  }

  static _doRequest(url, params, Map<String, String> header, Options options,
      {bool isText: false}) async {
    LogUtil.v(url, tag: TAG);

    CacheProvider provider = CacheProvider();
    var result = await provider.query(url);
    if (result != null) {
      var data = jsonDecode(result.data);
      DateTime dateTime = DateTime.parse(result.dateTime);
      int subTime = DateTime.now().millisecondsSinceEpoch -
          dateTime.millisecondsSinceEpoch;
      if (subTime <= DateUtil.SECONDS_LIMIT) {
        LogUtil.v('load data from cache, date is ' + result.dateTime, tag: TAG);
        return ResponseResultData(
          data,
          true,
          200,
        );
      }
    }
    return await _doNext(url, params, header, options, provider,
        isText: isText);
  }

  static _doNext(url, params, Map<String, String> header, Options options,
      CacheProvider provider,
      {bool isText: false}) async {
    //检查网络
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return ResponseResultData(
        null,
        false,
        -1,
      );
    }
    //封装网络请求头
    Map<String, String> headers = _getHeaders(header);
    if (options != null) {
      options.headers = headers;
    } else {
      options = Options(method: _GET);
      options.headers = headers;
    }
    options.contentType = isText ? ContentType.text : ContentType.json;

    //设置请求超时时间
    options.connectTimeout = 15 * 1000;

    Dio _dio = Dio();
    //开始请求
    Response response;
    try {
      //因为contenttype是application/json，不用在进行json转换
      response = await _dio.request(url, data: params, options: options);

      if (response.statusCode >= HttpStatus.ok &&
          response.statusCode < HttpStatus.multipleChoices) {
        LogUtil.v(
            'load data from network is ok, date is ' +
                DateTime.now().toIso8601String(),
            tag: TAG);
        provider.insert(
            url, jsonEncode(response.data), DateTime.now().toIso8601String());
        return ResponseResultData(
          response.data,
          true,
          response.statusCode,
        );
      } else {
        LogUtil.v('load data from network but error', tag: TAG);
        return ResponseResultData(
          response.data["message"],
          false,
          response.statusCode,
        );
      }
    } on DioError catch (e) {
      LogUtil.v('request error is $e', tag: TAG);
      return ResponseResultData(
        null,
        false,
        -2,
      );
    }
  }

  static _getHeaders(Map<String, String> header) {
    Map<String, String> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    headers["Authorization"] = LoginManager.instance.getToken();
    return headers;
  }

  static download(url, savePath, progress) async {
    try {
      Dio _dio = Dio();
      Response response =
          await _dio.download(url, savePath, onReceiveProgress: progress);
      print(response.statusCode);
    } catch (e) {
      LogUtil.v('download error is $e', tag: TAG);
    }
  }
}
