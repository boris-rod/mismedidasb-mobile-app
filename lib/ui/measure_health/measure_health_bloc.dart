import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';
import 'package:mismedidasb/ui/measure_health/health_result.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class MeasureHealthBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<HealthMeasureResultModel> _measureController =
      new BehaviorSubject();

  Stream<HealthMeasureResultModel> get measureResult =>
      _measureController.stream;

  int currentPage = 0;
  HealthMeasureResultModel healthMeasureResultModel;

  void iniDataResult() {
    if (healthMeasureResultModel == null) {
      final diets = AnswerModel.getAnswers();
      final exercises = AnswerModel.getPhysicalExercise();
      healthMeasureResultModel = HealthMeasureResultModel(
          age: 18,
          weight: 40,
          height: 100,
          sex: 1,
          physicalExercise: 1,
          physicalExerciseValue: exercises[0].title,
          diet: List.generate(QuestionModel.getDiets().length, (index) {
            return diets[0].id;
          }),
          dietValue: List.generate(QuestionModel.getDiets().length, (index) {
            return diets[0].title;
          }));
    }
  }

  void setDataResult(HealthMeasureResultModel model) {
    _measureController.sinkAddSafe(model);
  }

  void changePage(bool isNext) async {
    if (isNext && currentPage < 2) {
      currentPage += 1;
    } else if (currentPage > 0) {
      currentPage -= 1;
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

  void generateResults() async {
    final model = (await measureResult.first);

    final String result = HealthResult.getResult(model);
    model.result = result;
    _measureController.sinkAddSafe(model);
  }

  @override
  void dispose() {
    _measureController.close();
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
