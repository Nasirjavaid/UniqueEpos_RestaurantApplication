import 'package:flutter/material.dart';
import 'package:retaurant_app/config/appTheme.dart';
import 'package:retaurant_app/ui/CommomWidgets/roundedCornerImageView.dart';

class ReservationDetailBoxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background1,
      body: Center(
        child: Container(
          
          width: MediaQuery.of(context).size.width*0.80,
          child: Card(
           shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),),
          
  
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    RoundedCornerImageView(
                      height: MediaQuery.of(context).size.height * 0.40,
                      width: MediaQuery.of(context).size.width ,
                      borderWidth: 1.0,
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical:16.0,horizontal: 10),
                      child: Text(
                        "Table Successfully Booked!",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    )
                  ]),
          
          ),
        ),
      ),
    );
  }
}
