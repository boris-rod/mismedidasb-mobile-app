import 'dart:convert';

import 'package:mismedidasb/data/dao/_base/app_database.dart';
import 'package:mismedidasb/data/dao/_base/db_constants.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_converter.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:sqflite/sqflite.dart';

class PersonalDataDao implements IPersonalDataDao {
  final AppDatabase _appDatabase;
  final IPersonalDataConverter _iPersonalDataConverter;

  PersonalDataDao(this._appDatabase, this._iPersonalDataConverter);

  @override
  Future<HealthResult> getHealthResult() async {
    HealthResult model = HealthResult();
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(DBConstants.health_result_table);
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final HealthResult obj =
            _iPersonalDataConverter.fromJsonHealthResult(json.decode(value));
        model = obj;
      });
    } catch (ex) {}
    return model;
  }

  @override
  Future<bool> saveHealthResult(HealthResult model) async{
    try {
      Database db = await _appDatabase.db;
      final data = jsonEncode(_iPersonalDataConverter.toJsonHealthResult(model));
      if (data.isNotEmpty) {
        final map = {
          DBConstants.id_key: "1",
          DBConstants.data_key: data,
          DBConstants.parent_key: "parent"
        };
        await db.insert(DBConstants.health_result_table, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return true;
    } catch (ex) {
      return false;
    }  }
}
