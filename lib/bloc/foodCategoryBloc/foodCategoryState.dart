
import 'package:retaurant_app/model/foodCategory.dart';
import 'package:retaurant_app/model/foodProduct.dart';

abstract class FoodCategoryState  {
  const FoodCategoryState();

  // @override
  // List<Object> get props => [];
}

class FoodCategoryInProgressState extends FoodCategoryState{}

class FoodCategoryInitialState extends FoodCategoryState {}

class FoodCategoryFailureState extends FoodCategoryState {}

class FoodCategorySuccessState extends FoodCategoryState {


  final FoodCategory foodCategory;
  final bool hasReachedMax;

  const FoodCategorySuccessState({this.foodCategory, this.hasReachedMax});

  FoodCategorySuccessState copyWith(
      {FoodProduct foodProduct, bool hasReachedMax}) {

    return FoodCategorySuccessState(

        foodCategory: foodProduct ?? this.foodCategory,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  // @override
  // List<Object> get props => [foodCategory, hasReachedMax];

  @override
  String toString() =>
      ' Category State : ${foodCategory.data.category[0].name}, hasReachedMax : $hasReachedMax';
}
