import 'dart:convert';

import 'package:mismedidasb/data/dao/_base/app_database.dart';
import 'package:mismedidasb/data/dao/_base/db_constants.dart';
import 'package:mismedidasb/domain/dish/dish_model.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:sqflite/sqflite.dart';

class DishDao extends IDishDao {
  final AppDatabase _appDatabase;
  final IDishConverter _foodConverter;

  DishDao(this._appDatabase, this._foodConverter);

  @override
  Future<List<DailyFoodModel>> getDailyFoodModelList() async {
    List<DailyFoodModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(DBConstants.daily_food_activity_table);
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final DailyFoodModel obj =
            _foodConverter.fromJsonDailyFoodModel(jsonDecode(value));
        list.add(obj);
      });
    } catch (ex) {
      print(ex.toString());
    }
    return list;
  }

  @override
  Future<bool> saveDailyFoodModelList(List<DailyFoodModel> list) async {
    try {
      Database db = await _appDatabase.db;
      list.forEach((model) async {
        final map = {
          DBConstants.id_key:
          CalendarUtils.getTimeIdBasedDay(dateTime: model.dateTime),
          DBConstants.data_key:
          jsonEncode(_foodConverter.toJsonDailyFoodModel(model)),
          DBConstants.parent_key:
          CalendarUtils.getTimeIdBasedDay(dateTime: model.dateTime),
        };
        await db.insert(DBConstants.daily_food_activity_table, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> removeDailyFoodModel(String id) async {
    try {
      Database db = await _appDatabase.db;
      final rows = await db.delete(DBConstants.daily_food_activity_table,
          where: '${DBConstants.id_key}= ?', whereArgs: [id]);
      return rows > 0;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> saveDailyFoodModel(DailyFoodModel model) async {
    try {
      Database db = await _appDatabase.db;
      final data = jsonEncode(_foodConverter.toJsonDailyFoodModel(model));
      if (data.isNotEmpty) {
        final map = {
          DBConstants.id_key: CalendarUtils.getTimeIdBasedDay(dateTime: model.dateTime),
          DBConstants.data_key: data,
          DBConstants.parent_key: CalendarUtils.getTimeIdBasedDay(dateTime: model.dateTime)
        };
        final inserted = await db.insert(
            DBConstants.daily_food_activity_table, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<List<FoodModel>> getFoodModeList() async {
    List<FoodModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(DBConstants.food_table);
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final FoodModel obj =
            _foodConverter.fromJsonFoodModel(jsonDecode(value));
        list.add(obj);
      });
    } catch (ex) {}
    return list;
  }

  @override
  Future<bool> saveFoodModelList(List<FoodModel> list) async {
    try {
      Database db = await _appDatabase.db;
      list.forEach((model) async {
        final map = {
          DBConstants.id_key: model.id,
          DBConstants.data_key:
              jsonEncode(_foodConverter.toJsonFoodModel(model)),
          DBConstants.parent_key: model.id,
        };
        await db.insert(DBConstants.food_table, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> clearFoodModelList() async {
    try {
      Database db = await _appDatabase.db;
      await db.delete(DBConstants.food_table);
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<List<TagModel>> getFoodTagList() async {
    List<TagModel> list = [];
    try {
      Database db = await _appDatabase.db;
      final data = await db.query(DBConstants.food_tag_table);
      data.forEach((map) {
        final value = map[DBConstants.data_key];
        final TagModel obj =
            _foodConverter.fromJsonFoodTagModel(jsonDecode(value));
        list.add(obj);
      });
    } catch (ex) {}
    return list;
  }

  @override
  Future<bool> saveFoodTagList(List<TagModel> list) async {
    try {
      Database db = await _appDatabase.db;
      list.forEach((model) async {
        final map = {
          DBConstants.id_key: model.id,
          DBConstants.data_key:
              jsonEncode(_foodConverter.toJsonFoodModelTag(model)),
          DBConstants.parent_key: model.id,
        };
        await db.insert(DBConstants.food_tag_table, map,
            conflictAlgorithm: ConflictAlgorithm.replace);
      });
      return true;
    } catch (ex) {
      return false;
    }
  }

  @override
  Future<bool> clearFoodTagList() async {
    try {
      Database db = await _appDatabase.db;
      await db.delete(DBConstants.food_tag_table);
      return true;
    } catch (ex) {
      return false;
    }
  }
}
