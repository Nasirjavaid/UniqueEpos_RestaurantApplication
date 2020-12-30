import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/myReservationModel.dart';

class MyReservationService {
  HttpService httpService = new HttpService.internal();
  MyReserveListModel myReserveListModel;

  Future<MyReserveListModel> getMyReservationList(
      int startingPoint, int maxResults, String customerId) async {
    Map<String, String> requestBody = <String, String>{
      'customer_id': customerId,
    };

    final http.Response response = await httpService.postRequest(
        APIConstants.myReservationEndpoint, requestBody);

    if (response.statusCode == 200) {
      print("response body  in My my reservation Service: ${response.body}");

      var json = jsonDecode(response.body);

      myReserveListModel = MyReserveListModel.fromJson(json);
    } else {
      throw Exception("My reservation service: Failed to get My reservation ");
    }

    return myReserveListModel;
  }
}
