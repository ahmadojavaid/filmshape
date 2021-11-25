import 'package:flutter/material.dart';

class SlideDots extends StatelessWidget {
  bool isActive;

  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: isActive ? 12 : 12,
      width: isActive ? 12 : 12,
      decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          border: new Border.all(
              width: 1.0, color: Theme.of(context).primaryColor)),
    );
  }
}
