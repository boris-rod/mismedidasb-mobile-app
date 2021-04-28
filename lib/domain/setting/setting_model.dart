class SettingModel {
  bool showResumeBeforeSave;
  int languageCodeId;
  String languageCode;
  String heightUnit;
  String weightUnit;
  bool isDarkMode;
  bool showBreakFastNoti;
  bool showSnack1Noti;
  bool showLunchNoti;
  bool showSnack2Noti;
  bool showDinnerNoti;
  bool showDrinkWaterNoti;
  bool showPlanFoodsNoti;
  DateTime breakfastTime;
  DateTime snack1Time;
  DateTime lunchTime;
  DateTime snack2Time;
  DateTime dinnerTime;
  DateTime drinkWaterTime;
  DateTime planFoodsTime;

  SettingModel(
      {this.showResumeBeforeSave,
      this.showDrinkWaterNoti,
      this.drinkWaterTime,
      this.languageCode,
      this.languageCodeId,
      this.isDarkMode,
      this.showBreakFastNoti,
      this.showSnack1Noti,
      this.showLunchNoti,
      this.showSnack2Noti,
      this.showDinnerNoti,
      this.showPlanFoodsNoti,
      this.breakfastTime,
      this.snack1Time,
      this.planFoodsTime,
      this.lunchTime,
      this.snack2Time,
      this.dinnerTime,
      this.heightUnit,
      this.weightUnit});
}

class SettingAPIModel {
  int settingId;
  String setting;
  String value;

  SettingAPIModel({this.settingId, this.setting, this.value});
}
