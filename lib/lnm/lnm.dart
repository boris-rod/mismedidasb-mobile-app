import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/local_notification_model.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

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
          didReceiveLocalNotificationSubject.add(ReceivedNotification(
              id: id, title: title, body: body, payload: payload));
        });

    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      if (payload?.isNotEmpty == true) {
        selectNotificationSubject.add(payload);
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

  void initReminders() async {
    initBreakFastReminder();
    initSnack1Reminder();
    initLunchReminder();
    initSnack2Reminder();
    initDinnerReminder();
    initDrinkWater1Reminder();
    initDrinkWater2Reminder();
    initPlanFoodsReminder();
    initMakeExerciseReminder();
  }

  @override
  void cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  @override
  void initPollNotificationReminders() async {
    final String userName =
        await _sharedPreferencesManager.getStringValue(SharedKey.userName);
    var androidPlatformChannelSpecifics =
        _getCommonAndroidNotificationDetail('$pollNotificationId');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        pollNotificationId,
        'Hola $userName',
        'Dejanos saber que tal te ha ido tu día.',
        Time(22, 00, 0),
        platformChannelSpecifics,
        payload: '$pollNotificationId');
  }

  @override
  void initBreakFastReminder() async {
    final bool showBreakFastTime = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showBreakFastTime);
    if (showBreakFastTime) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.breakFastTime))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$breakFastIdReminderId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          breakFastIdReminderId,
          'Hola $userName',
          'Casi es tiempo de su desayuno.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$breakFastIdReminderId');
    }
  }

  @override
  void initDinnerReminder() async {
    final bool showDinnerTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDinnerTime);
    if (showDinnerTime) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.dinnerTime))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$dinnerIdReminderId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          dinnerIdReminderId,
          'Hola $userName',
          'Casi es tiempo de su cena.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$dinnerIdReminderId');
    }
  }

  @override
  void initDrinkWater1Reminder() async {
    final bool showDrinkWater =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDrinkWater);
    if (showDrinkWater) {
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$drinkWater1Id');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          drinkWater1Id,
          'Hola $userName',
          'Recuerde beber agua, se recomienda al menos 2 litros diarios.',
          Time(11, 0, 0),
          platformChannelSpecifics,
          payload: '$drinkWater1Id');
    }
  }

  @override
  void initDrinkWater2Reminder() async {
    final bool showDrinkWater =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showDrinkWater);
    if (showDrinkWater) {
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$drinkWater2Id');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          drinkWater2Id,
          'Hola $userName',
          'Recuerde beber agua, se recomienda al menos 2 litros diarios.',
          Time(16, 0, 0),
          platformChannelSpecifics,
          payload: '$drinkWater2Id');
    }
  }

  @override
  void initLunchReminder() async {
    final bool showLunchTime =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showLunchTime);
    if (showLunchTime) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.lunchTime))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$lunchIdReminderId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          lunchIdReminderId,
          'Hola $userName',
          'Casi es tiempo de su comida.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$lunchIdReminderId');
    }
  }

  @override
  void initMakeExerciseReminder() async {
    final bool showPhysicalExerciseTime = await _sharedPreferencesManager
        .getBoolValue(SharedKey.showPhysicalExerciseTime);
    if (showPhysicalExerciseTime) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.physicalExerciseTime))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$makeExerciseId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          makeExerciseId,
          'Hola $userName',
          'Casi es tiempo de hacer sus ejercicios.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$makeExerciseId');
    }
  }

  @override
  void initPlanFoodsReminder() async {
    final bool showPlanFood =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showPlanFood);
    if (showPlanFood) {
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$planFoodsId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          planFoodsId,
          'Hola $userName',
          'Recuerde planificar sus comidas para mañana.',
          Time(22, 30, 0),
          platformChannelSpecifics,
          payload: '$planFoodsId');
    }
  }

  @override
  void initSnack1Reminder() async {
    final bool showSnack1Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack1Time);
    if (showSnack1Time) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.snack1Time))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$snack1IdReminderId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          snack1IdReminderId,
          'Hola $userName',
          'Casi es tiempo de su tentenpié.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$snack1IdReminderId');
    }
  }

  @override
  void initSnack2Reminder() async {
    final bool showSnack2Time =
        await _sharedPreferencesManager.getBoolValue(SharedKey.showSnack2Time);
    if (showSnack2Time) {
      final DateTime time = (await _sharedPreferencesManager
              .getDateTimeValue(SharedKey.snack2Time))
          .subtract(Duration(minutes: 10));
      final String userName =
          await _sharedPreferencesManager.getStringValue(SharedKey.userName);
      var androidPlatformChannelSpecifics =
          _getCommonAndroidNotificationDetail('$snack2IdReminderId');
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.showDailyAtTime(
          snack2IdReminderId,
          'Hola $userName',
          'Casi es tiempo de su merienda.',
          Time(time.hour, time.minute, time.second),
          platformChannelSpecifics,
          payload: '$snack2IdReminderId');
    }
  }

  @override
  void showCommonNotification(String title, String content) async {
    var androidPlatformChannelSpecifics =
        _getCommonAndroidNotificationDetail('common_noti');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        99, title, content, platformChannelSpecifics,
        payload: 'common_noti');
  }

  @override
  void cancelAll() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  AndroidNotificationDetails _getCommonAndroidNotificationDetail(
      String channelId) {
    return AndroidNotificationDetails(
        channelId, 'your channel name', 'your channel description',
        importance: Importance.Max,
        priority: Priority.High,
        ticker: 'ticker',
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
//        'Recuerde beber suficiente agua, se recomienda 2L diarios.',
//        Time(16, 57, 0),
//        platformChannelSpecifics);
//
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        101,
////        'Hola $userName',
////        'Recuerde beber suficiente agua, se recomienda 2L diarios.',
////        Time(16, 33, 0),
////        platformChannelSpecifics);
////
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        102,
////        'Hola $userName',
////        'Recuerde beber suficiente agua, se recomienda 2L diarios.',
////        Time(16, 34, 0),
////        platformChannelSpecifics);
////
////    await _flutterLocalNotificationsPlugin.showDailyAtTime(
////        103,
////        'Hola $userName',
////        'Recuerde planificar su comida de mañana',
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
//        'Recuerde planificar su comida',
//        Time(11, 50, 00),
//        platformChannelSpecifics);
//
//    await _flutterLocalNotificationsPlugin.showDailyAtTime(
//        0,
//        'Recordatorio',
//        'Recuerde planificar su comida',
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
