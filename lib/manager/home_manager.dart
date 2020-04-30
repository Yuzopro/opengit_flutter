import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:open_git/bean/home_banner_bean.dart';
import 'package:open_git/bean/home_item_bean.dart';
import 'package:open_git/http/api.dart';
import 'package:open_git/http/http_request.dart';

class HomeManager {
  factory HomeManager() => _getInstance();

  static HomeManager get instance => _getInstance();
  static HomeManager _instance;

  HomeManager._internal();

  static HomeManager _getInstance() {
    if (_instance == null) {
      _instance = new HomeManager._internal();
    }
    return _instance;
  }

  Future<List<Data>> getHomeBanner() async {
    final response = await HttpRequest().get(Api.getBanner());
    if (response != null && response.result) {
      if (response.data != null) {
        HomeBannerBean bean = HomeBannerBean.fromJson(response.data);
        if (bean != null && bean.data != null) {
          return bean.data;
        }
      }
      return [];
    }
    return null;
  }

  Future<HomeItemBean> getHomeItem() async {
    var data = await rootBundle.loadString('assets/data/home_data.json');
    Map map = json.decode(data);
    return HomeItemBean.fromJson(map);
  }
}
