import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_flutter_mar/Utils/AppColors.dart';
import 'package:new_flutter_mar/Utils/AssetStrings.dart';
import 'package:new_flutter_mar/Utils/UniversalFunctions.dart';

class ProjectPendingRequest extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<ProjectPendingRequest> {
  @override
  void initState() {
    super.initState();
  }

  Widget getCornerButton(String text) {
    return new Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(color: AppColors.kPrimaryBlue, width: 1.0),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
      child: new Text(
        text,
        style: new TextStyle(color: AppColors.kPrimaryBlue, fontSize: 15.0),
      ),
    );
  }

  Widget getAttributeItem(String title, String image, IconData data) {
    return Container(
      margin: new EdgeInsets.only(left: 35.0, right: 55.0, top: 25.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: new TextStyle(
                fontSize: 14.0, color: Colors.black45.withOpacity(0.6)),
          ),
          new SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Icon(
                data,
                size: 16.0,
              ),
              new SizedBox(
                width: 7.0,
              ),
              Expanded(
                  child: new Text(
                image,
                style: new TextStyle(fontSize: 15.0, color: Colors.black),
              )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: new SingleChildScrollView(
              child: Container(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new SizedBox(
                      height: 40.0,
                    ),
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                          width: 20.0,
                        ),
                        new Icon(Icons.keyboard_arrow_down, size: 25.0),
                        new SizedBox(
                          width: 2.0,
                        ),
                        new Text(
                          "Close",
                          style: new TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                        Expanded(child: new Container()),
                        new Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 10.0),
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: Colors.grey.withOpacity(0.5),
                                  width: 1.0),
                              borderRadius: new BorderRadius.circular(16.0),
                              color: Colors.blueGrey.withOpacity(0.1)),
                          child: new Row(
                            children: <Widget>[
                              new Icon(
                                Icons.reply,
                                color: Colors.red,
                              ),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                "Revoke Request",
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                        new SizedBox(
                          width: 20.0,
                        ),
                      ],
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new Container(
                      height: 1.0,
                      color: Colors.blueGrey.withOpacity(0.1),
                    ),
                    new SizedBox(
                      height: 30.0,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 30.0),
                      child: new Text(
                        "You've requested to join a project",
                        style: new TextStyle(
                            color: AppColors.kBlack, fontSize: 20.0),
                      ),
                    ),
                    new SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 30.0, top: 15.0, right: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent, width: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: getCachedNetworkImage(
                                    url:
                                        "file:///home/avinash/Downloads/savour%20apps%20images%20and%20icons/image1.png",
                                    fit: BoxFit.cover),
                              )),
                          new SizedBox(
                            width: 10.0,
                          ),
                          new Text(
                            "Particia Jane Michlesion",
                            style: new TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 30.0, top: 15.0, right: 30.0),
                      child: Row(
                        children: <Widget>[
                          new Image.asset(
                            AssetStrings.imageEditing,
                            width: 30.0,
                            height: 30.0,
                            fit: BoxFit.cover,
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          new Text(
                            "Editor",
                            style: new TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          new Text(
                            " (Editing)",
                            style: new TextStyle(
                                color: Colors.black38,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 30.0, top: 15.0),
                      child: new Text(
                        "Role description",
                        style: new TextStyle(
                            color: Colors.black45, fontSize: 15.0),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 30.0, top: 13.0, right: 30.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        "Searching for a talented inidividual who edits for a living and loves to edit lots of things and they can't breathe without editing.",
                        style: new TextStyle(
                            color: Colors.black, height: 1.2, fontSize: 15.0),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 30.0, top: 40.0),
                      child: new Text(
                        "Project details",
                        style: new TextStyle(
                            color: AppColors.kBlack, fontSize: 20.0),
                      ),
                    ),
                    getAttributeItem(
                        "Project title", "the one lake", Icons.edit),
                    getAttributeItem(
                        "Project type", "Feature film", Icons.backup),
                    getAttributeItem("Genre", "Comedy", Icons.color_lens),
                    getAttributeItem(
                        "Location", "London, Uk", Icons.location_on),
                    getAttributeItem(
                        "Description",
                        "Searching for a talented inidividual who edits for a living and loves to edit lots of things and they can't breathe without editing.",
                        Icons.message),
                    getAttributeItem(
                        "Personal message",
                        "Searching for a talented inidividual who edits for a living and loves to edit lots of things and they can't breathe without editing.",
                        Icons.message),
                    new SizedBox(
                      height: 35.0,
                    ),
                    Container(
                        width: screensize.width,
                        child: getCornerButton("View project")),
                    new SizedBox(
                      height: 35.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
