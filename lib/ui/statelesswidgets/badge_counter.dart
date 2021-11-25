import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BadgeCounter extends StatelessWidget {
  final int count;

  BadgeCounter({@required this.count});

  @override
  Widget build(BuildContext context) {
    return Text('${count > 10 ? '10+' : count}',
        style: TextStyle(color: Colors.white, fontSize: 11));
  }
}
