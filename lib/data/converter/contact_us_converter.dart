import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_converter.dart';

class ContactUsConverter implements IContactUsConverter {
  @override
  Map<String, dynamic> toJson(ContactUsModel model) {
    return {
      "subject": model.title,
      "body": model.description
    };
  }
}
