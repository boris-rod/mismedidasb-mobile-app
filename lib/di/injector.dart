import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mismedidasb/app_bloc.dart';
import 'package:mismedidasb/data/_shared_prefs.dart';
import 'package:mismedidasb/data/api/account_api.dart';
import 'package:mismedidasb/data/api/answer_api.dart';
import 'package:mismedidasb/data/api/contact_us_api.dart';
import 'package:mismedidasb/data/api/dish_api.dart';
import 'package:mismedidasb/data/api/health_concept_api.dart';
import 'package:mismedidasb/data/api/legacy_api.dart';
import 'package:mismedidasb/data/api/personal_data_api.dart';
import 'package:mismedidasb/data/api/poll_api.dart';
import 'package:mismedidasb/data/api/question_api.dart';
import 'package:mismedidasb/data/api/remote/network_handler.dart';
import 'package:mismedidasb/data/api/session_api.dart';
import 'package:mismedidasb/data/api/user_api.dart';
import 'package:mismedidasb/data/converter/account_converter.dart';
import 'package:mismedidasb/data/converter/answer_converter.dart';
import 'package:mismedidasb/data/converter/contact_us_converter.dart';
import 'package:mismedidasb/data/converter/dish_converter.dart';
import 'package:mismedidasb/data/converter/health_concept_converter.dart';
import 'package:mismedidasb/data/converter/legacy_converter.dart';
import 'package:mismedidasb/data/converter/personal_data_converter.dart';
import 'package:mismedidasb/data/converter/poll_converter.dart';
import 'package:mismedidasb/data/converter/question_converter.dart';
import 'package:mismedidasb/data/converter/session_converter.dart';
import 'package:mismedidasb/data/converter/user_converter.dart';
import 'package:mismedidasb/data/dao/_base/app_database.dart';
import 'package:mismedidasb/data/dao/dish_dao.dart';
import 'package:mismedidasb/data/dao/common_dao.dart';
import 'package:mismedidasb/data/dao/personal_data_dao.dart';
import 'package:mismedidasb/data/repository/account_repository.dart';
import 'package:mismedidasb/data/repository/answer_repository.dart';
import 'package:mismedidasb/data/repository/common_repository.dart';
import 'package:mismedidasb/data/repository/contact_us_repository.dart';
import 'package:mismedidasb/data/repository/dish_repository.dart';
import 'package:mismedidasb/data/repository/health_concept_repository.dart';
import 'package:mismedidasb/data/repository/legacy_repository.dart';
import 'package:mismedidasb/data/repository/personal_data_repository.dart';
import 'package:mismedidasb/data/repository/poll_repository.dart';
import 'package:mismedidasb/data/repository/question_repository.dart';
import 'package:mismedidasb/data/repository/session_repository.dart';
import 'package:mismedidasb/data/repository/user_repository.dart';
import 'package:mismedidasb/domain/account/i_account_api.dart';
import 'package:mismedidasb/domain/account/i_account_converter.dart';
import 'package:mismedidasb/domain/account/i_account_repository.dart';
import 'package:mismedidasb/domain/answer/i_answer_api.dart';
import 'package:mismedidasb/domain/answer/i_answer_converter.dart';
import 'package:mismedidasb/domain/answer/i_answer_repository.dart';
import 'package:mismedidasb/domain/common_db/i_common_dao.dart';
import 'package:mismedidasb/domain/common_db/i_common_repository.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_api.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_converter.dart';
import 'package:mismedidasb/domain/contact_us/i_contact_us_repository.dart';
import 'package:mismedidasb/domain/dish/i_dish_api.dart';
import 'package:mismedidasb/domain/dish/i_dish_converter.dart';
import 'package:mismedidasb/domain/dish/i_dish_dao.dart';
import 'package:mismedidasb/domain/dish/i_dish_repository.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_api.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_converter.dart';
import 'package:mismedidasb/domain/health_concept/i_health_concept_repository.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_api.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_converter.dart';
import 'package:mismedidasb/domain/legacy/i_legacy_repository.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_api.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_converter.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_dao.dart';
import 'package:mismedidasb/domain/personal_data/i_personal_data_repository.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_api.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_converter.dart';
import 'package:mismedidasb/domain/poll_model/i_poll_repository.dart';
import 'package:mismedidasb/domain/question/i_question_api.dart';
import 'package:mismedidasb/domain/question/i_question_converter.dart';
import 'package:mismedidasb/domain/question/i_question_repository.dart';
import 'package:mismedidasb/domain/session/i_session_api.dart';
import 'package:mismedidasb/domain/session/i_session_converter.dart';
import 'package:mismedidasb/domain/session/i_session_repository.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_converter.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/fcm/fcm_feature.dart';
import 'package:mismedidasb/fcm/i_fcm_feature.dart';
import 'package:mismedidasb/lnm/i_lnm.dart';
import 'package:mismedidasb/lnm/lnm.dart';
import 'package:mismedidasb/rt/i_real_time_container.dart';
import 'package:mismedidasb/rt/real_time_container.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/change_password/change_password_bloc.dart';
import 'package:mismedidasb/ui/contact_us/contact_us_bloc.dart';
import 'package:mismedidasb/ui/food/food_bloc.dart';
import 'package:mismedidasb/ui/food_add_edit/food_add_edit_bloc.dart';
import 'package:mismedidasb/ui/food_craving/food_craving_bloc.dart';
import 'package:mismedidasb/ui/food_dish/food_dish_bloc.dart';
import 'package:mismedidasb/ui/food_search/food_search_bloc.dart';
import 'package:mismedidasb/ui/habit/habit_bloc.dart';
import 'package:mismedidasb/ui/home/home_bloc.dart';
import 'package:mismedidasb/ui/invite_page/invite_bloc.dart';
import 'package:mismedidasb/ui/legacy/legacy_bloc.dart';
import 'package:mismedidasb/ui/login/login_bloc.dart';
import 'package:mismedidasb/ui/measure_health/measure_health_bloc.dart';
import 'package:mismedidasb/ui/measure_value/measure_value_bloc.dart';
import 'package:mismedidasb/ui/measure_wellness/measure_wellness_bloc.dart';
import 'package:mismedidasb/ui/poll_notification/poll_notification_bloc.dart';
import 'package:mismedidasb/ui/profile/profile_bloc.dart';
import 'package:mismedidasb/ui/profile_edit/profile_edit_bloc.dart';
import 'package:mismedidasb/ui/recover_password/recover_password_bloc.dart';
import 'package:mismedidasb/ui/register/register_bloc.dart';
import 'package:mismedidasb/ui/scores_page/score_bloc.dart';
import 'package:mismedidasb/ui/settings/settings_bloc.dart';
import 'package:mismedidasb/ui/splash/splash_bloc.dart';
import 'package:mismedidasb/utils/logger.dart';

