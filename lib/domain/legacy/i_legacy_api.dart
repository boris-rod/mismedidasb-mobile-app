import 'package:mismedidasb/domain/legacy/legacy_model.dart';

abstract class ILegacyApi {
  Future<LegacyModel> getLegacyContent(int contentType);

  Future<bool> acceptTermsCond();
}
