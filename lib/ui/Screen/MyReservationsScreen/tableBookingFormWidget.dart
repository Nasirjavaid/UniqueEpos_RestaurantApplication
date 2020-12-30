import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservationEvent.dart';
import 'package:retaurant_app/bloc/myReservationBloc/myReservetionBloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileBloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileState.dart';
import 'package:retaurant_app/model/userLogin.dart' as login;
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/model/tableInfoModel.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';

class TableBookingFormWidget extends StatefulWidget {
  final Tableinfo tableinfo;
  TableBookingFormWidget({this.tableinfo});
  @override
  _TableBookingFormWidgetState createState() => _TableBookingFormWidgetState();
}

class _TableBookingFormWidgetState extends State<TableBookingFormWidget> {
  bool guestUserValue = false;
  String selectedTime;
  TextEditingController etPerson = TextEditingController();
  TextEditingController etName = TextEditingController();
  TextEditingController etMobleNumber = TextEditingController();
  TextEditingController etEmailAddress = TextEditingController();
  TextEditingController etSpecialNote = TextEditingController();

  // User login object to get user data
  UserLogin userLoginObjectForTableBooking = UserLogin();

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

  @override
  void initState() {
    super.initState();

    getValueOFguestUserFromSharedPrefrences();
  }

  getValueOFguestUserFromSharedPrefrences() async {
    guestUserValue = await Methods.getGuestFromSharedPref();
    setState(() {
      return guestUserValue;
    });

    return guestUserValue;
  }

