import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/foodProduct.dart';

class DashboardService {
  Future<FoodProduct> getDashvoardOffers() async {
    FoodProduct foodProduct;
    HttpService httpService = new HttpService.internal();

    final http.Response response =
        await httpService.getRequet(APIConstants.foodProductItemOfferListEndpoint);

    if (response.statusCode == 200) {
      print("response body  in DashboardServiece: ${response.body}");

      var json = jsonDecode(response.body);
    
      foodProduct = FoodProduct.fromJson(json);
    } else {
      throw Exception(
          "response body  in DashboardServiece list with ******Exception");
    }

    return foodProduct;
  }
}
