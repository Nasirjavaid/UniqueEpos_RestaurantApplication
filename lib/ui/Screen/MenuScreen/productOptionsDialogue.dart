import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/cartBloc/cartBloc.dart';
import '../../../bloc/cartBloc/cartEvent.dart';
import '../../../config/appTheme.dart';
import '../../../model/foodProduct.dart';

// ignore: must_be_immutable
class ProductOptionsDialogue extends StatefulWidget {
  Foodinfo foodinfo;
  BuildContext contextA;
  Data data;

  ProductOptionsDialogue({this.foodinfo, this.contextA, this.data}) {
    this.foodinfo = foodinfo;
    this.data = data;
  }

  @override
  _ProductOptionsDialogueState createState() => _ProductOptionsDialogueState();
}

class _ProductOptionsDialogueState extends State<ProductOptionsDialogue> {
  //new module parts
  List<List<String>> globalList = [];
  List<String> newInnerList;
  //

  @override
  void initState() {
    super.initState();
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: AppTheme.appDefaultColor,
        content:
            Text("$message", style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            "Choose",
            style: Theme.of(context).textTheme.button.copyWith(fontSize: 16),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView(
                //shrinkWrap: true,
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    child: widget.foodinfo.productOptions.length != 0
                        ? productOptionsListView(widget.foodinfo.productOptions)
                        : Container(),

                    
                  
                  ),
                  
                  SizedBox(
                      height: 5,
                    ),

                      addTocartButton(widget.foodinfo),
                ]),
          ),

          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(6),
        ));
  }

  Widget productOptionsListView(
    List<ProductOptions> productOptions,
  ) {
    for (int i = 0; i < productOptions.length; i++) {
      List<String> i = [];
      // String dynamicName = i.toString();
      // var listName =dynamicList+"";
      globalList.add(i);
    }

    return ListView.builder(
        itemCount: productOptions.length,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          // return Text("test");
          return productOptionListCard(context, productOptions[index], index);
        });
  }

  Widget productOptionListCard(BuildContext context,
      ProductOptions productOptions, int productOptionIndex) {
    List<String> optionValues = [];
    optionValues = productOptions.optionValues.split(",");
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "${productOptions.title}",
              style: Theme.of(context).textTheme.button.copyWith(fontSize: 14),
            ),
          ),
          Container(
           // height: MediaQuery.of(context).size.height * 0.345,
            child: ListView.builder(
                itemCount: optionValues.length,
                scrollDirection: Axis.vertical,
                //physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  var optionsList = productOptions.optionValues;
                  var optionsListAsItems = json.decode(optionsList);

                  return CheckboxListTile(
                    dense: true,

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    activeColor: AppTheme.appDefaultColor,
                    //tileColor: Colors.grey[100],
                    title: Text(
                      "${optionsListAsItems[index]}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ), //    <-- label
                    value: globalList[productOptionIndex]
                        .contains(optionsListAsItems[index]),
                    // value: false,

                    onChanged: (newValue) {
                      // print(
                      //     "test  ::: ${globalList[productOptionIndex].contains(optionsListAsItems[index].toString())} ${optionsListAsItems[index].toString()}");

                      setState(() {
                        newInnerList = globalList[productOptionIndex];

                        if (newValue == true) {
                          // print("Value true ${globalList.length}");

                          if (newInnerList.length >=
                              int.parse(productOptions.maximumSelection)) {
                            newInnerList = [];
                            print(
                                "You can select Max ${productOptions.maximumSelection} option(s)");
                            _showToast(context,
                                "You can select Max ${productOptions.maximumSelection} option(s)");
                          } else {
                            // List<String>  newInnerList =[];
                            newInnerList.add(optionsListAsItems[index]);
                            globalList.add(newInnerList);
                            print("inner list size ${newInnerList.length}");
                            print("global list size ${globalList.length}");
                          }
                        } else {
                          newInnerList.remove(optionsListAsItems[index]);
                          print(
                              "Value false and inner list size ${newInnerList.length}");
                        }
                      });
                    },
                  );
                  // return Row(
                  //   children: [
                  //     Text("${optionsListAsItems[index]}"),
                  //     Checkbox(),
                  //   ],
                  // );
                }),
          ),
          Divider()
        ],
      ),
    );
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
                child: Text("Add to Cart",
                    style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white)),
              ),
              onPressed: () {
                print("Add to cart Clicked");

// this was added to remove a bug of duplication and unnecessary list item updating isssue
                Foodinfo foodinfoMain =
                    new Foodinfo.fromJson(foodinfo.toJson());

                print("Object hash code########### : ${foodinfoMain.hashCode}");
                ////////////////////////////////////////////

                // new module portion of product options
                List<String> productOptionsListMain = [];
                for (int i = 0; i < foodinfoMain.productOptions.length; i++) {
                  List<String> productOptionsList = [];
                  productOptionsList.add(globalList[i].toString());

                  // productOptionsList.
                  for (int j = 0; j < productOptionsList.length; j++) {
                    if (!productOptionsList[j].contains("[]") ||
                        !productOptionsList[j]
                            .contains(productOptionsList[j].toString())) {
                      productOptionsListMain.add(productOptionsList[j]);
                    } else {
                      print("empty value or duplicate value");
                    }
                  }
                }
                foodinfoMain.selectedOptionValues =
                    productOptionsListMain.toString();

                print(
                    "Main product options list size ${productOptionsListMain.length}");
//

                BlocProvider.of<CartBloc>(widget.contextA)
                    .add(AddProductTocartEvent(foodinfo: foodinfoMain));

                    
                    BlocProvider.of<CartBloc>(widget.contextA)
                    .add(FoodProductTotalBillCartEvent());

                Navigator.pop(context);
                // _showToast(widget.contextA,
                //     "${foodinfo.productName} (${foodinfo.variantName})   Added to cart");
              }

              // showInSnackBar("Login button pressed")

              ),
        ),
      ),
    );
  }
}
