import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/foodProduct.dart';

class FoodProductService {
  Future<FoodProduct> getFoodProduct() async {
    FoodProduct foodProduct;

    HttpService httpService = new HttpService.internal();

    final http.Response response =
        await httpService.getRequet(APIConstants.foodProductListEndpoint);

    if (response.statusCode == 200) {
      print("response body  in Food product List service: ${response.body}");

      var json = jsonDecode(response.body);
      foodProduct = FoodProduct.fromJson(json);
    } else {
      throw Exception(
          "Food Product List Service: Failed to get Food product list");
    }

    return foodProduct;
  }

  Future<FoodProduct> getFoodProductById(String categoryId) async {
    FoodProduct foodProduct;
    HttpService httpService = new HttpService.internal();

    Map<String, String> requestBody = <String, String>{
      'CategoryID': categoryId
    };

    final http.Response response = await httpService.postRequest(
        APIConstants.foodProductListByCategoryIdEndpoint, requestBody);

    print("status code ${response.statusCode}");

    if (response.statusCode == 200) {
      print(
          "response body  in Food product List service by id : ${response.body}");

      var json = jsonDecode(response.body);

      foodProduct = FoodProduct.fromJson(json);

      print(
          "response body  in Food product List service by id : ${foodProduct.data.foodinfo[0].productName}");
    } else {
      throw Exception(
          "Food Product List Service by id: Failed to get Food product list");
    }

    return foodProduct;
  }
}
