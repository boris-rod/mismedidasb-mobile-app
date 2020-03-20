import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/ui/_base/navigation_utils.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_page.dart';

class FCMAwareBody extends StatefulWidget {
  final Widget child;

  const FCMAwareBody({Key key, this.child}) : super(key: key);

  @override
  _FCMAwareBodyState createState() => _FCMAwareBodyState();
}

class _FCMAwareBodyState extends State<FCMAwareBody> {
  StreamSubscription subscription;

  @override
  void initState() {
    super.initState();
    print('Init state FCMAwareBody $this');
    final fcmFeature = Injector.instance.getDependency<IFCMFeature>();
    subscription = fcmFeature.onMessageActionBackground().listen((fcmMessage) {
      print('onFcmClicked $fcmMessage');
      if (fcmMessage?.todoId != null) {
        fcmFeature.clearBackgroundNotification();
        NavigationUtils.pushModal(
            context,
            FoodDishPage(
              fromNotificationScope: true,
            ));
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
