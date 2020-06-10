import 'package:flutter/material.dart';
import 'package:mismedidasb/ui/_base/bloc_state.dart';
import 'package:mismedidasb/ui/poll_notification/poll_notification_bloc.dart';

class PollNotificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PollNotificationState();
}

class _PollNotificationState
    extends StateWithBloC<PollNotificationPage, PollNotificationBloC> {
  @override
  Widget buildWidget(BuildContext context) {
    return Stack(
      children: <Widget>[

      ],
    );
  }
}
