import 'dart:io';

import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/account/account_model.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

abstract class IUserRepository {
  Future<Result<UserModel>> getProfile();

  Future<Result<AppVersionModel>> getAppVersion();

  Future<Result<UserModel>> updateProfile(UserModel userModel);

  Future<Result<bool>> uploadAvatar(File photo);

  Future<Result<bool>> invite(List<String> emails);

  Future<Result<ScoreModel>> getScores();

  Future<Result<String>> stripePaymentAction(int productId, bool savePM);

  Future<Result<List<PlanifiveProductsModel>>> getPlanifiveProducts();

  Future<Result<List<CreditCardModel>>> getPaymentMethods();

  Future<Result<bool>> deletePaymentMethod(String paymentMethodId);

  Future<Result<SoloQuestionStatsModel>> getSoloQuestionStats(int daysAgo);

  Future<Result<UsernameSuggestionModel>> usernameValidation(
      int userId, String email, String username, String fullName);

  Future<Result<bool>> buySubscription(int subscriptionId);

  Future<Result<bool>> buySubscriptionsOffer1();

  Future<Result<List<SubscriptionModel>>> getSubscriptions();

  Future<Result<List<OrderModel>>> postPurchaseDetails(String verificationKey);


}
