import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservationEvent.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservetionBloc.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';

class CheckReservationAvailabilityWidget extends StatefulWidget {
  @override
  _CheckReservationAvailabilityWidgetState createState() =>
      _CheckReservationAvailabilityWidgetState();
}

class _CheckReservationAvailabilityWidgetState
    extends State<CheckReservationAvailabilityWidget> {
  String selectedDate;
  String selectedTime;
  TextEditingController etPerson = TextEditingController();

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 2000),
        backgroundColor: AppTheme.appDefaultColor,
        content:
            Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  _submitButtonPressed() {
    if (etPerson.text == null || etPerson.text.isEmpty) {
      _showToast(context, "Please enter total person.");
    } else if (selectedTime == null || selectedTime.isEmpty) {
      _showToast(context, "Please select time.");
    } else if (selectedDate == null || selectedDate.isEmpty) {
         _showToast(context, "Please select date.");
    } else {
      BlocProvider.of<MyReservationBloc>(context).add(
        MyReservationEventCheckTableAvailabilty(
            person: etPerson.text,
            reserveDate: selectedDate,
            reserveTime: selectedTime),
      );
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 25,
            ),
            totalPersonsInputFieldWidegt(context),
            SizedBox(
              height: 10,
            ),
            timePickerWidget(context),
            SizedBox(
              height: 10,
            ),
            datePickerWidget(context),
            SizedBox(
              height: 30,
            ),
            availabilityButton(context),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  Widget datePickerWidget(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.grey.shade300,
      onPressed: () {
        DatePicker.showDatePicker(context, showTitleActions: true,
            // minTime: DateTime(2020, 1, 1),
            //  maxTime: DateTime(2050, 12, 30),
            onChanged: (date) {
          setState(() {
            selectedDate = DateFormat('dd-MM-yyyy').format(date).toString();
          });
        }, onConfirm: (date) {
          print('confirm $date');

          setState(() {
            selectedDate = DateFormat('dd-MM-yyyy').format(date).toString();
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        // height: MediaQuery.of(context).size.height * 0.07,
        child: Center(
            child: selectedDate == null
                ? myMainCard(
                    "Select Date",
                    FontAwesomeIcons.calendar,
                  )
                : myMainCard(
                    selectedDate,
                    FontAwesomeIcons.calendar,
                  )),
      ),
    );
  }

  Widget timePickerWidget(BuildContext context) {
    return FlatButton(
      highlightColor: Colors.grey.shade300,
      onPressed: () {
        DatePicker.showTime12hPicker(context, showTitleActions: true,
            // minTime: DateTime(2020, 1, 1),
            //  maxTime: DateTime(2050, 12, 30),
            onChanged: (time) {
          setState(() {
            selectedTime = DateFormat('hh:mm:a').format(time).toString();
          });
        }, onConfirm: (time) {
          print('confirm $time');

          setState(() {
            selectedTime = DateFormat('hh:mm:a').format(time).toString();
          });
        }, currentTime: DateTime.now(), locale: LocaleType.en);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
       // height: MediaQuery.of(context).size.height * 0.06,
        child: Center(
            child: selectedTime == null
                ? myMainCard(
                    "Select Time",
                    FontAwesomeIcons.clock,
                  )
                : myMainCard(
                    selectedTime,
                    FontAwesomeIcons.clock,
                  )),
      ),
    );
  }

  Widget totalPersonsInputFieldWidegt(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.06,
      child: new TextField(
          controller: etPerson,
          expands: false,
          maxLines: 1,
          minLines: 1,
          maxLength: 4,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,

          //validator: _validateFirstName,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.people, color: Colors.grey),
            counterText: "",
            // filled: true,
            // fillColor: AppTheme.appDefaultColor,
            labelText: "Number of People",
            labelStyle:
                TextStyle(color: AppTheme.appDefaultColor, fontSize: 12),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppTheme.appDefaultColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: AppTheme.appDefaultColor,
                width: 1.0,
              ),
            ),
          )),
    );
  }

  Widget availabilityButton(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width * 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Container(
          // margin: EdgeInsets.only(top: 0.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            gradient: new LinearGradient(
                colors: [Colors.redAccent, Colors.redAccent],
                begin: const FractionalOffset(0.0, 1.0),
                end: const FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: MaterialButton(
              highlightColor: AppTheme.appDefaultButtonSplashColor,
              splashColor: AppTheme.appDefaultButtonSplashColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),

//checking user before placing the order
                // child: guestUserValue
                //     ? Text("Sign In",
                //         style: Theme.of(context).textTheme.bodyText2.copyWith(
                //             fontWeight: FontWeight.w600, color: Colors.white))
                //     : Text("Check out",
                //         style: Theme.of(context).textTheme.bodyText2.copyWith(
                //             fontWeight: FontWeight.w600, color: Colors.white)),

                child: Text("Check Reservation",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () async {
                print("check availability button pressed");

                NetworkConnectivity.check().then((internet) {
                  if (internet) {
                    _submitButtonPressed();
                  } else {
                    //show network erro

                    Methods.showToast(context, "Check your network");
                  }
                });
              }),
        ),
      ),
    );
  }

  Widget myMainCard(
    String title,
    IconData iconData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.background,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(8),
              bottomLeft: Radius.circular(8),
              bottomRight: Radius.circular(8),
              topLeft: Radius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    iconData,
                    color: Colors.black45,
                    size: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 1,
                    height: MediaQuery.of(context).size.height * 0.03,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$title ",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 12),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_downward,
                color: Colors.black45,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
