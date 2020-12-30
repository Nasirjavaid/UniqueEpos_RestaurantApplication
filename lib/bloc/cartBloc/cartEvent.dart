import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/userLogin.dart';

abstract class CartEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GettAllCartProducts extends CartEvent {}

// ignore: must_be_immutable
class AddProductTocartEvent extends CartEvent {
  Foodinfo foodinfo;
  AddProductTocartEvent({@required this.foodinfo});
}

class RemoveProductFromcartEvent extends CartEvent {
  final int index;
  RemoveProductFromcartEvent({@required this.index});
}

class IncreaseProductCountInCartEvent extends CartEvent {
  final int index;
  IncreaseProductCountInCartEvent({@required this.index});
}

class DecreaseProductCountInCartEvent extends CartEvent {
  final int index;
  DecreaseProductCountInCartEvent({@required this.index});
}

// ignore: must_be_immutable
class UpdateFoodInfoCartEvent extends CartEvent {
  Foodinfo foodinfo;
  int index;
  UpdateFoodInfoCartEvent({@required this.foodinfo, this.index});
}

class FoodProductTotalBillCartEvent extends CartEvent {
  final int index;
  FoodProductTotalBillCartEvent({this.index});
}

class SaveDataToSharedPrefrencesCartEvent extends CartEvent {}

class GetDataFromSharedPrefrencesCartEvent extends CartEvent {}

class RemoveDataFromSharedPrefrencesOfCartWhenLogout extends CartEvent {}

// ignore: must_be_immutable
class PlaceOrderCartEvent extends CartEvent {
  List<Foodinfo> foodinfoListForPlcaingOrder;
  UserLogin userLogin;
  // String customerName;
  // String customerPhone;
  // String customerEmail;
  // String customerDeliveryAddress;
  // String customerNote;

  PlaceOrderCartEvent(
      {this.foodinfoListForPlcaingOrder,
     this.userLogin});
}

class UpdateBillOnChangeOfDeliveryTypeCartEvent extends CartEvent {
  final int index;
  UpdateBillOnChangeOfDeliveryTypeCartEvent({this.index});
}
