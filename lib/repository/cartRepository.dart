import 'dart:convert';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/orderPlacingModel.dart';
import 'package:retaurant_app/model/orderPlacingResponceModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/service/cartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepository {
  storeCartListToCartRepository(List<Foodinfo> foodInfoCartList) async {
    SharedPreferences sharedCartList = await SharedPreferences.getInstance();

    String foodInfoCart = jsonEncode(foodInfoCartList);

    print("Food object list Stored in  shared pref :: $foodInfoCart");
    sharedCartList.setString('foodinfo', foodInfoCart);
  }

  Future<List<Foodinfo>> cartInfoStoredInsharedPrefrences() async {
    SharedPreferences sharedCartList = await SharedPreferences.getInstance();

    print(
        "Raw food info data from shared pref : ${sharedCartList.getString('foodinfo')}");
    List<Foodinfo> foodinfoList = [];
    var json;
    try {
      json = jsonDecode(sharedCartList.getString('foodinfo'));
      print("Raw food info data from shared pref  As JSON  : $json");

      if (json.length.isNegative) {
        return foodinfoList;
      } else {
        for (int i = 0; i < json.length; i++) {
          foodinfoList.add(Foodinfo.fromJson(json[i]));
//  //prices data type  conversion
//           double foodPriceCoversionFromStringToDouble =
//               double.parse(foodinfoList[i].price);
//           foodinfoList[i].foodPerItemTtotalPrice = 0;
// //calculting food per item total price
//           foodinfoList[i].foodPerItemTtotalPrice = foodinfoList[i].count *
//               foodPriceCoversionFromStringToDouble.toInt();

          print(
              "Raw food info data from shared pref  As JSON in lOoop  : ${foodinfoList[i].foodPerItemTtotalPrice}");
        }
        print(
            "Returned Food info by shared prefrences   ${foodinfoList[0].productName} ");
        return foodinfoList;
      }
    } catch (ex) {
      print("Erroe while geting data from shared prefrences : $ex");
      return foodinfoList;
    }
  }

  Future<OrderPlacingResponceModel> placeOrder(
      UserLogin userLogin, List<Foodinfo> foodInfoListFromCart) async {
    CartService cartService = CartService();
    List<OrderPlacingModel> orderPlacingModelList = List<OrderPlacingModel>();

    for (int i = 0; i < foodInfoListFromCart.length; i++) {
      OrderPlacingModel orderPlacingModel = OrderPlacingModel();
//assign product id
      orderPlacingModel.productsID =
          int.parse(foodInfoListFromCart[i].productsID).toInt();
//assign quantity
      orderPlacingModel.count = foodInfoListFromCart[i].count;

//assign varientid
      orderPlacingModel.variantid = foodInfoListFromCart[i].variantid;

//assign number of addons
      orderPlacingModel.addons = foodInfoListFromCart[i].addons;

//assign addons info list , with status true
      List<AddonsinfoOrderPlacingModel> addonsinfoOrderPlacingModelList =
          List<AddonsinfoOrderPlacingModel>();

      if (foodInfoListFromCart[i].addons != 0) {
        for (int j = 0; j < foodInfoListFromCart[i].addonsinfo.length; j++) {
          if (foodInfoListFromCart[i].addonsinfo[j].addedStatus != null &&
              foodInfoListFromCart[i].addonsinfo[j].addedStatus) {
            AddonsinfoOrderPlacingModel addonsinfoOrderPlacingModel =
                new AddonsinfoOrderPlacingModel();
//assign addons id
            addonsinfoOrderPlacingModel.addonsid =
                foodInfoListFromCart[i].addonsinfo[j].addonsid;
//assign addons price

            // addonsinfoOrderPlacingModel.addonsprice =
            //     foodInfoListFromCart[i].addonsinfo[j].addonsprice;
//assign addons quantity
            addonsinfoOrderPlacingModel.count =
                foodInfoListFromCart[i].addonsinfo[j].addOnsCount;

            addonsinfoOrderPlacingModelList.add(addonsinfoOrderPlacingModel);
          }
        }

// adding addons list
        orderPlacingModel.addonsinfo = addonsinfoOrderPlacingModelList;
      }

//Menu Options addition

      List<String> menuOptionsList = [];

      if (foodInfoListFromCart[i].selectedOptionValues != null ||
          foodInfoListFromCart[i].selectedOptionValues != "") {
        menuOptionsList.add(foodInfoListFromCart[i].selectedOptionValues);
      }

      String menuOptionsStringValue = menuOptionsList.toString().replaceAll(new RegExp(r'[\[\]]'), '');
      orderPlacingModel.menu_options = menuOptionsStringValue;

      ///menu options portion ends here
      orderPlacingModelList.add(orderPlacingModel);
    }

    OrderPlacingResponceModel orderPlacingResponceModel = await cartService
        .placeOrder(userLogin, foodInfoListFromCart, orderPlacingModelList);

    return orderPlacingResponceModel;
  }
}
