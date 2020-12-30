import 'package:flutter/material.dart';


class OrderPlacedSuccessfullyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.done_outline,
            size: 60,
            color: Colors.red[100],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Order Placed Successfully",
                style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}