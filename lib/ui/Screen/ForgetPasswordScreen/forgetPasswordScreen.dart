import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/passwordRecoveryBloc/passwordReciveryBloc.dart';
import 'package:retaurant_app/bloc/passwordRecoveryBloc/passwordRecoveryEvent.dart';
import 'package:retaurant_app/bloc/passwordRecoveryBloc/passwordRecoveryState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/ui/CommomWidgets/commonWidgets.dart';

class ForgetPasswordScreenMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: BlocProvider(
            create: (context) => PasswordRecoveryBloc(),
            child: ForgetPasswordScreen()));
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController etEmail = TextEditingController();
  onRegisterButtonPressed() {
    BlocProvider.of<PasswordRecoveryBloc>(context)
        .add(PasswordRecoveryButtonPressed(etEmail.text));
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 5000),
        backgroundColor: AppTheme.appDefaultColor,
        content:
            Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
      backgroundColor: AppTheme.background1,
      appBar: AppBar(
        title:
            Text("Forget Password", style: Theme.of(context).textTheme.button),
      ),
      body: _buildBody(context),
    ));
  }

  Widget _buildBody(BuildContext context) {
    return BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
        listener: (context, state) {
      if (state is PasswordRecoveryFailure) {
        _showToast(context, "${state.error}");
      }
      if (state is PasswordRecoveryInProgress) {
        return Center(
          child: CommonWidgets.progressIndicator,
        );
      }
      if (state is PasswordRecoveryInSuccess) {
        _showToast(context, "${state.message}");
      }
      if (state is PasswordRecoverySuccessAndGoToLoginScreen) {
        Navigator.pop(context);
      }
    }, child: BlocBuilder<PasswordRecoveryBloc, PasswordRecoveryState>(
            builder: (context, state) {
      return SingleChildScrollView(
        child: Container(
            child: Padding(
          padding: const EdgeInsets.only(top: 100.0, right: 20, left: 20),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 18.0, bottom: 1, right: 18, left: 18),
                  child: Text(
                    "Please type you email address !",
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(fontWeight: FontWeight.w900),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14.0, horizontal: 25),
                  child: emailInputField(context),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 28.0),
                  child: Center(
                      child: state is PasswordRecoveryInProgress
                          ? CommonWidgets.progressIndicator
                          : submitButton(context)),
                ),
              ],
            ),
          ),
        )),
      );
    }));
  }

  Widget emailInputField(BuildContext context) {
    return TextFormField(
      controller: etEmail,
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      autocorrect: false,

      //controller: firstNameTextController,
      //validator: _validateFirstName,
      maxLength: 128,
      style: TextStyle(
        color: Colors.black54,
        //fontFamily: ScreensFontFamlty.FONT_FAMILTY
      ),
      decoration: InputDecoration(
          counterText: "",
          // prefixIcon: Icon(
          //   Icons.person,
          //   size: 22,
          //   color: Color(0xFF72868a),
          // ),
          // contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          // border: const OutlineInputBorder(
          //     borderSide: const BorderSide(
          //         // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 1.0),
          //     borderRadius: BorderRadius.all(Radius.circular(25))),
          // enabledBorder: const OutlineInputBorder(
          //     borderSide: const BorderSide(
          //         // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 1.0),
          //     borderRadius: BorderRadius.all(Radius.circular(25))),
          // focusedBorder: const OutlineInputBorder(
          //     borderSide: const BorderSide(
          //         // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 1.0),
          //     borderRadius: BorderRadius.all(Radius.circular(25))),
          // errorBorder: const OutlineInputBorder(
          //     borderSide: const BorderSide(
          //         // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 1.0),
          //     borderRadius: BorderRadius.all(Radius.circular(25))),
          labelText: "Email",
          labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
              fontWeight: FontWeight.w600, color: Colors.black38, fontSize: 14)

          // errorStyle: AppTypoGraphy.errorHintStyle
          ),

      validator: (String email) {
        if (email.isEmpty) {
          return "Email";
        } else {
          return null;
        }
      },
    );
  }

  Widget submitButton(BuildContext context) {
    return SizedBox(
      height: 40,
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
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 82.0),
                child: Text("Submit",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () {
                NetworkConnectivity.check().then((internet) {
                  if (internet) {
                    onRegisterButtonPressed();
                  } else {
                    //show network erro

                    Methods.showToast(context, "Check your network");
                  }
                });
              }

              // showInSnackBar("Login button pressed")

              ),
        ),
      ),
    );
  }
}
