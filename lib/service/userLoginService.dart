import 'dart:convert';


import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/userLogin.dart';

class UserLoginService {
  Future<UserLogin> getUser(String username, password) async {
    UserLogin usersLogin;

    HttpService httpService = new HttpService.internal();
    

     Map<String, String> requestBody = <String,String>{
     'customer_email':username,
     'password':password
  };

    final http.Response response =
        await httpService.postRequest(APIConstants.userLoginEndpoint,requestBody);

    if (response.statusCode == 200) {
      print("response body  in user login: ${response.body}");

      var json = jsonDecode(response.body);

      usersLogin = UserLogin.fromJson(json);
    } else {
      throw Exception("UserLogin service: Failed to get User");
    }

    return usersLogin;
  }
}
