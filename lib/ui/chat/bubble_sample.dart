import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

class BubbleSample extends StatefulWidget {
  @override
  _BubbleSampleState createState() => _BubbleSampleState();
}

class _BubbleSampleState extends State<BubbleSample> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 80.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                color: Colors.greenAccent.shade100,
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 60.0, top: 0, left: 5.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Linkify(
                            text: "User ",
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                                fontFamily: AssetStrings.lotoBoldStyle)),
                        Linkify(
                            text: "hiiii xvxvxvl",
                            style:
                                TextStyle(fontSize: 13, color: Colors.black)),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Row(
                      children: <Widget>[
                        Text("12:30 am",
                            style: TextStyle(
                              color: Colors.black38,
                              fontSize: 10.0,
                            )),
                        SizedBox(width: 3.0),
                        Icon(
                          Icons.done,
                          size: 12.0,
                          color: Colors.black38,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: new Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    border: new Border.all(color: Colors.white, width: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: getCachedNetworkImageWithurl(url: "", size: 32),
                  )),
            ),
          ],
        )
      ],
    );
    ;
  }
}
