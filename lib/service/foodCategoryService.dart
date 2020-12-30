import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/foodCategory.dart';

class FoodCategoryService {
  HttpService httpService = new HttpService.internal();
  FoodCategory foodCategory;
  Future<FoodCategory> getFoodCategory(int startingPoint, int maxResults) async {
    final http.Response response =
        await httpService.getRequet(APIConstants.foodCategoryListEndpoint);

    if (response.statusCode == 200) {
      print("response body  in Food category Service: ${response.body}");

      var json = jsonDecode(response.body);

      foodCategory = FoodCategory.fromJson(json);
    } else {
      throw Exception("FoodCategory service: Failed to get Food Category");
    }

    return foodCategory;
  }
}
