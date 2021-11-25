import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoleStackWidget extends StatelessWidget {
  final List<String> roles;
  final LOADROLEICONFROM type; //from local or from internet
  final double size;

  RoleStackWidget(
      {@required this.roles, @required this.type, @required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: new Stack(
        alignment: Alignment.centerRight,
        children: <Widget>[]
          // todo: make dynamic
          ..addAll(new List.generate(roles.length, (index) {
            return new Padding(
              padding: new EdgeInsets.only(
                right: index *
                    (28.0), // give left and remove alignment for reverse type
              ),
              child: new Container(
                width: size,
                height: size,
                decoration: new BoxDecoration(
                  color: Colors.green[400],
                  shape: BoxShape.circle,
                  border: new Border.all(
                    width: 2.2,
                    color: Colors.white,
                  ),
                ),
                child: ClipOval(
                  child: type == LOADROLEICONFROM.SERVER
                      ? RoleCallIcon(url: roles[index], size: size)
                      : new SvgPicture.asset(
                          roles[index],
                          fit: BoxFit.cover,
                          width: size,
                          height: size,
                        ),
                ),
              ),
            );
          })),
      ),
    );
  }
}

class RoleCallIcon extends StatelessWidget {
  final String url;
  final double size;

  RoleCallIcon({
    @required this.url,
    @required this.size,
  });

  @override
  Widget build(BuildContext context) {
    print("url ${APIs.imageBaseUrl}$url");
    return new SvgPicture.network(
      "${APIs.imageBaseUrl}$url",
      fit: BoxFit.cover,
      width: size,
      height: size,
      placeholderBuilder: (context) {
        return new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kPrimaryBlue.withOpacity(0.7),
          ),
        );
      },
    );
  }
}
