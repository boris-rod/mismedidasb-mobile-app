import 'dart:io';

import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/remote_constanst.dart';
import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/common_db/i_common_repository.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:mismedidasb/ui/settings/settings_page.dart';
import 'package:mismedidasb/utils/calendar_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

import '../../enums.dart';

class ProfileBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;
  final SharedPreferencesManager _sharedPreferencesManager;
  final ILNM lnm;

  ProfileBloC(this._iUserRepository, this._sharedPreferencesManager, this.lnm);

  BehaviorSubject<UserModel> _userController = new BehaviorSubject();

  Stream<UserModel> get userResult => _userController.stream;

  BehaviorSubject<String> _appVersionController = new BehaviorSubject();

  Stream<String> get appVersionResult => _appVersionController.stream;

  BehaviorSubject<bool> _showFirstTimeController = new BehaviorSubject();

  Stream<bool> get showFirstTimeResult => _showFirstTimeController.stream;

  SettingAction settingAction;
  String currentPassword = "";

  set updateUser(UserModel user) {
    _userController.sinkAddSafe(user);
  }

  void loadVersion()async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
//    String appName = packageInfo.appName;
//    String packageName = packageInfo.packageName;
    String version = packageInfo.version;

    _appVersionController.sinkAddSafe("Planifive => $version");
  }

  void getProfile() async {
    currentPassword = await _sharedPreferencesManager.getPassword();
    isLoading = true;
    final res = await _iUserRepository.getProfile();
    if (res is ResultSuccess<UserModel>) {
      bool hasPlani = false;
      final plani = res.value.subscriptions.firstWhere(
          (element) => element.product == RemoteConstants.subscription_virtual_assessor, orElse: () {
        return null;
      });
      if (plani != null) {
        hasPlani = CalendarUtils.compare(plani.validAt, DateTime.now()) >= 0;
      }

      await _sharedPreferencesManager.setBoolValue(
          SharedKey.hasPlaniVirtualAssesor, hasPlani);
      if (!hasPlani) {
        lnm.cancelAll();
      }

      _userController.sinkAddSafe(res.value);
      launchFirstTime();
    } else
      showErrorMessage(res);
    isLoading = false;
  }

  void updateProfile() async {}

  void uploadAvatar(File file) async {
    isLoading = true;
    final res = await _iUserRepository.uploadAvatar(file);
    if (res is ResultSuccess<bool>) {
      getProfile();
    } else {
      isLoading = false;
      showErrorMessage(res);
    }
  }

  void updatePlani(int id) async {
    _sharedPreferencesManager.setIntValue(SharedKey.planiId, id);
  }

  void removeAvatar() async {}

  void launchFirstTime() async {
    final value =
    await _sharedPreferencesManager.getBoolValue(SharedKey.firstTimeInProfile, defValue: true);
    _showFirstTimeController.sinkAddSafe(value);
  }

  void setNotFirstTime() async {
    await _sharedPreferencesManager.setBoolValue(
        SharedKey.firstTimeInProfile, false);
    _showFirstTimeController.sinkAddSafe(false);
  }

  @override
  void dispose() {
    _userController.close();
    _appVersionController.close();
    _showFirstTimeController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
