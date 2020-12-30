import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:retaurant_app/bloc/MyordersBloc/myOrdersBloc.dart';
import 'package:retaurant_app/bloc/MyordersBloc/myOrdersEvent.dart';
import 'package:retaurant_app/bloc/MyordersBloc/myOrdersState.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthBloc.dart';
import 'package:retaurant_app/bloc/userAuthBloc/userAuthEvent.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/main.dart';
import 'package:retaurant_app/model/myOrdersModel.dart';
import 'package:retaurant_app/repository/userAuthRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocProvider(
        create: (context) {
          return MyOrdersBloc()..add(MyOrdersEventFetched());
        },
        child: MyOrdersScreenMain(),
      ),
    );
  }
}

class MyOrdersScreenMain extends StatefulWidget {
  @override
  _MyOrdersMainState createState() => _MyOrdersMainState();
}

class _MyOrdersMainState extends State<MyOrdersScreenMain> {
  bool guestUserValue = false;

  getValueOFguestUserFromSharedPrefrences() async {
    guestUserValue = await Methods.getGuestFromSharedPref();
    setState(() {
      return guestUserValue;
    });

    return guestUserValue;
  }

  @override
  void initState() {
    super.initState();

    getValueOFguestUserFromSharedPrefrences();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              actions: [
                IconButton(
                    icon: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Icon(
                        Icons.refresh,
                        size: 28,
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<MyOrdersBloc>(context)
                          .add(MyOrdersEventFetched());
                    })
              ],
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Text(
                      "Active orders",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                  Tab(
                    icon: Text(
                      "Past orders",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ],
              ),
              title: Text(
                "My orders",
                style: Theme.of(context).textTheme.button,
              ),
            ),

            //   body: TabBarView(
            //   children: [
            //     Icon(Icons.directions_car),
            //     Icon(Icons.directions_transit),

            //   ],
            // ),
            body: BlocBuilder<MyOrdersBloc, MyOrdersState>(
              builder: (BuildContext context, state) {
                if (state is MyOrdersStateInProgressState) {
                  return LoadingIndicator();
                }
                if (state is MyOrdersStateSuccessState) {
                  List<Orderinfo> currentOrders = new List<Orderinfo>();
                  List<Orderinfo> pastOrders = new List<Orderinfo>();

                  for (int i = 0;
                      i < state.myOrdersModel.data.orderinfo.length;
                      i++) {
                    if (state.myOrdersModel.data.orderinfo[i].status ==
                            "Pending" ||
                        state.myOrdersModel.data.orderinfo[i].status ==
                            "Processing" ||
                        state.myOrdersModel.data.orderinfo[i].status ==
                            "Ready") {
                      currentOrders.add(state.myOrdersModel.data.orderinfo[i]);
                    } else {
                      pastOrders.add(state.myOrdersModel.data.orderinfo[i]);
                    }
                  }
                  return TabBarView(
                    children: [
                      _buildBody(
                          context, currentOrders, state.myOrdersModel.data),
                      _buildBody(context, pastOrders, state.myOrdersModel.data),
                    ],
                  );
                }

                if (state is MyOrdersStateFailureState) {
                  return guestUserValue == true
                      ? Center(
                          child: failedWidget(context),
                        )
                      : InkWell(
                          onTap: () {
                            NetworkConnectivity.check().then((internet) {
                              if (internet) {
                                MyOrdersBloc()..add(MyOrdersEventFetched());
                              } else {
                                //show network erro

                                Methods.showToast(
                                    context, "Check your network");
                              }
                            });
                          },
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("No items",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(
                                          color: Colors.black38,
                                        )),
                                SizedBox(
                                  height: 8,
                                ),
                                Text("Tap to Reload",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                          color: Colors.black45,
                                        )),
                              ],
                            ),
                          ),
                        );
                }

                return Container();
              },
            )),
      ),
    );
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

  Widget topWidget(BuildContext context) {
    return Container(
      height: 50,
      color: AppTheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 1,
          ),
          Text(
            "Past Orders",
            style: Theme.of(context).textTheme.headline6,
          ),
          Divider()
        ],
      ),
    );
  }

  Widget _buildBody(
      BuildContext context, List<Orderinfo> orderInfoList, Data data) {
    return Stack(
      children: [
        pastOrdersList(context, orderInfoList, data),
        // topWidget(context),
      ],
    );
  }

  Widget pastOrdersList(
      BuildContext context, List<Orderinfo> orderInfoList, Data data) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, right: 5, left: 5, bottom: 1),
        child: ListView.builder(
            itemCount: orderInfoList.length == 0 ? 1 : orderInfoList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              if (orderInfoList.length == 0) {
                return Center(
                    child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text("No orders",
                      style: Theme.of(context).textTheme.bodyText1),
                ));
              } else {
                return orderInfoListItemCard(
                    context, orderInfoList[index], data);
              }
            }),
      ),
    );
  }

  Widget orderInfoListItemCard(
      BuildContext context, Orderinfo orderInfo, Data data) {
    return InkWell(
      onTap: () {
        Methods.showDialogueForMyOrderDetail(
          context,
          orderInfo,
          data,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
        child: Card(
            elevation: 2,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.80,
                            height: 30,
                            child: orderInfoInnerListView(orderInfo)),
                        flex: 3,
                      ),
                      Flexible(
                        child: Text(
                            "${data.currencyIcon}${orderInfo.orderamount != null ? orderInfo.orderamount : ""}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 13)),
                        flex: 1,
                      ),
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Text("${orderInfo.orderdate != null ? orderInfo.orderdate : ""}"),
                      Text(
                          "${orderInfo.orderdate != null ? Methods.dateToDateTimeConversion(orderInfo.orderdate) : ""}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 13)),

                      orderInfo.status == "Pending"
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.amber,
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
                          : orderInfo.status == "Cancelled"
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
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
                              : orderInfo.status == "Served"
                                  ? Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
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
                                  : orderInfo.status == "Processing"
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: Colors.orange,
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0,
                                                        horizontal: 7),
                                                child: Text(
                                                    "${orderInfo.status}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1
                                                        .copyWith(
                                                            fontSize: 11,
                                                            color:
                                                                Colors.white)),
                                              ))
                                          : Container()
                    ],
                  ),
                  Row(
                    children: [
                      Text("Order ID : ",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 13)),
                      Text(
                          "${orderInfo.saleinvoice != null ? orderInfo.saleinvoice.substring(1) : ""}",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget orderInfoInnerListView(Orderinfo orderInfo) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5.0,
        ),
        child: ListView.builder(
            itemCount:
                orderInfo.foodlist == null ? 0 : orderInfo.foodlist.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              if (orderInfo.foodlist.length == -1 ||
                  orderInfo.foodlist == null ||
                  orderInfo.foodlist.isEmpty) {
                return Container();
              } else {
                return Text(
                  "${orderInfo.foodlist[index].productName}, ",
                  style: Theme.of(context).textTheme.bodyText2,
                );
              }
            }),
      ),
    );
  }
}
