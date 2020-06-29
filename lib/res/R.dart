import 'package:mismedidasb/di/injector.dart';
import 'package:mismedidasb/res/values/colors.dart';
import 'package:mismedidasb/res/values/dimens.dart';
import 'package:mismedidasb/res/values/images.dart';
import 'package:mismedidasb/res/values/text/custom_localizations_delegate.dart';
import 'package:mismedidasb/res/values/text/strings_base.dart';

class R {
  static StringsBase get string => CustomLocalizationsDelegate.stringsBase;
  static final AppImage image = AppImage();
  static final AppDimens dim = AppDimens();
  static final AppColor color =
      AppColor();
}
