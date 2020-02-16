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
      final dietsQuestion = QuestionModel.getDiets();
      final exercises = AnswerModel.getPhysicalExercise();
      healthMeasureResultModel = HealthMeasureResultModel(
          age: 18,
          weight: 40,
          height: 100,
          sex: 1,
          physicalExercise: 1,
          physicalExerciseValue: exercises[0].title,
          diet: List.generate(dietsQuestion.length, (index) {
            return 1;
          }),
          dietValue: List.generate(dietsQuestion.length, (index) {
            return diets[0].title;
          }));
    }
  }

  void setDataResult(HealthMeasureResultModel model) {
    _measureController.sinkAddSafe(model);
  }

  void setAge(int data) async {
    healthMeasureResultModel.age = data;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setWeight(int data) async {
    healthMeasureResultModel.weight = data;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setHeight(int data) async {
    healthMeasureResultModel.height = data;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setSex(int data) async {
    healthMeasureResultModel.sex = data;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setPhysicalExercise(int data, String name) async {
    healthMeasureResultModel.physicalExercise = data;
    healthMeasureResultModel.physicalExerciseValue = name;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setDiet(int data, String name, int index) async {
    healthMeasureResultModel.diet[index] = data;
    healthMeasureResultModel.dietValue[index] = name;
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void setResult()async{
    HealthResult.getResult(healthMeasureResultModel);
    _measureController.sinkAddSafe(healthMeasureResultModel);
  }

  void changePage(bool isNext) async {
    if (isNext && currentPage < 3) {
      if (currentPage == 2) {
        HealthResult.getResult(healthMeasureResultModel);
        _measureController.sinkAddSafe(healthMeasureResultModel);
      }
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

  @override
  void dispose() {
    _measureController.close();
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
