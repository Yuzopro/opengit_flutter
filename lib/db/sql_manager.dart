import 'dart:async';

import 'package:open_git/manager/login_manager.dart';
import 'package:open_git/util/log_util.dart';
import 'package:sqflite/sqflite.dart';

class SqlManager {
  static const TAG = "SqlManager";

  static const _VERSION = 1;

  static const _NAME = "open_git.db";

  static Database _database;

  static _init() async {
    var databasesPath = await getDatabasesPath();
    var user = LoginManager.instance.getUserBean();
    String dbName = _NAME;
    if (user != null && user.login != null) {
      dbName = user.login + "_" + _NAME;
    }
    String path = databasesPath + "/" + dbName;
    LogUtil.v(path, tag: TAG);
    _database = await openDatabase(path, version: _VERSION,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      //await db.execute("CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)");
    });
  }

  /**
   * 表是否存在
   */
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await _init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}
