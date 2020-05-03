import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';

abstract class IContactUsRepository {
  Future<Result<String>> sendInfo(ContactUsModel model);
}
