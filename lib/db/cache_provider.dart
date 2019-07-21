import 'dart:convert';

import 'package:open_git/db/sql_provider.dart';
import 'package:open_git/util/log_util.dart';
import 'package:sqflite/sqlite_api.dart';

class CacheProvider extends BaseDbProvider {
  static String TAG = 'CacheProvider';

  final String name = 'cache';
  final String columnId = "_id";
  final String columnUrl = "url";
  final String columnData = "data";
  final String columnDate = "date";
  final String columnData1 = "data1";
  final String columnData2 = "data2";
  final String columnData3 = "data3";
  final String columnData4 = "data4";

  int id;
  String url;
  String data;
  String dateTime;

  CacheProvider();

  Map<String, dynamic> toMap(String url, String data, String date) {
    Map<String, dynamic> map = {
      columnUrl: url,
      columnData: data,
      columnDate: date,
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  CacheProvider.fromMap(Map map) {
    id = map[columnId];
    url = map[columnUrl];
    data = map[columnData];
    dateTime = map[columnDate];
  }

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnUrl text not null,
        $columnData text not null,
        $columnDate text not null,
        $columnData1 text,
        $columnData2 text,
        $columnData3 text,
        $columnData4 text)
      ''';
  }

  Future insert(String url, String data, String date) async {
    LogUtil.v('insert $url', tag: TAG);
    Database db = await getDataBase();
    var provider = await _getProvider(db, url);
    if (provider != null) {
      LogUtil.v('insert provider is not null', tag: TAG);
      await db.delete(name, where: "$columnUrl = ?", whereArgs: [url]);
    }

    return await db.insert(name, toMap(url, data, date));
  }

  Future query(String url) async {
    LogUtil.v('query $url', tag: TAG);
    Database db = await getDataBase();

    var provider = await _getProvider(db, url);
    return provider;
  }

  Future delete() async {
    Database db = await getDataBase();
    return await db.delete(name);
  }

  Future _getProvider(Database db, String url) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [columnId, columnUrl, columnData, columnDate],
        where: "$columnUrl = ?",
        whereArgs: [url]);
    if (maps.length > 0) {
      return CacheProvider.fromMap(maps.first);
    }
    return null;
  }
}
