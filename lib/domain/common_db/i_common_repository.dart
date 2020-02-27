import 'package:mismedidasb/data/api/remote/result.dart';

abstract class ICommonRepository {
  Future<Result<bool>> cleanDB();
}
