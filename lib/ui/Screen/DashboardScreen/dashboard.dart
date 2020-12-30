import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/dashboardBloc/dashBoardState.dart';
import 'package:retaurant_app/bloc/dashboardBloc/dashboardBloc.dart';
import 'package:retaurant_app/bloc/dashboardBloc/dashboardEvent.dart';
import 'package:retaurant_app/config/appConstants.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:retaurant_app/ui/CommomWidgets/roundedImageViewWithoutBorderDynamic.dart';

class DashBoardMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) {
          return DashboardBloc()..add(GetDashBoardData());
        },
        child: DashBoard(),
      ),
    );
  }
}

//  NetworkConnectivity.check().then((internet) {
//     if (internet) {
//       callCartFromSharedPrefrences();
//     } else {
//       //show network erro
//       showMessageError("Check your network");
//     }
//   });

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  List<Foodinfo> foodInfoList;
  Foodinfo singleFoodinfo;

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 1000),
        backgroundColor: AppTheme.appDefaultColor,
        content:
            Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardSate>(
      builder: (BuildContext context, state) {
        if (state is FetchingDashboadDataInProgressDashboardState) {
          return LoadingIndicator();
        }
        if (state is FetchedDashboadDataSuccessfulyDashboardState) {
          try {
            foodInfoList = List<Foodinfo>();
            singleFoodinfo = new Foodinfo();
            foodInfoList = state.foodProduct.data.foodinfo;
            singleFoodinfo = foodInfoList[0];
            foodInfoList.removeAt(0);
          } catch (ex) {
            print("Error in dashboard :$ex");
          }
          return _buildMainBody(
            context,
            state.foodProduct,
            singleFoodinfo,
            foodInfoList,
          );
        }

        if (state is FailedToFetchDashboadDataDashboardState) {
          return Center(
            child: failedWidget(context),
          );
        }

        return Container();
      },
    );
  }

  Widget _buildMainBody(BuildContext contex, FoodProduct foodProduct,
      Foodinfo singleFoodinfo, List<Foodinfo> foodInfoList) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            singleWidgetImageProduct(foodProduct, singleFoodinfo),
            itemsGridView(context, foodProduct, foodInfoList),
          ],
        ),
      ),
    );
  }

  Widget itemsGridView(BuildContext context, FoodProduct foodProduct,
      List<Foodinfo> foodInfoList) {
    // foodinfoList = state.foodinfoList;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 6),
      child: GridView.count(
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 1.9),
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: List.generate(foodInfoList.length, (index) {
          return Card(
            elevation: 6,
            child: InkWell(
              onTap: () {
                addProductToCart(
                    foodProduct.data.foodinfo[index], foodProduct.data);
              },
              child: Stack(
                children: [
                  RoundedCornerImageViewWithoutBorderDynamic(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    cornerRadius: 5,
                    imageLink: foodProduct.data.foodinfo[index].productImage ==
                            APIConstants.baseUrl
                        ? "https://ozersky.tv/wp-content/uploads/2018/02/hamburger-7.jpg"
                        : foodProduct.data.foodinfo[index].productImage,
                  ),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment(-1.0, 1.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                  // topLeft: const Radius.circular(5.0),
                                  // topRight: const Radius.circular(5.0),
                                  bottomRight: const Radius.circular(5.0),
                                  bottomLeft: const Radius.circular(5.0),
                                ),
                                gradient: LinearGradient(
                                    begin: Alignment.topRight,
                                    end: Alignment.center,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black87
                                    ])),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5.0, left: 6.0, top: 6),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  foodProduct.data.foodinfo[index].productName
                                          .isNotEmpty
                                      ? Text(
                                          "${foodProduct.data.foodinfo[index].productName}",
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button
                                              .copyWith(color: Colors.white),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              const Radius.circular(3.0),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.center,
                                                colors: [
                                                  Colors.green,
                                                  Colors.green,
                                                ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.0, horizontal: 3),
                                          child: Text(
                                            "${foodProduct.data.foodinfo[index].variantName}",
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .copyWith(
                                                    fontSize: 9,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w900),
                                          ),
                                        ),
                                      ),

                                      //////////
                                      SizedBox(
                                        width: 4,
                                      ),
                                      foodProduct.data.foodinfo[index].price
                                              .isNotEmpty
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    const Radius.circular(3.0),
                                                  ),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.center,
                                                      colors: [
                                                        Colors.white,
                                                        Colors.white,
                                                      ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0,
                                                        horizontal: 2),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${foodProduct.data.currencyIcon}",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                    ),
                                                    Text(
                                                      "${foodProduct.data.foodinfo[index].price}",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                            fontSize: 9,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                            decorationThickness:
                                                                2.5,
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 4,
                                      ),

                                      // Container(
                                      //   height: 1,
                                      //   width: 5,
                                      //   color: Colors.white,
                                      // ),
                                      // SizedBox(
                                      //   width: 4,
                                      // ),

//////////////////////////////////////////////////////////////////////

                                      foodProduct.data.foodinfo[index]
                                                  .foodItemDiscountedPrice !=
                                              null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.all(
                                                    const Radius.circular(3.0),
                                                  ),
                                                  gradient: LinearGradient(
                                                      begin: Alignment.topRight,
                                                      end: Alignment.center,
                                                      colors: [
                                                        AppTheme
                                                            .appDefaultColor,
                                                        AppTheme
                                                            .appDefaultColor,
                                                      ])),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 2.0,
                                                        horizontal: 3),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      "${foodProduct.data.currencyIcon}",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                    ),
                                                    Text(
                                                      "${foodProduct.data.foodinfo[index].foodItemDiscountedPrice.toStringAsFixed(2)}",
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              fontSize: 9,
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ))),
                  Positioned.fill(
                      child: Align(
                          alignment: Alignment(1.0, -1.0),
                          child: discountWidgetForGrid(
                              foodProduct.data.foodinfo[index])))
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget singleWidgetImageProduct(
      FoodProduct foodProduct, Foodinfo singleFoodinfo) {
    return InkWell(
      onTap: () {
        addProductToCart(singleFoodinfo, foodProduct.data);
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5.5, top: 3),
        child: Card(
          elevation: 6,
          child: Stack(children: [
            RoundedCornerImageViewWithoutBorderDynamic(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width,
              cornerRadius: 5,
              imageLink: singleFoodinfo.productImage == APIConstants.baseUrl
                  ? "https://ozersky.tv/wp-content/uploads/2018/02/hamburger-7.jpg"
                  : singleFoodinfo.productImage,
            ),
            Positioned.fill(
                child: Align(
                    alignment: Alignment(-1.0, 1.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            // topLeft: const Radius.circular(5.0),
                            // topRight: const Radius.circular(5.0),
                            bottomRight: const Radius.circular(5.0),
                            bottomLeft: const Radius.circular(5.0),
                          ),
                          gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.center,
                              colors: [Colors.transparent, Colors.black87])),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8.0, left: 8.0, top: 3, right: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${singleFoodinfo.productName}",
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.white),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: new BorderRadius.all(
                                        const Radius.circular(3.0),
                                      ),
                                      gradient: LinearGradient(
                                          begin: Alignment.topRight,
                                          end: Alignment.center,
                                          colors: [
                                            Colors.green,
                                            Colors.green,
                                          ])),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3.0, horizontal: 4),
                                    child: Text(
                                      "${singleFoodinfo.variantName}",
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),

                                //////////
                                SizedBox(
                                  width: 10,
                                ),
                                singleFoodinfo.price.isNotEmpty
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              const Radius.circular(3.0),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.center,
                                                colors: [
                                                  Colors.white,
                                                  Colors.white,
                                                ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 4),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${foodProduct.data.currencyIcon}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w900),
                                              ),
                                              Text(
                                                "${singleFoodinfo.price}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationThickness: 2.5,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  width: 4,
                                ),

                                // Container(
                                //   height: 1,
                                //   width: 5,
                                //   color: Colors.white,
                                // ),
                                // SizedBox(
                                //   width: 4,
                                // ),

