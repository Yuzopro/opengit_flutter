import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/sp_const.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/http/response_result_data.dart';
import 'package:open_git/manager/login_manager.dart';

class HttpRequest {
  static final String TAG = "HttpRequest";

  get(String url, {bool isCache: true}) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.GET)
      ..isCache(isCache)
      ..url(url);

    return await builder(requestBuilder);
  }

  post(String url, dynamic data) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..isCache(false)
      ..method(HttpMethod.POST)
      ..url(url)
      ..data(data);

    return await builder(requestBuilder);
  }

  delete(String url, {bool isCache: true}) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.DELETE)
      ..isCache(isCache)
      ..url(url);

    return await builder(requestBuilder);
  }

  put(String url, {bool isCache: true}) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.PUT)
      ..isCache(isCache)
      ..url(url);

    return await builder(requestBuilder);
  }

  patch(String url, dynamic data) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..isCache(false)
      ..method(HttpMethod.PATCH)
      ..url(url)
      ..data(data);

    return await builder(requestBuilder);
  }

  builder(RequestBuilder builder) async {
    if (builder.getCache()) {
      int time = SpUtil.instance.getInt(SP_KEY_CACHE_TIME, defValue: 4);
      if (time > 0) {
        CacheProvider provider = CacheProvider();
        var result = await provider.query(builder.getUrl());
        if (result != null) {
          var data = jsonDecode(result.data);
          DateTime dateTime = DateTime.parse(result.dateTime);
          int subTime = DateTime.now().millisecondsSinceEpoch -
              dateTime.millisecondsSinceEpoch;
          if (subTime <= time * 60 * 60 * 1000) {
            LogUtil.v('load data from cache, url is ' + builder.getUrl(),
                tag: TAG);
            return ResponseResultData(data, true, 200);
          }
        }
      }
    }

    return await _doRequest(builder);
  }

  _doRequest(RequestBuilder builder) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    //无网络
    if (connectivityResult == ConnectivityResult.none) {
      return ResponseResultData(null, false, -1);
    }

    BaseOptions options = BaseOptions(
      method: _getMethod(builder.getMethod()),
      headers: _getHeaders(builder.getHeader()),
      responseType: builder.getResponseType(),
      connectTimeout: 15 * 1000,
    );

    String url = builder.getUrl();
    LogUtil.v(url /*+ '-->' + builder.getData().toString()*/);

    Dio _dio = Dio(options);
    //开始请求
    Response response;
    try {
      response = await _dio.request(
        url,
        data: builder.getData(),
      );

      if (response.statusCode >= HttpStatus.ok &&
          response.statusCode < HttpStatus.multipleChoices) {
        if (builder._isCache) {
          CacheProvider provider = CacheProvider();
          provider.insert(
              url, jsonEncode(response.data), DateTime.now().toIso8601String());
        }
        LogUtil.v(
            'load data from network and success, url is ' + builder.getUrl(),
            tag: TAG);
       LogUtil.v(response.data);
        return ResponseResultData(response.data, true, response.statusCode);
      } else {
        LogUtil.v(
            'load data from network and error code, url is ' + builder.getUrl(),
            tag: TAG);
        return ResponseResultData(
            response.data["message"], false, response.statusCode);
      }
    } on DioError catch (e) {
     // ToastUtil.showMessgae(e.toString());
      LogUtil.v('load data from network and exception, e is ' + e.toString(),
          tag: TAG);
      return ResponseResultData(null, false, -2);
    }
  }

  String _getMethod(HttpMethod method) {
    if (method == HttpMethod.DELETE) {
      return 'DELETE';
    } else if (method == HttpMethod.PATCH) {
      return 'PATCH';
    } else if (method == HttpMethod.POST) {
      return 'POST';
    } else if (method == HttpMethod.PUT) {
      return 'PUT';
    }
    return 'GET';
  }

  Map<String, dynamic> _getHeaders(Map<String, dynamic> header) {
    Map<String, dynamic> headers = HashMap();
    if (header != null) {
      headers.addAll(header);
    }
    headers["Authorization"] = LoginManager.instance.getToken();
    return headers;
  }

  download(url, savePath, progress) async {
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

class RequestBuilder {
  HttpMethod _method;
  Map<String, dynamic> _headers;
  ResponseType _contentType = ResponseType.json;
  dynamic _data;
  String _url;
  bool _isCache = true;

  RequestBuilder method(HttpMethod method) {
    this._method = method;
    return this;
  }

  RequestBuilder header(Map<String, dynamic> headers) {
    this._headers = headers;
    return this;
  }

  RequestBuilder contentType(ResponseType contentType) {
    this._contentType = contentType;
    return this;
  }

  RequestBuilder data(dynamic data) {
    this._data = data;
    return this;
  }

  RequestBuilder url(String url) {
    this._url = url;
    return this;
  }

  RequestBuilder isCache(bool isCache) {
    this._isCache = isCache;
    return this;
  }

  HttpMethod getMethod() {
    return _method;
  }

  Map<String, dynamic> getHeader() {
    return _headers;
  }

  ResponseType getResponseType() {
    return _contentType;
  }

  dynamic getData() {
    return _data;
  }

  String getUrl() {
    return _url;
  }

  bool getCache() {
    return _isCache;
  }
}

enum HttpMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}
