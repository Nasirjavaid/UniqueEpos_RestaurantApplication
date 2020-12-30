import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/foodCategoryBloc/foodCategoryBloc.dart';
import 'package:retaurant_app/bloc/foodCategoryBloc/foodCategoryEvent.dart';
import 'package:retaurant_app/bloc/foodCategoryBloc/foodCategoryState.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/config/methods.dart';
import 'package:retaurant_app/config/networkConectivity.dart';
import 'package:retaurant_app/repository/foodCategoryRepository.dart';
import 'package:retaurant_app/ui/CommomWidgets/imageSlider.dart';
import 'package:retaurant_app/ui/CommomWidgets/loadingIndicator.dart';
import 'package:retaurant_app/ui/Screen/MenuScreen/tabs.dart';
import 'package:retaurant_app/ui/Screen/MenuScreen/menuItemListView.dart';
import 'package:tuple/tuple.dart';

class MenuScreenMain extends StatelessWidget {
  final FoodCategoryRepository foodCategoryRepository =
      FoodCategoryRepository();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            FoodCategoryBloc()..add(FoodCategoryEventFetched()),
        child: MenuScreen(context));
  }
}

class MenuScreen extends StatefulWidget {
  final BuildContext context;
  MenuScreen(this.context);
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  final FoodCategoryRepository foodCategoryRepository =
      FoodCategoryRepository();
  TabController _tabController;

  final List<Tuple2> _pages = [];
  // final FoodCategoryRepository foodCategoryRepository = FoodCategoryRepository();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
      builder: (context, state) {
        //initial state is data is loading  from the repository show loading indicator
        if (state is FoodCategoryInProgressState) {
          return LoadingIndicator();
        }
        // If any error then show error message
        if (state is FoodCategoryFailureState) {
          return InkWell(
            onTap: () {
              NetworkConnectivity.check().then((internet) {
                if (internet) {
                  BlocProvider.of<FoodCategoryBloc>(context)
                      .add(FoodCategoryEventFetched());
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
        if (state is FoodCategorySuccessState) {
// state.foodCategory.data.length

          for (int i = 0; i < state.foodCategory.data.category.length; i++) {
            _pages.add(Tuple2(
                MenuTabs(state.foodCategory.data.category[i].name),
                MenuItemListViewMain(
                    categoryId:
                        state.foodCategory.data.category[i].categoryID)));
          }
          _tabController = TabController(length: _pages.length, vsync: this);

          return DefaultTabController(
            length: _pages.length,
            child: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height * 0.25,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background:
                          ImageSlider(state.foodCategory.data.sliderinfo),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: MyTabsHorizontalList(
                        color: Colors.white,
                        tabBar: TabBar(
                            isScrollable: true,
                            indicatorColor: AppTheme.appDefaultColor,
                            controller: _tabController,
                            tabs: _pages
                                .map<Tab>(
                                    (Tuple2 page) => Tab(icon: page.item1))
                                .toList())),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children:
                    _pages.map<Widget>((Tuple2 page) => page.item2).toList(),
              ),
            ),
          );
        }
        return Center(child: Text("Nothing here"));
      },
    );
  }
}

class MyTabsHorizontalList extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color color;
  final double expandedHeight;
  final double collapsedHeight;

  MyTabsHorizontalList(
      {@required this.tabBar,
      this.color,
      this.collapsedHeight,
      this.expandedHeight});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: color,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;

  // Widget tabBar(BuildContext context) {
  //   return Container(
  //     child: Column(
  //       children: [
  //         TabBar(
  //           isScrollable: true,
  //           indicatorColor: AppTheme.appDefaultColor,
  //           tabs: [
  //             dynamicTabForTabViews("LEBANESE", context),
  //             dynamicTabForTabViews("STARTERS", context),
  //             dynamicTabForTabViews("SOUP & SALAD", context),
  //             dynamicTabForTabViews("BEEF", context),
  //             dynamicTabForTabViews("CHICKEN", context),
  //             dynamicTabForTabViews("SEAFOOD", context),
  //             dynamicTabForTabViews("BURGERS", context),
  //             dynamicTabForTabViews("SANDWICHES", context),
  //             dynamicTabForTabViews("PIZA", context),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget dynamicTabForTabViews(String tabHedingText, BuildContext context) {
  //   return Tab(
  //     icon: Container(
  //       decoration: BoxDecoration(
  //           border: Border.all(color: Colors.redAccent),
  //           borderRadius: BorderRadius.all(Radius.circular(5))),
  //       child: Padding(
  //         padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
  //         child: Text(
  //           "$tabHedingText",
  //           style: Theme.of(context).textTheme.bodyText1,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

// class MySliverAppBar extends SliverPersistentHeaderDelegate {
//   final double expandedHeight;

//   MySliverAppBar({@required this.expandedHeight});

//   @override
//   Widget build(
//       BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Stack(
//       fit: StackFit.expand,
//       overflow: Overflow.visible,
//       children: [
//         ImageSlider(),
//         Center(
//           child: Opacity(
//             opacity: shrinkOffset / expandedHeight,
//             child: Text(
//               "Menu Screen",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 23,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   double get maxExtent => expandedHeight;

//   @override
//   double get minExtent => kToolbarHeight;

//   @override
//   bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
//}
