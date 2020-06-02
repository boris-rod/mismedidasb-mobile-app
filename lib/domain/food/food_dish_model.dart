import 'package:mismedidasb/domain/food/food_base_model.dart';

class FoodDishModel {
  FoodBaseModel foodBaseModel;
  double qty;

  FoodDishModel({this.foodBaseModel, this.qty});

  double get caloriesQty => foodBaseModel.calories * qty;

  String get displayQty => qty == 0.25
      ? "1/4"
      : (qty == 0.50
          ? "1/2"
          : (qty == 0.75 ? "3/4" : qty.truncate().toString()));
}
