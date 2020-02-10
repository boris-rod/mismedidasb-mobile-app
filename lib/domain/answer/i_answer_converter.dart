import 'package:mismedidasb/domain/answer/answer_model.dart';

abstract class IAnswerConverter {
  AnswerModel fromJson(Map<String, dynamic> json);
}