  _submitButtonPressed() {
    if (etName.text == null || etName.text == "") {
      _showToast(context, "Please Enter Name");
    } else if (etMobleNumber.text == null || etMobleNumber.text == "") {
      _showToast(context, "Please Enter Phone");
    } else if (etEmailAddress.text == null || etEmailAddress.text == "") {
      _showToast(context, "Please Enter Email Address");
    } else if (etPerson.text == null || etPerson.text == "") {
      _showToast(context, "Please Enter Address");
    } else if (selectedTime == null || selectedTime == "") {
      _showToast(context, "Please Select Leaving Time");
    } else {
      UserLogin userLoginAsGuestInfo = new UserLogin();
      login.Data data = new login.Data(
        customerName: "",
        customerPhone: "",
        customerEmail: "",
        customerAddress: "",
        customerNote: "0",
        customerId: "",
      );

      data.customerName = etName.text;
      data.customerPhone = etMobleNumber.text;
      data.customerEmail = etEmailAddress.text;

      if (userLoginObjectForTableBooking.message != null) {
        data.customerId = userLoginObjectForTableBooking.data.customerId;
      } else {
        data.customerId = "";
      }

      userLoginAsGuestInfo.data = data;

      print("Entered Name :  " + etName.text);
      print("Entered Phone : " + etMobleNumber.text);
      print("Entered Email : " + etEmailAddress.text);
      print("selected time : " + selectedTime);
      print("selected time : " + etSpecialNote.text);

      BlocProvider.of<MyReservationBloc>(context).add(
          MyReservationEventBookNewTable(
              customerId: data.customerId,
              person: widget.tableinfo.capacity,
              reserveDate: widget.tableinfo.reserveDate,
              reserveTime: widget.tableinfo.reserveTime,
              endTime: selectedTime,
              name: etName.text,
              phone: etMobleNumber.text,
              tableId: widget.tableinfo.tableID,
              email: etEmailAddress.text,
              cutomerNote: etSpecialNote.text));

      etName.clear();
      etMobleNumber.clear();
      etPerson.clear();
      etEmailAddress.clear();
      etSpecialNote.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
              userDefaultCard(),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: myMainCard(
                      "Capacity \n\n ${widget.tableinfo.capacity}",
                      Icons.people)),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: myMainCard(
                      "In Time \n\n ${widget.tableinfo.reserveTime}",
                      Icons.alarm_add_outlined)),
              SizedBox(
                height: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: myMainCard(
                      "In Date \n\n ${widget.tableinfo.reserveDate}",
                      Icons.calendar_today)),
              SizedBox(
                height: 10,
              ),
              timePickerWidget(context),
              SizedBox(
                height: 25,
              ),
              availabilityButton(context),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget userDefaultCard() {
    return BlocProvider(create: (context) {
      return UserProfileBloc()..add(GetUserDataUserProfileEvent());
    }, child: BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        //initial state is data is loading  from the repository show loading indicator
        if (state is InProgresssGettingUserProfileState) {
          return LoadingIndicator();
        }
        // If any error then show error message
        if (state is FailedTogetUserProfileData) {
          return userInfoWidget(context, userLoginObjectForTableBooking);
        }
        // if data is Successfully obtained pass to widget body
        if (state is UserProfiledetailTakenSuccessfully) {
          userLoginObjectForTableBooking = new UserLogin();
          // print(
          //     "Obtained user data in user profile  ${state.userLogin.data.customerName}");
          userLoginObjectForTableBooking = state.userLogin;

          if (!guestUserValue) {
            etName.text = userLoginObjectForTableBooking.data.customerName;
            etMobleNumber.text =
                userLoginObjectForTableBooking.data.customerPhone;
            etEmailAddress.text =
                userLoginObjectForTableBooking.data.customerEmail;
          }

          return userInfoWidget(context, state.userLogin);
        }
        //assigning the total people capacity of table  to edit text
        etPerson.text = widget.tableinfo.capacity;
        return userInfoWidget(context, userLoginObjectForTableBooking);
      },
    ));
  }

  Widget userInfoWidget(BuildContext context, UserLogin userLogin) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        nameInputFieldWidegt(context),
        SizedBox(
          height: 10,
        ),
        phoneInputFieldWidegt(context),
        SizedBox(
          height: 10,
        ),
        emailAddressInputFieldWidegt(context),
        SizedBox(
          height: 10,
        ),

        userNoteInputFieldWidegt(context),
        SizedBox(
          height: 10,
        ),
        // totalPersonsInputFieldWidegt(context),
        // SizedBox(
        //   height: 10,
        // ),
      ],
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
                    "Select Leaving",
                    FontAwesomeIcons.clock,
                  )
                : myMainCard(
                    selectedTime,
                    FontAwesomeIcons.clock,
                  )),
      ),
    );
  }

  Widget nameInputFieldWidegt(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.06,
      child: new TextField(
          controller: etName,
          expands: false,
          maxLines: 1,
          minLines: 1,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,

          //validator: _validateFirstName,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.person, color: Colors.grey),
            counterText: "",
            // filled: true,
            // fillColor: AppTheme.appDefaultColor,
            labelText: "Name",
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

  Widget phoneInputFieldWidegt(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.06,
      child: new TextField(
          controller: etMobleNumber,
          expands: false,
          maxLines: 1,
          minLines: 1,
          maxLength: 30,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,

          //validator: _validateFirstName,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone, color: Colors.grey),
            counterText: "",
            // filled: true,
            // fillColor: AppTheme.appDefaultColor,
            labelText: "Mobile Number",
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

  Widget emailAddressInputFieldWidegt(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.06,
      child: new TextField(
          controller: etEmailAddress,
          expands: false,
          maxLines: 1,
          minLines: 1,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,

          //validator: _validateFirstName,

          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email, color: Colors.grey),
            counterText: "",
            // filled: true,
            // fillColor: AppTheme.appDefaultColor,
            labelText: "Email Address",
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

  Widget userNoteInputFieldWidegt(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.1,
      child: new TextField(
          controller: etSpecialNote,
          expands: false,
          maxLines: 5,
          minLines: 3,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,

          //validator: _validateFirstName,

          decoration: InputDecoration(
            // prefixIcon: Icon(Icons.edit, color: Colors.grey),
            counterText: "",
            // filled: true,
            // fillColor: AppTheme.appDefaultColor,
            labelText: "Special Note",
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

                child: Text("Book Now",
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