///Part dependency injector engine and Part service locator.
///The main purpose of [Injector] is to provide bloCs instances and initialize the app components depending the current scope.
///To reuse a bloc instance in the widget's tree feel free to use the [BlocProvider] mechanism.
class Injector {
  ///Singleton instance
  static Injector instance;
  bool darkTheme = false;

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

  Injector._startProd() {
    _initialize();
  }

  _initialize() {
    _registerCommon();
    _registerApiLayer();
    _registerDaoLayer();
    _registerRepositoryLayer();
    _registerBloCs();
    _registerMappers();
  }

  _registerMappers() {
    container.registerSingleton<IAccountConverter, AccountConverter>(
        (c) => AccountConverter());

    container.registerSingleton<ISessionConverter, SessionConverter>(
        (c) => SessionConverter());

    container.registerSingleton<IUserConverter, UserConverter>(
        (c) => UserConverter());

    container.registerSingleton<IAnswerConverter, AnswerConverter>(
        (c) => AnswerConverter());

    container.registerSingleton<IHealthConceptConverter,
        HealthConceptConverter>((c) => HealthConceptConverter());

    container.registerSingleton<IPersonalDataConverter, PersonalDataConverter>(
        (c) => PersonalDataConverter());

    container.registerSingleton<IPollConverter, PollConverter>(
        (c) => PollConverter(container.resolve(), container.resolve()));

    container.registerSingleton<IQuestionConverter, QuestionConverter>(
        (c) => QuestionConverter(container.resolve()));

    container.registerSingleton<IDishConverter, DishConverter>(
        (c) => DishConverter());

    container.registerSingleton<ILegacyConverter, LegacyConverter>(
        (c) => LegacyConverter());

    container.registerSingleton<IContactUsConverter, ContactUsConverter>(
        (c) => ContactUsConverter());
  }

