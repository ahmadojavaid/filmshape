import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRoleImage extends StatelessWidget
{
  final String userThumbnail;
  UserRoleImage({@required this.userThumbnail});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return new Container(
        width: 35.0,
        height: 35.0,
        decoration: new BoxDecoration(
          color: AppColors.kGrey.withOpacity(0.2),
          border: new Border.all(
              color: Colors.transparent, width: 0.3),
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: getCachedNetworkImage(
              url:userThumbnail,
              fit: BoxFit.cover),
        )
    );
  }

}