import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/enums.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/local_notification_model.dart';
import 'package:mismedidasb/res/R.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

//final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
//    BehaviorSubject<ReceivedNotification>();
//
//final BehaviorSubject<String> selectNotificationSubject =
//    BehaviorSubject<String>();

final BehaviorSubject<bool> onPollNotificationLaunch = BehaviorSubject<bool>();

class LNM implements ILNM {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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

  LNM(this.flutterLocalNotificationsPlugin, this._sharedPreferencesManager);

  @override
  void setup() async {
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');

    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {
//          didReceiveLocalNotificationSubject.add(ReceivedNotification(
//              id: id, title: title, body: body, payload: payload));
        });

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload?.isNotEmpty == true) {
        if (payload == pollNotificationId.toString()) {
          await _sharedPreferencesManager.setBoolValue(
              SharedKey.launchNotiPoll, true);
          onPollNotificationLaunch.sinkAddSafe(true);
        }
//        onNotiTap(payload);
//        Fluttertoast.showToast(msg: payload);
//        selectNotificationSubject.add(payload);
      }
    });

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> initReminders() async {
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
//    List<PendingNotificationRequest> list =
//        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    await flutterLocalNotificationsPlugin.cancel(id);
//    List<PendingNotificationRequest> list1 =
//        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
//    print(list1.length.toString());
  }

  @override
  Future<void> initPollNotificationReminders() async {
    final exist = await checkIfPendingNotificationExist(pollNotificationId);
    final planiId = await _sharedPreferencesManager.getIntValue(SharedKey.planiId);
    if (exist) return;
    final String userName =
        await _sharedPreferencesManager.getStringValue(SharedKey.userName);
    String title = 'Hola $userName';
    String content = 'Gana puntos y déjame saber que tal te va?';
    var androidPlatformChannelSpecifics = _getCommonAndroidNotificationDetail(
        channelId: '$pollNotificationId',
        title: title,
        content: content,
        notificationType: NotificationType.POLL);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(pollNotificationId,
        title, content, Time(22, 30, 0), platformChannelSpecifics,
        payload: '$pollNotificationId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          breakFastIdReminderId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$breakFastIdReminderId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          dinnerIdReminderId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$dinnerIdReminderId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          drinkWater1Id,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$drinkWater1Id');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          drinkWater2Id,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$drinkWater2Id');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          lunchIdReminderId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$lunchIdReminderId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          makeExerciseId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$makeExerciseId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(planFoodsId, title,
          content, Time(time.hour, time.minute, time.second), platformChannelSpecifics,
          payload: '$planFoodsId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          snack1IdReminderId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$snack1IdReminderId');
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
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          snack2IdReminderId,
          title,
          content,
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$snack2IdReminderId');
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
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        channelId, title, content, platformChannelSpecifics,
        payload: channelId.toString());
  }

  @override
  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<bool> checkIfPendingNotificationExist(int notiId) async {
    List<PendingNotificationRequest> list =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
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
        importance: Importance.Max,
        priority: Priority.High,
        styleInformation: bigTextStyleInformation,
        largeIcon: DrawableResourceAndroidBitmap('logo'));
  }

