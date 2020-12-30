import 'package:retaurant_app/model/tableInfoModel.dart';

abstract class MyReservationEvent {
  // @override
  // List<Object> get props => [];
}

class MyReservationEventFetched extends MyReservationEvent {}

class MyReservationEventCheckTableAvailabilty extends MyReservationEvent {
  final String person;
  final String reserveDate;
  final String reserveTime;
  MyReservationEventCheckTableAvailabilty(
      {this.person, this.reserveDate, this.reserveTime});
}

class MyReservationEventToShowForm extends MyReservationEvent {}

class MyReservationEventToShowBookingForm extends MyReservationEvent {

  final Tableinfo tableinfo;

  MyReservationEventToShowBookingForm({this.tableinfo});
}


class MyReservationEventBookNewTable extends MyReservationEvent {
  final String customerId;
  final String person;
  final String reserveDate;
  final String reserveTime;
  final String endTime;
  final String name;
  final String phone;
  final String tableId;
  final String email;
  final String cutomerNote;
  MyReservationEventBookNewTable(
      {this.customerId,
      this.person,
      this.reserveDate,
      this.reserveTime,
      this.endTime,
      this.name,
      this.phone,
      this.tableId,
      this.email,this.cutomerNote});
}
