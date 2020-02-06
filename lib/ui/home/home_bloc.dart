import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class HomeBloC with LoadingBloC, ErrorHandlerBloC implements BaseBloC {
//  BehaviorSubject<bool> _loadingController = new BehaviorSubject();
//
//  Stream<bool> get isLoadingResult => _loadingController.stream;

  void asd() async {
    isLoading = true;
    try {
      Future.delayed(Duration(seconds: 3), () {
        isLoading = false;
      });
    } catch (ex) {
      onError(ex);
    }
  }

  @override
  void dispose() {
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
//    _loadingController.close();
  }
}
