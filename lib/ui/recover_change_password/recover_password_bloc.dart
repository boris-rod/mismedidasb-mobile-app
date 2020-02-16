import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class RecoverPasswordBloC extends BaseBloC  with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC{

  @override
  void dispose() {
    // TODO: implement dispose
  }

}