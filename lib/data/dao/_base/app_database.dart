import 'dart:async';
import 'dart:io';

import 'package:mismedidasb/data/dao/_base/db_constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._privateConstructor();

  static final AppDatabase instance = AppDatabase._privateConstructor();

  Database _db;

  Future<Database> get db async {
    if (_db == null) await _initDb();
    return _db;
  }

  _initDb() async {
    String documentsDirectory = await getDatabasesPath();
    String path = join(documentsDirectory, DBConstants.db_name);
    _db = await openDatabase(path,
        version: DBConstants.db_version,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion)
      await _createTables(db);
  }

  Future _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future _createTables(Database db) async {
    await _createTable(db, DBConstants.food_table, DBConstants.table_cols);
    await _createTable(db, DBConstants.food_tag_table, DBConstants.table_cols);
    await _createTable(db, DBConstants.daily_food_activity_table, DBConstants.table_cols);
//    await _createTable(db, DBConstants.measure_health_table, DBConstants.table_cols);
//    await _createTable(db, DBConstants.health_result_table, DBConstants.table_cols);
  }

  static Future<bool> _createTable(
      Database db, String tableName, Map<String, String> columns) async {
    if (columns.length == 0) return false;

    try {
      var script = 'CREATE TABLE $tableName ( ';
      columns.keys.forEach((key) {
        final val = columns[key];
        if (key == columns.keys.first)
          script = '$script $key $val PRIMARY KEY';
        else
          script = '$script, $key $val';
      });

      script = script + ')';

      await db.execute(script);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<int> deleteAll(String tableName) async {
    final res = await _db.delete(tableName);
    return res;
  }
}
// return the path
