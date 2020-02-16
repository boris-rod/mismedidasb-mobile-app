import 'dart:async';

export 'package:mismedidasb/utils/extensions.dart';

extension SafeSink<T> on StreamController<T> {
  void sinkAddSafe(T value) {
    if (!this.isClosed) this.sink.add(value);
  }
}
