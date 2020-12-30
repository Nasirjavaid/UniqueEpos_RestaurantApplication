import 'package:flutter/material.dart';


class TopMenuListItemCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // GestureDetector(
        //   child: RoundedCornerImageViewWithoutBorderDynamic(
        //     imageLink:
        //         "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTczJS00NHlErZkMfvR0coMfRcu-fFgQKsS_g&usqp=CAU",
        //     height: 115,
        //     width: 120,
        //     borderWidth: 0.0,
            
        //   ),
        //   //onTap:() =>onTapFunction,

        //   // {
        //   //   widget.onTapFunction;
        //   //   // Navigator.push(
        //   //   //     context, MaterialPageRoute(builder: (context) => TopCast()));
        //   // },
        // ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.center,
          child: Text(
            "Item name",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                .copyWith(color: Colors.white),
          ),
        ))
      ],
    );
  }
}
