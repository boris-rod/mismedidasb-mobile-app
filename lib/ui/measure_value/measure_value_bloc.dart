import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';

class MeasureValueBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {
  void loadMeasures() async {
    isLoading = true;
    try {
      Future.delayed(Duration(seconds: 1), () {
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
  }
}
