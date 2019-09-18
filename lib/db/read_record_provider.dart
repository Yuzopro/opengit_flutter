import 'package:flutter_common_util/flutter_common_util.dart';
import 'package:open_git/bean/track_bean.dart';
import 'package:open_git/db/sql_provider.dart';
import 'package:sqflite/sqlite_api.dart';

class ReadRecordProvider extends BaseDbProvider {
  static final TYPE_H5 = "h5";
  static final TYPE_REPO = "repo";
  static final TYPE_ISSUE = "issue";

  final String name = 'read_record';

  final String columnId = "_id";
  final String columnUrl = "url";
  final String columnTitle = "title";
  final String columnType = "type";
  final String columnRepoOwner = "repo_owner";
  final String columnRepoName = "repo_name";
  final String columnIssueNumber = "issue_number";
  final String columnDate = "date";
  final String columnData1 = "data1";
  final String columnData2 = "data2";
  final String columnData3 = "data3";
  final String columnData4 = "data4";

  int id;
  String url;
  String title;
  String type;
  String repoOwner;
  String repoName;
  String issueNumber;
  int dateTime;

  ReadRecordProvider();

  @override
  tableName() {
    return name;
  }

  @override
  tableSqlString() {
    return tableBaseString(name, columnId) +
        '''
        $columnUrl text not null,
        $columnTitle text,
        $columnType text not null,
        $columnRepoOwner text,
        $columnRepoName text,
        $columnIssueNumber text,
        $columnDate int not null,
        $columnData1 text,
        $columnData2 text,
        $columnData3 text,
        $columnData4 text)
      ''';
  }

  Future insert(
      {String url,
      String title,
      String type,
      String repoOwner,
      String repoName,
      int date,
      String number,
      String data}) async {
    if (TextUtil.equals(TYPE_H5, type)) {
      return _insertH5(url, title, date, data);
    } else if (TextUtil.equals(TYPE_REPO, type)) {
      return _insertRepo(url, repoOwner, repoName, date, data);
    } else if (TextUtil.equals(TYPE_ISSUE, type)) {
      return _insertIssue(url, number, date, data);
    }
  }

  Future _insertH5(String url, String title, int date, String data) async {
    LogUtil.v('_insertH5 title is $title');

    Database db = await getDataBase();
    var provider = await _query(db, url);
    if (provider != null) {
      LogUtil.v('_insertH5 update');

      Map<String, dynamic> values = {columnDate: date};
      db.update(name, values, where: "$columnUrl = ?", whereArgs: [url]);
    } else {
      LogUtil.v('_insertH5 insert');

      Map<String, dynamic> values = {
        columnDate: date,
        columnUrl: url,
        columnTitle: title,
        columnType: TYPE_H5,
        columnData1:data,
      };
      db.insert(name, values);
    }
  }

  Future _insertRepo(
      String url, String repoOwner, String repoName, int date, String data) async {
    LogUtil.v('_insertRepo repoName is $repoName');

    Database db = await getDataBase();
    var provider = await _query(db, url);
    if (provider != null) {
      Map<String, dynamic> values = {columnDate: date};
      db.update(name, values, where: "$columnUrl = ?", whereArgs: [url]);
    } else {
      Map<String, dynamic> values = {
        columnDate: date,
        columnUrl: url,
        columnRepoOwner: repoOwner,
        columnRepoName: repoName,
        columnType: TYPE_REPO,
        columnData1:data,
      };
      db.insert(name, values);
    }
  }

  Future _insertIssue(String url, String number, int date, String data) async {
    LogUtil.v('_insertIssue url is $url');

    Database db = await getDataBase();
    var provider = await _query(db, url);
    if (provider != null) {
      Map<String, dynamic> values = {columnDate: date};
      db.update(name, values, where: "$columnUrl = ?", whereArgs: [url]);
    } else {
      Map<String, dynamic> values = {
        columnDate: date,
        columnUrl: url,
        columnIssueNumber: number,
        columnType: TYPE_ISSUE,
        columnData1:data,
      };
      db.insert(name, values);
    }
  }

  Future _query(Database db, String url) async {
    List<Map<String, dynamic>> maps = await db.query(name,
        columns: [
          columnId,
          columnUrl,
          columnTitle,
          columnType,
          columnRepoOwner,
          columnRepoName,
          columnIssueNumber,
          columnDate
        ],
        where: "$columnUrl = ?",
        whereArgs: [url]);
    if (maps.length > 0) {
      return TrackBean.fromJson(maps.first);
    }
    return null;
  }

  Future query(int date) async {
    Database db = await getDataBase();

    List<Map<String, dynamic>> maps = await db.query(
      name,
      where: "$columnDate < ?",
      whereArgs: [date],
      limit: 20,
      orderBy: '$columnDate desc',
    );

    LogUtil.v('query maps is $maps');

    if (maps != null) {
      List<TrackBean> list = List();
      for (var value in maps) {
        list.add(TrackBean.fromJson(value));
      }
      return list;
    }
    return null;
  }
}
