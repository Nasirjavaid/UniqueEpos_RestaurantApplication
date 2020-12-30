import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../bloc/cartBloc/cartBloc.dart';
import '../../../bloc/cartBloc/cartEvent.dart';
import '../../../config/appTheme.dart';
import '../../../model/foodProduct.dart';

class CartaddonsUpdatingDialogue extends StatefulWidget {
  final Foodinfo foodinfo;
  final BuildContext contextA;
  final int shippingInfoListIndex;
  final Data data;

  CartaddonsUpdatingDialogue(
      {this.foodinfo, this.contextA, this.shippingInfoListIndex, this.data});

  @override
  _CartaddonsUpdatingDialogueState createState() =>
      _CartaddonsUpdatingDialogueState();
}

class _CartaddonsUpdatingDialogueState
    extends State<CartaddonsUpdatingDialogue> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double addOnsListTotalPrice = 0;

  double getAddonsTotalPricePerProductWithCountValue(Addonsinfo addOnsInfo) {
    double addOnsPerProductTotalPrice = double.parse(addOnsInfo.addonsprice) *
        double.parse(addOnsInfo.addOnsCount.toString());

    print(
        "Total price of aadon per product with counter ${addOnsInfo.addOnsCount}  and rate price ${addOnsInfo.addonsprice}  and total price $addOnsPerProductTotalPrice");

    return addOnsPerProductTotalPrice;
  }

  double totalPriceOfAddonsList(Foodinfo foodinfo) {
    double totalAddonsListPrice = 0;

    for (int i = 0; i < foodinfo.addonsinfo.length; i++) {
      if (foodinfo.addonsinfo[i].addedStatus != null &&
          foodinfo.addonsinfo[i].addedStatus == true) {
        totalAddonsListPrice +=
            foodinfo.addonsinfo[i].addonsPerItemTotalPrice.toInt();
      }
    }

    setState(() {
      return totalAddonsListPrice;
    });

    return totalAddonsListPrice;
  }

  // void _showToast(BuildContext context, String message) {
  //   _scaffoldKey.currentState.showSnackBar(
  //     SnackBar(
  //       backgroundColor: AppTheme.appDefaultColor,
  //       content:
  //           Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    // addonsInfoSelectedItemsList = widget.foodinfo.addonsinfo;

    if (widget.foodinfo.addonsinfo.length != 0) {
      totalPriceOfAddonsList(widget.foodinfo);
      setState(() {
        addOnsListTotalPrice = widget.foodinfo.addOnsListTotalPrice;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Colors.black38,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        //centerTitle: true,
        title: Text(
          "Customize",
          style: Theme.of(context).textTheme.button.copyWith(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${widget.foodinfo.productName}",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(fontSize: 18),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          widget.foodinfo.variantName != null
                              ? Text("(${widget.foodinfo.variantName})",
                                  style: Theme.of(context).textTheme.bodyText1)
                              : Text("N/A",
                                  style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(
                            height: 4,
                          ),
                        ],
                      ),
                      Text(
                        "${widget.data.currencyIcon != null ? widget.data.currencyIcon : ""} ${double.parse(widget.foodinfo.price).toStringAsFixed(2)}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 0.0, right: 20),
                //   child: Text(
                //     "${foodinfo.description}",
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 2,
                //     style: Theme.of(widget.context)
                //         .textTheme
                //         .bodyText1
                //         .copyWith(
                //           fontSize: 11,
                //         ),
                //   ),
                // ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Addons",
                  style:
                      Theme.of(context).textTheme.button.copyWith(fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  flex: 9,
                  child: ListView.builder(
                      itemCount: widget.foodinfo.addonsinfo.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return addOnsItemCard(
                          context,
                          widget.foodinfo.addonsinfo[index],
                        );
                      }),
                ),
                SizedBox(
                  height: 5,
                ),
                totalPriceWidet(context),
                SizedBox(
                  height: 5,
                ),
                Expanded(flex: 1, child: addTocartButton(widget.foodinfo)),
              ],
            ),
          ),
          margin: EdgeInsets.only(bottom: 10, left: 6, right: 6, top: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ),
    );
  }

  Widget addOnsItemCard(
    BuildContext context,
    Addonsinfo addonsinfo,
  ) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setState) {
        return Card(
          elevation: 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${addonsinfo.addOnName}",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 13),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              if (addonsinfo.addOnsCount > 1)
                                // print(
                                //     "with index  Addons decreament ${addonsinfo.addOnsCount -= 1}");

                                //Decreasing addons counter
                                addonsinfo.addOnsCount =
                                    addonsinfo.addOnsCount - 1;

                              print(
                                  "Addons decreament ${addonsinfo.addOnsCount}");

                              //get Per addons prices ass counter decreases
                              addonsinfo.addonsPerItemTotalPrice =
                                  getAddonsTotalPricePerProductWithCountValue(
                                      addonsinfo);

                              print(
                                  "Addons price now  ${addonsinfo.addonsPerItemTotalPrice}");
                              //get total prices of addons selected list
                              addOnsListTotalPrice =
                                  totalPriceOfAddonsList(widget.foodinfo);

                              print(
                                  "tottal addons list price now $addOnsListTotalPrice}");
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Icon(
                              FontAwesomeIcons.minus,
                              size: 15,
                              color: AppTheme.appDefaultColor,
                            ),
                          ),
                        ),
                        Container(
                          width: 30,
                          height: 20,
                          child: Center(
                            child: Text(
                              "${addonsinfo.addOnsCount}",
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              // print(
                              //     "with index Increment   ${addonsinfo.addOnsCount += 1}");
                              // print("with index Increment  $addOnsCount");

                              //add ons increament counter
                              addonsinfo.addOnsCount =
                                  addonsinfo.addOnsCount + 1;

                              print(
                                  "Addons Increment  ${addonsinfo.addOnsCount}");
//get total prices of per product
                              addonsinfo.addonsPerItemTotalPrice =
                                  getAddonsTotalPricePerProductWithCountValue(
                                      addonsinfo);

                              print(
                                  "Addons price now  ${addonsinfo.addonsPerItemTotalPrice}");
//get total prices of addons selected list
                              addOnsListTotalPrice =
                                  totalPriceOfAddonsList(widget.foodinfo);

                              print(
                                  "tottal addons list price now $addOnsListTotalPrice}");
                            });
                            //get Per addons prices ass counter increases
                            getAddonsTotalPricePerProductWithCountValue(
                                addonsinfo);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Icon(FontAwesomeIcons.plus,
                                size: 15, color: AppTheme.appDefaultColor),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "${widget.data.currencyIcon != null ? widget.data.currencyIcon : ""} ${double.parse(addonsinfo.addonsprice).toStringAsFixed(2)}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 15,
                      width: 15,
                      child: Checkbox(
                        activeColor: AppTheme.appDefaultColor,
                        value: addonsinfo.addedStatus != null
                            ? addonsinfo.addedStatus
                            : false,
                        onChanged: (val) {
                          setState(() {
                            // changed
                            if (val == true) {
                              // if (!addonsInfoSelectedItemsList
                              //     .contains(addonsinfo)) {
                              //       addonsInfoSelectedItemsList.add(addonsinfo);
                              //     }
                              //addons added status for cart confirmation
                              addonsinfo.addedStatus = true;
                              print(
                                  "status for addons added ${addonsinfo.addedStatus}");
                              //get Per addons prices ass counter decreases
                              addonsinfo.addonsPerItemTotalPrice =
                                  getAddonsTotalPricePerProductWithCountValue(
                                      addonsinfo);

                              /////////////////////////////
                              setState(() {
                                addOnsListTotalPrice =
                                    totalPriceOfAddonsList(widget.foodinfo);
                              });

                              print(
                                  "tottal addons list price now $addOnsListTotalPrice}");
                            } else {
                              //addons added status for cart confirmation
                              addonsinfo.addedStatus = false;
                              print(
                                  "status for addons added ${addonsinfo.addedStatus}");
                              //get Per addons prices ass counter decreases
                              addonsinfo.addonsPerItemTotalPrice =
                                  getAddonsTotalPricePerProductWithCountValue(
                                      addonsinfo);

                              ///////////////////////////////////////////////
                              setState(() {
                                addOnsListTotalPrice =
                                    totalPriceOfAddonsList(widget.foodinfo);
                              });
                              print(
                                  "tottal addons list price now $addOnsListTotalPrice}");
                              // print(
                              //     "item removed form addons info selected list : ${addonsinfo.addOnName}");
                              // print(
                              //     " addons info selected items list size:  ${addonsInfoSelectedItemsList.length}");
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget totalPriceWidet(BuildContext context) {
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              Text(
                "${widget.data.currencyIcon != null ? widget.data.currencyIcon : ""} ${addOnsListTotalPrice.toStringAsFixed(2)}",
                style: Theme.of(context)
                    .textTheme
                    .button
                    .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget addTocartButton(Foodinfo foodinfo) {
    return SizedBox(
      height: 35,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: Container(
          width: MediaQuery.of(context).size.width,
          // margin: EdgeInsets.only(top: 0.0),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(0.0)),
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
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 82.0),
                child: Text("Update Cart",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () async {
                print("Update cart Clicked");

                widget.foodinfo.addOnsListTotalPrice = addOnsListTotalPrice;

                BlocProvider.of<CartBloc>(widget.contextA)
                    .add(UpdateFoodInfoCartEvent(foodinfo: widget.foodinfo));

                ////////////////////////////////////////////////////////////////dd
                BlocProvider.of<CartBloc>(widget.contextA).add(
                    FoodProductTotalBillCartEvent(
                        index: widget.shippingInfoListIndex));

///////////////////////////////////////////////////////////////////
                Navigator.pop(context);
                // _showToast(widget.contextA,
                //     "${foodinfo.productName} (${foodinfo.variantName})   Updated");
              }

              // showInSnackBar("Login button pressed")

              ),
        ),
      ),
    );
  }
}