//////////////////////////////////////////////////////////////////////

                                singleFoodinfo.foodItemDiscountedPrice != null
                                    ? Container(
                                        decoration: BoxDecoration(
                                            borderRadius: new BorderRadius.all(
                                              const Radius.circular(3.0),
                                            ),
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.center,
                                                colors: [
                                                  AppTheme.appDefaultColor,
                                                  AppTheme.appDefaultColor,
                                                ])),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3.0, horizontal: 4),
                                          child: Row(
                                            children: [
                                              Text(
                                                "${foodProduct.data.currencyIcon}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900),
                                              ),
                                              Text(
                                                "${singleFoodinfo.foodItemDiscountedPrice.toStringAsFixed(2)}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .copyWith(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))),
            Positioned.fill(
                child: Align(
                    alignment: Alignment(1.0, -1.0),
                    child: discountWidgetForSingleUpperWidget(
                        singleFoodinfo.offersRate)))
          ]),
        ),
      ),
    );
  }

  Widget discountWidgetForSingleUpperWidget(String discountRate) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(0.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(0.0),
              bottomLeft: const Radius.circular(25.0),
            ),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.center,
                colors: [AppTheme.appDefaultColor, AppTheme.appDefaultColor])),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
          child: Text(
            "-$discountRate%",
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(color: Colors.white, fontWeight: FontWeight.w900),
          ),
        ));
  }

  Widget discountWidgetForGrid(Foodinfo foodinfo) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(0.0),
              topRight: const Radius.circular(5.0),
              bottomRight: const Radius.circular(0.0),
              bottomLeft: const Radius.circular(25.0),
            ),
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.center,
                colors: [AppTheme.appDefaultColor, AppTheme.appDefaultColor])),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 12),
          child: Text(
            "-${foodinfo.offersRate}%",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ));
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
            Text("No items",
                style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: Colors.black38,
                    )),
            SizedBox(
              height: 8,
            ),
            Text("Tap to Reload",
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                      color: Colors.black45,
                    )),
          ],
        ),
      ),
      onPressed: () {
        NetworkConnectivity.check().then((internet) {
          if (internet) {
            BlocProvider.of<DashboardBloc>(context).add(GetDashBoardData());
          } else {
            //show network erro

            Methods.showToast(context, "Check your network");
          }
        });
      },
    );
  }

  void addProductToCart(Foodinfo foodinfo, Data data) {
    Foodinfo foodinfoMain = new Foodinfo.fromJson(foodinfo.toJson());
    if (foodinfoMain.addons == 0) {
      print("No adons available");

      if (foodinfo.productOptions.length != 0) {
        Methods.showDialogForProductOptions(context, foodinfo, data);
      } else {
        print(
            "Food info per item total prices (on Add product event in Menu Screen ):${foodinfo.foodPerItemTtotalPrice}");

        BlocProvider.of<CartBloc>(context)
            .add(AddProductTocartEvent(foodinfo: foodinfo));
////////////////////////////////////////////////////////////////dd

        BlocProvider.of<CartBloc>(context).add(FoodProductTotalBillCartEvent());

///////////////////////////////////////////////////////////////////
        _showToast(context,
            "${foodinfo.productName} (${foodinfo.variantName})   added to cart");
      }

//       BlocProvider.of<CartBloc>(context)
//           .add(AddProductTocartEvent(foodinfo: foodinfoMain));
// ////////////////////////////////////////////////////////////////dd

//       BlocProvider.of<CartBloc>(context).add(FoodProductTotalBillCartEvent());

// ///////////////////////////////////////////////////////////////////
//       _showToast(context, "${foodinfo.productName}. added to cart");

    } else {
      Methods.showDialogMenuListAddons(context, foodinfo, data);
    }
  }
}
