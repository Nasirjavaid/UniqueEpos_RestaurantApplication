import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservationEvent.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservetionBloc.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/model/tableInfoModel.dart';
import 'package:retaurant_app/ui/CommomWidgets/roundedImageViewWithoutBorderDynamic.dart';

class TableInfoListWidget extends StatefulWidget {
  final TableInfoModel tableInfoModel;
  TableInfoListWidget({this.tableInfoModel});
  @override
  _TableInfoListWidgetState createState() => _TableInfoListWidgetState();
}

class _TableInfoListWidgetState extends State<TableInfoListWidget> {
  @override
  Widget build(BuildContext context) {
    return listViewWidget(context);
  }

  _onShowTableBookingFormButtonPressed(Tableinfo tableinfo) {
    BlocProvider.of<MyReservationBloc>(context).add(
      MyReservationEventToShowBookingForm(tableinfo:tableinfo),
    );
  }

  Widget listViewWidget(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5, bottom: 1),
        child: ListView.builder(
            itemCount: widget.tableInfoModel.data.tableinfo.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (widget.tableInfoModel.data.tableinfo.length == 0) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text("No Table Found",
                      style: Theme.of(context).textTheme.bodyText1),
                ));
              } else {
                return reservationListCard(
                    context, widget.tableInfoModel.data.tableinfo[index]);
              }
            }),
      ),
    );
  }

  Widget reservationListCard(BuildContext context, Tableinfo tableinfo) {
    return Container(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RoundedCornerImageViewWithoutBorderDynamic(
                    height: 100,
                    width: 100,
                    borderWidth: 0.1,
                    imageLink: tableinfo.tableImage,
                    cornerRadius: 5),
                SizedBox(
                  width: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.61,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
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
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.44,
                          // ),
                          Text(
                            "${tableinfo.tableName != null ? tableinfo.tableName : "-"}",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.w900, fontSize: 16),
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
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width * 0.48,
                          // ),
                          Text(
                            "${tableinfo.capacity != null ? tableinfo.capacity : "-"}",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontWeight: FontWeight.w900, fontSize: 16),
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
                                "${tableinfo.reserveTime != null ? tableinfo.reserveTime : "-"}",
                                style: Theme.of(context)
                                    .textTheme
                                    .button
                                    .copyWith(fontWeight: FontWeight.w900),
                              ),

                              // Text(
                              //   " to ",
                              //   style: Theme.of(context).textTheme.bodyText1,
                              // ),
                              // SizedBox(
                              //   width: 5,
                              // ),
                              // Text(
                              //   "${reserveinfo.totime !=null ? reserveinfo.totime : "-"}",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .button
                              //       .copyWith(fontWeight: FontWeight.w900),
                              // )
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
                            "${tableinfo.reserveDate != null ? tableinfo.reserveDate : "-"}",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontWeight: FontWeight.w900),
                          )
                        ],
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "Status",
                      //       style: Theme.of(context).textTheme.bodyText2,
                      //     ),
                      //     Text(
                      //       "${reserveinfo.status !=null ? reserveinfo.status :"-"}",
                      //       style: Theme.of(context).textTheme.button.copyWith(
                      //           fontWeight: FontWeight.w900, color: Colors.red),
                      //     )
                      //   ],
                      // )
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: tableBookingDialogueBox(context,tableinfo),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tableBookingDialogueBox(BuildContext context,Tableinfo tableinfo) {
    return InkWell(
      onTap: () {
        _onShowTableBookingFormButtonPressed(tableinfo);
      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: AppTheme.appDefaultColor,
            borderRadius: BorderRadius.all(Radius.circular(3))),
        child: Text(
          "Book Now",
          style: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
