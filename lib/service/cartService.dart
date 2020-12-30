import 'dart:convert';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/http/httpService.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/orderPlacingModel.dart';
import 'package:retaurant_app/model/orderPlacingResponceModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/config/methods.dart';

class CartService {
  Future<OrderPlacingResponceModel> placeOrder(
      UserLogin userLogin,
      List<Foodinfo> foodInfoListFromCart,
      List<OrderPlacingModel> orderPlacingModelList) async {
    List<String> menuOptionsList = [];
    HttpService httpService = new HttpService.internal();
    OrderPlacingResponceModel orderPlacingResponceModel =
        new OrderPlacingResponceModel();

    double deliveryFee = foodInfoListFromCart[0].cartTotalBill.deliveryFee;
    //int discount = foodInfoListFromCart[0].cartTotalBill.disccount;
    double total = foodInfoListFromCart[0].cartTotalBill.subTotal;
    double grandTotal = foodInfoListFromCart[0].cartTotalBill.totalBill;
    double vatAmount = foodInfoListFromCart[0].cartTotalBill.vatAmount;
    double disccount = foodInfoListFromCart[0].cartTotalBill.disccount;

  
    int deliveryOptionsIndex =
        foodInfoListFromCart[0].shippingInfoListIndexFormFoodInfo;
    String deliveryType;
    String isShipping;

    if (deliveryOptionsIndex != null) {
      deliveryType = foodInfoListFromCart[0]
          .cartTotalBill
          .shippinginfo[deliveryOptionsIndex]
          .shippingName;

      //shipping confirmation
      isShipping = "1";
    } else {
      //shipping confirmation
      isShipping = "0";
    }
/////////////////////////////////////////////////
    //this is writter just remove brackets from Options menu list
   
    ////////////////////////////////////

    // var jsonEncodedMenuOptionsListAsString = menuOptionsList.toString();
    // print(
    //   "menuOptionsList as string  list  $jsonEncodedMenuOptionsListAsString");
  var jsonEncodedFoodObjectsList = jsonEncode(orderPlacingModelList);
    print(
        "Json encoded list of Order placiing object list  $jsonEncodedFoodObjectsList");

    Map<String, dynamic> requestBody = <String, dynamic>{
      'customer_id': userLogin.data.customerId.toString(),
      'full_name': userLogin.data.customerName.toString(),
      'email': userLogin.data.customerEmail.toString(),
      'password': userLogin.data.password.toString(),
      'phone': userLogin.data.customerPhone.toString(),
      'billing_address': userLogin.data.customerAddress.toString(),
      'address2': userLogin.data.customerAddress.toString(),
      'SubtotalTotal': total.toString(),
      'grandtotal': grandTotal.toString(),
      'ordre_notes': userLogin.data.customerNote.toString(),
      'City': "Not available",
      'District': "Not Available",
      'postcode': "",
      'ISshiping': isShipping.toString(),
      'CartData': jsonEncodedFoodObjectsList,
      'Pay_type': "Cash Payment",
      'invoice_discount': disccount.toString(),
      'service_charge': deliveryFee.toString(),
      'vat': vatAmount.toString(),
      'shippingdate': Methods.getSytemCurrenDateAndTime(),
      'shipping_type': deliveryType.toString(),
    };

    final response = await httpService.postRequest(
        APIConstants.orderPlaceEndpoint, requestBody);

    print("status code ${response.statusCode}");

    try {
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        orderPlacingResponceModel = OrderPlacingResponceModel.fromJson(json);

        print("response body  in cartService : $json");
        return orderPlacingResponceModel;
      }
    } catch (ex) {
      print("Error while placing order $ex");
      return orderPlacingResponceModel;
    }
    return orderPlacingResponceModel;
  }
}
