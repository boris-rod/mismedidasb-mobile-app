import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class ScoreBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IUserRepository _iUserRepository;

  ScoreBloC(this._iUserRepository);

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
