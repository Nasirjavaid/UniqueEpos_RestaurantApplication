import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:retaurant_app/bloc/foodCategoryBloc/foodCategoryEvent.dart';
import 'package:retaurant_app/bloc/foodCategoryBloc/foodCategoryState.dart';
import 'package:retaurant_app/model/foodCategory.dart';

import 'package:retaurant_app/repository/foodCategoryRepository.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {


  FoodCategoryBloc();
  FoodCategoryRepository foodCategoryRepository = FoodCategoryRepository();

  @override
  FoodCategoryState get initialState => FoodCategoryInitialState();

// Note: Overriding transform allows us to transform the Stream before mapEventToState is called.
// This allows for operations like distinct(), debounceTime(), etc... to be applied.
//Using rx DART library for this purpose
  @override
  Stream<Transition<FoodCategoryEvent, FoodCategoryState>> transformEvents(
      Stream<FoodCategoryEvent> events,
      TransitionFunction<FoodCategoryEvent, FoodCategoryState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FoodCategoryState> mapEventToState(FoodCategoryEvent event) async* {
    //final currentState = state;

    if (event is FoodCategoryEventFetched) {
      try {
        yield FoodCategoryInProgressState();
        FoodCategory foodCategory = FoodCategory();

        foodCategory = await foodCategoryRepository.getFoodCategory();

        if (foodCategory.data.category != null) {
          yield FoodCategorySuccessState(
              foodCategory: foodCategory, hasReachedMax: false);
        }

        if (foodCategory.data.category == null) {
          yield FoodCategoryFailureState();
        }

// if current state is success then get next 20 results and add into the previous list
        // if (currentState is FoodCategorySuccessState) {
        //   final foodCategory = await foodCategoryRepository.getFoodCategory(
        //       );

        //   yield foodCategory.isEmpty
        //       ? currentState.copyWith(hasReachedMax: true)
        //       : FoodCategorySuccessState(
        //           salarySlipList: currentState.salarySlipList + salarySlipList,
        //           hasReachedMax: false);
        // }
      } catch (_) {
        yield FoodCategoryFailureState();
      }
    }
  }

  // bool _hasReachedMax(SalarySlipState state) =>
  //     state is SalarySlipSuccessState && state.hasReachedMax;
}
