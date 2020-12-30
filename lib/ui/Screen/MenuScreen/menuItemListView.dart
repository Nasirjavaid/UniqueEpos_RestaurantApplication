import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartState.dart';
import 'package:retaurant_app/bloc/foodProductBloc/foodProductBloc.dart';
import 'package:retaurant_app/bloc/foodProductBloc/foodProductEvent.dart';
import 'package:retaurant_app/bloc/foodProductBloc/foodProductState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/model/foodProduct.dart';
import 'package:retaurant_app/repository/foodProductRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:retaurant_app/ui/CommomWidgets/triAnglePainter.dart';

class MenuItemListViewMain extends StatefulWidget {
  final String categoryId;

  MenuItemListViewMain({@required this.categoryId});

  @override
  _MenuItemListViewMainState createState() => _MenuItemListViewMainState();
}

class _MenuItemListViewMainState extends State<MenuItemListViewMain>
    with WidgetsBindingObserver, AutomaticKeepAliveClientMixin {
  final FoodProductRepository foodProductRepository = FoodProductRepository();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            FoodProductBloc()..add(FoodProductEventFetched(widget.categoryId)),
        child:
            MenuItemListView(context: context, categoryId: widget.categoryId));
  }
}

class MenuItemListView extends StatefulWidget {
  final BuildContext context;
  final String categoryId;

  MenuItemListView({this.context, this.categoryId});

  @override
  _MenuItemListViewState createState() => _MenuItemListViewState();
}

class _MenuItemListViewState extends State<MenuItemListView> {
  final FoodProductRepository foodProductRepository = FoodProductRepository();
  int addOnsCount = 1;

  List<Addonsinfo> addonsInfoSelectedItemsList = [];

  double getAddonsTotalPricePerProductWithCountValue(Addonsinfo addOnsInfo) {
    // int addOnsTotalPrice;

    double addOnsPerProductTotalPrice = double.parse(addOnsInfo.addonsprice) *
        double.parse(addOnsInfo.addOnsCount.toString());

    print(
        "Total price of aadon per product with counter ${addOnsInfo.addOnsCount}  and rate price ${addOnsInfo.addonsprice}  and total price $addOnsPerProductTotalPrice");

    return addOnsPerProductTotalPrice;
  }

