import 'package:mismedidasb/domain/dish/dish_model.dart';

abstract class IDishApi {
  Future<List<FoodModel>> getFoodModelList();

  Future<List<TagModel>> getTagList();
}
