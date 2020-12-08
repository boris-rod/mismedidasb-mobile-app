import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/local_notification_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

//final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//    BehaviorSubject<ReceivedNotification>();
//
//final BehaviorSubject<String> selectNotificationSubject =
//    BehaviorSubject<String>();

final BehaviorSubject<bool> onPollNotificationLaunch = BehaviorSubject<bool>();

class LNM implements ILNM {
  final SharedPreferencesManager _sharedPreferencesManager;

  static int breakFastIdReminderId = 111;
  static int snack1IdReminderId = 112;
  static int lunchIdReminderId = 113;
  static int snack2IdReminderId = 114;
  static int dinnerIdReminderId = 115;
  static int drinkWater1Id = 222;
  static int drinkWater2Id = 223;
  static int planFoodsId = 333;
  static int makeExerciseId = 444;
  static int pollNotificationId = 555;
  static int localCommonNoti = 11;
  static int fcmNoti = 22;

  LNM(this._sharedPreferencesManager);

  @override
  Future<void> setup() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await Injector.flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: (String payload) async {
      if (payload?.isNotEmpty == true) {
        if (payload == pollNotificationId.toString()) {
          onPollNotificationLaunch.sinkAddSafe(true);
        }
      }
    });

    Injector.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  String _currentTimeZone = "";

  Future<void> initReminders() async {
    tz.initializeTimeZones();
    _currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(_currentTimeZone));

    await initBreakFastReminder();
    await initSnack1Reminder();
    await initDrinkWater1Reminder();
    await initLunchReminder();
    await initSnack2Reminder();
    await initDinnerReminder();
    await initDrinkWater2Reminder();
    await initPlanFoodsReminder();
    await initMakeExerciseReminder();
    await initPollNotificationReminders();
  }

  @override
  Future<void> cancel(int id) async {
    await Injector.flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  Future<void> initPollNotificationReminders() async {
    final exist = await checkIfPendingNotificationExist(pollNotificationId);
    if (exist) return;
    final String userName =
        await _sharedPreferencesManager.getStringValue(SharedKey.userName);
    String title = 'Hola $userName';
    String content = 'Gana puntos y déjame saber qué tal te va.';
    var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
        channelId: '$pollNotificationId',
        title: title,
        content: content,
        notificationType: NotificationType.POLL);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(_currentTimeZone));

    await _setScheduleNotification(
        id: pollNotificationId,
        title: title,
        content: content,
        time: Time(22, 30, 0),
        notificationDetails: platformChannelSpecifics);

    // final nowDate = DateTime.now();
    // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
    //     pollNotificationId,
    //     title,
    //     content,
    //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day, 20, 00, 0)
    //         .add(Duration(days: 1)),
    //     platformChannelSpecifics,
    //     androidAllowWhileIdle: true,
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     matchDateTimeComponents: DateTimeComponents.time,
    //     payload: '$pollNotificationId');
  }

  @override
  Future<void> initBreakFastReminder() async {
    final exist = await checkIfPendingNotificationExist(breakFastIdReminderId);
    if (exist) return;
    final bool showBreakFastTime = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showBreakFastTime);
    if (showBreakFastTime) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.breakFastTime));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de tu desayuno.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$breakFastIdReminderId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: breakFastIdReminderId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     breakFastIdReminderId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$breakFastIdReminderId');
    }
  }

  @override
  Future<void> initDinnerReminder() async {
    final exist = await checkIfPendingNotificationExist(dinnerIdReminderId);
    if (exist) return;
    final bool showDinnerTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDinnerTime);
    if (showDinnerTime) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.dinnerTime));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de tu cena.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$dinnerIdReminderId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: dinnerIdReminderId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     dinnerIdReminderId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$dinnerIdReminderId');
    }
  }

  @override
  Future<void> initDrinkWater1Reminder() async {
    final exist = await checkIfPendingNotificationExist(drinkWater1Id);
    if (exist) return;
    final bool showDrinkWater =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDrinkWater);
    if (showDrinkWater) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.drinkWater1Time));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content =
          'Recuerda beber agua, se recomienda al menos 2 litros diarios.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$drinkWater1Id',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: drinkWater1Id,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     drinkWater1Id,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$drinkWater1Id');
    }
  }

  @override
  Future<void> initDrinkWater2Reminder() async {
    final exist = await checkIfPendingNotificationExist(drinkWater2Id);
    if (exist) return;
    final bool showDrinkWater =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDrinkWater);
    if (showDrinkWater) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.drinkWater2Time));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content =
          'Recuerda beber agua, se recomienda al menos 2 litros diarios.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$drinkWater2Id',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: drinkWater2Id,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     drinkWater2Id,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$drinkWater2Id');
    }
  }

  @override
  Future<void> initLunchReminder() async {
    final exist = await checkIfPendingNotificationExist(lunchIdReminderId);
    if (exist) return;
    final bool showLunchTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showLunchTime);
    if (showLunchTime) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.lunchTime));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de tu comida.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$lunchIdReminderId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: lunchIdReminderId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     lunchIdReminderId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$lunchIdReminderId');
    }
  }

  @override
  Future<void> initMakeExerciseReminder() async {
    final exist = await checkIfPendingNotificationExist(makeExerciseId);
    if (exist) return;
    final bool showPhysicalExerciseTime = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showPhysicalExerciseTime);
    if (showPhysicalExerciseTime) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.physicalExerciseTime));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de hacer tus ejercicios.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$makeExerciseId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: makeExerciseId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     makeExerciseId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$makeExerciseId');
    }
  }

  @override
  Future<void> initPlanFoodsReminder() async {
    final exist = await checkIfPendingNotificationExist(planFoodsId);
    if (exist) return;
    final bool showPlanFood =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showPlanFoods);
    if (showPlanFood) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.planFoodsTime));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Recuerda planificar tus comidas para mañana.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$planFoodsId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: planFoodsId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     planFoodsId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$planFoodsId');
    }
  }

  @override
  Future<void> initSnack1Reminder() async {
    final exist = await checkIfPendingNotificationExist(snack1IdReminderId);
    if (exist) return;
    final bool showSnack1Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack1Time);
    if (showSnack1Time) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.snack1Time));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de tu tentempié.';

      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$snack1IdReminderId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: snack1IdReminderId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     snack1IdReminderId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$snack1IdReminderId');
    }
  }

  @override
  Future<void> initSnack2Reminder() async {
    final exist = await checkIfPendingNotificationExist(snack2IdReminderId);
    if (exist) return;
    final bool showSnack2Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack2Time);
    if (showSnack2Time) {
      final DateTime time = (await _sharedPreferencesManager
          .getDateTimeValue(SharedKey.snack2Time));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      String title = 'Hola $userName';
      String content = 'Casi es tiempo de tu merienda.';
      var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
          channelId: '$snack2IdReminderId',
          title: title,
          content: content,
          notificationType: NotificationType.REMINDER);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics);

      await _setScheduleNotification(
          id: snack2IdReminderId,
          title: title,
          content: content,
          time: Time(time.hour, time.minute, time.second),
          notificationDetails: platformChannelSpecifics);

      // final nowDate = DateTime.now();
      // await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
      //     snack2IdReminderId,
      //     title,
      //     content,
      //     tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day,
      //             time.hour, time.minute, time.second)
      //         .add(Duration(days: 1)),
      //     platformChannelSpecifics,
      //     androidAllowWhileIdle: true,
      //     uiLocalNotificationDateInterpretation:
      //         UILocalNotificationDateInterpretation.absoluteTime,
      //     matchDateTimeComponents: DateTimeComponents.time,
      //     payload: '$snack2IdReminderId');
    }
  }

  @override
  Future<void> showCommonNotification(
      {int channelId = 0,
      String title = "",
      String content = "",
      NotificationType notificationType = NotificationType.GENERAL}) async {
    var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
        channelId: channelId.toString(),
        title: title,
        content: content,
        notificationType: notificationType);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await Injector.flutterLocalNotificationsPlugin.show(
        channelId, title, content, platformChannelSpecifics,
        payload: channelId.toString());
  }

  @override
  Future<void> cancelAll() async {
    await Injector.flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> checkIfPendingNotificationExist(int notiId) async {
    List<PendingNotificationRequest> list = await Injector
        .flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
    final noti = list.firstWhere((element) => element.id == notiId, orElse: () {
      return null;
    });

    return noti != null;
  }

  AndroidNotificationDetails _getCommonAndroidNotificationDetail(
      {String channelId,
      String title,
      String content,
      NotificationType notificationType}) {
    String summary = '<b>Información</b>';
    if (notificationType == NotificationType.REMINDER)
      summary = '<b>Recordatorio</b>';
    if (notificationType == NotificationType.POLL)
      summary = '<b>Cuestionario</b>';
    if (notificationType == NotificationType.REWARD)
      summary = '<b>Recompensa</b>';

    String answerBtn =
        '<p><span style="color: #3F51B5;"><b>Responder cuestionario</b></span></p>';

    var bigTextStyleInformation = BigTextStyleInformation(
      notificationType == NotificationType.POLL
          ? "$content $answerBtn"
          : content,
      contentTitle: title,
      summaryText: summary,
      htmlFormatBigText: true,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );
    return AndroidNotificationDetails(
        channelId, 'your channel name', 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        largeIcon: DrawableResourceAndroidBitmap('logo'));
  }

  Future<void> _setScheduleNotification(
      {int id,
      String title,
      String content,
      Time time,
      NotificationDetails notificationDetails}) async {
    final nowDate = DateTime.now();
    await Injector.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        content,
        tz.TZDateTime.local(nowDate.year, nowDate.month, nowDate.day, time.hour,
                time.minute, time.second)
            .add(Duration(days: 1)),
        notificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: '$id');
  }
}
