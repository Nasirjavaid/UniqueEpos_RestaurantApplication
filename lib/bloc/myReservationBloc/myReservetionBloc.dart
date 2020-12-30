import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservationEvent.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservationState.dart';
import 'package:retaurant_app/model/myReservationModel.dart';
import 'package:retaurant_app/model/tableBookingModel.dart';
import 'package:retaurant_app/model/tableInfoModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/myReservationRepository.dart';
import 'package:retaurant_app/repository/tableInfoRepository.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';

class MyReservationBloc extends Bloc<MyReservationEvent, MyReservationState> {
  MyReservationRepository myReservationRepository =
      new MyReservationRepository();
  UserLogin userLogin = UserLogin();
  TableInfoRepository tableInfoRepository = TableInfoRepository();

  UserAuthRepository userAuthRepository = new UserAuthRepository();
  TableInfoModel tableInfoModel = TableInfoModel();
  MyReserveListModel myReserveListModel = MyReserveListModel();

  @override
  MyReservationState get initialState => MyReservationStateInitialState();

  @override
  Stream<MyReservationState> mapEventToState(MyReservationEvent event) async* {
    try {
      if (event is MyReservationEventFetched) {
        userLogin = await userAuthRepository.getUserDataFromSharedPrefrences();

        if (userLogin == null) {
          yield MyReservationNeedToLoginState();
        } else {
          myReserveListModel =
              await myReservationRepository.getMyReservationList();

          yield MyReservationInProgressState();
          await Future.delayed(Duration(milliseconds: 500));

          if (myReserveListModel.data.reserveinfo.length != 0) {
            yield MyReservationStateSuccessState(
                myReserveListModel: myReserveListModel);
          } else {
            yield MyReservationStateFailureState();
          }
        }
      }

      if (event is MyReservationEventToShowForm) {
        yield MyReservationStateFailureState();
      }

      if (event is MyReservationEventCheckTableAvailabilty) {
        yield CheckReserVationProgressState();
        tableInfoModel = await tableInfoRepository.getTableInfo(
            event.person, event.reserveDate, event.reserveTime);

        if (tableInfoModel.data.tableinfo.length != 0) {
          for (int i = 0; i < tableInfoModel.data.tableinfo.length; i++) {
            tableInfoModel.data.tableinfo[i].reserveDate = event.reserveDate;
            tableInfoModel.data.tableinfo[i].reserveTime = event.reserveTime;
          }
          yield CheckReservationStateSuccessState(
              tableInfoModel: tableInfoModel);
        } else {
          yield CheckReserVationFailureState(message: tableInfoModel.message);
        }
      }

      if (event is MyReservationEventToShowBookingForm) {
        yield MyReservationToShowBookingFormState(tableinfo: event.tableinfo);
      }

      if (event is MyReservationEventBookNewTable) {
        yield MyReservationInProgressState();
        TableBookingModel tableBookingModel = TableBookingModel();

        tableBookingModel = await tableInfoRepository.bookNewTable(
            event.customerId,
            event.person,
            event.reserveDate,
            event.reserveTime,
            event.endTime,
            event.name,
            event.phone,
            event.tableId,
            event.email,event.cutomerNote);

        if (tableBookingModel.status == "failed") {
          yield MyReservationFailedTableBookingState(
              message: tableBookingModel.message);
        }
        if (tableBookingModel.status == "success") {
          yield MyReservationTableBookingResponceState(
              tableBookingModel: tableBookingModel);
         // await Future.delayed(Duration(seconds: 3));
          myReserveListModel =
              await myReservationRepository.getMyReservationList();
          yield MyReservationInProgressState();

          if (myReserveListModel.data.reserveinfo.length != 0) {
            yield MyReservationStateSuccessState(
                myReserveListModel: myReserveListModel);
          } else {
            yield MyReservationStateFailureState();
          }
        } else {
          yield CheckReservationStateSuccessState(
              tableInfoModel: tableInfoModel);
        }
      }
    } catch (ex) {
      print("Exception in My Reservation Bloc $ex");
      yield MyReservationStateFailureState();
    }
  }
}
