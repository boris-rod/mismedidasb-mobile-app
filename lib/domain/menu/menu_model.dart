import 'package:mismedidasb/domain/dish/dish_model.dart';

class MenuModel {
  int id;
  String name;
  String nameEn;
  String nameIt;
  String description;
  String descriptionEn;
  String descriptionIt;
  bool active;
  int groupId;
  int createdById;
  DateTime createdAt;
  DateTime modifiedAt;
  double calories;
  double proteins;
  double carbohydrates;
  double fats;
  double fibers;
  List<DailyActivityFoodModel> dailyEats;

  MenuModel(
      {this.description,
      this.id,
      this.name,
      this.active,
      this.calories,
      this.carbohydrates,
      this.createdAt,
      this.createdById,
      this.dailyEats = const [],
      this.descriptionEn,
      this.descriptionIt,
      this.fats,
      this.fibers,
      this.groupId,
      this.modifiedAt,
      this.nameEn,
      this.nameIt,
      this.proteins});
}
