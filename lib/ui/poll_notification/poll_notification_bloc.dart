import 'package:flutter/material.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../enums.dart';

class PollNotificationBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final ILNM _ilnm;

  PollNotificationBloC(
      this._iPollRepository, this._sharedPreferencesManager, this._ilnm);

  BehaviorSubject<List<SoloQuestionModel>> _soloQuestionsController =
      new BehaviorSubject();

  Stream<List<SoloQuestionModel>> get soloQuestionsResult =>
      _soloQuestionsController.stream;

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<PollResponseModel> _rewardController = new BehaviorSubject();

  Stream<PollResponseModel> get rewardResult => _rewardController.stream;

  BehaviorSubject<SoloQuestionModel> _feelingTodayController =
      new BehaviorSubject();

  Stream<SoloQuestionModel> get feelingTodayResult =>
      _feelingTodayController.stream;

  BehaviorSubject<SoloQuestionModel> _exercisePlanTomorrowController =
      new BehaviorSubject();

  Stream<SoloQuestionModel> get exercisePlanTomorrowResult =>
      _exercisePlanTomorrowController.stream;

  BehaviorSubject<SoloQuestionModel> _foodPlanReachedController =
      new BehaviorSubject();

  Stream<SoloQuestionModel> get foodPlanReachedResult =>
      _foodPlanReachedController.stream;

  BehaviorSubject<SoloQuestionModel> _exercisePlanReachedController =
      new BehaviorSubject();

  Stream<SoloQuestionModel> get exercisePlanReachedResult =>
      _exercisePlanReachedController.stream;

  int currentPageIndex = 0;
  String userName = "";

  void loadData() async {
    isLoading = true;
    userName =
        await _sharedPreferencesManager.getStringValue(SharedKey.userName);

    final DateTime dateTime = await _sharedPreferencesManager
        .getDateTimeValue(SharedKey.physicalExerciseTime);
    exerciseTime = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

    timeMarked = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showPhysicalExerciseTime);

    final res = await _iPollRepository.getSoloQuestions();
    if (res is ResultSuccess<List<SoloQuestionModel>>) {
      int index = 0;
      _soloQuestionsController.sinkAddSafe(res.value);
      res.value.forEach((element) {
        element.index = index;
        element.soloAnswerModelSelected = element.soloAnswers[0];
        if (element.code == 'SQ-1') {
          _foodPlanReachedController.sinkAddSafe(element);
        } else if (element.code == 'SQ-2') {
          _feelingTodayController.sinkAddSafe(element);
        } else if (element.code == 'SQ-3') {
          _exercisePlanTomorrowController.sinkAddSafe(element);
        } else if (element.code == 'SQ-4') {
          _exercisePlanReachedController.sinkAddSafe(element);
        }
        index += 1;
      });
    }
    isLoading = false;
  }

  void answer() async {
    isLoading = true;
    final _foodPlanReachedResult = await foodPlanReachedResult.first;
    final _feelingTodayResult = await feelingTodayResult.first;
    final _exercisePlanTomorrowResult = await exercisePlanTomorrowResult.first;
    final _exercisePlanReachedResult = await exercisePlanReachedResult.first;

    final createModel = SoloAnswerCreateModel();
    if (currentPageIndex == _foodPlanReachedResult.index) {
      createModel.questionCode = _foodPlanReachedResult.code;
      createModel.answerCode =
          _foodPlanReachedResult.soloAnswerModelSelected.code;
    } else if (currentPageIndex == _feelingTodayResult.index) {
      createModel.questionCode = _feelingTodayResult.code;
      createModel.answerCode = _feelingTodayResult.soloAnswerModelSelected.code;
    } else if (currentPageIndex == _exercisePlanTomorrowResult.index) {
      createModel.questionCode = _exercisePlanTomorrowResult.code;
      createModel.answerCode =
          _exercisePlanTomorrowResult.soloAnswerModelSelected.code;

      if (createModel.answerCode == 'SQ-3-SA-2') {
        await _sharedPreferencesManager.setBoolValue(
            SharedKey.showPhysicalExerciseTime, false);
        await _ilnm.cancel(LNM.makeExerciseId);
      } else {
        await _sharedPreferencesManager.setBoolValue(
            SharedKey.showPhysicalExerciseTime, true);
        await _ilnm.initMakeExerciseReminder();
      }
    } else if (currentPageIndex == _exercisePlanReachedResult.index) {
      createModel.questionCode = _exercisePlanReachedResult.code;
      createModel.answerCode =
          _exercisePlanReachedResult.soloAnswerModelSelected.code;
    }

    final res = await _iPollRepository.postSoloQuestion(createModel);
    if (res is ResultSuccess<PollResponseModel>) {
      currentPageIndex += 1;
      _pageController.sinkAddSafe(currentPageIndex);

      if (currentPageIndex >= (await soloQuestionsResult.first).length) {
        _ilnm.showCommonNotification(
            channelId: LNM.localCommonNoti,
            title: "Enhorabuena $userName",
            content:
                "Has obtenido una recompensa de ${res.value.reward.points} puntos.",
            notificationType: NotificationType.REWARD);
      } else {
        _rewardController.sinkAddSafe(res.value);
      }
    } else {
      showErrorMessage(res);
    }

    isLoading = false;
  }

  void saveFoodPlanReached(SoloAnswerModel answer, int index) async {
    final _foodPlanReachedResult = await foodPlanReachedResult.first;
    _foodPlanReachedResult.soloAnswerModelSelected = answer;
    _foodPlanReachedController.sinkAddSafe(_foodPlanReachedResult);
  }

  void saveFeelingToday(SoloAnswerModel answer, int index) async {
    final _feelingTodayResult = await feelingTodayResult.first;
    _feelingTodayResult.soloAnswerModelSelected = answer;
    _feelingTodayController.sinkAddSafe(_feelingTodayResult);
  }

  void saveExercisePlanTimeTomorrow(SoloAnswerModel answer, int index) async {
    final _exercisePlanTomorrowResult = await exercisePlanTomorrowResult.first;
    _exercisePlanTomorrowResult.soloAnswerModelSelected = answer;
    _exercisePlanTomorrowController.sinkAddSafe(_exercisePlanTomorrowResult);
  }

  void saveExercisePlanReached(SoloAnswerModel answer, int index) async {
    final _exercisePlanReachedResult = await exercisePlanReachedResult.first;
    _exercisePlanReachedResult.soloAnswerModelSelected = answer;
    _exercisePlanReachedController.sinkAddSafe(_exercisePlanReachedResult);
  }

  TimeOfDay exerciseTime;
  bool timeMarked = true;
  String timeTitle = "Hora";

  String get exerciseTimeStr =>
      "${exerciseTime.hour < 10 ? "0${exerciseTime.hour}" : exerciseTime.hour}:${exerciseTime.minute < 10 ? "0${exerciseTime.minute}" : exerciseTime.minute} ${exerciseTime.period == DayPeriod.am ? "am" : "pm"}";

  void updateExerciseTime(TimeOfDay newTime) async {
    timeMarked = true;
    exerciseTime = newTime;
    final now = DateTime.now();
    final tomorrow = now.add(Duration(days: 1));
    final tomorrowTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
        exerciseTime.hour, exerciseTime.minute);

    await _sharedPreferencesManager.setDateTimeValue(
        SharedKey.physicalExerciseTime, tomorrowTime);

    await _sharedPreferencesManager.setBoolValue(
        SharedKey.showPhysicalExerciseTime, true);
  }

  @override
  void dispose() {
    _rewardController.close();
    _soloQuestionsController.close();
    _feelingTodayController.close();
    _exercisePlanTomorrowController.close();
    _exercisePlanReachedController.close();
    _foodPlanReachedController.close();
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
