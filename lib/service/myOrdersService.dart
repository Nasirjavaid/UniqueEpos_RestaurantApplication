import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';

class MyOrdersService {
  HttpService httpService = new HttpService.internal();
  MyOrdersModel myOrdersModel;

  Future<MyOrdersModel> getMyOrders(
      int startingPoint, int maxResults, String customerId) async {
    Map<String, String> requestBody = <String, String>{
      'Customerid': customerId,
    };

    final http.Response response = await httpService.postRequest(
        APIConstants.myOrdersEndpoint, requestBody);

    if (response.statusCode == 200) {
      print("response body  in My orders Service: ${response.body}");
      var json = jsonDecode(response.body);

      myOrdersModel = MyOrdersModel.fromJson(json);
    } else {
      throw Exception("My orders service: Failed to get My orders ");
    }

    return myOrdersModel;
  }
}
