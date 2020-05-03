import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_api.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_repository.dart';

class ContactUsRepository extends BaseRepository
    implements IContactUsRepository {
  final IContactUsApi _iContactUsApi;

  ContactUsRepository(this._iContactUsApi);

  @override
  Future<Result<String>> sendInfo(ContactUsModel model) async {
    try {
      final result = await _iContactUsApi.sendInfo(model);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
