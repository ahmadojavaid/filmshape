import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatGroupImage extends StatelessWidget {
  int totalMembers;
  String firstProfilePic;
  String secondPoriflePic;

  ChatGroupImage(
      {@required this.totalMembers,
      @required this.firstProfilePic,
      @required this.secondPoriflePic});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
            width: 30.0,
            height: 30.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: getCachedNetworkImageWithurl(
                  url: firstProfilePic, fit: BoxFit.cover),
            )),
        new Container(
          width: 44.0,
          height: 44.0,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
        ),
        (totalMembers > 2)
            ? Positioned(
                bottom: 0.0,
                right: 0.0,
                child: new Container(
                  width: 32.0,
                  height: 32.0,
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.chipColors,
                      border: new Border.all(color: Colors.white, width: 2)),
                  child: new Text("+${totalMembers - 1}",
                      style: new TextStyle(
                          fontFamily: AssetStrings.lotoBoldStyle,
                          color: AppColors.kprojectTitle,
                          fontSize: 16.0)),
                ),
              )
            : (totalMembers == 2)
                ? Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: new Container(
                      width: 32.0,
                      height: 32.0,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,

                         ),
                      child:  new Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: getCachedNetworkImageWithurl(
                                url: secondPoriflePic, fit: BoxFit.cover),
                          )),
                    ),
                  )
                : Container()
      ],
    );
  }
}
