import 'dart:ui';

import 'package:rxdart/subjects.dart';

class GlobalBloC {
  PublishSubject<Locale> _languageController = PublishSubject();

  Stream<Locale> get languageResult => _languageController.stream;

  void disposeControllers() {
    _languageController.close();
  }
}
