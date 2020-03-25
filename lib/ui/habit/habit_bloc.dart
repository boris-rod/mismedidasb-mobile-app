import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/habit/habit_model.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HabitBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  HabitBloC(this._iPollRepository);

  BehaviorSubject<List<HabitModel>> _habitsController = new BehaviorSubject();
  Stream<List<HabitModel>> get habitsResult => _habitsController.stream;

  void loadData(int conceptId) async {
    isLoading = true;
    final res = await _iPollRepository.getPollsByConcept(conceptId);
    if(res is ResultSuccess<List<PollModel>>){
      List<HabitModel> list = HabitModel.getHabits();
      _habitsController.sinkAddSafe(list);
    }
    isLoading = false;
  }

  @override
  void dispose() {
    _habitsController.close();
  }
}
