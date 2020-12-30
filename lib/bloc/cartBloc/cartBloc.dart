import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartState.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/model/orderPlacingResponceModel.dart';
import 'dart:async';
import 'package:retaurant_app/repository/cartRepository.dart';
import 'package:retaurant_app/repository/foodProductRepository.dart';
import 'package:retaurant_app/repository/myOrdersRepository.dart';
import '../../model/foodProduct.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  @override
  CartState get initialState => FetchAllFoodProductsFromCartSate();

  CartRepository cartRepository = CartRepository();

  List<Foodinfo> foodinfoCartList = new List<Foodinfo>();
  MyOrdersModel myOrdersModel;

  FoodProduct settings = new FoodProduct();
  FoodProductRepository foodProductRepository = new FoodProductRepository();

  int shippingInfoListIndexFormFoodInfo;

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is GettAllCartProducts) {
      if (foodinfoCartList.isEmpty) {
        yield FailedToFetchAllFoodProductsFromCartSate();
      }

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is AddProductTocartEvent) {
      settings = await Methods.getSettingsFromSharedPrefrences();
      // event.foodinfo.shippingInfoListIndexFormFoodInfo =
      //     shippingInfoListIndexFormFoodInfo;
      if (event.foodinfo.count == 0) {
        event.foodinfo.count = 1;
      }

      if (foodinfoCartList.length == 0) {
        //calculating Bill

        Foodinfo foodinfoCalulatedBill =
            calculateBillOnEventFire(foodinfo: event.foodinfo);

        //adding product to cart list
        foodinfoCartList.add(foodinfoCalulatedBill);
      } else {
        try {
          // if (event.foodinfo.offerIsavailable == "1") {
          //   index = foodinfoCartList.indexWhere(
          //     (f) => f.productsID == event.foodinfo.productsID,
          //   );
          // } else {
          //   index = foodinfoCartList.indexWhere(
          //     (f) => f.variantid == event.foodinfo.variantid,
          //   );
          // }

          int index = foodinfoCartList.indexWhere(
            (f) => f.variantid == event.foodinfo.variantid,
          );

          if (index != -1) {
            if (event.foodinfo.addons != 0) {
              //calculating Bill
              Foodinfo foodinfoCalulatedBill = calculateBillOnEventFire(
                  foodinfo: event.foodinfo,
                  shippingAddressIndex: shippingInfoListIndexFormFoodInfo);

              foodinfoCartList.add(foodinfoCalulatedBill);
            } else {
//assigning the previous counter and increasing counter by user tap
              event.foodinfo.count = foodinfoCartList[index].count + 1;

//Updating the product with no addons
              Foodinfo foodinfoCalulatedBill =
                  calculateBillOnEventFire(foodinfo: event.foodinfo);
              foodinfoCartList.removeAt(index);
              foodinfoCartList.insert(index, foodinfoCalulatedBill);
            }
          } else {
            Foodinfo foodinfoCalulatedBill =
                calculateBillOnEventFire(foodinfo: event.foodinfo);
            foodinfoCartList.add(foodinfoCalulatedBill);
          }
        } catch (ex) {
          print("Exception while adding or updaing product in cart : $ex");
        }
      }

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is UpdateFoodInfoCartEvent) {
      try {
        int indexOfProductForUpdate = foodinfoCartList.indexOf(event.foodinfo);
        foodinfoCartList.removeAt(indexOfProductForUpdate);
        //calculating bill
        Foodinfo foodinfoCalulatedBill =
            calculateBillOnEventFire(foodinfo: event.foodinfo);
        foodinfoCartList.insert(indexOfProductForUpdate, foodinfoCalulatedBill);
      } catch (ex) {
        print("Exception while  updaing product in cart : $ex");
      }

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is RemoveProductFromcartEvent) {
      print("lenght in cart at removing  ${foodinfoCartList.length}");
      foodinfoCartList.remove(event.index);

      print("state lenght in cart at removing  ${foodinfoCartList.length}");
      print(
          "Product removed from cart ${event.index}  and Cart List lenght is ${foodinfoCartList.length}");

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is IncreaseProductCountInCartEvent) {
      //incraesing product counter
      foodinfoCartList[event.index].count += 1;

      //prices data type  conversion
      double foodPriceCoversionFromStringToDouble =
          double.parse(foodinfoCartList[event.index].price);

      foodinfoCartList[event.index].foodPerItemTtotalPrice =
          foodinfoCartList[event.index].count *
              foodPriceCoversionFromStringToDouble;

      //total prices of food product after adding addons list total prices
      if (foodinfoCartList[event.index].addons == 0) {
        foodinfoCartList[event.index].foodItemTtotalPrice =
            foodinfoCartList[event.index].foodPerItemTtotalPrice;
      } else {
        foodinfoCartList[event.index].foodItemTtotalPrice =
            foodinfoCartList[event.index].addOnsListTotalPrice +
                foodinfoCartList[event.index].foodPerItemTtotalPrice;
      }

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is DecreaseProductCountInCartEvent) {
      //incraesing product counter
      foodinfoCartList[event.index].count -= 1;

      //prices data type  conversion
      double foodPriceCoversionFromStringToDouble =
          double.parse(foodinfoCartList[event.index].price);

//calculting food per item total price
      foodinfoCartList[event.index].foodPerItemTtotalPrice =
          foodinfoCartList[event.index].count *
              foodPriceCoversionFromStringToDouble;

      //total prices of food product after adding addons list total prices

      if (foodinfoCartList[event.index].addons == 0) {
        foodinfoCartList[event.index].foodItemTtotalPrice =
            foodinfoCartList[event.index].foodPerItemTtotalPrice;
      } else {
        foodinfoCartList[event.index].foodItemTtotalPrice =
            foodinfoCartList[event.index].addOnsListTotalPrice +
                foodinfoCartList[event.index].foodPerItemTtotalPrice;
      }

      // cartRepository.storeCartListToCartRepository(foodinfoCartList);
      //  foodinfoCartList = await cartRepository.cartInfoStoredInsharedPrefrences();

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is FoodProductTotalBillCartEvent) {
      shippingInfoListIndexFormFoodInfo = event.index;
      for (int i = 0; i < foodinfoCartList.length; i++) {
        foodinfoCartList[i].cartTotalBill =
            getCArtCalculations(shippingAddressIndex: event.index);
      }

      yield UpdateFoodProductListWhenAddingNewFoodProductState(
          foodinfo: foodinfoCartList);
    }

    if (event is RemoveDataFromSharedPrefrencesOfCartWhenLogout) {
      foodinfoCartList.clear();
      cartRepository.storeCartListToCartRepository(foodinfoCartList);
    }

    if (event is SaveDataToSharedPrefrencesCartEvent) {
      for (int i = 0; i < foodinfoCartList.length; i++) {
        foodinfoCartList[i].shippingInfoListIndexFormFoodInfo =
            shippingInfoListIndexFormFoodInfo;
      }
      Methods.storeStateToSharedPref(false);
      cartRepository.storeCartListToCartRepository(foodinfoCartList);
    }

    if (event is GetDataFromSharedPrefrencesCartEvent) {
      foodinfoCartList.clear();

      //yield GettingCartDataInProcess();
      // settings = await foodProductRepository.getFoodProduct();
      settings = await Methods.getSettingsFromSharedPrefrences();
      foodinfoCartList =
          await cartRepository.cartInfoStoredInsharedPrefrences();

      print(
          "Inside Bloc foodinfoCartList " + foodinfoCartList.length.toString());

      for (int i = 0; i < foodinfoCartList.length; i++) {
        foodinfoCartList[i].cartTotalBill = getCArtCalculations(
            shippingAddressIndex:
                foodinfoCartList[i].shippingInfoListIndexFormFoodInfo);
      }

      bool stateValue = await Methods.getStateFromSharedPref();
      if (stateValue) {
        if (myOrdersModel.status != null || myOrdersModel.status != "") {
          yield OrderPlacedReturnedRecipt(myOrdersModel: myOrdersModel);
          // Methods.storeStateToSharedPref(false);
        } else {
          yield UpdateFoodProductListWhenAddingNewFoodProductState(
              foodinfo: foodinfoCartList);
        }
      } else {
        yield UpdateFoodProductListWhenAddingNewFoodProductState(
            foodinfo: foodinfoCartList);
      }

      // yield UpdateFoodProductListWhenAddingNewFoodProductState(
      //     foodinfo: foodinfoCartList);
    }

    // if (event is UpdateBillOnChangeOfDeliveryTypeCartEvent) {
    //   if (event.index == null) {
    //     return;
    //   } else {
    //     for (int i = 0; i < foodinfoCartList.length; i++) {
    //       foodinfoCartList[i].cartTotalBill =
    //           getCArtCalculations(shippingAddressIndex: event.index);
    //     }
    //     print("Delivery fee event called in CartBloc ==========");
    //   }
    //   yield UpdateFoodProductListWhenAddingNewFoodProductState(
    //       foodinfo: foodinfoCartList);
    // }

    if (event is PlaceOrderCartEvent) {
      
      CartRepository cartRepository = CartRepository();
      myOrdersModel = MyOrdersModel();
      MyOrdersRepository ordersRepository = MyOrdersRepository();

      // UserLogin userLoginOrser = new UserLogin();
      // userLoginOrser.data.customerName = event.customerName;
      // userLoginOrser.data.customerPhone = event.customerPhone;
      // userLoginOrser.data.customerEmail = event.customerEmail;
      // userLoginOrser.data.favoriteDeliveryAddress = event.customerDeliveryAddress;
      // userLoginOrser.data.customerNote = event.customerNote;

      OrderPlacingResponceModel orderPlacingResponceModel =
          new OrderPlacingResponceModel();

      yield OrderPlacingInProcess();

     for (int i = 0; i < foodinfoCartList.length; i++) {
      if (foodinfoCartList[i].selectedOptionValues != null ||
          foodinfoCartList[i].selectedOptionValues != "") {
        //  menuOptionsList.add(foodInfoListFromCart[i].selectedOptionValues);

        var finalResult;
        if (foodinfoCartList[i].selectedOptionValues != "[]") {
          final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
          final input = '${foodinfoCartList[i].selectedOptionValues}';
          final result = regExp
              .allMatches(input)
              .map((m) => m.group(1))
              // .map((String item) => item.replaceAll(new RegExp(r'(((?:\[)?([[^\]]*?\](?:,?))(?:\?)))'), ''));
              .map(
                  (String item) => item.replaceAll(new RegExp(r'[\[\],]'), ''));

          print(
              "Test  in cart srivice while placing order${result.toString().replaceAll("(", "").replaceAll(")", "")}");

          finalResult =
              result.toString().replaceAll("(", "").replaceAll(")", "");

          foodinfoCartList[i].selectedOptionValues = finalResult;
        }
      }
    }

      orderPlacingResponceModel =
          await cartRepository.placeOrder(event.userLogin, foodinfoCartList);

      if (orderPlacingResponceModel.data != null) {
        foodinfoCartList.clear();
        cartRepository.storeCartListToCartRepository(foodinfoCartList);

        //   await Future.delayed(Duration(seconds: 2));

        yield OrderPlacedSuccessfully();
        //get order  from my order api

        myOrdersModel = await ordersRepository.getMyOrderByOrderId(
            orderiD: orderPlacingResponceModel.data.orderID.toString(),
            guestId: orderPlacingResponceModel.data.customer_id.toString());
        // await Future.delayed(Duration(seconds: 2));
        if (myOrdersModel != null) {
          yield OrderPlacedReturnedRecipt(myOrdersModel: myOrdersModel);
          await Future.delayed(Duration(seconds: 5));
          yield UpdateFoodProductListWhenAddingNewFoodProductState(
              foodinfo: foodinfoCartList);
        } else {
          await Future.delayed(Duration(seconds: 2));
          yield UpdateFoodProductListWhenAddingNewFoodProductState(
              foodinfo: foodinfoCartList);
        }
      } else {
        yield FailedOrderPlacing();
        // await Future.delayed(Duration(seconds: 2));
        yield UpdateFoodProductListWhenAddingNewFoodProductState(
            foodinfo: foodinfoCartList);
      }
    }
  }

  Foodinfo calculateBillOnEventFire(
      {Foodinfo foodinfo, int shippingAddressIndex}) {
    if (foodinfo.addons != 0) {
      double foodPriceCoversionFromStringToDouble =
          double.parse(foodinfo.price);
      foodinfo.foodPerItemTtotalPrice =
          foodPriceCoversionFromStringToDouble * foodinfo.count;

      foodinfo.foodItemTtotalPrice =
          foodinfo.foodPerItemTtotalPrice + foodinfo.addOnsListTotalPrice;
    } else {
//calculating Bill
      double foodPriceCoversionFromStringToDouble =
          double.parse(foodinfo.price);
      foodinfo.foodPerItemTtotalPrice =
          foodPriceCoversionFromStringToDouble * foodinfo.count;

      foodinfo.foodItemTtotalPrice = foodinfo.foodPerItemTtotalPrice;
    }

    return foodinfo;
  }

  CartTotalBill getCArtCalculations({int shippingAddressIndex}) {
    double subTotalbloc = 0;
    double deliveryFeebloc = 0;
    double discountBloc = 0;
    CartTotalBill cartTotalBill = CartTotalBill(
        subTotal: 0,
        deliveryFee: 0,
        totalBill: 0,
        disccount: 0,
        currency: "",
        currencyIcon: "",
        restaurantvat: "",
        vatAmount: 0);

    for (int i = 0; i < foodinfoCartList.length; i++) {
      //prices data type  conversion
      double foodPriceCoversionFromStringToDouble =
          double.parse(foodinfoCartList[i].price);

//calculting food per item total price
      foodinfoCartList[i].foodPerItemTtotalPrice =
          foodinfoCartList[i].count * foodPriceCoversionFromStringToDouble;

      print(
          "Food per item total prices  ${foodinfoCartList[i].foodPerItemTtotalPrice}");

//Sub total is defined here

      if (foodinfoCartList[i].addons != 0) {
        double tempSubTotal = foodinfoCartList[i].addOnsListTotalPrice +
            foodinfoCartList[i].foodPerItemTtotalPrice;
        subTotalbloc += tempSubTotal;
      } else {
        print(
            "without addons prices cart food per itrm here ${foodinfoCartList[i].foodPerItemTtotalPrice}");

        subTotalbloc += foodinfoCartList[i].foodPerItemTtotalPrice;
      }

//Calculating Discount
      if (foodinfoCartList[i].offerIsavailable == "1") {
        double pricePercentageAsDiscount =
            (double.parse(foodinfoCartList[i].offersRate).toDouble() / 100) *
                double.parse(foodinfoCartList[i].price).toDouble();
        // double productPriceAfterDiscount =
        //     double.parse(foodinfoCartList[i].price).toDouble() -
        //         pricePercentageAsDiscount;

        discountBloc += pricePercentageAsDiscount * foodinfoCartList[i].count;

        // foodinfoCartList[i].price =
        //     productPriceAfterDiscount * foodinfoCartList[i].count;
      }
    }

    try {
//Inserting these values to main cart total bill class

      cartTotalBill.currencyIcon = settings.data.currencyIcon;
      cartTotalBill.currency = settings.data.currency;
      cartTotalBill.shippinginfo = settings.data.shippinginfo;
      cartTotalBill.restaurantvat = settings.data.restaurantvat;
// vat calculation for cart with sub total
      double actualVatWitSubTotalCalculation =
          (double.parse(settings.data.restaurantvat).toDouble() / 100) *
              subTotalbloc;
//assign subtotal and
      cartTotalBill.subTotal = subTotalbloc;
      cartTotalBill.vatAmount = actualVatWitSubTotalCalculation;

//calculating delivery fee

      if (shippingInfoListIndexFormFoodInfo != null) {
        deliveryFeebloc = calculateDeliveryFee(
            settings.data.shippinginfo, shippingInfoListIndexFormFoodInfo);
      } else {
        deliveryFeebloc = calculateDeliveryFee(
            settings.data.shippinginfo, shippingAddressIndex);
      }

      //calculating dissscount
      cartTotalBill.disccount = discountBloc;

      cartTotalBill.deliveryFee = deliveryFeebloc;
      cartTotalBill.totalBill = subTotalbloc +
          deliveryFeebloc +
          actualVatWitSubTotalCalculation -
          discountBloc;

// bill after disscount
      return cartTotalBill;
    } catch (ex) {
      print("Exception in cart total bill portion :$ex");
    }

    return cartTotalBill;
  }

  double calculateDeliveryFee(List<Shippinginfo> shippinInfoList, int index) {
    if (index != null) {
      double deliveryFeeValue =
          double.parse(shippinInfoList[index].shippingrate);

      print("Shipping rate in function 'calculateDeliveryFee' : " +
          shippinInfoList[index].shippingrate);
      return deliveryFeeValue;
    } else {
      return 0;
    }
  }
}
