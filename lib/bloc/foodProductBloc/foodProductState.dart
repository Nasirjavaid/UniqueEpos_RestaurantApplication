
import 'package:retaurant_app/model/foodProduct.dart';

abstract class FoodProductState  {
  const FoodProductState();

  // @override
  // List<Object> get props => [];
}

class FoodProductInProgressState extends FoodProductState{}

class FoodProductInitialState extends FoodProductState {}

class FoodProductFailureState extends FoodProductState {}

class FoodProductSuccessState extends FoodProductState {


  final FoodProduct foodProduct;
  final bool hasReachedMax;

  const FoodProductSuccessState({this.foodProduct, this.hasReachedMax});

  FoodProductSuccessState copyWith(
      {FoodProduct foodProduct, bool hasReachedMax}) {

    return FoodProductSuccessState(

        foodProduct: foodProduct ?? this.foodProduct,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  // @override
  // List<Object> get props => [foodProduct, hasReachedMax];

  @override
  String toString() =>
      'LeaveSummaryListSuccessState : ${foodProduct.data.foodinfo[0].productName}, hasReachedMax : $hasReachedMax';
}
