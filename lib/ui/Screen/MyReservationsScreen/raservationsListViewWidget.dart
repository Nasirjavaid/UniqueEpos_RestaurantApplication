import 'package:flutter/material.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/model/myReservationModel.dart';

class ReservationsListViewWidet extends StatefulWidget {
  final MyReserveListModel myReserveListModel;
  ReservationsListViewWidet({this.myReserveListModel});
  @override
  _ReservationsListViewWidetState createState() =>
      _ReservationsListViewWidetState();
}

class _ReservationsListViewWidetState extends State<ReservationsListViewWidet> {
  @override
  Widget build(BuildContext context) {
    return listViewWidget(context);
  }

  Widget listViewWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5, bottom: 1),
        child: ListView.builder(
            itemCount: widget.myReserveListModel.data.reserveinfo.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (widget.myReserveListModel.data.reserveinfo.length == 0) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text("No Previous Reservations.",
                      style: Theme.of(context).textTheme.bodyText1),
                ));
              } else {
                return reservationListCard(
                    context, widget.myReserveListModel.data.reserveinfo[index]);
              }
            }),
      ),
    );
  }

  Widget reservationListCard(BuildContext context, Reserveinfo reserveinfo) {
    return Container(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Table Name",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "${reserveinfo.tableName != null ? reserveinfo.tableName : "-"}",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Capacity",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "${reserveinfo.capacity != null ? reserveinfo.capacity : "-"}",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reservation Time",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "${reserveinfo.formtime != null ? reserveinfo.formtime : "-"}",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          " to ",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${reserveinfo.totime != null ? reserveinfo.totime : "-"}",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(fontWeight: FontWeight.w900),
                        )
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Reservation Date",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "${reserveinfo.reserveday != null ? reserveinfo.reserveday : "-"}",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontWeight: FontWeight.w900),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Status",
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    reserveinfo.status.contains("1")
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Text(
                              "Free",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white),
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2))),
                            child: Text(
                              "Booked",
                              style: Theme.of(context)
                                  .textTheme
                                  .button
                                  .copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: Colors.green),
                            ),
                          )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
