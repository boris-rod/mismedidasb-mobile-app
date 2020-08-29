import 'package:mismedidasb/data/api/remote/result.dart';
import 'package:mismedidasb/domain/user/i_user_repository.dart';
import 'package:mismedidasb/ui/_base/bloc_base.dart';
import 'package:mismedidasb/ui/_base/bloc_error_handler.dart';
import 'package:mismedidasb/ui/_base/bloc_form_validator.dart';
import 'package:mismedidasb/ui/_base/bloc_loading.dart';
import 'package:rxdart/subjects.dart';
import 'package:mismedidasb/utils/extensions.dart';

class InvitePeopleBloC extends BaseBloC
    with LoadingBloC, ErrorHandlerBloC, FormValidatorBloC {
  final IUserRepository _iUserRepository;

  InvitePeopleBloC(this._iUserRepository);

  BehaviorSubject<List<String>> _emailsController = new BehaviorSubject();

  Stream<List<String>> get emailsResult => _emailsController.stream;

  BehaviorSubject<bool> _addEnableController = new BehaviorSubject();

  Stream<bool> get addEnableResult => _addEnableController.stream;

  BehaviorSubject<bool> _inviteEnabledController = new BehaviorSubject();

  Stream<bool> get inviteEnabledResult => _inviteEnabledController.stream;

  BehaviorSubject<int> _inviteController = new BehaviorSubject();

  Stream<int> get inviteResult => _inviteController.stream;

  bool invited = false;
  void loadData() {
    _emailsController.sinkAddSafe([]);
  }

  void invite() async {
    isLoading = true;
    final emails = await emailsResult.first;
    final res = await _iUserRepository.invite(emails);
    if (res is ResultSuccess<bool>) {
      invited = true;
    }
    _inviteController.sinkAddSafe(1);
    isLoading = true;
  }

  void addEmail(String email) async {
    final emails = await emailsResult.first;
    final em = emails.firstWhere(
        (element) => element == email.trim().toLowerCase(), orElse: () {
      return null;
    });

    if (em == null) {
      emails.add(email.trim().toLowerCase());
      _emailsController.sinkAddSafe(emails);
    }
    enableInvite();
  }

  void enableAdd(bool enable) async {
    _addEnableController.sinkAddSafe(enable);
  }

  void enableInvite() async {
    final emails = await emailsResult.first;
    _inviteEnabledController.sinkAddSafe(emails.isNotEmpty);
  }

  void removeEmail(String email) async {
    final emails = await emailsResult.first;
    emails.remove(emails);
    _emailsController.sinkAddSafe(emails);
    enableInvite();
  }

  @override
  void dispose() {
    _emailsController.close();
    _inviteController.close();
    _addEnableController.close();
    _inviteEnabledController.close();
    disposeLoadingBloC();
    disposeErrorHandlerBloC();
  }
}
