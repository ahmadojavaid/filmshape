import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserProfileWithIndicator extends StatelessWidget {
  final String profilePic;
  final bool isOnline;

  UserProfileWithIndicator(
      {@required this.profilePic, @required this.isOnline});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
            width: 35.0,
            height: 35.0,
            margin: new EdgeInsets.only(right: 0, bottom: 1.0),
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.transparent, width: 0.3),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: getCachedNetworkImage(
                  url: "${APIs.imageBaseUrl}$profilePic",
                  fit: BoxFit.cover),
            )),
        Positioned(
          bottom: 0.0,
          right: 0.0,
          child: new Container(
            width: 12.0,
            height: 12.0,
            decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color:
                    (isOnline ?? false) ? Colors.greenAccent : Colors.grey,
                border: new Border.all(color: Colors.white, width: 1.2)),
          ),
        ),
      ],
    );
  }
}
