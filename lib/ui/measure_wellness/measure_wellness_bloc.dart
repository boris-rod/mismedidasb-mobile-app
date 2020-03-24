import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
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
  final IPollRepository _iPollRepository;

  MeasureWellnessBloC(this._iPollRepository);

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<List<PollModel>> _pollsController = new BehaviorSubject();

  Stream<List<PollModel>> get pollsResult => _pollsController.stream;

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
    wellnessResultModel.result = WellnessResult.getResult(wellnessResultModel);
  }

  void setAnswerValue(int questionIndex, int answerId) async {
    wellnessResultModel.wellness[questionIndex].selectedAnswer =
        wellnessResultModel.wellness[questionIndex].answers
            .firstWhere((a) => a.id == answerId);
    wellnessResultModel.result = WellnessResult.getResult(wellnessResultModel);
    _pageController.sinkAddSafe(currentPage);
  }

  void changePage(int value) async {
    if (value > 0 && currentPage < wellnessResultModel.wellness.length) {
      currentPage += value;
    } else if (value < 0 && currentPage > 0) {
      currentPage += value;
    }
    _pageController.sinkAddSafe(currentPage);
  }

  void loadPolls(int conceptId) async {
    isLoading = true;
    final res = await _iPollRepository.getPollsByConcept(conceptId);
    if (res is ResultSuccess<List<PollModel>>) {
      _pollsController.sinkAddSafe(res.value);
    }
    isLoading = false;
  }

  void saveMeasures() async {
    isLoading = true;
    Future.delayed(Duration(seconds: 2), () {
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
