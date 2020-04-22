import 'dart:ui';

import 'package:mismedidasb/domain/setting/setting_model.dart';
import 'package:rxdart/subjects.dart';

PublishSubject<SettingModel> languageCodeController = PublishSubject();

Stream<SettingModel> get languageCodeResult => languageCodeController.stream;
