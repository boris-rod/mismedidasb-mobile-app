import 'package:mismedidasb/domain/answer/answer_model.dart';

abstract class IAnswerApi {
  Future<List<AnswerModel>> getAnswerList(int questionId);
}
