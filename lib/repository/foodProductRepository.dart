import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/service/foodProductService.dart';

class FoodProductRepository {

  Future<FoodProduct> getFoodProduct() async {
    
//custom delay
   // await Future.delayed(Duration(seconds: 1));

    FoodProduct foodProduct = FoodProduct();
    FoodProductService foodProductService = FoodProductService();

    foodProduct = await foodProductService.getFoodProduct();

    // print(
    //     "User profile screen data in userProfile repositiry ${foodProduct.data.currency}");

    if (foodProduct != null) {
      return foodProduct;
    }
    return null;
  }

  Future<FoodProduct> getFoodProductById(String categoryId) async {
    //custom delay
    //await Future.delayed(Duration(seconds: 1));

    FoodProduct foodProduct = FoodProduct();
    FoodProductService foodProductService = FoodProductService();

    foodProduct = await foodProductService.getFoodProductById(categoryId);

    print(
        "User profile screen data in userProfile repositiry ${foodProduct.data}");
    return foodProduct;
  }
}
