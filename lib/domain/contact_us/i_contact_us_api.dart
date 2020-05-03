import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';

abstract class IContactUsApi {
  Future<String> sendInfo(ContactUsModel model);
}
