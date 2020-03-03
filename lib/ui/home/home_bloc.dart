import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';

class HomeBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPersonalDataRepository _iPersonalDataRepository;

  HomeBloC(this._iPersonalDataRepository);

  void loadHomeData() async {
    isLoading = true;
    try {
      Future.delayed(Duration(seconds: 1), () {
        isLoading = false;
      });
    } catch (ex) {
      onError(ex);
    }
  }

  Future<bool> canNavigateToFoodPage() async {
    HealthResult healthResult =
        await _iPersonalDataRepository.getHealthResult();
    return healthResult.result.isNotEmpty &&
        healthResult.kCal != 1 &&
        healthResult.imc != 1;
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
//    _loadingController.close();
  }
}
