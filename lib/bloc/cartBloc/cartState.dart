import 'package:flutter/cupertino.dart';

import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';

abstract class CartState {
  const CartState();

  // @override
  // List<Object> get props => [];
}

class FetchAllFoodProductsFromCartSate extends CartState {}

class PermissionCartState extends CartState {}

class FailedToFetchAllFoodProductsFromCartSate extends CartState {}

class GetSubTotalOfFoodProductCartState extends CartState {
  final List<Foodinfo> foodinfo;

  GetSubTotalOfFoodProductCartState({@required this.foodinfo});
}

class FoodProductAlreadyAvailableCartSate extends CartState {}

class UpdateFoodProductListWhenAddingNewFoodProductState extends CartState {
  final List<Foodinfo> foodinfo;
  final int productCounter;

  const UpdateFoodProductListWhenAddingNewFoodProductState({
    this.foodinfo,
    this.productCounter
  });

  // UpdateFoodProductListWhenAddingNewFoodProductState copyWith({
  //   List<Foodinfo> foodinfo,
  // }) {
  //   return UpdateFoodProductListWhenAddingNewFoodProductState(
  //       foodinfo: foodinfo ?? this.foodinfo);
  // }
}

class CartTotalBillCartState extends CartState {
  final CartTotalBill cartTotalBill;
  const CartTotalBillCartState({this.cartTotalBill});
}

class SaveDataToSharedPrefrencesCartState extends CartState {
  final List<Foodinfo> foodinfo;

  const SaveDataToSharedPrefrencesCartState({
    this.foodinfo,
  });
}

class GettingCartDataInProcess extends CartState {}

class GetDataFromSharedPrefrencesCartState extends CartState {
  final List<Foodinfo> foodinfo;

  const GetDataFromSharedPrefrencesCartState({
    this.foodinfo,
  });
}

class OrderPlacingInProcess extends CartState {}

class FailedOrderPlacing extends CartState {}

class OrderPlacedSuccessfully extends CartState {}

class OrderPlacedReturnedRecipt extends CartState {
  final MyOrdersModel myOrdersModel;

  OrderPlacedReturnedRecipt({this.myOrdersModel});
}

class ProductCounterForMenuItems extends CartState {
  ProductCounterForMenuItems();
}
