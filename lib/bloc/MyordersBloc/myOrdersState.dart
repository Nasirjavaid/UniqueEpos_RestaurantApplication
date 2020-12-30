import 'package:retaurant_app/model/myOrdersModel.dart';

abstract class MyOrdersState  {
  const MyOrdersState();

  // @override
  // List<Object> get props => [];
}

class MyOrdersStateInProgressState extends MyOrdersState{}

class MyOrdersStateInitialState extends MyOrdersState {}

class MyOrdersStateFailureState extends MyOrdersState {}

class MyOrdersStateSuccessState extends MyOrdersState {


  final MyOrdersModel myOrdersModel;
  final bool hasReachedMax;

  const MyOrdersStateSuccessState({this.myOrdersModel, this.hasReachedMax});

  MyOrdersStateSuccessState copyWith(
      {MyOrdersModel myOrdersModel, bool hasReachedMax}) {

    return MyOrdersStateSuccessState(

        myOrdersModel: myOrdersModel ?? this.myOrdersModel,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  // @override
  // List<Object> get props => [foodCategory, hasReachedMax];

  @override
  String toString() =>
      ' My orders state : ${myOrdersModel.data}, hasReachedMax : $hasReachedMax';
}
