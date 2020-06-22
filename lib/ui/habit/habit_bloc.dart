import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/habit/habit_model.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HabitBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;

  HabitBloC(this._iPollRepository);

  BehaviorSubject<List<TitleSubTitlesModel>> _pollsController =
      new BehaviorSubject();

  Stream<List<TitleSubTitlesModel>> get pollsResult => _pollsController.stream;

  void loadData(int conceptId) async {
    List<TitleSubTitlesModel> list = TitleSubTitlesModel.getHabitsLiterals();
    _pollsController.sinkAddSafe(list);
  }

  @override
  void dispose() {
    _pollsController.close();
  }
}
