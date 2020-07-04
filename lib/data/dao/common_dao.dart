import 'package:mismedidasb/data/dao/_base/app_database.dart';
import 'package:mismedidasb/data/dao/_base/db_constants.dart';
import 'package:mismedidasb/domain/common_db/i_common_dao.dart';
import 'package:sqflite/sqflite.dart';

class CommonDao implements ICommonDao {
  final AppDatabase _appDatabase;

  CommonDao(this._appDatabase);

  @override
  Future<bool> cleanDB() async {
    try {
      Database db = await _appDatabase.db;
      db.delete(DBConstants.food_table);
      db.delete(DBConstants.food_compound_table);
      db.delete(DBConstants.food_tag_table);
      db.delete(DBConstants.daily_food_activity_table);
      ///Add here all lines for complete data remove by each table...
      return true;
    } catch (ex) {
      return false;
    }
  }
}
