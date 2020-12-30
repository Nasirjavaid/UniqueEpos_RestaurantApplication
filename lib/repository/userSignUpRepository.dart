import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/service/userSignUpService.dart';

class UserSignUpRepository {
  UserSignUpService userSignUpService = UserSignUpService();
  Future<UserLogin> registerNewUser(String name,
  String email,
 String password,
  String phone,
  String address) async {

    UserLogin userLogin =
        await userSignUpService.registerNewUser(name,
   email,
  password,
   phone,
   address);

    return userLogin;
  }
}
