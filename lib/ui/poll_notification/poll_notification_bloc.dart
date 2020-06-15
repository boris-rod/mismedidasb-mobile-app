import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class PollNotificationBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  final IPollRepository _iPollRepository;
  final SharedPreferencesManager _sharedPreferencesManager;

  PollNotificationBloC(this._iPollRepository, this._sharedPreferencesManager);

  void savePoll() {
    
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
