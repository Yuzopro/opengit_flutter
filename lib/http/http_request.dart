import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/common/shared_prf_key.dart';
import 'package:open_git/db/cache_provider.dart';
import 'package:open_git/http/response_result_data.dart';
import 'package:open_git/manager/login_manager.dart';

class HttpRequest {
  static final String TAG = "HttpRequest";

  get(String url) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.GET)
      ..url(url);

    return await builder(requestBuilder);
  }

  post(String url, dynamic data) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.POST)
      ..url(url)
      ..data(data);

    return await builder(requestBuilder);
  }

  delete(String url) async {
    RequestBuilder requestBuilder = RequestBuilder()
      ..method(HttpMethod.DELETE)
      ..url(url);

    return await builder(requestBuilder);
  }

  builder(RequestBuilder builder) async {
    if (builder.getCache()) {
      int time =
          SpUtil.instance.getInt(SharedPrfKey.SP_KEY_CACHE_TIME, defValue: 4);
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

    Options options = Options(
      method: _getMethod(builder.getMethod()),
      headers: _getHeaders(builder.getHeader()),
      contentType: builder.getContentType(),
      connectTimeout: 15 * 1000,
    );

    String url = builder.getUrl();

    Dio _dio = Dio();
    //开始请求
    Response response;
    try {
      response = await _dio.request(
        url,
        data: builder.getData(),
        options: options,
      );

      if (response.statusCode >= HttpStatus.ok &&
          response.statusCode < HttpStatus.multipleChoices) {
        CacheProvider provider = CacheProvider();
        provider.insert(
            url, jsonEncode(response.data), DateTime.now().toIso8601String());
        LogUtil.v(
            'load data from network and success, url is ' + builder.getUrl(),
            tag: TAG);
//        LogUtil.v(response.data.toString(), tag: TAG);
        return ResponseResultData(response.data, true, response.statusCode);
      } else {
        LogUtil.v(
            'load data from network and error code, url is ' + builder.getUrl(),
            tag: TAG);
        return ResponseResultData(
            response.data["message"], false, response.statusCode);
      }
    } on DioError catch (e) {
      LogUtil.v(
          'load data from network and exception, url is ' + builder.getUrl(),
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
  ContentType _contentType = ContentType.json;
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

  RequestBuilder contentType(ContentType contentType) {
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

  ContentType getContentType() {
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