  _registerApiLayer() {
    container.registerSingleton<IAccountApi, AccountApi>(
        (c) => AccountApi(container.resolve(), container.resolve()));

    container.registerSingleton<ISessionApi, SessionApi>((c) => SessionApi(
        container.resolve(),
        container.resolve(),
        container.resolve(),
        container.resolve()));

    container.registerSingleton<IUserApi, UserApi>(
        (c) => UserApi(container.resolve(), container.resolve()));

    container.registerSingleton<IAnswerApi, AnswerApi>(
        (c) => AnswerApi(container.resolve(), container.resolve()));

    container.registerSingleton<IHealthConceptApi, HealthConceptApi>(
        (c) => HealthConceptApi(container.resolve(), container.resolve()));

    container.registerSingleton<IPersonalDataApi, PersonalDataApi>(
        (c) => PersonalDataApi(container.resolve(), container.resolve()));

    container.registerSingleton<IPollApi, PollApi>(
        (c) => PollApi(container.resolve(), container.resolve()));

    container.registerSingleton<IQuestionApi, QuestionApi>(
        (c) => QuestionApi(container.resolve(), container.resolve()));

    container.registerSingleton<IDishApi, DishApi>(
        (c) => DishApi(container.resolve(), container.resolve()));

    container.registerSingleton<ILegacyApi, LegacyApi>(
        (c) => LegacyApi(container.resolve(), container.resolve()));

    container.registerSingleton<IContactUsApi, ContactUsApi>(
        (c) => ContactUsApi(container.resolve(), container.resolve()));
  }

  _registerDaoLayer() {
    container.registerSingleton((c) => AppDatabase.instance);

    container.registerSingleton<ICommonDao, CommonDao>(
        (c) => CommonDao(container.resolve()));

    container.registerSingleton<IDishDao, DishDao>(
        (c) => DishDao(container.resolve(), container.resolve()));

    container.registerSingleton<IPersonalDataDao, PersonalDataDao>(
        (c) => PersonalDataDao(container.resolve(), container.resolve()));
  }

  _registerRepositoryLayer() {
    container.registerSingleton<IAccountRepository, AccountRepository>(
        (c) => AccountRepository(container.resolve()));

    container.registerSingleton<ICommonRepository, CommonRepository>(
        (c) => CommonRepository(container.resolve()));

    container.registerSingleton<ISessionRepository, SessionRepository>((c) =>
        SessionRepository(container.resolve(), container.resolve(),
            container.resolve(), container.resolve()));

    container.registerSingleton<IUserRepository, UserRepository>(
        (c) => UserRepository(container.resolve()));

    container.registerSingleton<IAnswerRepository, AnswerRepository>(
        (c) => AnswerRepository(container.resolve()));

    container
        .registerSingleton<IHealthConceptRepository, HealthConceptRepository>(
            (c) => HealthConceptRepository(container.resolve()));

    container.registerSingleton<IPersonalDataRepository,
            PersonalDataRepository>(
        (c) =>
            PersonalDataRepository(container.resolve(), container.resolve()));

    container.registerSingleton<IPollRepository, PollRepository>(
        (c) => PollRepository(container.resolve()));

    container.registerSingleton<IQuestionRepository, QuestionRepository>(
        (c) => QuestionRepository(container.resolve()));

    container.registerSingleton<IDishRepository, DishRepository>((c) =>
        DishRepository(
            container.resolve(), container.resolve(), container.resolve()));

    container.registerSingleton<ILegacyRepository, LegacyRepository>(
        (c) => LegacyRepository(container.resolve()));

    container.registerSingleton<IContactUsRepository, ContactUsRepository>(
        (c) => ContactUsRepository(container.resolve()));
  }

