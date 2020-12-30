import 'package:flutter/material.dart';

class MenuTabs extends StatelessWidget {
  final tabHeadingText;
  MenuTabs(this.tabHeadingText);
  @override
  Widget build(BuildContext context) {
    return Container(
      
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:3.0),
          child: Text(
            "$tabHeadingText",maxLines: 1,overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.button.copyWith(fontWeight: FontWeight.w900,fontSize: 16),
          ),
        ),
      
    );
  }
}
