import 'package:flutter/material.dart';
import 'package:retaurant_app/ui/CommomWidgets/commonWidgets.dart';

class OrderPlacingInProgressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         CommonWidgets.progressIndicator,

          SizedBox(
            height: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "In Progress...",
                style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}