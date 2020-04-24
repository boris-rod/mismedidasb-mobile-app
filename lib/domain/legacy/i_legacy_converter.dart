import 'package:mismedidasb/domain/legacy/legacy_model.dart';

abstract class ILegacyConverter{

  LegacyModel fromJson(Map<String, dynamic> json);

}