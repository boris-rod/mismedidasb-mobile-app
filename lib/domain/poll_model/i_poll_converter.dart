import 'package:mismedidasb/domain/poll_model/poll_model.dart';

abstract class IPollConverter {
  PollModel fromJson(Map<String, dynamic> json);
}
