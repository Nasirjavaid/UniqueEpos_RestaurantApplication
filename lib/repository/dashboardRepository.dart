import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/service/dashboardService.dart';

class DashboardRepository {
  Future<FoodProduct> getFoodProduct() async {
//custom delay
    // await Future.delayed(Duration(seconds: 1));

    FoodProduct foodProduct = FoodProduct();
    DashboardService dashboardService = DashboardService();
    List<Foodinfo> foodinfoOffersList = List<Foodinfo>();
    foodProduct = await dashboardService.getDashvoardOffers();

    for (int i = 0; i < foodProduct.data.foodinfo.length; i++) {
     
      if (foodProduct.data.foodinfo[i].offerIsavailable == "1") {
        double pricePercentageAsDiscount =
            (double.parse(foodProduct.data.foodinfo[i].offersRate).toDouble() /
                    100) *
                double.parse(foodProduct.data.foodinfo[i].price).toDouble();
        double productPriceAfterDiscount =
            double.parse(foodProduct.data.foodinfo[i].price).toDouble() -
                pricePercentageAsDiscount;

        foodProduct.data.foodinfo[i].foodItemDiscountedPrice =
            productPriceAfterDiscount;

        foodinfoOffersList.add(foodProduct.data.foodinfo[i]);
      }
    }

    print(
        "Data in Dashboard repository  ${foodProduct.data.foodinfo[0].productName}");

    // if (foodProduct != null) {
    //   return foodinfoOffersList;
    // }

    return foodProduct;
  }
}
