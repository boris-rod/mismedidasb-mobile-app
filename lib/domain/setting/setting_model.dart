class SettingModel {
  bool showResumeBeforeSave;
  int languageCodeId;
  String languageCode;
  bool isDarkMode;

  SettingModel(
      {this.showResumeBeforeSave,
      this.languageCode,
      this.languageCodeId,
      this.isDarkMode});
}

class SettingAPIModel {
  int settingId;
  String setting;
  String value;

  SettingAPIModel({this.settingId, this.setting, this.value});
}
