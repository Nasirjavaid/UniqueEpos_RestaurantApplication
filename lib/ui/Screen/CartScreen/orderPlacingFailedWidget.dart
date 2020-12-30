import 'package:flutter/material.dart';


class OrderPlacingFailedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
           Icons.cancel,
            size: 60,
            color: Colors.red[200],
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Failed to place order.",
                style: Theme.of(context).textTheme.button.copyWith(color: Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}