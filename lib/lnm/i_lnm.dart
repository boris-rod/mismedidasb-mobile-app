import '../enums.dart';

abstract class ILNM {
  void setup();

  void showCommonNotification(
      {String channelId,
      String title,
      String content,
      NotificationType notificationType});

  void initReminders();

  void initPollNotificationReminders();

  void initBreakFastReminder();

  void initSnack1Reminder();

  void initLunchReminder();

  void initSnack2Reminder();

  void initDinnerReminder();

  void initDrinkWater1Reminder();

  void initDrinkWater2Reminder();

  void initPlanFoodsReminder();

  void initMakeExerciseReminder();

  void cancel(int id);

  void cancelAll();
}
