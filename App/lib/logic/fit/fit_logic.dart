import 'package:helse/services/account.dart';

class FitLogic {
  Account account;
  FitLogic(this.account);

  Future<void> sync() async {
    await Future.delayed(const Duration(seconds: 10), () {});
  }
}
