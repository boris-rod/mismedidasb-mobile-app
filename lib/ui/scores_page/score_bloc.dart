import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class ScoreBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;

  ScoreBloC(this._iUserRepository);

  BehaviorSubject<ScoreModel> _scoresController = new BehaviorSubject();

  Stream<ScoreModel> get scoresResult => _scoresController.stream;

  BehaviorSubject<SoloQuestionStatsModel> _soloQuestionStatsController =
      new BehaviorSubject();

  Stream<SoloQuestionStatsModel> get soloQuestionStatsResult =>
      _soloQuestionStatsController.stream;

  bool pointsLoaded = false;
  bool soloQuestionStatsLoaded = false;

  void loadData() {
    isLoading = true;
    getScores();
    getSoloQuestionStats(true, 7);
  }

  void getScores() async {
    final res = await _iUserRepository.getScores();
    pointsLoaded = true;
    if (soloQuestionStatsLoaded) isLoading = false;
    if (res is ResultSuccess<ScoreModel>) {
      _scoresController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
  }

  void getSoloQuestionStats(bool initLoad, daysAgo) async {
    if (!initLoad) isLoading = true;
    final res = await _iUserRepository.getSoloQuestionStats(daysAgo);
    soloQuestionStatsLoaded = true;
    if (res is ResultSuccess<SoloQuestionStatsModel>) {
      _soloQuestionStatsController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    if (pointsLoaded) isLoading = false;
  }

  @override
  void dispose() {
    _scoresController.close();
    _soloQuestionStatsController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
