import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/common_db/i_common_dao.dart';
import 'package:mismedidasb/domain/common_db/i_common_repository.dart';

class CommonRepository implements ICommonRepository {
  final ICommonDao _commonDao;

  CommonRepository(this._commonDao);

  @override
  Future<bool> cleanDB() async {
    return await _commonDao.cleanDB();
  }
}
