import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/bloc/cartBloc/cartState.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/ui/Screen/CartScreen/cartScreen.dart';
import 'package:retaurant_app/ui/Screen/DashboardScreen/dashboard.dart';
import 'package:retaurant_app/ui/Screen/DashboardScreen/myNavDrawer.dart';

import 'package:retaurant_app/ui/Screen/MenuScreen/menuScreen.dart';
import 'package:retaurant_app/ui/Screen/MoreScreen/moreScreen.dart';

class HomeCintainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CartBloc();
      },
      child: MainHomeContainer(),
    );
  }
}

class MainHomeContainer extends StatefulWidget {
  @override
  _MainHomeContainerState createState() => _MainHomeContainerState();
}

class _MainHomeContainerState extends State<MainHomeContainer>
    with WidgetsBindingObserver {
  int _currentIndex = 0;

  final allScreenDestiNations = [
    DashBoardMain(),
    MenuScreenMain(),
    CartScreen(),
    MoreScreen(),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    Methods.storeStateToSharedPref(false);
    WidgetsBinding.instance.addObserver(this);
    callCartFromSharedPrefrences();

    super.initState();
  }

  void callCartFromSharedPrefrences() async {
    BlocProvider.of<CartBloc>(context)
        .add(GetDataFromSharedPrefrencesCartEvent());
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
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        // actions: [
        //   IconButton(icon: Icon(Icons.search), onPressed: null),
        // ],
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          "Unique ePOS",
          style: Theme.of(context).textTheme.button,
        ),
      ),
      body: SafeArea(
        top: false,
        child:
            IndexedStack(index: _currentIndex, children: allScreenDestiNations),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                FontAwesomeIcons.home,
                size: 15,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                'Home',
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                FontAwesomeIcons.list,
                size: 15,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                'Menu',
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (BuildContext context, state) {
                    print("Before state $state");
                    if (state
                        is UpdateFoodProductListWhenAddingNewFoodProductState) {
                      print("Before state ${state.foodinfo.length}");

                      if (state.foodinfo.length > 0) {
                        return Badge(
                          position:
                              BadgePosition.topRight(top: -16, right: -19),
                          animationDuration: Duration(milliseconds: 300),
                          animationType: BadgeAnimationType.fade,
                          badgeContent: Text(
                            "${state.foodinfo.length}",
                            style: TextStyle(color: Colors.white),
                          ),
                          child: Icon(
                            FontAwesomeIcons.cartPlus,
                            size: 15,
                          ),
                        );
                      } else {
                        return Icon(
                          FontAwesomeIcons.cartPlus,
                          size: 15,
                        );
                      }
                    } else {
                      return Icon(
                        FontAwesomeIcons.cartPlus,
                        size: 15,
                      );
                    }
                  },
                )

                // Icon(
                //   FontAwesomeIcons.cartPlus,
                //   size: 15,
                // ),
                ),
            title: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                'Cart',
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                Icons.more,
                size: 15,
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                'More',
                style: GoogleFonts.lato(
                    textStyle:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              ),
            ),
          )
        ],
      ),
      drawer: MyNaveDrawerMain(),
    );
  }
}
