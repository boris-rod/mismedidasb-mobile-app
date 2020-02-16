import 'package:mismedidasb/domain/habit/habit_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HabitBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  BehaviorSubject<List<HabitModel>> _habitsController = new BehaviorSubject();

  Stream<List<HabitModel>> get habitsResult => _habitsController.stream;

  void loadData() async {
    isLoading = true;
    await Future.delayed(Duration(seconds: 1), () {
      List<HabitModel> list = HabitModel.getHabits();
      _habitsController.sinkAddSafe(list);
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _habitsController.close();
  }
}