  int totalPriceOfAddonsList(List<Addonsinfo> addOnsInfoList) {
    int totalAddonsListPrice = 0;
    for (int i = 0; i < addOnsInfoList.length; i++) {
      totalAddonsListPrice += addOnsInfoList[i].addonsPerItemTotalPrice.toInt();
    }

    setState(() {
      return totalAddonsListPrice;
    });
    return totalAddonsListPrice;
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: 600),
        backgroundColor: AppTheme.appDefaultColor,
        content:
            Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodProductBloc, FoodProductState>(
      builder: (context, state) {
        //initial state is data is loading  from the repository show loading indicator
        if (state is FoodProductInProgressState) {
          return LoadingIndicator();
        }
        // If any error then show error message
        if (state is FoodProductFailureState) {
          return InkWell(
            onTap: () {
              // FoodProductBloc(foodProductRepository: foodProductRepository)
              //   ..add(FoodProductEventFetched(widget.categoryId));

              NetworkConnectivity.check().then((internet) {
                if (internet) {
                  BlocProvider.of<FoodProductBloc>(context)
                      .add(FoodProductEventFetched(widget.categoryId));
                } else {
                  //show network erro

                  Methods.showToast(context, "Check your network");
                }
              });
            },
            child: Center(
              child: Column(
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
          );
        }
        // if data is Successfully obtained pass to widget body
        if (state is FoodProductSuccessState) {
          return Container(
            color: AppTheme.background1,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 5.0, right: 5, left: 5, bottom: 1),
              child: ListView.builder(
                  // padding: EdgeInsets.only(top:40),
                  itemCount: state.foodProduct.data.foodinfo.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return menuItemListViewCard(
                        context,
                        state.foodProduct.data.foodinfo[index],
                        state.foodProduct.data);
                  }),
            ),
          );
        }
        return Container();
      },
    );

    // return Container(
    //   color: AppTheme.background1,
    //   child: Padding(
    //     padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5, bottom: 1),
    //     child: ListView.builder(
    //         itemCount: 100,
    //         scrollDirection: Axis.vertical,
    //         itemBuilder: (BuildContext context, int index) {
    //           return menuItemListViewCard(context);
    //         }),
    //   ),
    // );
  }

  Widget menuItemListViewCard(
      BuildContext contex, Foodinfo foodinfo, Data data) {
    return Stack(
      children: [
        InkWell(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.4),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2),
                    topLeft: Radius.circular(2)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  foodinfo.productName != null
                      ? Text("${foodinfo.productName}",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(widget.context)
                              .textTheme
                              .button
                              .copyWith(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16))
                      : Text("N/A",
                          style: Theme.of(widget.context)
                              .textTheme
                              .button
                              .copyWith(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 4,
                          ),
                          foodinfo.variantName != null
                              ? Text("(${foodinfo.variantName})",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1)
                              : Text("N/A",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          data == null || data.currencyIcon == null
                              ? Text("",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(
                                        color: Colors.black38,
                                      ))
                              : Text("${data.currencyIcon}",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Colors.black38,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900)),
                          foodinfo.price != null
                              ? Text("${foodinfo.price}",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.black45,
                                      ))
                              : Text("N/A",
                                  style: Theme.of(widget.context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                        color: Colors.black45,
                                      )),
                        ],
                      )
                      // IconButton(
                      //     hoverColor: AppTheme.appDefaultColor,
                      //     icon: Icon(
                      //       FontAwesomeIcons.cartPlus,
                      //       size: 14,
                      //       color: AppTheme.appDefaultColor,
                      //     ),
                      //     onPressed: () {
                      //       if (foodinfo.addons == 0) {
                      //         print("No adons available");
                      //          BlocProvider.of<CartBloc>(context)
                      //         .add(AddProductTocartEvent(foodinfo: foodinfo));

                      //       } else {
                      //         showDialog(context, foodinfo);
                      //       }
                      //     })
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  foodinfo.description != null
                      ? Text(
                          "${foodinfo.description}",
                          overflow: TextOverflow.ellipsis,
                          maxLines: 4,
                          style: Theme.of(widget.context).textTheme.bodyText1,
                        )
                      : Text("N/A",
                          style: Theme.of(widget.context).textTheme.bodyText1),
                ],
              ),
            ),
          ),
          onTap: () {
            if (foodinfo.addons == 0) {
              print("No adons available");

              // double foodPriceCoversionFromStringToDouble =
              //     double.parse(foodinfo.price);
              // foodinfo.foodPerItemTtotalPrice =
              //     foodPriceCoversionFromStringToDouble.toInt() * foodinfo.count;

              // foodinfo.total = foodinfo.foodPerItemT  totalPrice;
              if (foodinfo.productOptions.length != 0) {
                Methods.showDialogForProductOptions(context, foodinfo, data);
              } else {
                print(
                    "Food info per item total prices (on Add product event in Menu Screen ):${foodinfo.foodPerItemTtotalPrice}");

                BlocProvider.of<CartBloc>(context)
                    .add(AddProductTocartEvent(foodinfo: foodinfo));
////////////////////////////////////////////////////////////////dd

                BlocProvider.of<CartBloc>(context)
                    .add(FoodProductTotalBillCartEvent());

///////////////////////////////////////////////////////////////////
                _showToast(context,
                    "${foodinfo.productName} (${foodinfo.variantName})   added to cart");
              }
            } else {
              Methods.showDialogMenuListAddons(context, foodinfo, data);
            }
          },
        ),
        Positioned(
          right: MediaQuery.of(context).size.width * -0.031,
          top: MediaQuery.of(context).size.height * -0.001,
          child: Container(
            alignment: Alignment.center,
            child: BlocBuilder<CartBloc, CartState>(
                builder: (BuildContext context, state) {
              if (state is UpdateFoodProductListWhenAddingNewFoodProductState) {
                int index = state.foodinfo.lastIndexWhere(
                  (f) => f.variantid == foodinfo.variantid,
                );
                if (index == -1) {
                  return Container();
                } else {
                  return RotationTransition(
                    turns: new AlwaysStoppedAnimation(45 / 360),
                    child: CustomPaint(
                      painter: TrianglePainter(
                        strokeColor: AppTheme.appDefaultColor,
                        // strokeWidth: 10,
                        paintingStyle: PaintingStyle.fill,
                      ),
                      child: RotationTransition(
                        turns: new AlwaysStoppedAnimation(-45 / 360),
                        child: Container(
                          height: 25,
                          width: 50,
                          child: Center(
                              child: Padding(
                            padding: const EdgeInsets.only(right: 5.0, top: 2),
                            child: Icon(
                              FontAwesomeIcons.cartArrowDown,
                              size: 10,
                              color: Colors.white,
                            ),
                          )),
                        ),
                      ),
                    ),
                  );
                }
              }

              return Container();
            }),
          ),
        ),
      ],
    );
  }
}
