import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatProjectWidget extends StatelessWidget {
  final ProjectData projectData;

  ChatProjectWidget(this.projectData);

  @override
  Widget build(BuildContext context) {
    List<String> teamList = new List();
    if (projectData.team != null)
      for (var data in projectData.team) {
        teamList.add(data.thumbnailUrl); //add team users
      }

    return Container(
      margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Card(
        elevation: 1.3,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: <Widget>[
              Container(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
/*
                Expanded(
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    child:  buildStackList(),
                  ),
                ),*/
                  ]
                    ..add(Expanded(
                      child: teamList.length != null && teamList.length > 0
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: new Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[]
                                  // todo: make dynamic
                                  ..addAll(new List.generate(teamList.length,
                                      (index) {
                                    return new Padding(
                                      padding: new EdgeInsets.only(
                                        right: index *
                                            (28.0), // give left and remove alignment for reverse type
                                      ),
                                      child: new Container(
                                        width: 40,
                                        height: 40,
                                        decoration: new BoxDecoration(
                                          color: Colors.green[400],
                                          shape: BoxShape.circle,
                                          border: new Border.all(
                                            width: 1.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: getCachedNetworkImage(
                                              url: teamList[index],
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                    );
                                  })),
                              ),
                            )
                          : Container(),
                    ))
                    ..add(
                      Container(
                        padding: new EdgeInsets.only(bottom: 5.0),
                        margin: new EdgeInsets.only(left: 25.0),
                        child: InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              new Icon(
                                Icons.thumb_up,
                                size: 16.0,
                                color: projectData.isLike != null &&
                                        projectData.isLike
                                    ? AppColors.kPrimaryBlue
                                    : Colors.black,
                              ),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                projectData.likedBy != null &&
                                        projectData.likedBy.length > 0
                                    ? " ${projectData.likedBy.length.toString()}"
                                    : "0",
                                style: new TextStyle(
                                    color: projectData.isLike != null &&
                                            projectData.isLike
                                        ? AppColors.kPrimaryBlue
                                        : Colors.black,
                                    fontSize: 13.0,
                                    fontFamily: AssetStrings.lotoRegularStyle),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ),
              ),
              new SizedBox(
                height: 13.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "${projectData.description ?? ""}",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              new SizedBox(
                height: 5.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "${projectData.location ?? ""}",
                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
