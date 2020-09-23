import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/poll_model/poll_model.dart';
import 'package:mismedidasb/domain/single_selection_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class FoodCravingBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final SharedPreferencesManager _sharedPreferencesManager;
  FoodCravingBloC(this._sharedPreferencesManager);

  @override
  void dispose() {
    _pollsController.close();
    _showFirstTimeController.close();
  }

  BehaviorSubject<List<TitleSubTitlesModel>> _pollsController = new BehaviorSubject();

  Stream<List<TitleSubTitlesModel>> get pollsResult => _pollsController.stream;

  BehaviorSubject<bool> _showFirstTimeController = new BehaviorSubject();

  Stream<bool> get showFirstTimeResult => _showFirstTimeController.stream;

  void loadData(int conceptId) async {
    final cravings = TitleSubTitlesModel.getCravingLiterals();
    launchFirstTime();
    _pollsController.sinkAddSafe(cravings);
  }

  void launchFirstTime() async {
    final value =
    await _sharedPreferencesManager.getBoolValue(SharedKey.firstTimeInCraving, defValue: true);
    _showFirstTimeController.sinkAddSafe(value);
  }

  void setNotFirstTime() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInCraving, false);
    _showFirstTimeController.sinkAddSafe(false);
  }
}