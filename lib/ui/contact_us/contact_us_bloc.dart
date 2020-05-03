import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/contact_us/contact_us_model.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class ContactUsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IContactUsRepository _iContactUsRepository;

  ContactUsBloC(this._iContactUsRepository);

  Future<bool> sedInfo(String title, String description) async {
    bool wasSent = false;
    isLoading = true;
    final res = await _iContactUsRepository
        .sendInfo(ContactUsModel(title: title, description: description));
    if(res is ResultSuccess<String>){
      wasSent =  true;
    }else{
      showErrorMessage(res);
    }
    isLoading = false;
    return wasSent;
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
