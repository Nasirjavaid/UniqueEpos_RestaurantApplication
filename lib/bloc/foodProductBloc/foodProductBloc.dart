import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:retaurant_app/bloc/foodProductBloc/foodProductEvent.dart';
import 'package:retaurant_app/bloc/foodProductBloc/foodProductState.dart';
import 'package:retaurant_app/repository/foodProductRepository.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class FoodProductBloc extends Bloc<FoodProductEvent, FoodProductState> {
  FoodProductRepository foodProductRepository = FoodProductRepository();

  FoodProductBloc();

  @override
  FoodProductState get initialState => FoodProductInitialState();

// Note: Overriding transform allows us to transform the Stream before mapEventToState is called.
// This allows for operations like distinct(), debounceTime(), etc... to be applied.
//Using rx DART library for this purpose
  @override
  Stream<Transition<FoodProductEvent, FoodProductState>> transformEvents(
      Stream<FoodProductEvent> events,
      TransitionFunction<FoodProductEvent, FoodProductState> transitionFn) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<FoodProductState> mapEventToState(FoodProductEvent event) async* {
    //final currentState = state;

    if (event is FoodProductEventFetched) {
      try {
        yield FoodProductInProgressState();

        final foodProduct =
            await foodProductRepository.getFoodProductById(event.categoryId);

        yield FoodProductSuccessState(
            foodProduct: foodProduct, hasReachedMax: false);

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
        yield FoodProductFailureState();
      }
    }
  }

  // bool _hasReachedMax(SalarySlipState state) =>
  //     state is SalarySlipSuccessState && state.hasReachedMax;
}
