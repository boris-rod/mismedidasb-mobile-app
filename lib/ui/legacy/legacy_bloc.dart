import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_repository.dart';
import 'package:mismedidasb/domain/legacy/legacy_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class LegacyBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final ILegacyRepository _iLegacyRepository;

  LegacyBloC(this._iLegacyRepository);

  BehaviorSubject<bool> _termsCondController = BehaviorSubject();

  Stream<bool> get termsCondResult => _termsCondController.stream;

  BehaviorSubject<LegacyModel> _legacyController = BehaviorSubject();

  Stream<LegacyModel> get legacyResult => _legacyController.stream;

  bool termsCondAccepted = false;

  void acceptTermsCond() async {
    isLoading = true;
    final res = await _iLegacyRepository.acceptTermsCond();
    if (res is ResultSuccess<bool>) {
      termsCondAccepted = true;
      _termsCondController.sinkAddSafe(true);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void loadData(int contentType) async {
    isLoading = true;
    final res = await _iLegacyRepository.getLegacyContent(contentType);
    if (res is ResultSuccess<LegacyModel>) {
      _legacyController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  String getTitleBar(int contentType) {
    String result = R.string.aboutUs;
    if (contentType == 0)
      result = R.string.privacyPolicies;
    else if (contentType == 1)
      result = R.string.termsCond;
    else if (contentType == 2)
      result = R.string.aboutUs;
    else if (contentType == 3) result = R.string.faq;
    return result;
  }

  @override
  void dispose() {
    _termsCondController.close();
    _legacyController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
