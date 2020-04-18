import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class SettingsBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final SharedPreferencesManager _sharedPreferencesManager;

  SettingsBloC(this._sharedPreferencesManager);

  BehaviorSubject<SettingModel> _settingsController = new BehaviorSubject();

  Stream<SettingModel> get settingsResult => _settingsController.stream;

  void initData() async {
    final settingModel = SettingModel();
    final showResumeBeforeSave =
        await _sharedPreferencesManager.getShowDailyResume();

    settingModel.showResumeBeforeSave = showResumeBeforeSave;

    _settingsController.sinkAddSafe(settingModel);
  }

  void setShowResumeBeforeSave(bool value) async {
    final currentSetting = await settingsResult.first;
    currentSetting.showResumeBeforeSave = value;
    await _sharedPreferencesManager.setShowDailyResume(value);
    _settingsController.sinkAddSafe(currentSetting);
  }

  @override
  void dispose() {
    _settingsController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
