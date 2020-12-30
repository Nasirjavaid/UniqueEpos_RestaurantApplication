import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userLoginBloc/loginBloc.dart';
import 'package:retaurant_app/bloc/userLoginBloc/loginEvent.dart';
import 'package:retaurant_app/bloc/userLoginBloc/loginState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/commonWidgets.dart';
import 'package:retaurant_app/ui/Containers/MainHomeContainer/mainHomeContainer.dart';
import 'package:retaurant_app/ui/Screen/ForgetPasswordScreen/forgetPasswordScreen.dart';
import 'package:retaurant_app/ui/Screen/SignUpScreen/signUpScreen.dart';

class LoginPage extends StatelessWidget {
  final UserAuthRepository userAuthRepository;

  LoginPage({Key key, this.userAuthRepository});
  // : assert(userAuthRepository != null),
  //   super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) {
          return LoginBloc(
            userAuthBloc: BlocProvider.of<UserAuthBloc>(context),
            userAuthRepository: userAuthRepository,
          );
        },
        child: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
//Animation for Slider
  AnimationController animationController;
  // final _formKey = GlobalKey();

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Methods.storeStateToSharedPref(false);
    WidgetsBinding.instance.addObserver(this);

    NetworkConnectivity.check().then((internet) {
      if (internet) {
        callCartFromSharedPrefrences();
      } else {
        //show network erro
        showMessageError("Check your network");
      }
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    // tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  _onLoginButtonPressed() {
    BlocProvider.of<LoginBloc>(context).add(
      LoginButtonPressed(
        userName: _usernameController.text,
        password: _passwordController.text,
      ),
    );
  }

  void showMessageError(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: color,
      content: new Text(
        message,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
      duration: const Duration(seconds: 5),
    ));
  }

  void callCartFromSharedPrefrences() async {
    BlocProvider.of<CartBloc>(context)
        .add(GetDataFromSharedPrefrencesCartEvent());
  }

  @override
  void dispose() {
    // BlocProvider.of<CartBloc>(context)
    //     .add(SaveDataToSharedPrefrencesCartEvent());
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      BlocProvider.of<CartBloc>(context)
          .add(SaveDataToSharedPrefrencesCartEvent());
    }

    if (state == AppLifecycleState.resumed) {
      BlocProvider.of<CartBloc>(context)
          .add(GetDataFromSharedPrefrencesCartEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(listener: (context, state) {
      if (state is LoginFailure) {
        showMessageError("${state.error}");
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return Scaffold(
        key: _scaffoldKey,
        body: Stack(children: [
          Center(
            child: ListView(
              children: [
                SizedBox(
                  height: 120,
                ),
                Column(
                  children: [
                    //Image logo
                    Center(
                      child: Container(
                          height: 100,
                          width: 100,
                          child: Image.asset('assets/images/splash.png')),
                    ),
                    SizedBox(height: 30),

                    Container(
                      child: state is LoginInProgress
                          ? CommonWidgets.progressIndicator
                          : loginText(context),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 50),
                      child: Column(
                        children: [
                          //user name field
                          userNameInputField(context),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1.0,
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.purpleAccent,
                                    Colors.redAccent
                                  ],
                                  begin: Alignment(1.0, 0.0),
                                  end: Alignment(0.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                          ),

                          SizedBox(height: 10),

                          //Password field
                          passwordInputField(context),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 1.0,
                            decoration: BoxDecoration(
                              gradient: new LinearGradient(
                                  colors: [
                                    Colors.purpleAccent,
                                    Colors.redAccent
                                  ],
                                  begin: Alignment(1.0, 0.0),
                                  end: Alignment(0.0, 1.0),
                                  stops: [0.0, 1.0],
                                  tileMode: TileMode.clamp),
                            ),
                          ),
                          SizedBox(height: 30),

                          //login button

                          loginButton(context),

                          SizedBox(height: 30),
                          forgotPasswordText(context),
                          SizedBox(height: 15),
                          registernewAccountText(context),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: continueAsGuestText(context),
              ),
            ],
          ),
        ]),
      );
    }));
  }

  Widget loginText(BuildContext context) {
    return Text("Login",
        style: Theme.of(context)
            .textTheme
            .headline6
            .copyWith(fontWeight: FontWeight.w600, color: Colors.black87));
  }

  Widget userNameInputField(BuildContext context) {
    return TextFormField(
      controller: _usernameController,
      keyboardType: TextInputType.text,

      autocorrect: false,

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
          labelText: "EMAIL",
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.w600, color: Colors.black38)

          // errorStyle: AppTypoGraphy.errorHintStyle
          ),

      validator: (String userName) {
        if (userName.isEmpty) {
          return "User Name";
        } else {
          return null;
        }
      },
    );
  }

  Widget passwordInputField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      // cursorColor: Color.fromRGBO(64, 75, 96, .9),
      keyboardType: TextInputType.text,

      autocorrect: false,

      //validator: _validateFirstName,
      maxLength: 128,
      style: TextStyle(
        color: Color.fromRGBO(64, 75, 96, .9),
        //fontFamily: ScreensFontFamlty.FONT_FAMILTY
      ),
      decoration: InputDecoration(
          counterText: "",
          // prefixIcon: Icon(
          //   Icons.lock,
          //   size: 22,
          //   color: Color(0xFF72868a),
          // ),
          //contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          // border: const OutlineInputBorder(
          //     borderSide: const BorderSide(

          //         // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 1.0),
          //     borderRadius: BorderRadius.all(Radius.circular(25))),
          enabledBorder: const OutlineInputBorder(
              borderSide: const BorderSide(
                  // color: Color.fromARGB(255, 232, 232, 232),
                  color: Colors.white,
                  width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(0))),
          // focusedBorder: const OutlineInputBorder(
          //     borderSide: const BorderSide(
          //        // color: Color.fromARGB(255, 232, 232, 232),
          //         color: Colors.white,
          //         width: 0.0),
          //     borderRadius: BorderRadius.all(Radius.circular(0))),
          labelText: "PASSWORD",
          labelStyle: Theme.of(context)
              .textTheme
              .bodyText1
              .copyWith(fontWeight: FontWeight.w600, color: Colors.black38)

          // errorStyle: AppTypoGraphy.errorHintStyle
          ),
      validator: (String password) {
        if (password.isEmpty) {
          return "password";
        } else {
          return null;
        }
      },
    );
  }

  Widget loginButton(BuildContext context) {
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
                child: Text("Sign In",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () {
                print("Login Button clicked");

                NetworkConnectivity.check().then((internet) {
                  if (internet) {
                    _onLoginButtonPressed();
                  } else {
                    //show network erro
                    showMessageError("Check your network");
                  }
                });
              }

              // showInSnackBar("Login button pressed")

              ),
        ),
      ),
    );
  }

  Widget forgotPasswordText(BuildContext context) {
//return Text("FORGOT PASSWORD?", style:  GoogleFonts.lato());
    return InkWell(
      child: Text("Forget your password?",
          style: Theme.of(context).textTheme.bodyText2.copyWith(
                color: Colors.red[900],
                decoration: TextDecoration.underline,
                decorationThickness: 2,
                decorationStyle: TextDecorationStyle.solid,
                decorationColor: Colors.red[900],
              )),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ForgetPasswordScreenMain()));
      },
    );
  }

  Widget registernewAccountText(BuildContext context) {
//return Text("FORGOT PASSWORD?", style:  GoogleFonts.lato());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't Have an Account ?",
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.black38, fontSize: 12)),
        SizedBox(
          width: 10,
        ),
        InkWell(
          highlightColor: Colors.red[100],
          child: Text("Register Now",
              style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Colors.red[900],
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.solid,
                    decorationColor: Colors.red[900],
                  )),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
        ),
      ],
    );
  }

  Widget continueAsGuestText(BuildContext context) {
//return Text("FORGOT PASSWORD?", style:  GoogleFonts.lato());
    return InkWell(
      child: Container(
        color: Colors.red[50],
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Continue as Guest",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.red[900],
                    )),
          ),
        ),
      ),
      onTap: () {
        Methods.storeGuestValueToSharedPref(true);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => MainHomeContainer()));
      },
    );
  }
}
