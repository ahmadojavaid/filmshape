import 'package:flutter/material.dart';

class ComingSoong extends StatefulWidget {

  @override
  _ComingSoongState createState() => _ComingSoongState();
}

class _ComingSoongState extends State<ComingSoong> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Text(
          "Coming Soon",
          style: new TextStyle(color: Colors.black, fontSize: 30.0),
        ),
      ),
    );
  }
}
