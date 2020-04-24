import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_api.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_repository.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';

class LegacyRepository extends BaseRepository implements ILegacyRepository{
  final ILegacyApi _iLegacyApi;

  LegacyRepository(this._iLegacyApi);

  @override
  Future<Result<bool>> acceptTermsCond() async{
    try {
      final result = await _iLegacyApi.acceptTermsCond();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<LegacyModel>> getLegacyContent(int contentType) async{
    try {
      final result = await _iLegacyApi.getLegacyContent(contentType);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

}