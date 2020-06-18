import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/answer/answer_model.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/question/question_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class MeasureValueBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  MeasureValueBloC(this._iPollRepository, this._sharedPreferencesManager);

  BehaviorSubject<int> _pageController = new BehaviorSubject();
  Stream<int> get pageResult => _pageController.stream;

  BehaviorSubject<PollModel> _pollsController = new BehaviorSubject();
  Stream<PollModel> get pollsResult => _pollsController.stream;

  BehaviorSubject<PollResponseModel> _pollSaveController = new BehaviorSubject();
  Stream<PollResponseModel> get pollSaveResult => _pollSaveController.stream;

  int currentPage = 1;
  String userName = "";
  void setAnswerValue(int questionIndex, int answerId) async {
    final poll = await pollsResult.first;
    poll.questions[questionIndex].selectedAnswerId = answerId;
    poll.questions[questionIndex].lastAnswer = answerId;
    _pollsController.sinkAddSafe(poll);
  }

  void changePage(int value) async {
    currentPage += value;
    _pageController.sinkAddSafe(currentPage - 1);
  }

  void loadPolls(int conceptId) async {
    isLoading = true;
    userName = await _sharedPreferencesManager.getStringValue(SharedKey.userName);
    final res = await _iPollRepository.getPollsByConcept(conceptId);
    if (res is ResultSuccess<List<PollModel>>) {
      if (res.value.isNotEmpty)
        _pollsController.sinkAddSafe(res.value[0]);
      else
        _pollsController.sinkAddSafe(PollModel(id: -1));
    }else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  void saveMeasures() async {
    isLoading = true;
    final poll = await pollsResult.first;
    final res = await _iPollRepository.setPollResult([poll]);
    if (res is ResultSuccess<PollResponseModel>) {
      _pollSaveController.sinkAddSafe(res.value);
    }else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _pageController.close();
    _pollsController.close();
    _pollSaveController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
