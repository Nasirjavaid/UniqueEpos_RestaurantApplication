import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/model/myReservationModel.dart';
import 'package:retaurant_app/model/tableBookingModel.dart';
import 'package:retaurant_app/model/tableInfoModel.dart';

abstract class MyReservationState {
  const MyReservationState();

  // @override
  // List<Object> get props => [];
}


class MyReservationToShowBookingFormState extends MyReservationState {
  final Tableinfo tableinfo;
  MyReservationToShowBookingFormState({this.tableinfo});
}
class MyReservationInProgressState extends MyReservationState {}

class CheckReserVationProgressState extends MyReservationState {}

class CheckReserVationFailureState extends MyReservationState {
  final String message;
  CheckReserVationFailureState({this.message});
}

class MyReservationStateInitialState extends MyReservationState {}

class MyReservationStateFailureState extends MyReservationState {}

class MyReservationNeedToLoginState extends MyReservationState {}

class MyReservationTableBookingResponceState extends MyReservationState {
final TableBookingModel tableBookingModel;
  MyReservationTableBookingResponceState({this.tableBookingModel});
}

class MyReservationFailedTableBookingState extends MyReservationState {
final String message;
  MyReservationFailedTableBookingState({this.message});
}

class CheckReservationStateSuccessState extends MyReservationState {
  final TableInfoModel tableInfoModel;
  final bool hasReachedMax;

  const CheckReservationStateSuccessState(
      {this.tableInfoModel, this.hasReachedMax});

  CheckReservationStateSuccessState copyWith(
      {TableInfoModel tableInfoModel, bool hasReachedMax}) {
    return CheckReservationStateSuccessState(
        tableInfoModel: tableInfoModel ?? this.tableInfoModel,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  // @override
  // List<Object> get props => [foodCategory, hasReachedMax];

  @override
  String toString() =>
      ' Check table state : ${tableInfoModel.data}, hasReachedMax : $hasReachedMax';
}

class MyReservationStateSuccessState extends MyReservationState {
  final MyReserveListModel myReserveListModel;
  final bool hasReachedMax;

  const MyReservationStateSuccessState(
      {this.myReserveListModel, this.hasReachedMax});

  MyReservationStateSuccessState copyWith(
      {MyOrdersModel myOrdersModel, bool hasReachedMax}) {
    return MyReservationStateSuccessState(
        myReserveListModel: myOrdersModel ?? this.myReserveListModel,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  // @override
  // List<Object> get props => [foodCategory, hasReachedMax];

  @override
  String toString() =>
      ' My Reservation state : ${myReserveListModel.data}, hasReachedMax : $hasReachedMax';
}
