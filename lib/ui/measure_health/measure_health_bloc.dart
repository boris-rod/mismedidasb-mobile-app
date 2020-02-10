import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_health/health_measure_result_model.dart';
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
    double dailyKal = 0.0;
    final IMC = model.weight / ((model.height / 100) * ((model.height / 100)));
    final TMB_PROV = 10 * model.weight + 6.25 * model.height - 5 * model.age;
    int dietSummary = 0;
    model.diet.forEach((value) {
      dietSummary += value;
    });

    if (model.sex == 1) {
      if (model.physicalExercise == 1) {
        dailyKal = (TMB_PROV + 5) * 1.2;
      } else if (model.physicalExercise == 2) {
        dailyKal = (TMB_PROV + 5) * 1.375;
      } else if (model.physicalExercise == 3) {
        dailyKal = (TMB_PROV + 5) * 1.55;
      } else if (model.physicalExercise == 4) {
        dailyKal = (TMB_PROV + 5) * 1.725;
      } else {
        dailyKal = (TMB_PROV + 5) * 1.9;
      }
    } else {
      if (model.physicalExercise == 1) {
        dailyKal = (TMB_PROV - 161) * 1.2;
      } else if (model.physicalExercise == 2) {
        dailyKal = (TMB_PROV - 161) * 1.375;
      } else if (model.physicalExercise == 3) {
        dailyKal = (TMB_PROV - 161) * 1.55;
      } else if (model.physicalExercise == 4) {
        dailyKal = (TMB_PROV - 161) * 1.725;
      } else {
        dailyKal = (TMB_PROV - 161) * 1.9;
      }
    }

    String IMCString = IMC.toStringAsFixed(2);
    if (IMC < 15) {
      model.result =
          "Usted presenta BAJO PESO EXTREMO ( $IMCString Kg/m2) ¡Consulte a un médico!";
    } else if (IMC >= 15 && IMC < 16) {
      model.result =
          "Usted presenta BAJO PESO GRAVE ( $IMCString Kg/m2) ¡Consulte a un médico!";
    } else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
          "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Se sugiere consultar a un médico.";
    }else if (IMC >= 16 &&
        IMC < 17 &&
        dietSummary <= 7 &&
        model.physicalExercise == 1) {
      model.result =
      "Usted presenta BAJO PESO MODERADO ( $IMCString Kg/m2): Su ingesta de calorías debe estar por encima de $dailyKal Kcal/día. Se sugiere consultar a un médico.";
    }

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
