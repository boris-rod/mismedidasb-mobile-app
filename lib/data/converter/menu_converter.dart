import 'package:mismedidasb/domain/dish/i_dish_converter.dart';
import 'package:mismedidasb/domain/menu/i_menu_converter.dart';
import 'package:mismedidasb/domain/menu/menu_model.dart';

class MenuConverter implements IMenuConverter {
  IDishConverter _iDishConverter;

  MenuConverter(this._iDishConverter);

  @override
  MenuModel fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      nameEn: json['nameEN'],
      nameIt: json['nameIT'],
      description: json['description'],
      descriptionEn: json['descriptionEN'],
      descriptionIt: json['descriptionIT'],
      active: json['active'],
      groupId: json['groupId'],
      createdById: json['createdById'],
      createdAt: json['createdAt'],
      modifiedAt: json['modifiedAt'],
      calories: json['calories'],
      proteins: json['proteins'],
      carbohydrates: json['carbohydrates'],
      fats: json['fats'],
      fibers: json['fibers'],
      dailyEats: (json['eats'] as List<dynamic>)
          .map((e) => _iDishConverter.fromJsonDailyActivityFoodModel(e))
          .toList(),
    );
  }
}
