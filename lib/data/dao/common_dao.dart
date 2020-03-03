import 'package:mismedidasb/data/dao/_base/app_database.dart';
import 'package:mismedidasb/data/dao/_base/db_constants.dart';
import 'package:mismedidasb/domain/common_db/i_common_dao.dart';

class CommonDao implements ICommonDao {
  final AppDatabase _appDatabase;

  CommonDao(this._appDatabase);

  @override
  Future<bool> cleanDB() async {
    try {
      await _appDatabase.deleteAll(DBConstants.food_table);
      await _appDatabase.deleteAll(DBConstants.food_tag_table);
      await _appDatabase.deleteAll(DBConstants.daily_food_activity_table);
      await _appDatabase.deleteAll(DBConstants.measure_health_table);
      await _appDatabase.deleteAll(DBConstants.health_result_table);

      ///Add here all lines for complete data remove by each table...
      return true;
    } catch (ex) {
      return false;
    }
  }
}
