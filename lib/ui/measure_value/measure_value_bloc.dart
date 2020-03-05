import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class MeasureValueBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  int currentPage = 0;

  ValueResultModel valueResultModel;

  void iniDataResult() {
    if (valueResultModel == null)
      valueResultModel = ValueResultModel(results: [], values: []);

    List<QuestionModel> questions = QuestionModel.getValues();
    List<AnswerModel> answers = AnswerModel.getAnswers2();

    questions.forEach((q) {
      final measureW = MeasureValueModel(
          question: q, answers: answers, selectedAnswer: answers[0]);
      valueResultModel.values.add(measureW);
    });
    valueResultModel.results = ValueResult.getResult(valueResultModel);
  }

  void setAnswerValue(int questionIndex, int answerId) async {
    valueResultModel.values[questionIndex].selectedAnswer = valueResultModel
        .values[questionIndex].answers
        .firstWhere((a) => a.id == answerId);
    valueResultModel.results = ValueResult.getResult(valueResultModel);
    _pageController.sinkAddSafe(currentPage);
  }

  void changePage(int value) async {
    if (value > 0 && currentPage < valueResultModel.values.length) {
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

  void saveMeasures()async{
    isLoading = true;
    Future.delayed(Duration(seconds: 2), (){
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
