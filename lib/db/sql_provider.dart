import 'dart:async';

import 'package:open_git/db/sql_manager.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseDbProvider {
  bool isTableExits = false;

  tableSqlString();

  tableName();

  tableBaseString(String name, String columnId) {
    return '''
        create table $name (
        $columnId integer primary key autoincrement,
      ''';
  }

  Future<Database> getDataBase() async {
    return await _open();
  }

  _prepare(name, String createSql) async {
    isTableExits = await SqlManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await SqlManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  _open() async {
    if (!isTableExits) {
      await _prepare(tableName(), tableSqlString());
    }
    return await SqlManager.getCurrentDatabase();
  }
}
