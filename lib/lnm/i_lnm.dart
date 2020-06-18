import 'package:flutter/material.dart';

import '../enums.dart';

abstract class ILNM {
  void setup();

  Future<void> showCommonNotification(
      {int channelId,
      String title,
      String content,
      NotificationType notificationType});

  Future<void> initReminders();

  Future<void> initPollNotificationReminders();

  Future<void> initBreakFastReminder();

  Future<void> initSnack1Reminder();

  Future<void> initLunchReminder();

  Future<void> initSnack2Reminder();

  Future<void> initDinnerReminder();

  Future<void> initDrinkWater1Reminder();

  Future<void> initDrinkWater2Reminder();

  Future<void> initPlanFoodsReminder();

  Future<void> initMakeExerciseReminder();

  Future<void> cancel(int id);

  Future<void> cancelAll();
}
