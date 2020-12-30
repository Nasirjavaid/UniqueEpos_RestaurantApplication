import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartBloc.dart';
import 'package:retaurant_app/bloc/cartBloc/cartEvent.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/model/foodProduct.dart';

class AddToCartButton extends StatelessWidget {
  final Foodinfo foodinfo;

  AddToCartButton(this.foodinfo);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return BlocProvider(
            create: (contextC) => CartBloc(),
            child: addTocartButton(context, foodinfo));
      },
    );
  }

  Widget addTocartButton(BuildContext context, Foodinfo foodinfo) {
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

                BlocProvider.of<CartBloc>(context).add(
                  AddProductTocartEvent(foodinfo: foodinfo),
                );
              }

              // showInSnackBar("Login button pressed")

              ),
        ),
      ),
    );
  }
}
