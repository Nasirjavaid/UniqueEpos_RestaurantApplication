import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/cartAddonsUpdatingDialogue.dart';
import 'package:retaurant_app/ui/Screen/MenuScreen/addonsDialogue.dart';
import 'package:retaurant_app/ui/Screen/MenuScreen/productOptionsDialogue.dart';
import 'package:retaurant_app/ui/Screen/MyOrdersScreen/myOrdersDialogueBox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:retaurant_app/model/foodProduct.dart' as data;

class Methods {
  //Url Launcher
  // static launchURL() async {
  //   const url = 'https://www.visionplus.com.pk/';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  //Storing user information in shared prefrences

  //getCurrent date and time of system

  static void showToast(BuildContext context, String message) {
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

  static String getSytemCurrenDateAndTime() {
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    print(
        "Current date and time sent to server while placing order::   $date ");
    return date.toString();
  }

  static storeGuestValueToSharedPref(bool stateBoolValue) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    // String user = jsonEncode(userLogin.toJson());
    String guestValue = "guest";

    print("Guest Stored in  shared pref :: $stateBoolValue");
    sharedUser.setBool(guestValue, stateBoolValue);
  }

//getting user information from shared pefrences
  static Future<bool> getGuestFromSharedPref() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    try {
      String guestValue = "guest";
      bool stateBoolValue = sharedUser.getBool(guestValue);
      if (stateBoolValue) {
        print("Guest  value back from shared pref :: $stateBoolValue");
        return stateBoolValue;
      }
    } catch (ex) {
      print("Exception in Shared prefrences $ex");
      return false;
    }
    return false;
  }

  //Storing user information in shared prefrences
  static storeUserToSharedPref(UserLogin userLogin) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String user = jsonEncode(userLogin.toJson());

    print("User object Stored in  shared pref :: $user");
    sharedUser.setString('user', user);
  }

  static Future<UserLogin> userInfoStoredInsharedPrefrences() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin();
    Map userMap;

    try {
      userMap = jsonDecode(sharedUser.getString('user'));

      if (userMap.length.isNegative) {
        return userLogin;
      } else {
        userLogin = UserLogin.fromJson(userMap);
        print(
            "Returned User info by shared prefrences   ${userLogin.data.customerName} ");
        return userLogin;
      }
    } catch (ex) {
      return userLogin;
    }
  }

//getting user information from shared pefrences
  static Future<UserLogin> getRealUserFromSharedPref() async {
    // SharedPreferences sharedUser = await SharedPreferences.getInstance();
    UserLogin userLogin = UserLogin();
    userLogin = await userInfoStoredInsharedPrefrences();
    try {
      //  Map userMap = jsonDecode(sharedUser.getString('user'));

      if (userLogin.data.customerId != 0) {
        return userLogin;
      }
    } catch (ex) {
      print("Exception in Shared prefrences $ex");
      return userLogin;
    }
    return userLogin;
  }

  static String dateToDateTimeConversion(String mydate) {
    DateTime dd = DateTime.parse(mydate);

    dd.toString();
    print("Date time in mili seconds :: ${dd.year}");
    print("Date time in mili seconds :: ${dd.month}");
    print("Date time in mili seconds :: ${dd.day}");
    print("Date time in mili seconds :: ${dd.hour}");
    print("Date time in mili seconds :: ${dd.minute}");
    String formattedDate = DateFormat('EEE,dd-MM-yyyy').format(dd);
    return formattedDate;
  }

  static void showDialogMenuListAddons(
      BuildContext context, Foodinfo foodinfo, data.Data data) {
    showGeneralDialog(
      barrierLabel: "Customizations",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return AddonsDialogue(
            foodinfo: foodinfo, contextA: context, data: data);
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static void showDialogCartListAddons(
      BuildContext context, Foodinfo foodinfo) async {
        
    //get Settings from Shared prefrnces
    FoodProduct foodProduct = await getSettingsFromSharedPrefrences();
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',

      context: context,

      pageBuilder: (_, __, ___) {
        return CartaddonsUpdatingDialogue(
            foodinfo: foodinfo, contextA: context, data: foodProduct.data);
      },

      // transitionBuilder: (context, animation, anotherAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: child,
      //   );
      // },

      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static void showDialogueForMyOrderDetail(
      BuildContext context, Orderinfo orderInfo, data) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: Duration(milliseconds: 400),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (_, __, ___) {
        return MyOrdersDialogueBox(
          orderinfo: orderInfo,
          data: data,
          conteextA: context,
        );
      },

      // transitionBuilder: (context, animation, anotherAnimation, child) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: child,
      //   );
      // },

      transitionBuilder: (context, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }


    static void showDialogForProductOptions(
      BuildContext context, Foodinfo foodinfo, data.Data data) {
    showGeneralDialog(
      barrierLabel: "Customizations",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, __, ___) {
        return ProductOptionsDialogue(
            foodinfo: foodinfo, contextA: context, data: data);
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  static storeStateToSharedPref(bool stateBoolValue) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    // String user = jsonEncode(userLogin.toJson());
    String guestValue = "stateBoolValue";

    print("stateBoolValue Stored in  shared pref :: $stateBoolValue");
    sharedUser.setBool(guestValue, stateBoolValue);
  }

//getting user information from shared pefrences
  static Future<bool> getStateFromSharedPref() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    try {
      String guestValue = "stateBoolValue";
      bool stateBoolValue = sharedUser.getBool(guestValue);
      if (stateBoolValue) {
        print("stateBoolValue  value back from shared pref :: $stateBoolValue");
        return stateBoolValue;
      }
    } catch (ex) {
      print("Exception in Shared prefrences $ex");
      return false;
    }
    return false;
  }

  ///////////////////////////////////////////////////////
  //Storing user information in shared prefrences
  static storeSettingsTosharedPrefrences(FoodProduct foodProduct) async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();

    String settings = jsonEncode(foodProduct.toJson());

    print("Settings stored in Shared prefrences:: $settings");
    sharedUser.setString('settings', settings);
  }

  static Future<FoodProduct> getSettingsFromSharedPrefrences() async {
    SharedPreferences sharedUser = await SharedPreferences.getInstance();
    FoodProduct foodProduct = FoodProduct();
    Map userMap;

    try {
      userMap = jsonDecode(sharedUser.getString('settings'));

      if (userMap.length.isNegative) {
        return foodProduct;
      } else {
        foodProduct = FoodProduct.fromJson(userMap);
        print(
            "Returned Settings from Shared Prefrences : ${foodProduct.data.currency} ");
        return foodProduct;
      }
    } catch (ex) {
      return foodProduct;
    }
  }


  static String returnSimpleString(Foodinfo foodinfo)
  {
       var result;
    if (foodinfo.selectedOptionValues != "[]") {
      final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
      final input = '${foodinfo.selectedOptionValues}';
      result = regExp
          .allMatches(input)
          .map((m) => m.group(1))
          .map((String item) => item.replaceAll(new RegExp(r'[\[\],]'), ''));

      print(result);
      return result;
    }else{return null;}
  }
}

mixin ValidationMixin {
  bool isFieldEmpty(String fieldValue) => fieldValue?.isEmpty ?? true;

  bool validateEmailAddress(String email) {
    if (email == null) {
      return false;
    }
    String emailTrimmed = email.trim();
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(emailTrimmed);
  }

  bool validatePassword(String value) {
    Pattern pattern = r'^.{6,}$';
    RegExp regex = new RegExp(pattern);
    print(value);
    if (value.isEmpty) {
      return false;
    } else {
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    }
  }
}

//validating login fields
enum FieldError { Empty, Invalid }
