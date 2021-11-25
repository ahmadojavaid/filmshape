import 'dart:collection';

import 'package:Filmshape/Model/searchtalent/search_talent_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatefulWidget {
  final UserData userData;
  UserWidget(this.userData);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget>
    with AutomaticKeepAliveClientMixin<UserWidget> {
  List<String> roles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    roles = List();

    LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
    //add user role
    for (var data in widget.userData.roles) {
      listLocal.add(data.iconUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      child: Card(
        elevation: 1.5,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            children: <Widget>[
              Container(
                child: IntrinsicHeight(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: getCachedNetworkImage(
                                url:
                                    "${APIs.imageBaseUrl}${widget.userData.thumbnailUrl}",
                                fit: BoxFit.cover),
                          )),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                widget.userData.fullName ?? "",
                                style: AppCustomTheme.suggestedFriendNameStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              new SizedBox(
                                height: 5.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: new EdgeInsets.only(right: 38.0),
                                  child: new Text(
                                    widget.userData.bio ?? "",
                                    style: AppCustomTheme.followingTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (roles.length > 0)
                        ? Container(
                            height: 35, child: getStackItem(roles, 0, 35))
                        : Container(),
                    Expanded(
                      child: new SizedBox(
                        width: 5.0,
                      ),
                    ),
//                    Row(
//                      children: <Widget>[
//                        new Text(
//                          "Approached",
//                          style: new TextStyle(
//                            color: AppColors.searchTalentColor,
//                            fontSize: 13.5,
//                            fontFamily: AssetStrings.lotoRegularStyle,
//                          ),
//                        ),
//                        SizedBox(
//                          width: 5,
//                        ),
//                        Icon(
//                          Icons.check_circle,
//                          color: AppColors.searchTalentColor,
//                          size: 16,
//                        )
//                      ],
//                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
