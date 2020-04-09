import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/health_concept/health_concept.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HomeBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IHealthConceptRepository _iHealthConceptRepository;
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  HomeBloC(this._iHealthConceptRepository,
      this._iUserRepository, this._sharedPreferencesManager);

  BehaviorSubject<List<HealthConceptModel>> _conceptController =
      new BehaviorSubject();

  Stream<List<HealthConceptModel>> get conceptResult =>
      _conceptController.stream;

  bool canNavigateToFoodPage = false;
  void loadHomeData() async {
    isLoading = true;
    final profileRes = await _iUserRepository.getProfile();
    if (profileRes is ResultSuccess<UserModel>) {
      profileRes.value.dailyKCal = profileRes.value.dailyKCal ?? 2000;
      profileRes.value.imc = profileRes.value.imc ?? 24;

      await _sharedPreferencesManager.setDailyKCal(profileRes.value.dailyKCal ?? 2000);
      await _sharedPreferencesManager.setIMC(profileRes.value.imc ?? 24);
      canNavigateToFoodPage = profileRes.value.dailyKCal > 1 && profileRes.value.imc > 1;
      final res = await _iHealthConceptRepository.getHealthConceptList();
      if (res is ResultSuccess<List<HealthConceptModel>>) {
        _conceptController.sinkAddSafe(res.value);
      } else
        showErrorMessage(res);
    } else
      showErrorMessage(profileRes);
    isLoading = false;
  }

  int getHomeCountPerRow(double screenW) {
    int count = 0;
    double partialW = 0;
    while (screenW > partialW + R.dim.homeWidgetDimen) {
      count += 1;
      partialW += partialW + R.dim.homeWidgetDimen;
    }
    return count;
  }

  String getDefaultHomeImage(HealthConceptModel model){
    String resDir = R.image.logo;
    if(model.codeName == RemoteConstants.concept_health_measure)
      resDir = R.image.health_home;
    else if(model.codeName == RemoteConstants.concept_values_measure)
      resDir = R.image.values_home;
    else if(model.codeName == RemoteConstants.concept_wellness_measure)
      resDir = R.image.wellness_home;
    else if(model.codeName == RemoteConstants.concept_dishes)
      resDir = R.image.dishes_home;
    else if(model.codeName == RemoteConstants.concept_habits)
      resDir = R.image.habits_home;
    else if(model.codeName == RemoteConstants.concept_craving)
      resDir = R.image.food_craving_home;

    return resDir;
  }

  @override
  void dispose() {
    _conceptController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
//    _loadingController.close();
  }
}
