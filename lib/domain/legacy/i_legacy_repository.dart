import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';

abstract class ILegacyRepository{

  Future<Result<LegacyModel>> getLegacyContent(int contentType);

  Future<Result<bool>> acceptTermsCond();
}