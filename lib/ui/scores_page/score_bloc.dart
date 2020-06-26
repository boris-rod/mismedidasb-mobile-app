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

  void getScores() async {
    isLoading = true;
    final res = await _iUserRepository.getScores();
    if (res is ResultSuccess<ScoreModel>) {
      _scoresController.sinkAddSafe(res.value);
    } else {
      showErrorMessage(res);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _scoresController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
