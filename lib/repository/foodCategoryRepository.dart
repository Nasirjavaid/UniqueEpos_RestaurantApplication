import 'package:retaurant_app/model/foodCategory.dart';
import 'package:retaurant_app/service/foodCategoryService.dart';

class FoodCategoryRepository {
  Future<FoodCategory> getFoodCategory() async {


      //custom delay
    // await Future.delayed(Duration(seconds: 1));

    FoodCategory foodCategory = FoodCategory();
    FoodCategoryService foodCategoryService = FoodCategoryService();

    foodCategory = await foodCategoryService.getFoodCategory(
      0,
      0,
    );

    print("Food Category data in Repository ${foodCategory.data.category[0].name}");

    if (foodCategory != null) {
      return foodCategory;
    }
    return null;
  }
}
