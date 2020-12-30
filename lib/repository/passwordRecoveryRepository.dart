import 'package:retaurant_app/model/passwordRecovery.dart';
import 'package:retaurant_app/service/passwordRecoveryService.dart';

class PasswordRecoveryRepository {
  PasswordRecoveryService passwordRecoveryService = PasswordRecoveryService();
  Future<PasswordRecovery> sendPasswordToUserEmail(
    String customerEmail,
  ) async {
    PasswordRecovery passwordRecovery =
        await passwordRecoveryService.sendPasswordToUserEmail(customerEmail);

    return passwordRecovery;
  }
}
