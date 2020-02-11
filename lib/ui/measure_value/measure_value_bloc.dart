import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';

class MeasureValueBloC extends BaseBloC with LoadingBloC, ErrorHandlerBloC {

  BehaviorSubject<int> _pageController = new BehaviorSubject();

  Stream<int> get pageResult => _pageController.stream;

  int currentPage = 0;

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
    _pageController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
