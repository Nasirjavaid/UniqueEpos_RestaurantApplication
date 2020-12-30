import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';
import 'dart:io';

import 'package:screenshot/screenshot.dart';

class MyOrdersDialogueBox extends StatefulWidget {
  final Orderinfo orderinfo;
  final Data data;
  final BuildContext conteextA;

  MyOrdersDialogueBox({this.orderinfo, this.data, this.conteextA});
  @override
  _MyOrdersDialogueBoxState createState() => _MyOrdersDialogueBoxState();
}

class _MyOrdersDialogueBoxState extends State<MyOrdersDialogueBox> {
  // int _counter = 0;
  File _imageFile;
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Map<Permission, PermissionStatus> statuses;
  Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;
  // int _counter = 0;

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
  void initState() {
    if (Platform.isAndroid) {
      requestPermission(Permission.storage);
    } else {
      requestPermission(Permission.photos);
    }
    _listenForPermissionStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0, top: 0),
      child: Container(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            // height: double.infinity,
            // padding: const EdgeInsets.symmetric(vertical: 130.0, horizontal: 15),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Screenshot(
                  controller: screenshotController,
                  child: Card(
                      child:
                          _buildBody(context, widget.orderinfo, widget.data)),
                ),
              ),
            )),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Orderinfo orderInfo, Data data) {
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              orderIdWidget(orderInfo, data),
              // SizedBox(height: 20),
              // Text(
              //   "Puchased items",
              //   style:
              //       Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 17),
              // ),
              SizedBox(height: 5),
              orderInfoInnerListView(orderInfo, data),
              SizedBox(height: 12),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: Colors.black12,
              ),
              SizedBox(height: 18),
              statusWidget(orderInfo),
              SizedBox(height: 10),

              dynamicItemsRow(
                context,
                "Date",
                "${orderInfo.orderdate != null ? Methods.dateToDateTimeConversion(orderInfo.orderdate) : ""}",
              ),
              SizedBox(height: 10),
              dynamicItemsRow(
                context,
                "VAT",
                "${data.currencyIcon}${orderInfo.vAT != null ? orderInfo.vAT : ""}",
              ),

              SizedBox(height: 10),

              dynamicItemsRow(
                context,
                "Service charges",
                "${orderInfo.servicecharge != null ? data.currencyIcon + orderInfo.servicecharge : ""}",
              ),
              SizedBox(height: 10),

              dynamicItemsRow(
                context,
                "Discount",
                "${orderInfo.discount != null ? data.currencyIcon + orderInfo.discount : ""}",
              ),

              SizedBox(height: 16),

              totalBillWidget(
                context,
                "Grand total ",
                "${orderInfo.orderamount != null ? data.currencyIcon + orderInfo.orderamount : ""}",
              ),
              SizedBox(height: 50),
              buttons(context, ""),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderIdWidget(Orderinfo orderInfo, Data data) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 60,
        decoration: BoxDecoration(
          color: AppTheme.appDefaultColor,
          // set border width
          borderRadius: BorderRadius.all(
              Radius.circular(0.0)), // set rounded corner radius
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Order ID : ",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 21, color: Colors.white)),
                Text("${orderInfo.saleinvoice.substring(1)}",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 21, color: Colors.white)),
              ],
            ),
          ),
        ));
  }

  Widget orderInfoInnerListView(Orderinfo orderInfo, Data data) {
    return Container(
      constraints: BoxConstraints(
          minHeight: 50, maxHeight: MediaQuery.of(context).size.height * 0.25),
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: orderInfo.foodlist == null ? 0 : orderInfo.foodlist.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            if (orderInfo.foodlist.length == -1 ||
                orderInfo.foodlist == null ||
                orderInfo.foodlist.isEmpty) {
              return Container();
            } else {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 1.0, horizontal: 1),
                child: Container(
                  color: AppTheme.background,
                  child: Container(
                    decoration: BoxDecoration(
                      // set border width
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0)), // set rounded corner radius
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${orderInfo.foodlist[index].productName != null ? orderInfo.foodlist[index].productName : ""}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 14),
                              ),
                              Text(
                                "x${orderInfo.foodlist[index].qty}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          Text(
                            "(${orderInfo.foodlist[index].variantName != null ? orderInfo.foodlist[index].variantName : ""})",
                            style:
                                Theme.of(context).textTheme.bodyText1.copyWith(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${data.currencyIcon != null ? data.currencyIcon : ""}${orderInfo.foodlist[index].variantPrice != null ? orderInfo.foodlist[index].variantPrice : ""}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w800),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget statusWidget(Orderinfo orderInfo) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Text("${orderInfo.orderdate != null ? orderInfo.orderdate : ""}"),
          Text("Status",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontSize: 14, fontWeight: FontWeight.w700)),

          orderInfo.status == "Pending"
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    // set border width
                    borderRadius: BorderRadius.all(
                        Radius.circular(3.0)), // set rounded corner radius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 7),
                    child: Text("${orderInfo.status}",
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(fontSize: 11, color: Colors.white)),
                  ))
              : orderInfo.status == "Cancelled"
                  ? Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        // set border width
                        borderRadius: BorderRadius.all(
                            Radius.circular(3.0)), // set rounded corner radius
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 7),
                        child: Text("${orderInfo.status}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 11, color: Colors.white)),
                      ))
                  : orderInfo.status == "Served"
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.green,
                            // set border width
                            borderRadius: BorderRadius.all(Radius.circular(
                                3.0)), // set rounded corner radius
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 7),
                            child: Text("${orderInfo.status}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
                                        fontSize: 11, color: Colors.white)),
                          ))
                      : orderInfo.status == "Processing"
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                // set border width
                                borderRadius: BorderRadius.all(Radius.circular(
                                    3.0)), // set rounded corner radius
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4.0, horizontal: 7),
                                child: Text("${orderInfo.status}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                            fontSize: 11, color: Colors.white)),
                              ))
                          : orderInfo.status == "Ready"
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    // set border width
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            3.0)), // set rounded corner radius
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 7),
                                    child: Text("${orderInfo.status}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .copyWith(
                                                fontSize: 11,
                                                color: Colors.white)),
                                  ))
                              : Container()
        ],
      ),
    );
  }

  Widget dynamicItemsRow(
      BuildContext context, String dynamicHeading, String dynamicInofText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$dynamicHeading",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          Text(
            "$dynamicInofText",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget totalBillWidget(
      BuildContext context, String dynamicHeading, String dynamicInofText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$dynamicHeading",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          Text(
            "$dynamicInofText",
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontSize: 18, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context, String imagePath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.30,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.background,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close",
                  style: Theme.of(context).textTheme.button.copyWith(
                        fontSize: 17,
                      ))),
        ),
        SizedBox(
          width: 12,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.30,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.appDefaultColor,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: FlatButton(
              onPressed: () {
                saveAnsShareImage(1, context);
              },
              child: Text("Save",
                  style: Theme.of(context).textTheme.button.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                      ))),
        ),
      ],
    );
  }

  void saveAnsShareImage(int requestCode, BuildContext context) {
    // if (_permissionStatus.isGranted) {
    // if (requestCode == 1) {
    screenshotController.capture().then((File image) async {
      //Capture Done
      setState(() {
        _imageFile = image;
      });

      final result =
          await ImageGallerySaver.saveImage(_imageFile.readAsBytesSync());
      print("File Saved to Gallery $result");
      _showToast(widget.conteextA, "Recipt saved");

      await Future.delayed(Duration(seconds: 2));
      Scaffold.of(widget.conteextA).hideCurrentSnackBar();
    }).catchError((onError) {
      print(onError);
    });

    print("Image file here $_imageFile");
    //  }
    // else if (requestCode == 2) {
    //   screenshotController.capture().then((File image) async {
    //     //Capture Done
    //     setState(() {
    //       _imageFile = image;
    //     });

    //     final result =
    //         await ImageGallerySaver.saveImage(_imageFile.readAsBytesSync());
    //     print("File Saved to Gallery $result");

    //     // share(result);
    //     // shareImage(result);
    //   }).catchError((onError) {
    //     print(onError);
    //   });
    // }
    // }
    //  else {
    //   if (Platform.isAndroid) {
    //     requestPermission(Permission.storage);
    //   } else {
    //     requestPermission(Permission.photos);
    //   }
    // }
  }

  void _listenForPermissionStatus() async {
    try {
      final status = await _permission.status;
      setState(() => _permissionStatus = status);
    } catch (ex) {
      print("exception in Recipt $ex");
    }
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}
