import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/passwordRecovery.dart';

class PasswordRecoveryService {
  HttpService httpService = new HttpService.internal();
  PasswordRecovery passwordRecovery;
  Future<PasswordRecovery> sendPasswordToUserEmail(String customerEmail) async {


    Map<String, String> requestBody = <String,String>{
     'customer_email':customerEmail,
  
  };


    final http.Response response =
        await httpService.postRequest(APIConstants.passwordRecoveryEndpoint,requestBody);

    if (response.statusCode == 200) {
      print("response body  in Password Recovery Service: ${response.body}");

      var json = jsonDecode(response.body);

      passwordRecovery = PasswordRecovery.fromJson(json);
    } else {
      throw Exception("Exception in Password Recovery Service: Failed to send email to user email address");
    }

    return passwordRecovery;
  }
}
