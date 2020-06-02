import 'package:mismedidasb/domain/food/food_base_model.dart';

class FoodModel extends FoodBaseModel {
  bool isProteic;
  bool isCaloric;
  bool isFruitAndVegetables;
  List<TagModel> tags;

  FoodModel(
      {this.isProteic, this.isCaloric, this.isFruitAndVegetables, this.tags});

  TagModel get tag => tags.isNotEmpty ? tags[0] : TagModel();
}

class TagModel {
  int id;
  String name;
  bool isSelected;

  TagModel({this.id = 0, this.name = "", this.isSelected = true});
}
