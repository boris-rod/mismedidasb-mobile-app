import 'package:rxdart/rxdart.dart';
import 'package:mismedidasb/utils/extensions.dart';

class LoadingBloC{
  BehaviorSubject<bool> _loadingController = BehaviorSubject();

  Stream<bool> get isLoadingStream => _loadingController.stream;

  bool get isLoading => _loadingController.value;

  set isLoading(bool loading) {
    _loadingController.sinkAddSafe(loading);
  }

  void disposeLoadingBloC() {
    _loadingController.close();
  }
}