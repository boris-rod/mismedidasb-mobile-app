import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';

abstract class IContactUsConverter {
  Map<String, dynamic> toJson(ContactUsModel model);
}