  _registerBloCs() {
    container.registerFactory((c) => AppBloC(container.resolve()));
    container.registerFactory(
        (c) => SplashBloC(container.resolve(), container.resolve()));
    container.registerFactory((c) => LoginBloC(container.resolve(),
        container.resolve(), container.resolve(), container.resolve()));
    container.registerFactory((c) => RecoverPasswordBloC(container.resolve()));
    container.registerFactory((c) => RegisterBloC(
        container.resolve(), container.resolve(), container.resolve()));
    container.registerFactory((c) => HomeBloC(
        container.resolve(),
        container.resolve(),
        container.resolve(),
        container.resolve(),
        container.resolve()));
    container.registerFactory((c) => HabitBloC(container.resolve()));
    container.registerFactory((c) => FoodCravingBloC(container.resolve()));
    container.registerFactory((c) => MeasureHealthBloC(
        container.resolve(), container.resolve(), container.resolve()));
    container.registerFactory((c) => MeasureValueBloC(container.resolve(), container.resolve()));
    container.registerFactory((c) => MeasureWellnessBloC(container.resolve(), container.resolve()));
    container.registerFactory((c) => FoodDishBloC(c.resolve(), c.resolve()));
    container.registerFactory((c) => FoodBloC(c.resolve(), c.resolve()));
    container.registerFactory((c) => FoodSearchBloC(c.resolve()));
    container.registerFactory((c) => FoodAddEditBloC(c.resolve()));
    container.registerFactory(
        (c) => ChangePasswordBloC(container.resolve(), container.resolve()));
    container.registerFactory(
        (c) => ProfileBloC(container.resolve(), container.resolve()));
    container.registerFactory(
        (c) => SettingsBloC(c.resolve(), c.resolve(), c.resolve(), c.resolve()));
    container.registerFactory((c) => LegacyBloC(c.resolve()));
    container.registerFactory((c) => ContactUsBloC(c.resolve()));
    container.registerFactory((c) => ProfileEditBloC(c.resolve(), c.resolve()));
    container.registerFactory((c) => InvitePeopleBloC(c.resolve()));
    container
        .registerFactory((c) => PollNotificationBloC(c.resolve(), c.resolve(), c.resolve()));
    container.registerFactory((c) => ScoreBloC(c.resolve()));
  }

  _registerCommon() {
    container.registerSingleton<Logger, LoggerImpl>((c) => LoggerImpl());
    container.registerSingleton((c) => SharedPreferencesManager());
    container.registerSingleton(
      (c) => NetworkHandler(container.resolve(), container.resolve()),
    );
    container.registerSingleton<IFCMFeature, FCMFeature>(
      (c) => FCMFeature(
        c.resolve(),
        c.resolve(),
        c.resolve(),
      ),
    );

    container.registerSingleton((c) => FlutterLocalNotificationsPlugin());
    container.registerSingleton<ILNM, LNM>(
        (c) => LNM(container.resolve(), container.resolve()));
    container.registerSingleton<IRealTimeContainer, RealTimeContainer>(
        (c) => RealTimeContainer(container.resolve()));
  }
}
