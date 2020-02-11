import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class MeasureWellnessBloC
    with LoadingBloC, ErrorHandlerBloC
    implements BaseBloC {
  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  int currentPage = 0;

  WellnessResultModel wellnessResultModel;

  void iniDataResult() {
    if (wellnessResultModel == null)
      wellnessResultModel = WellnessResultModel(result: [], wellness: []);

    List<QuestionModel> questions = QuestionModel.getWellness();
    List<AnswerModel> answers = AnswerModel.getAnswers();

    questions.forEach((q) {
      final measureW = MeasureWellnessModel(
          question: q, answers: answers, selectedAnswer: answers[0]);
      wellnessResultModel.wellness.add(measureW);
    });
    wellnessResultModel.result =
        WellnessResult.getResult(wellnessResultModel);
  }

  void setAnswerValue(int questionIndex, AnswerModel answer) async {
    wellnessResultModel.wellness[questionIndex].selectedAnswer = answer;
    wellnessResultModel.result =
        WellnessResult.getResult(wellnessResultModel);
  }

  void changePage(int value) async {
    if (value > 0 && currentPage < wellnessResultModel.wellness.length) {
      currentPage += value;
    } else if (value < 0 && currentPage > 0) {
      currentPage += value;
    }
    _pageController.sinkAddSafe(currentPage);
  }

  void loadMeasures() async {
    isLoading = true;
    try {
      Future.delayed(Duration(seconds: 1), () {
        isLoading = false;
      });
    } catch (ex) {
      onError(ex);
    }
  }

  @override
  void dispose() {
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
