import 'package:mismedidasb/domain/food/food_base_model.dart';
import 'package:mismedidasb/domain/food/food_model.dart';

class FoodCompoundModel extends FoodBaseModel{
  List<FoodModel> foods;

  FoodCompoundModel({this.foods});
}