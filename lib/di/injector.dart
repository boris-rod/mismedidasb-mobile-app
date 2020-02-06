
import 'package:kiwi/kiwi.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_bloc.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_bloc.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_bloc.dart';
import 'package:mismedidasb/ui/splash/splash_bloc.dart';
import 'package:mismedidasb/utils/logger.dart';

///Part dependency injector engine and Part service locator.
///The main purpose of [Injector] is to provide bloCs instances and initialize the app components depending the current scope.
///To reuse a bloc instance in the widget's tree feel free to use the [BlocProvider] mechanism.
class Injector {
  ///Singleton instance
  static Injector instance;

  Container container = Container();

  ///Is the app in debug mode?
  bool isInDebugMode() {
    var debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  ///returns the current instance of the logger
//  Logger getLogger() => container.resolve();

  ///returns a new bloc instance
  T getNewBloc<T extends BaseBloC>() => container.resolve();

//  NetworkHandler get networkHandler => container.resolve();
//
//  SharedPreferencesManager get sharedP => container.resolve();

  T getDependency<T>() => container.resolve();

  static initProd() {
    if (instance == null) {
      instance = Injector._startProd();
    }
  }

  Injector._startDemo() {
    _registerDemo();
    _initialize();
  }

  Injector._startProd() {
    _registerProd();
    _initialize();
  }

  _initialize() {
    _registerCommon();
    _registerBloCs();
    _registerMappers();
  }

  _registerDemo() {

  }

  _registerProd() {

  }

  _registerMappers() {
  }

  _registerBloCs() {
    container.registerFactory((c) => SplashBloC());
    container.registerFactory((c) => HomeBloC());
    container.registerFactory((c) => MeasureHealthBloC());
    container.registerFactory((c) => MeasureValueBloC());
    container.registerFactory((c) => MeasureWellnessBloC());
  }

  _registerCommon() {
    container.registerSingleton<Logger, LoggerImpl>((c) => LoggerImpl());
    container.registerSingleton((c) => SharedPreferencesManager());
    container.registerSingleton(
          (c) => NetworkHandler(container.resolve(), container.resolve()),
    );
  }
}
