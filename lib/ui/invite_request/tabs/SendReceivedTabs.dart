import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_flutter_mar/Utils/AssetStrings.dart';

class SendReceivedTabs extends StatefulWidget {
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<SendReceivedTabs> {
  _buildContestList() {
    return Expanded(
      child: Container(
        margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0),
        child: new ListView.builder(
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(index);
          },
          itemCount: 5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        child: new Column(
          children: <Widget>[
            new SizedBox(
              height: 20.0,
            ),
            videoLinkViewBottomSheet(
              "All invite and requests",
            ),
            videoLinkViewBottomSheet("Status filter"),
            _buildContestList(),
            new SizedBox(
              height: 50.0,
            )
          ],
        ),
      ),
    );
  }

  Widget videoLinkViewBottomSheet(String text) {
    return InkWell(
      onTap: () {},
      child: new Container(
        margin: new EdgeInsets.only(left: 0.0, right: 0.0, top: 15.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border:
              new Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              text,
              style: new TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            new Icon(
              Icons.arrow_drop_down,
              size: 24.0,
            )
          ],
        ),
      ),
    );
  }

  Widget buildItem(int index) {
    return Container(
      margin: new EdgeInsets.only(left: 10.0, right: 10.0, top: 35.0),
      child: Column(
        children: <Widget>[
          Row(
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
                style: new TextStyle(color: Colors.black38, fontSize: 14.0),
                maxLines: 1,
              ),
              Expanded(
                child: new SizedBox(
                  width: 5.0,
                ),
              ),
              new Icon(
                Icons.more_vert,
                size: 18.0,
                color: Colors.black54,
              )
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: new EdgeInsets.only(top: 13.0),
            child: new Text(
              'Request to join "the one lake" ',
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            margin: new EdgeInsets.only(top: 4.0),
            child: new Text(
              'There is nothing I would love more than to have a" ',
              style: new TextStyle(color: Colors.grey, fontSize: 15.0),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          new SizedBox(
            height: 15.0,
          ),
          Row(
            children: <Widget>[
              new Container(
                padding:
                    new EdgeInsets.symmetric(vertical: 5.0, horizontal: 13.0),
                decoration: new BoxDecoration(
                    border: new Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                    borderRadius: new BorderRadius.circular(2.0),
                    color: Colors.blueGrey.withOpacity(0.03)),
                child: new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.access_time,
                      color: Colors.black45,
                      size: 17.0,
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                    new Text(
                      "Pending",
                      style: new TextStyle(color: Colors.black, fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                  child: new Text(
                    "19/2/2012",
                    style: new TextStyle(color: Colors.black54, fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
