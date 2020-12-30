import 'dart:io';

import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/service/userProfileUpdateService.dart';

class UserProfileUpdateUpRepository {
  UserProfileUpdateService userProfileUpdateService =
      UserProfileUpdateService();
  Future<UserLogin> updateUserProfile(
      String userId,
      String name,
      String email,
      String oldPassword,
      String newPassword,
      String phone,
      String address,
      File profilePicturePath) async {
    UserLogin userLogin = await userProfileUpdateService.updateUserProfile(
        userId, name, email, oldPassword,newPassword, phone, address, profilePicturePath);

    return userLogin;
  }
}
