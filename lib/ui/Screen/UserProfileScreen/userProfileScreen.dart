import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meta/meta.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileBloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileState.dart';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/main.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/circulerImageView.dart';
import 'package:retaurant_app/ui/CommomWidgets/commonWidgets.dart';
import 'package:retaurant_app/ui/CommomWidgets/roundedImageViewWithoutBorderDynamic.dart';
import 'package:retaurant_app/ui/Screen/UserProfileScreen/userProfileUpdateScreen.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) {
          return UserProfileBloc()..add(GetUserDataUserProfileEvent());
        },
        child: UserProfiletPage(),
      ),
    );
  }
}

class UserProfiletPage extends StatefulWidget {
  UserProfiletPage({this.realoadMe});

  final bool realoadMe;

  @override
  _UserProfiletPageState createState() => _UserProfiletPageState();
}

class _UserProfiletPageState extends State<UserProfiletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (BuildContext context, state) {
            if (state is InProgresssGettingUserProfileState) {
              return CommonWidgets.progressIndicator;
            }
            if (state is UserProfiledetailTakenSuccessfully) {
              //TODO: Uncomment this block
              BlocProvider.of<UserProfileBloc>(context)
                  .add(GetUserDataUserProfileEvent());

              return _buildBody(state.userLogin);
            }

            if (state is FailedTogetUserProfileData) {
              return Center(
                child: failedWidget(context),
              );
            }

            return Container();
          },
        ));
  }
}

Widget failedWidget(BuildContext context) {
  return FlatButton(
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 0.0),
            child: Icon(
              FontAwesomeIcons.powerOff,
              size: 60,
              color: Colors.red[100],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Tap to Login",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    ),
    onPressed: () {
      UserAuthRepository userAuthRepository = UserAuthRepository();
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
}

Widget _buildBody(UserLogin userLogin) {
  return SingleChildScrollView(
    child: Column(
      children: <Widget>[
        ProfileHeader(
          imageUrl: userLogin.data.userPictureURL ==
                  APIConstants.baseUrl
              ? "https://img.favpng.com/17/3/18/computer-icons-user-profile-male-png-favpng-ZmC9dDrp9x27KFnnge0jKWKBs.jpg"
              : "${userLogin.data.userPictureURL}",
          backgroundImageUrl:
              "http://unique-itsolutions.co.uk/restaurant-demo/new/application/modules/itemmanage/assets/images/chicken_seekh.jpg",
          title: userLogin.data.customerName != null
              ? "${userLogin.data.customerName}"
              : "N/A",
          subtitle: "",
          // actions: <Widget>[
          //   MaterialButton(
          //     color: Colors.white,
          //     shape: CircleBorder(),
          //     elevation: 0,
          //     child: Icon(Icons.edit),
          //     onPressed: () {},
          //   )
          // ],
        ),
        const SizedBox(height: 10.0),
        UserInfo(
          userLogin: userLogin,
        ),
      ],
    ),
  );
}

class UserInfo extends StatelessWidget {
  UserInfo({@required this.userLogin});

  final UserLogin userLogin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "User Information",
                  style:
                      Theme.of(context).textTheme.button.copyWith(fontSize: 16),
                  textAlign: TextAlign.left,
                ),
                IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.edit,
                        size: 28,
                        color: AppTheme.appDefaultColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserProfileUpdateScreenMain()),
                      );
                    }),
              ],
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.symmetric(vertical: 5.5, horizontal: 6),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                        color: Colors.grey,
                        tiles: [
                          // ListTile(
                          //     contentPadding: EdgeInsets.symmetric(
                          //         horizontal: 12, vertical: 0),
                          //     leading: Icon(Icons.location_on),
                          //     title: Text(
                          //       "Favourite Delivery Address",
                          //       style: Theme.of(context).textTheme.button,
                          //     ),
                          //     subtitle: userLogin
                          //                     .data.favoriteDeliveryAddress ==
                          //                 null ||
                          //             userLogin.data.favoriteDeliveryAddress ==
                          //                 ""
                          //         ? Text("N/A")
                          //         : Text(
                          //             "${userLogin.data.favoriteDeliveryAddress}",
                          //             style: Theme.of(context)
                          //                 .textTheme
                          //                 .bodyText1
                          //                 .copyWith(fontSize: 12),
                          //           )),
                          ListTile(
                            leading: Icon(Icons.email),
                            title: Text(
                              "Email",
                              style: Theme.of(context).textTheme.button,
                            ),
                            subtitle: userLogin.data.customerEmail == null ||
                                    userLogin.data.cuntomerNo == ""
                                ? Text("N/A")
                                : Text(
                                    "${userLogin.data.customerEmail}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(fontSize: 12),
                                  ),
                          ),
                          ListTile(
                              leading: Icon(Icons.phone),
                              title: Text(
                                "Phone",
                                style: Theme.of(context).textTheme.button,
                              ),
                              subtitle: userLogin.data.customerPhone == null ||
                                      userLogin.data.customerPhone == ""
                                  ? Text("N/A")
                                  : Text(
                                      "${userLogin.data.customerPhone}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 12),
                                    )),
                          ListTile(
                              leading: Icon(Icons.my_location),
                              title: Text(
                                "Address",
                                style: Theme.of(context).textTheme.button,
                              ),
                              subtitle:
                                  userLogin.data.customerAddress == null ||
                                          userLogin.data.customerAddress == ""
                                      ? Text("N/A")
                                      : Text(
                                          "${userLogin.data.customerAddress}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .copyWith(fontSize: 12),
                                        )),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(
      {Key key,
      this.backgroundImageUrl,
      @required this.imageUrl,
      @required this.title,
      this.subtitle,
      this.actions})
      : super(key: key);

  final List<Widget> actions;
  final String backgroundImageUrl;
  final String imageUrl;
  final String subtitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    double dynamicPadding = MediaQuery.of(context).size.height * 0.28;
    return Stack(
      children: <Widget>[
        RoundedCornerImageViewWithoutBorderDynamic(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          imageLink: backgroundImageUrl,
          borderWidth: 0,
          cornerRadius: 0,
        ),
        // Ink(
        //   height: 200,
        //   decoration: BoxDecoration(
        //     image: DecorationImage(image: backgroundImageUrl, fit: BoxFit.cover),
        //   ),
        // ),
        Ink(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.35,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: dynamicPadding),
          child: Column(
            children: <Widget>[
              Avatar(
                imageUrl: imageUrl,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.headline6,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar(
      {Key key,
      @required this.imageUrl,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final String imageUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CirculerImageView(
      height: 100,
      width: 100,
      imageUrl: imageUrl,
    );
  }
}
