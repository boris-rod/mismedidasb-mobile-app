import 'dart:io';

import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/data/repository/_base_repository.dart';
import 'package:mismedidasb/domain/user/i_user_api.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/domain/user/user_model.dart';

class UserRepository extends BaseRepository implements IUserRepository {
  final IUserApi _iUserApi;

  UserRepository(this._iUserApi);

  @override
  Future<Result<UserModel>> getProfile() async {
    try {
      final result = await _iUserApi.getProfile();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<UserModel>> updateProfile(UserModel userModel) async {
    try {
      final result = await _iUserApi.updateProfile(userModel);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> uploadAvatar(File photo) async {
    try {
      final result = await _iUserApi.uploadAvatar(photo);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> invite(List<String> emails) async {
    try {
      final result = await _iUserApi.invite(emails);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<ScoreModel>> getScores() async {
    try {
      final result = await _iUserApi.getScores();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<String>> stripePaymentAction(int productId, bool savePM) async {
    try {
      final result = await _iUserApi.stripePaymentAction(productId, savePM);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<List<PlanifiveProductsModel>>> getPlanifiveProducts() async {
    try {
      final result = await _iUserApi.getPlanifiveProducts();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<List<CreditCardModel>>> getPaymentMethods() async {
    try {
      final result = await _iUserApi.getPaymentMethods();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<UsernameSuggestionModel>> usernameValidation(
      int userId, String email, String username, String fullName) async {
    try {
      final result =
          await _iUserApi.usernameValidation(userId, email, username, fullName);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<SoloQuestionStatsModel>> getSoloQuestionStats(
      int daysAgo) async {
    try {
      final result = await _iUserApi.getSoloQuestionStats(daysAgo);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<AppVersionModel>> getAppVersion() async {
    try {
      final result = await _iUserApi.getAppVersion();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> deletePaymentMethod(String paymentMethodId) async {
    try {
      final result = await _iUserApi.deletePaymentMethod(paymentMethodId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> buySubscription(int subscriptionId) async {
    try {
      final result = await _iUserApi.buySubscription(subscriptionId);
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<bool>> buySubscriptionsOffer1() async {
    try {
      final result = await _iUserApi.buySubscriptionsOffer1();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }

  @override
  Future<Result<List<SubscriptionModel>>> getSubscriptions() async {
    try {
      final result = await _iUserApi.getSubscriptions();
      return Result.success(value: result);
    } catch (ex) {
      return resultError(ex);
    }
  }
}
