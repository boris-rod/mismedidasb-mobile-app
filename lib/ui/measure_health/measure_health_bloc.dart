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

  BehaviorSubject<PollResponseModel> _pollSaveController = new BehaviorSubject();

  Stream<PollResponseModel> get pollSaveResult => _pollSaveController.stream;

  BehaviorSubject<PollResponseModel> _rewardController = new BehaviorSubject();

  Stream<PollResponseModel> get rewardResult => _rewardController.stream;

  BehaviorSubject<bool> _showFirstTimeController = new BehaviorSubject();

  Stream<bool> get showFirstTimeResult => _showFirstTimeController.stream;

  int currentPage = 1;
  //HealthMeasureResultModel healthMeasureResultModel;
  PollResponseModel pollResponseModel;
  bool isFirstTime = false;
  String hUnit;
  String wUnit;

  String userName = "";
  void loadPolls(int conceptId) async {
    isLoading = true;
    isFirstTime = await _sharedPreferencesManager.getBoolValue(SharedKey.firstTimeInMeasureHealth, defValue: true);
    userName = await _sharedPreferencesManager.getStringValue(SharedKey.userName);
    hUnit = await _sharedPreferencesManager.getHeightUnit();
    wUnit = await _sharedPreferencesManager.getWeightUnit();
    final res = await _iPollRepository.getPollsByConcept(conceptId);
    if (res is ResultSuccess<List<PollModel>>) {
      _pollsController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }


  void setAnswerValue(int pollIndex, int questionIndex, int answerId) async {
    final polls = await pollsResult.first;
    polls[pollIndex].questions[questionIndex].selectedAnswerId = answerId;
    polls[pollIndex].questions[questionIndex].lastAnswer = answerId;
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
    if (res is ResultSuccess<PollResponseModel>) {
      final profileRes = await _iUserRepository.getProfile();
      if (profileRes is ResultSuccess<UserModel>) {
        await _sharedPreferencesManager
            .setDailyKCal(profileRes.value.dailyKCal);
        await _sharedPreferencesManager.setIMC(profileRes.value.imc);
        await _sharedPreferencesManager
            .setFirstDateHealthResult(profileRes.value.firstDateHealthResult);
      }
      pollResponseModel = res.value;
      _pollSaveController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void launchFirstTime() async {
    final value =
    await _sharedPreferencesManager.getBoolValue(SharedKey.firstTimeInMeasureHealth, defValue: true);
    _showFirstTimeController.sinkAddSafe(value);
  }

  Future<void> setNotFirstTime() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInMeasureHealth, false);
    _showFirstTimeController.sinkAddSafe(false);
  }

  @override
  void dispose() {
    _measureController.close();
    _rewardController.close();
    _showFirstTimeController.close();
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
