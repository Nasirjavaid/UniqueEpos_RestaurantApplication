import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartState.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileBloc.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileEvent.dart';
import 'package:retaurant_app/bloc/userProfileBloc/userProfileState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/model/userLogin.dart' as login;
import 'package:retaurant_app/model/userLogin.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/orderPlacingFailedWidget.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/orderPlcedWidgetSuccessfully.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/orderPlcingInProgressWidget.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/orderRecipt.dart';
import 'package:retaurant_app/ui/Screen/MenuScreen/menuItemListView.dart';

class CartScreenMain extends StatefulWidget {
  @override
  _CartScreenMainState createState() => _CartScreenMainState();
}

class _CartScreenMainState extends State<CartScreenMain> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => CartBloc()..add(GettAllCartProducts()),
        child: CartScreen());
  }
}

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with WidgetsBindingObserver {
  String deliveryOptions;
  TextEditingController etAddress = TextEditingController();
  TextEditingController etEmail = TextEditingController();
  TextEditingController etName = TextEditingController();
  TextEditingController etPhone = TextEditingController();
  //Text editnig controllers
  TextEditingController etSpecialNote = TextEditingController();

//Guest values
  bool guestUserValue = false;

  //Menu item list object
  MenuItemListView menuItemListView = MenuItemListView();

  //is shipping Check
  bool shipingAddressSwitch = false;

  int shippingInfoListIndex;
  //User Auth repository
  UserAuthRepository userAuthRepository = UserAuthRepository();

  // User login object to get user data
  UserLogin userLoginForCartOrderSubmission = UserLogin();

  bool valueCheckFlag;

  @override
  void dispose() {
    super.dispose();
    // BlocProvider.of<CartBloc>(context)
    //     .add(SaveDataToSharedPrefrencesCartEvent());
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    valueCheckFlag = true;
    callCartFromSharedPrefrences();
    getValueOFguestUserFromSharedPrefrences();
  }

  getValueOFguestUserFromSharedPrefrences() async {
    guestUserValue = await Methods.getGuestFromSharedPref();
    setState(() {
      return guestUserValue;
    });

    return guestUserValue;
  }

  void callCartFromSharedPrefrences() async {
    BlocProvider.of<CartBloc>(context)
        .add(GetDataFromSharedPrefrencesCartEvent());
  }

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

  Widget failureWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.cartArrowDown,
            size: 60,
            color: Colors.red[100],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "No items",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext conext,
      UpdateFoodProductListWhenAddingNewFoodProductState state) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //items listView
          cartItemsLitView(state),

          //checkout button
          checkoutAndTotalBill(state),
        ],
      ),
    );
  }

  Widget cartItemsLitView(
      UpdateFoodProductListWhenAddingNewFoodProductState state) {
    return Container(
      // height: MediaQuery.of(context).size.height ,
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          physics: NeverScrollableScrollPhysics(),
          itemCount: state.foodinfo.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return cartListViewItemCard(state, index);
          }),
    );
  }

  Widget cartListViewItemCard(
      UpdateFoodProductListWhenAddingNewFoodProductState state, int index) {
    //var result;
    var finalResult;
    if (state.foodinfo[index].selectedOptionValues != "[]") {
      final regExp = new RegExp(r'(?:\[)?(\[[^\]]*?\](?:,?))(?:\])?');
      final input = '${state.foodinfo[index].selectedOptionValues}';
      final result = regExp
          .allMatches(input)
          .map((m) => m.group(1))
          // .map((String item) => item.replaceAll(new RegExp(r'(((?:\[)?([[^\]]*?\](?:,?))(?:\?)))'), ''));
          .map((String item) => item.replaceAll(new RegExp(r'[\[\],]'), ''));

      print(
          "Test ${result.toString().replaceAll("(", "").replaceAll(")", "")}");
      finalResult = result.toString().replaceAll("(", "").replaceAll(")", "");
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, bottom: 6, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          if (state.foodinfo[index].count > 1) {
                            print("Index is here  $index");
                            BlocProvider.of<CartBloc>(context)
                                .add(DecreaseProductCountInCartEvent(
                              index: index,
                            ));
                            ////////////////////////////////////////////////////////////////dd
                            BlocProvider.of<CartBloc>(context).add(
                                FoodProductTotalBillCartEvent(
                                    index: shippingInfoListIndex));

///////////////////////////////////////////////////////////////////
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15, right: 8, left: 15),
                        child: Icon(
                          FontAwesomeIcons.minus,
                          size: 16,
                          color: AppTheme.appDefaultColor,
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 25,
                        height: 18,
                        child: Center(
                          child: Text(
                            "${state.foodinfo[index].count}",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          print("Index is here  $index");
                          BlocProvider.of<CartBloc>(context)
                              .add(IncreaseProductCountInCartEvent(
                            index: index,
                          ));

////////////////////////////////////////////////////////////////
                          BlocProvider.of<CartBloc>(context).add(
                              FoodProductTotalBillCartEvent(
                                  index: shippingInfoListIndex));

/////////////////////////////////////////////////////////////////
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, bottom: 15, right: 8, left: 12),
                        child: Icon(FontAwesomeIcons.plus,
                            size: 15, color: AppTheme.appDefaultColor),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: new BoxConstraints(
                            minWidth: 30.0,
                            maxWidth: 210.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  "${state.foodinfo[index].productName}",
                                  maxLines: 3,
                                  overflow: TextOverflow.clip,
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        fontSize: 13,
                                      ),
                                ),
                              ),
                              SizedBox(height: 3),
                              state.foodinfo[index].variantName != ""
                                  ? Text(
                                      "(${state.foodinfo[index].variantName})",
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(fontSize: 8))
                                  : Container(
                                      height: 0.00001,
                                      width: 0.00001,
                                    )
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        !finalResult.contains("()") ||
                                finalResult != null ||
                                finalResult != ""
                            ? Text(
                                "Options: $finalResult",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyText1,
                              )
                            : Container(),
                        SizedBox(height: 4),
                        state.foodinfo[index].addons == 0
                            ? Container(
                                height: 0.00001,
                                width: 0.00001,
                              )
                            : Text(
                                "Addons price: ${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[index].addOnsListTotalPrice.toStringAsFixed(2)}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 11),
                              ),
                        Text(
                          "Product price: ${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[index].foodItemTtotalPrice.toStringAsFixed(2)}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 11),
                        ),
                        SizedBox(height: 5),
                        state.foodinfo[index].addons != 0
                            ? state.foodinfo[index].total != null
                                ? Row(
                                    children: [
                                      Text(
                                        "Total: ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(fontSize: 11),
                                      ),
                                      Text(
                                        "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[index].foodItemTtotalPrice.toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 1,
                                    width: 0,
                                  )
                            : Container(
                                height: 1,
                                width: 0,
                              )
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    state.foodinfo[index].addons == 0
                        ? SizedBox(
                            width: 25,
                            child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.bars,
                                  size: 14,
                                  color: Colors.transparent,
                                ),
                                onPressed: () {}),
                          )
                        : SizedBox(
                            width: 26,
                            child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.bars,
                                  size: 14,
                                  color: Colors.green[700],
                                ),
                                onPressed: () {
                                  Methods.showDialogCartListAddons(
                                      context, state.foodinfo[index]);
                                }),
                          ),
                    SizedBox(
                      width: 26,
                      child: IconButton(
                          icon: Icon(
                            Icons.delete,
                            size: 17,
                            color: Colors.red[700],
                          ),
                          onPressed: () {
                            _showDialog(state, index, context);
                          }),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget userDefaultAddressCard() {
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
          return userInfoWidget(userLoginForCartOrderSubmission);
        }
        // if data is Successfully obtained pass to widget body
        if (state is UserProfiledetailTakenSuccessfully) {
          userLoginForCartOrderSubmission = new UserLogin();
          // print(
          //     "Obtained user data in user profile  ${state.userLogin.data.customerName}");
          userLoginForCartOrderSubmission = state.userLogin;

          if (!guestUserValue) {
            etName.text = userLoginForCartOrderSubmission.data.customerName;
            etPhone.text = userLoginForCartOrderSubmission.data.customerPhone;
            etEmail.text = userLoginForCartOrderSubmission.data.customerEmail;
            etAddress.text =
                userLoginForCartOrderSubmission.data.customerAddress;
          }
          return userInfoWidget(state.userLogin);
        }
        return userInfoWidget(userLoginForCartOrderSubmission);
      },
    ));
  }

  Widget sepecialNoteTextInputField(BuildContext context) {
    return Container(
      child: new TextField(
          controller: etSpecialNote,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            // filled: true,
            // fillColor: AppTheme.textFieldOfCartBackbgtoundColor,
            labelText: "Special Note",
            labelStyle:
                TextStyle(color: AppTheme.appDefaultColor, fontSize: 13),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: AppTheme.appDefaultColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide(
                color: AppTheme.appDefaultColor,
                width: 1.0,
              ),
            ),
          )),
    );
  }

  Widget userInfoWidget(UserLogin userLogin) {
    return Column(
      children: [
        // SizedBox(
        //   height: 10,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Name",
        //       style: Theme.of(context).textTheme.button.copyWith(
        //             fontSize: 14,
        //           ),
        //     ),
        //     SizedBox(
        //       width: 4,
        //     ),
        //     Text(
        //       userLogin.data != null ? "${userLogin.data.customerName}" : "N/A",
        //       style: Theme.of(context).textTheme.button.copyWith(
        //             fontSize: 14,
        //           ),
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 8,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Phone",
        //       style: Theme.of(context).textTheme.button.copyWith(
        //             fontSize: 14,
        //           ),
        //     ),
        //     Row(
        //       children: [
        //         Text(
        //           userLogin.data != null
        //               ? "${userLogin.data.customerPhone}"
        //               : "N/A",
        //           style: Theme.of(context).textTheme.button.copyWith(
        //                 fontSize: 14,
        //               ),
        //         ),

        //         // state.foodinfo[0].cartTotalBill.deliveryFee != null
        //         //     ? Text(
        //         //         "${state.foodinfo[0].cartTotalBill.deliveryFee}",
        //         //         style: Theme.of(context)
        //         //             .textTheme
        //         //             .bodyText1
        //         //             .copyWith(fontSize: 13),
        //         //       )
        //         //     :
        //         //      Text(
        //         //         "N/A",
        //         //         style: Theme.of(context)
        //         //             .textTheme
        //         //             .bodyText1
        //         //             .copyWith(fontSize: 13),
        //         //       ),
        //       ],
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: 8,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Delivery address",
        //       style: Theme.of(context).textTheme.button.copyWith(
        //             fontSize: 14,
        //           ),
        //     ),
        //     Row(
        //       children: [
        //         SizedBox(
        //           width: 150,
        //           child: Text(
        //             userLogin.data != null
        //                 ? "${userLogin.data.customerAddress}"
        //                 : "N/A",
        //             textAlign: TextAlign.right,
        //             maxLines: 4,
        //             overflow: TextOverflow.ellipsis,
        //             style: Theme.of(context).textTheme.button.copyWith(
        //                   fontSize: 14,
        //                 ),
        //           ),
        //         ),

        //         // SizedBox(
        //         //   width: 4,
        //         // ),
        //         // Text(
        //         //   "${state.foodinfo[0].cartTotalBill.disccount}",
        //         //   style: Theme.of(context)
        //         //       .textTheme
        //         //       .bodyText1
        //         //       .copyWith(fontSize: 13),
        //         // ),
        //       ],
        //     )
        //   ],
        // ),
        // SizedBox(
        //   height: 28,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       "Ship To Different Address",
        //       style: Theme.of(context)
        //           .textTheme
        //           .button
        //           .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        //     ),
        //     // ignore: missing_required_param
        //     Checkbox(
        //       value: shipingAddressSwitch,
        //       activeColor: AppTheme.appDefaultColor,
        //       onChanged: (val) {
        //         if (val) {
        //           setState(() {
        //             shipingAddressSwitch = true;
        //           });
        //         } else {
        //           setState(() {
        //             shipingAddressSwitch = false;
        //           });
        //         }
        //       },
        //     ),
        //   ],
        // ),
        SizedBox(
          height: 10,
        ),
        // shipingAddressSwitch == true
        //     ? differentShipingAddressAndNote(context)
        //     : Container()
        differentShipingAddressAndNote(context)
      ],
    );
  }

  Widget differentShipingAddressAndNote(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          child: new TextField(
              controller: etName,
              expands: false,
              maxLines: 1,
              minLines: 1,
              maxLength: 40,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,

              //validator: _validateFirstName,

              decoration: InputDecoration(
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
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          child: new TextField(
              controller: etPhone,
              keyboardType: TextInputType.number,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              expands: false,
              maxLines: 1,
              minLines: 1,
              maxLength: 40,
              decoration: InputDecoration(
                counterText: "",
                // filled: true,
                // fillColor: AppTheme.textFieldOfCartBackbgtoundColor,
                labelText: "Phone",
                labelStyle:
                    TextStyle(color: AppTheme.appDefaultColor, fontSize: 13),
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
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          child: new TextField(
              controller: etEmail,
              expands: false,
              maxLines: 1,
              minLines: 1,
              maxLength: 40,
              keyboardType: TextInputType.multiline,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,

              //validator: _validateFirstName,

              decoration: InputDecoration(
                counterText: "",
                // filled: true,
                // fillColor: AppTheme.appDefaultColor,
                labelText: "Email",
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
        ),
        SizedBox(height: 10),
        Container(
          child: new TextField(
              controller: etAddress,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              minLines: 1,
              maxLines: 2,
              decoration: InputDecoration(
                // filled: true,
                // fillColor: AppTheme.appDefaultColor,
                labelText: "Address",
                labelStyle:
                    TextStyle(color: AppTheme.appDefaultColor, fontSize: 13),
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
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget checkoutAndTotalBill(
      UpdateFoodProductListWhenAddingNewFoodProductState state) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 15, bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Delivery type",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  deliveryOptionsDropDownList(
                      state.foodinfo[0].cartTotalBill.shippinginfo,
                      state.foodinfo[0].shippingInfoListIndexFormFoodInfo,
                      state),
                  SizedBox(
                    height: 25,
                  ),
                  sepecialNoteTextInputField(context),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal",
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        children: [
                          state.foodinfo[0].cartTotalBill.subTotal != null
                              ? Text(
                                  "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[0].cartTotalBill.subTotal.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                )
                              : Text(
                                  "N/A",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Delivery Fee",
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        children: [
                          state.foodinfo[0].cartTotalBill.deliveryFee != null
                              ? Text(
                                  "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[0].cartTotalBill.deliveryFee.toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                )
                              : Text(
                                  "N/A",
                                  style: Theme.of(context)
                                      .textTheme
                                      .button
                                      .copyWith(
                                        fontSize: 14,
                                      ),
                                ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "VAT(${state.foodinfo[0].cartTotalBill.restaurantvat}%)",
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[0].cartTotalBill.vatAmount.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.button.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discount",
                        style: Theme.of(context).textTheme.button.copyWith(
                              fontSize: 14,
                            ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[0].cartTotalBill.disccount.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.button.copyWith(
                                  fontSize: 14,
                                ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: Theme.of(context).textTheme.button.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      Row(
                        children: [
                          Text(
                            "${state.foodinfo[0].cartTotalBill.currencyIcon}${state.foodinfo[0].cartTotalBill.totalBill.toStringAsFixed(2)}",
                            style: Theme.of(context).textTheme.button.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                        ],
                      )
                    ],
                  ),

                  // SizedBox(
                  //   height: 13,
                  // ),
                  Divider(),

                  SizedBox(
                    height: 23,
                  ),
                  // Divider(),

                  Text(
                    "Reciever Info",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  //userDefault address card
                  userDefaultAddressCard(),

                  SizedBox(
                    height: 20,
                  ),
                  checkOutButon()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget deliveryOptionsDropDownList(
      List<Shippinginfo> shippingInfoList,
      int shippingInfoListIndexForFoodInfo,
      UpdateFoodProductListWhenAddingNewFoodProductState state) {
    if (shippingInfoListIndexForFoodInfo != null) {
      if (valueCheckFlag) {
        // shippingInfoListIndex = shippingInfoListIndexForFoodInfo;

        deliveryOptions =
            shippingInfoList[shippingInfoListIndexForFoodInfo].shippingName;
        shippingInfoListIndexForFoodInfo = null;
        valueCheckFlag = false;
      }
    }

    return Container(
      color: AppTheme.background,
      width: MediaQuery.of(context).size.width,
      height: 40,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: DropdownButton<String>(
          isExpanded: true,
          underline: Text(""),
          elevation: 12,
          // icon: FaIcon(
          //   FontAwesomeIcons.arrowAltCircleDown,
          //   color: Colors.redAccent,
          //   size: 19,
          // ),
          hint: Text("Please choose a delivery type",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontSize: 14, color: AppTheme.appDefaultColor)),
          value: deliveryOptions,
          focusColor: Colors.redAccent,
          items: shippingInfoList.map((Shippinginfo value) {
            return new DropdownMenuItem<String>(
              value: value.shippingName,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${value.shippingName}",
                        style: Theme.of(context).textTheme.bodyText2),
                    SizedBox(width: 10),
                    Text(
                        "${state.foodinfo[0].cartTotalBill.currencyIcon}${value.shippingrate}",
                        style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              // deliveryOptions = "";
              shippingInfoListIndexForFoodInfo = null;
              deliveryOptions = value.toString();
              shippingInfoListIndex = shippingInfoList.indexWhere(
                (s) => s.shippingName == deliveryOptions,
              );

              deliveryOptions =
                  shippingInfoList[shippingInfoListIndex].shippingName;

              print(
                  "Delivey type dropdown values changed $deliveryOptions with index $shippingInfoListIndex");

              //    BlocProvider.of<CartBloc>(context)
              // .add(UpdateBillOnChangeOfDeliveryTypeCartEvent(index:index));
              BlocProvider.of<CartBloc>(context).add(
                  FoodProductTotalBillCartEvent(index: shippingInfoListIndex));
            });
          },
        ),
      ),
    );
  }

  Widget checkOutButon() {
    return SizedBox(
      height: 40,
      width: MediaQuery.of(context).size.width,
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

                child: Text("Check out",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () async {
                print("check out button pressed");

                NetworkConnectivity.check().then((internet) {
                  if (internet) {
                    placeOrder();
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

  void _showDialog(UpdateFoodProductListWhenAddingNewFoodProductState state,
      int index, BuildContext mainContext) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Delete !!!",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: Colors.red, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("${state.foodinfo[index].productName}",
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 17)),
                  Text(
                    "(${state.foodinfo[index].variantName})",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 10),
                  ),
                ],
              ),
              SizedBox(
                height: 6,
              ),
              Text(
                "${state.foodinfo[index].description}",
                maxLines: 10,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontSize: 12),
              ),
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child:
                  new Text("Close", style: Theme.of(context).textTheme.button),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),

            FlatButton(
                child: Text("Delete",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Colors.red)),
                onPressed: () {
                  setState(() {
                    BlocProvider.of<CartBloc>(mainContext)
                        .add(RemoveProductFromcartEvent(index: index));

                    state.foodinfo.remove(state.foodinfo[index]);

                    ////////////////////////////////////////////////////////////////dd
                    BlocProvider.of<CartBloc>(mainContext)
                        .add(FoodProductTotalBillCartEvent());
                    Navigator.pop(context);

///////////////////////////////////////////////////////////////////
                  });
                }),
          ],
        );
      },
    );
  }

  void placeOrder() {
    try {
      // if (guestUserValue) {
      //   Methods.storeGuestValueToSharedPref(false);
      //   BlocProvider.of<CartBloc>(context)
      //       .add(SaveDataToSharedPrefrencesCartEvent());

      //   BlocProvider.of<UserAuthBloc>(context).add(AuthLoggedOut());
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => App(
      //         userRepository: userAuthRepository,
      //       ),
      //     ),
      //   );
      // } else {
      // try {
      if (deliveryOptions == null || deliveryOptions == "") {
        _showToast(context, "Please select delivery type.");
      }
      //   else {
      //      if (shipingAddressSwitch) {

      else if (etName.text == null || etName.text == "") {
        _showToast(context, "Please Enter Name");
      } else if (etPhone.text == null || etPhone.text == "") {
        _showToast(context, "Please Enter Phone");
      } else if (etEmail.text == null || etEmail.text == "") {
        _showToast(context, "Please Enter Email Address");
      } else if (etAddress.text == null || etAddress.text == "") {
        _showToast(context, "Please Enter Address");
      } else {
        UserLogin userLoginAsGuestInfo = new UserLogin();
        login.Data data = new login.Data(
            customerName: "",
            customerPhone: "",
            customerEmail: "",
            customerAddress: "",
            customerNote: "0",
            customerId: "");

        data.customerName = etName.text;
        data.customerPhone = etPhone.text;
        data.customerEmail = etEmail.text;
        data.customerAddress = etAddress.text;
        data.customerNote = etSpecialNote.text;
        if (userLoginForCartOrderSubmission.message != null) {
          data.customerId = userLoginForCartOrderSubmission.data.customerId;
        } else {
          data.customerId = "";
        }

        userLoginAsGuestInfo.data = data;

        print("Entered Special Note " + etSpecialNote.text);
        print("Entered Name :  " + etName.text);
        print("Entered Phone : " + etPhone.text);
        print("Entered Email : " + etEmail.text);
        print("Entered Addres " + etAddress.text);

        BlocProvider.of<CartBloc>(context)
            .add(PlaceOrderCartEvent(userLogin: userLoginAsGuestInfo));

        etSpecialNote.text = "";
        etName.text = "";
        etPhone.text = "";
        etAddress.text = "";
        etEmail.text = "";
      }
      // } else {
      //   userLoginForCartOrderSubmission.data.customerNote =
      //       etSpecialNote.text;

      //   BlocProvider.of<CartBloc>(context).add(PlaceOrderCartEvent(
      //       userLogin: userLoginForCartOrderSubmission));

      //   etSpecialNote.text = "";
      // }
      //  }
      // } catch (ex) {
      //   print(" 'User not logged in ' and exception here : $ex");
      // }
      // }
    } catch (ex) {
      print(" 'User not logged in ' and exception here : $ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, state) {
        if (state is FailedToFetchAllFoodProductsFromCartSate) {
          return failureWidget();
        }
        if (state is UpdateFoodProductListWhenAddingNewFoodProductState) {
          //  print("List size in cart screen ${state.foodinfo.length}");

//TODO: Un comment the Cart Billing block
//this will be called when ever the this state will come

          // if (shippingInfoListIndex == null) {
          //   if (state.foodinfo.length != 0) {
          //     if (state.foodinfo[0].shippingInfoListIndexFormFoodInfo != null) {
          //       BlocProvider.of<CartBloc>(context).add(
          //           FoodProductTotalBillCartEvent(
          //               index: state
          //                   .foodinfo[0].shippingInfoListIndexFormFoodInfo));
          //     } else {
          //       BlocProvider.of<CartBloc>(context)
          //           .add(FoodProductTotalBillCartEvent(index: null));
          //     }
          //   } else {
          //     BlocProvider.of<CartBloc>(context)
          //         .add(FoodProductTotalBillCartEvent(index: null));
          //   }
          // } else {
          //   BlocProvider.of<CartBloc>(context).add(
          //       FoodProductTotalBillCartEvent(index: shippingInfoListIndex));
          // }

          if (state.foodinfo.length > 0) {
            return Container(
                height: MediaQuery.of(context).size.height,
                color: AppTheme.background1,
                child: _buildBody(context, state));
          }
        }
        if (state is GettingCartDataInProcess) {
          return OrderPlacingInProgressWidget();
        }
        if (state is OrderPlacingInProcess) {
          return OrderPlacingInProgressWidget();
        }
        if (state is OrderPlacedSuccessfully) {
          return OrderPlacedSuccessfullyWidget();
        }
        if (state is OrderPlacedReturnedRecipt) {
          return OrderRecipt(
            orderinfo: state.myOrdersModel.data.orderinfo[0],
            data: state.myOrdersModel.data,
            conteextA: context,
          );
        }
        if (state is FailedOrderPlacing) {
          return OrderPlacingFailedWidget();
        }
        return failureWidget();
      },
    );
  }
}
