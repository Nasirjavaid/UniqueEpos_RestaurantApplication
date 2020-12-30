import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/model/userLogin.dart';

class UserProfileUpdateService {
  Future<UserLogin> updateUserProfile(
      String userId,
      String name,
      String email,
      String oldPassword,
      String newPassword,
      String phone,
      String address,
      File profilePicturePath) async {
    UserLogin usersLogin = new UserLogin();
    Dio dio = new Dio();
    // HttpService httpService = new HttpService.internal();

    // Map<dynamic, String> requestBody = <dynamic, String>{
    //   'Customerid': userId,
    //   'customer_name': name,
    //   'UserPicture':await http.MultipartFile.fromPath("field", profilePicturePath.path),
    //   'email': email,
    //   'mobile': phone,
    //   'Address': address,
    //   //'password': password,
    // };
    FormData formdata = FormData.fromMap({
      "UserPicture": profilePicturePath.path != ""
          ? await MultipartFile.fromFile(profilePicturePath.path,
              filename: basename(profilePicturePath.path))
          : null,
      'Customerid': userId,
      'customer_name': name,
      'email': email,
      'mobile': phone,
      'Address': address,
      'password': newPassword == null ? "" : newPassword,
      'oldpassword': oldPassword == null ? "" : oldPassword,
    });

    //final http.Response response = await httpService.postRequest(
    //  APIConstants.userProfileUpdateEndpoint, formdata);

    Response response = await dio.post(
      APIConstants.userProfileUpdateEndpoint,
      data: formdata,
      onSendProgress: (int sent, int total) {
        // String percentage = (sent / total * 100).toStringAsFixed(2);
      },
    );

    if (response.statusCode == 200) {
      print("response body  in user Profile update Service: ${response.data}");
      var json = jsonDecode(response.toString());
      if (json['data'] is List) {
        usersLogin.message = json['message'];
        usersLogin.status = json['status'];
      } else {
        usersLogin = UserLogin.fromJson(json);
      }
    } else if (response.statusCode == 400) {
      var json = jsonDecode(response.data);
      print("response body  in Profile update Service: ${response.data}");

      if (json['data'] is List) {
        usersLogin.message = json['data'];
        usersLogin.status = json['status'];
      }

      // usersLogin = UserLogin.fromJson(json);
    } else {
      throw Exception("UserProfileUpdate service: Failed to Register new User");
    }

    return usersLogin;
  }
}
