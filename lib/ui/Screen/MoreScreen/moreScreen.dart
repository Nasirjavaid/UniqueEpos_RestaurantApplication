import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/ui/Screen/MyOrdersScreen/myOrdersScreen.dart';
import 'package:retaurant_app/ui/Screen/UserProfileScreen/userProfileScreen.dart';
import 'package:retaurant_app/ui/Screen/WebViewContainerScreen/webViewContainer.dart';
import '../../../main.dart';

class MoreScreen extends StatefulWidget {
  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with WidgetsBindingObserver {
  UserAuthRepository userAuthRepository = UserAuthRepository();
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool guestUserValue = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    callCartFromSharedPrefrences();
    getValueOFguestUserFromSharedPrefrences();
  }

  void callCartFromSharedPrefrences() async {
    BlocProvider.of<CartBloc>(context)
        .add(GetDataFromSharedPrefrencesCartEvent());
  }

  @override
  void dispose() {
    // BlocProvider.of<CartBloc>(_scaffoldKey.currentContext)
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
      // you need data here on screen
    }
  }

  getValueOFguestUserFromSharedPrefrences() async {
    guestUserValue = await Methods.getGuestFromSharedPref();
    setState(() {
      return guestUserValue;
    });

    return guestUserValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: AppTheme.background1, body: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          InkWell(
            child: myMainCard(
              "Profile",
              FontAwesomeIcons.user,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserProfileScreen(),
                ),
              );
            },
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyOrdersScreen(),
                ),
              );
            },
            child: myMainCard(
              "My orders",
              FontAwesomeIcons.list,
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartBloc>(context)
                  .add(SaveDataToSharedPrefrencesCartEvent());

              NetworkConnectivity.check().then((internet) {
                if (internet) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                          "https://unique-itsolutions.co.uk/restaurant-demo/new/about",
                          "About us"),
                    ),
                  );
                } else {
                  //show network erro

                  Methods.showToast(context, "Check your network");
                }
              });
            },
            child: myMainCard(
              "About us",
              FontAwesomeIcons.addressBook,
            ),
          ),
          InkWell(
            onTap: () {
              BlocProvider.of<CartBloc>(context)
                  .add(SaveDataToSharedPrefrencesCartEvent());

              NetworkConnectivity.check().then((internet) {
                if (internet) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewContainer(
                          "https://unique-itsolutions.co.uk/restaurant-demo/new/contact",
                          "Contact us"),
                    ),
                  );
                } else {
                  //show network erro

                  Methods.showToast(context, "Check your network");
                }
              });
            },
            child: myMainCard(
              "Contact us",
              FontAwesomeIcons.mailBulk,
            ),
          ),
          Builder(builder: (BuildContext context) {
            if (guestUserValue) {
              return InkWell(
                child: myMainCard(
                  "Login",
                  FontAwesomeIcons.powerOff,
                ),
                onTap: () {
                  Methods.storeGuestValueToSharedPref(false);
                  BlocProvider.of<CartBloc>(context)
                      .add(SaveDataToSharedPrefrencesCartEvent());

                  BlocProvider.of<UserAuthBloc>(context).add(AuthLoggedOut());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => App(
                        userRepository: userAuthRepository,
                      ),
                    ),
                  );
                },
              );
            } else {
              return InkWell(
                onTap: () {
                  Methods.storeGuestValueToSharedPref(false);
                  BlocProvider.of<UserAuthBloc>(context).add(AuthLoggedOut());
                  BlocProvider.of<CartBloc>(context)
                      .add(RemoveDataFromSharedPrefrencesOfCartWhenLogout());
                },
                child: myMainCard(
                  "Logout",
                  FontAwesomeIcons.powerOff,
                ),
              );
            }
          })
        ],
      ),
    );
  }

  Widget myMainCard(
    String title,
    IconData iconData,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.black45,
                size: 18,
              )
            ],
          ),
        ),
      ),
    );
  }
}
