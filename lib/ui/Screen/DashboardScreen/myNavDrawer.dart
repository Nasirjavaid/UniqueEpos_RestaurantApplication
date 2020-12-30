import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileBloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileState.dart';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/circulerImageView.dart';
import 'package:retaurant_app/ui/CommomWidgets/commonWidgets.dart';
import 'package:retaurant_app/ui/Screen/MyOrdersScreen/myOrdersScreen.dart';
import 'package:retaurant_app/ui/Screen/MyReservationsScreen/myReservationsScreen.dart';
import 'package:retaurant_app/ui/Screen/UserProfileScreen/userProfileScreen.dart';
import 'package:retaurant_app/ui/Screen/UserProfileScreen/userProfileUpdateScreen.dart';
import 'package:retaurant_app/ui/Screen/WebViewContainerScreen/webViewContainer.dart';
import '../../../main.dart';
import 'myNavDrawerItems.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';

class MyNaveDrawerMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) {
          return UserProfileBloc()..add(GetUserDataUserProfileEvent());
        },
        child: MyNavDrawer(context),
      ),
    );
  }
}

class MyNavDrawer extends StatefulWidget {
  final BuildContext context;
  MyNavDrawer(this.context);

  @override
  _MyNavDrawerState createState() => _MyNavDrawerState();
}

class _MyNavDrawerState extends State<MyNavDrawer> {
  final UserAuthRepository userAuthRepository = UserAuthRepository();

  bool guestUserValue = false;
  String userImagePlaceHolder =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7e/Circle-icons-profile.svg/768px-Circle-icons-profile.svg.png";

  @override
  void initState() {
    getValueOFguestUserFromSharedPrefrences();
    super.initState();
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(0), topRight: Radius.circular(0)),
        color: Colors.white,
        // boxShadow: [
        //   BoxShadow(color: Colors.green, spreadRadius: 3),
        // ],
      ),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width * 0.75,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.

      child: Column(
        // Important: Remove any padding from the ListView
        // padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(height: 0),
          // rawer header
          DrawerHeader(child: BlocBuilder<UserProfileBloc, UserProfileState>(
            builder: (BuildContext context, state) {
              UserLogin userLoginFailure = UserLogin();
              if (state is InProgresssGettingUserProfileState) {
                return CommonWidgets.progressIndicator;
              }
              if (state is UserProfiledetailTakenSuccessfully) {
                return userInfoWidget(state.userLogin);
              }

              if (state is FailedTogetUserProfileData) {
                return Center(child: userInfoWidget(userLoginFailure));
              }

              return Container();
            },
          )),

          SingleChildScrollView(
            //  height: MediaQuery.of(context).size.height,
            // color: Colors.transparent,
            child: Column(children: [
              SizedBox(
                height: 0,
              ),
              new MyDrawerItems(context).drawerItem(
                  icon: FontAwesomeIcons.user,
                  text: 'Profile',
                  onTap: () => {
                        //clossing the nav drawer after click
                        Navigator.pop(context),

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserProfileScreen(),
                          ),
                        ),
                      }),
              Divider(),
              SizedBox(
                height: 0,
              ),
              new MyDrawerItems(context).drawerItem(
                  icon: FontAwesomeIcons.list,
                  text: 'My orders',
                  onTap: () => {
                        //clossing the nav drawer after click
                        Navigator.pop(context),

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyOrdersScreen(),
                          ),
                        ),
                      }),
              Divider(),
              SizedBox(
                height: 0,
              ),
              new MyDrawerItems(context).drawerItem(
                  icon: FontAwesomeIcons.chair,
                  text: 'My reservations',
                  onTap: () => {
                        //clossing the nav drawer after click
                        Navigator.pop(context),

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyReservationScreenMain(),
                          ),
                        ),
                      }),
              Divider(),
              SizedBox(
                height: 0,
              ),
              new MyDrawerItems(context).drawerItem(
                  icon: FontAwesomeIcons.addressBook,
                  text: 'About us',
                  onTap: () => {
                        Navigator.pop(context),
                        BlocProvider.of<CartBloc>(context)
                            .add(SaveDataToSharedPrefrencesCartEvent()),
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
                        }),
                        //clossing the nav drawer after click
                      }),
              Divider(),
              SizedBox(
                height: 0,
              ),
              new MyDrawerItems(context).drawerItem(
                  icon: FontAwesomeIcons.mailBulk,
                  text: 'Contact us',
                  onTap: () => {
                        //clossing the nav drawer after click
                        Navigator.pop(context),
                        BlocProvider.of<CartBloc>(context)
                            .add(SaveDataToSharedPrefrencesCartEvent()),

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
                        }),
                      }),
              Divider(),
              SizedBox(
                height: 0,
              ),
              Builder(
                builder: (
                  BuildContext context,
                ) {
                  if (guestUserValue) {
                    return MyDrawerItems(context).drawerItem(
                        icon: FontAwesomeIcons.powerOff,
                        text: 'Login',
                        onTap: () => {
                              //clossing the nav drawer after click
                              Navigator.pop(context),
                              Methods.storeGuestValueToSharedPref(false),
                              BlocProvider.of<CartBloc>(context)
                                  .add(SaveDataToSharedPrefrencesCartEvent()),
                              BlocProvider.of<UserAuthBloc>(context)
                                  .add(AuthLoggedOut()),
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => App(
                                    userRepository: userAuthRepository,
                                  ),
                                ),
                              ),
                            });
                  } else {
                    return MyDrawerItems(context).drawerItem(
                        icon: FontAwesomeIcons.powerOff,
                        text: 'Logout',
                        onTap: () {
                          Methods.storeGuestValueToSharedPref(false);
                          BlocProvider.of<UserAuthBloc>(context)
                              .add(AuthLoggedOut());

                          BlocProvider.of<CartBloc>(context).add(
                              RemoveDataFromSharedPrefrencesOfCartWhenLogout());
                        });
                  }
                },
              ),
              Divider(),
            ]),
          )
        ],
      ),
    );
  }

  Widget userInfoWidget(UserLogin userLogin) {
    return Column(
      children: [
        SizedBox(height: 20),
        Stack(children: [
          Align(
              child: CirculerImageView(
                  height: 70,
                  width: 70,
                  imageUrl: userLogin.data == null ||
                          userLogin.data.userPictureURL == "" ||
                          userLogin.data.userPictureURL == APIConstants.baseUrl
                      ? userImagePlaceHolder
                      : "${userLogin.data.userPictureURL}")),
          Positioned.fill(
            child: Align(
              alignment: Alignment(0, 1.5),
              child: Container(
                  width: 27,
                  height: 27,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    //borderRadius: BorderRadius.all(Radius.circular(25)),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.amber,
                        size: 10,
                      ),
                      onPressed: () {
                        BlocProvider.of<CartBloc>(context)
                            .add(SaveDataToSharedPrefrencesCartEvent());

                        Navigator.pop(context);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserProfileUpdateScreenMain()),
                        );
                      })),
            ),
          )
        ]),
        SizedBox(height: 25),
        Text(
            userLogin.data == null ? "Guest" : "${userLogin.data.customerName}",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.black87, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