//  Future<void> showNotification(
//      String channelId, String title, String content) async {
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      channelId,
//      'your channel name',
//      'your channel description',
//      importance: Importance.Max,
//      priority: Priority.High,
//      ticker: 'ticker',
//      largeIcon: DrawableResourceAndroidBitmap('logo'),
//    );
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin
//        .show(0, title, content, platformChannelSpecifics, payload: channelId);
//  }
//
//  Future<void> showInboxNotification() async {
//    var lines = List<String>();
//    lines.add('line <b>1</b>');
//    lines.add('line <i>2</i>');
//    var inboxStyleInformation = InboxStyleInformation(lines,
//        htmlFormatLines: true,
//        contentTitle: 'overridden <b>inbox</b> context title',
//        htmlFormatContentTitle: true,
//        summaryText: 'summary <i>text</i>',
//        htmlFormatSummaryText: true);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'inbox channel id', 'inboxchannel name', 'inbox channel description',
//        styleInformation: inboxStyleInformation);
//    var platformChannelSpecifics =
//    NotificationDetails(androidPlatformChannelSpecifics, null);
//    await _flutterLocalNotificationsPlugin.show(
//        0, 'inbox title', 'inbox body', platformChannelSpecifics);
//  }
//
//  Future<void> showMessagingNotification() async {
//    // use a platform channel to resolve an Android drawable resource to a URI.
//    // This is NOT part of the notifications plugin. Calls made over this channel is handled by the app
//    var messages = List<Message>();
//    // First two person objects will use icons that part of the Android app's drawable resources
//    var me = Person(
//        name: 'Me',
//        key: '1',
//        uri: 'tel:1234567890',
//        icon: FlutterBitmapAssetAndroidIcon(R.image.logo));
//    messages.add(Message(
//        '<p><span style="color: #3F51B5;">Responder</span></p>',
//        DateTime.now(),
//        null));
//    var messagingStyle = MessagingStyleInformation(me,
//        groupConversation: true,
//        conversationTitle: 'Recordatorio',
//        htmlFormatContent: true,
//        htmlFormatTitle: true,
//        messages: messages);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'message channel id',
//        'message channel name',
//        'message channel description',
//        category: 'msg',
//        styleInformation: messagingStyle);
//    var platformChannelSpecifics =
//    NotificationDetails(androidPlatformChannelSpecifics, null);
//    await _flutterLocalNotificationsPlugin.show(
//        0, 'message title', 'message body', platformChannelSpecifics);
//  }
//
//  Future<void> repeatNotification(String channelId) async {
//    final userName =
//    await _sharedPreferencesManager.getStringValue(SharedKey.userName);
//
////    var lunchBot = Person(
////      name: 'Plani',
////      key: 'bot',
////      bot: true,
////      icon: FlutterBitmapAssetAndroidIcon(R.image.logo),
////    );
////
////    List<Message> messages = [
////      Message('What\'s up?', DateTime.now().add(Duration(minutes: 5)), lunchBot)
////    ];
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//      channelId, 'repeating channel name', 'repeating description',
//      importance: Importance.Max,
//      priority: Priority.High,
//      ticker: 'ticker',
//      channelAction: AndroidNotificationChannelAction.Update,
////        styleInformation:
////            MessagingStyleInformation(lunchBot, messages: messages)
//    );
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.showDailyAtTime(
//        100,
//        'Hola $userName',
//        'Recuerda beber suficiente agua, se recomienda 2L diarios.',
//        Time(16, 57, 0),
//        platformChannelSpecifics);
//
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        101,
////        'Hola $userName',
////        'Recuerda beber suficiente agua, se recomienda 2L diarios.',
////        Time(16, 33, 0),
////        platformChannelSpecifics);
////
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        102,
////        'Hola $userName',
////        'Recuerda beber suficiente agua, se recomienda 2L diarios.',
////        Time(16, 34, 0),
////        platformChannelSpecifics);
////
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        103,
////        'Hola $userName',
////        'Recuerda planificar su comida de mañana',
////        Time(20, 30, 0),
////        platformChannelSpecifics);
//  }
//
//  Future<void> showDailyAtTime() async {
//    var time = Time(11, 49, 00);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'repeatDailyAtTime channel id',
//        'repeatDailyAtTime channel name',
//        'repeatDailyAtTime description');
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await _flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        'Recordatorio',
//        'Recuerda planificar su comida',
//        Time(11, 50, 00),
//        platformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        'Recordatorio',
//        'Recuerda planificar su comida',
//        Time(11, 51, 00),
//        platformChannelSpecifics);
//  }
//
//  Future<void> scheduleNotification() async {
//    var scheduledNotificationDateTime =
//    DateTime.now().add(Duration(seconds: 30));
////    var vibrationPattern = Int64List(4);
////    vibrationPattern[0] = 0;
////    vibrationPattern[1] = 1000;
////    vibrationPattern[2] = 5000;
////    vibrationPattern[3] = 2000;
//
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'your other channel id',
//        'your other channel name',
//        'your other channel description',
//        icon: 'logo',
////        sound: RawResourceAndroidNotificationSound('slow_spring_board'),
//        largeIcon: DrawableResourceAndroidBitmap('logo'),
////        vibrationPattern: vibrationPattern,
//        enableLights: true,
//        color: R.color.primary_color,
//        ledColor: R.color.primary_dark_color,
//        ledOnMs: 1000,
//        ledOffMs: 500);
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await _flutterLocalNotificationsPlugin.schedule(
//      0,
//      'scheduled title',
//      'scheduled body',
//      scheduledNotificationDateTime,
//      platformChannelSpecifics,
//    );
//  }
//
//  Future<void> showBigTextNotification() async {
//    String answer = '<pre>Has planificado tus comidas de ma&ntilde;na?</pre>' +
//        '<h1><span style="color: #3f51b5;">Responder</span></h1>';
//
//    var bigTextStyleInformation = BigTextStyleInformation(answer,
//        htmlFormatBigText: true,
//        contentTitle: "Hola Kiki",
//        htmlFormatContentTitle: true,
//        summaryText: '<b>Recordatorio</b>',
//        htmlFormatSummaryText: true);
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'big text channel id',
//        'big text channel name',
//        'big text channel description',
//        styleInformation: bigTextStyleInformation,
//        largeIcon: DrawableResourceAndroidBitmap('logo'));
//    var platformChannelSpecifics =
//    NotificationDetails(androidPlatformChannelSpecifics, null);
//    await _flutterLocalNotificationsPlugin.show(
//        0, "Hola Kiki", 'silent body', platformChannelSpecifics);
//  }
//
//  Future<void> showNotificationWithUpdatedChannelDescription() async {
//    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//        'your channel id',
//        'your channel name',
//        'your updated channel description',
//        importance: Importance.Max,
//        priority: Priority.High,
//        channelAction: AndroidNotificationChannelAction.Update);
//    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
//    var platformChannelSpecifics = NotificationDetails(
//        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
//    await _flutterLocalNotificationsPlugin.show(
//        0,
//        'updated notification channel',
//        'check settings to see updated channel description',
//        platformChannelSpecifics,
//        payload: 'item x');
//  }
}
