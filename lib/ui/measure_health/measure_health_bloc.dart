import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class MeasureHealthBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  MeasureHealthBloC(this._iPollRepository, this._iUserRepository,
      this._sharedPreferencesManager);

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<HealthMeasureResultModel> _measureController =
      new BehaviorSubject();

  Stream<HealthMeasureResultModel> get measureResult =>
      _measureController.stream;

  BehaviorSubject<List<PollModel>> _pollsController = new BehaviorSubject();

  Stream<List<PollModel>> get pollsResult => _pollsController.stream;

  BehaviorSubject<String> _pollSaveController = new BehaviorSubject();

  Stream<String> get pollSaveResult => _pollSaveController.stream;

  int currentPage = 1;
  HealthMeasureResultModel healthMeasureResultModel;

  void loadPolls(int conceptId) async {
    isLoading = true;
    final res = await _iPollRepository.getPollsByConcept(conceptId);
    if (res is ResultSuccess<List<PollModel>>) {
      _pollsController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

//  void setDataResult(HealthMeasureResultModel model) {
//    _measureController.sinkAddSafe(model);
//  }
//
//  void setAge(int data) async {
//    healthMeasureResultModel.age = data;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }
//
//  void setWeight(int data) async {
//    healthMeasureResultModel.weight = data;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }

//  void setHeight(int data) async {
//    healthMeasureResultModel.height = data;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }
//
//  void setSex(int data) async {
//    healthMeasureResultModel.sex = data;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }
//
//  void setPhysicalExercise(int data, String name) async {
//    healthMeasureResultModel.physicalExercise = data;
//    healthMeasureResultModel.physicalExerciseValue = name;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }
//
//  void setDiet(int data, String name, int index) async {
//    healthMeasureResultModel.diet[index] = data;
//    healthMeasureResultModel.dietValue[index] = name;
//    _measureController.sinkAddSafe(healthMeasureResultModel);
//  }

  void setAnswerValue(int pollIndex, int questionIndex, int answerId) async {
    final polls = await pollsResult.first;
    polls[pollIndex].questions[questionIndex].selectedAnswerId = answerId;
    _pollsController.sinkAddSafe(polls);
  }

  void changePage(int value) async {
    currentPage += value;
    _pageController.sinkAddSafe(currentPage - 1);
  }

  void saveMeasures() async {
    isLoading = true;
    final polls = await pollsResult.first;
    final res = await _iPollRepository.setPollResult(polls);
    if (res is ResultSuccess<String>) {
      final profileRes = await _iUserRepository.getProfile();
      if (profileRes is ResultSuccess<UserModel>) {
        await _sharedPreferencesManager
            .setDailyKCal(profileRes.value.dailyKCal);
        await _sharedPreferencesManager.setIMC(profileRes.value.imc);
        await _sharedPreferencesManager
            .setFirstDateHealthResult(profileRes.value.firstDateHealthResult);
      }
      _pollSaveController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _measureController.close();
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
