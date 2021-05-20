

import 'package:mismedidasb/domain/menu/menu_model.dart';

abstract class IMenuConverter {

  MenuModel fromJson(Map<String, dynamic> json);
}