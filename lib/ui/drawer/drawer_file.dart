import 'dart:async';

import 'package:Filmshape/ui/settings/SettingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/create_project/create_project.dart';
import 'package:Filmshape/ui/my_profile/my_profile.dart';

class NewDrawer extends StatefulWidget {
  @override
  _NewDrawerState createState() => _NewDrawerState();
}

class _NewDrawerState extends State<NewDrawer> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  DateTime _date = new DateTime.now();
  String text = "Flutter";
  String dateText = "";
  String timeText = "";
  Color backgroundColor = Colors.white;
  TimeOfDay _time = new TimeOfDay.now();

  Widget body;

  @override
  void initState() {
    // TODO: implement initState
    // body = MyProfile(null,null);
    super.initState();
  }

/* date picker*/
  Future<Null> selectedDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2018),
        lastDate: new DateTime(2020));

    if (picked != null && picked != _date) {
      print("date selected: $_date");
      setState(() {
        _date = picked;
        // dateText = DateFormat("d MMMM y").format(_date);
      });
    }
  }

  /* time _picker*/

  Future<Null> selectedTime(BuildContext context) async {
    final TimeOfDay timeOfDay =
        await showTimePicker(context: context, initialTime: _time);
    if (timeOfDay != null && timeOfDay != _time) {
      print("date selected: $_time");
      setState(() {
        _time = timeOfDay;
        timeText = "${_time.hour}" + ":" + "${_time.minute}";
      });
    }
  }

  Future getImage() async {
    /*  var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });*/
  }

  Widget getListTile(String text, String image, int pos) {
    return InkWell(
      onTap: () {
        print(pos);
        Navigator.pop(context);
        Navigator.pop(context);
        switch (pos) {
          case 6:
            {
//              Navigator.push(
//                context,
//                new CupertinoPageRoute(builder: (BuildContext context) {
//                  return new SettingScreen();
//                }),
//              );
              break;
            }
        }
      },
      child: Container(
          margin: new EdgeInsets.only(left: 30.0, top: 28.0),
          child: Row(
            children: <Widget>[
              new SvgPicture.asset(
                image,
                color: Colors.black,
                width: 20.0,
                height: 20.0,
              ),
              Expanded(
                child: Container(
                  margin: new EdgeInsets.only(left: 15.0),
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    text,
                    style: new TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
              ),
              Offstage(
                offstage: pos != 1 ? true : false,
                child: new Container(
                  width: 26.0,
                  height: 18.0,
                  padding:
                      new EdgeInsets.symmetric(vertical: 1.0, horizontal: 2.0),
                  alignment: Alignment.center,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(18.0),
                      color: AppColors.kPrimaryBlue),
                  child: new Text(
                    "1",
                    style: new TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0),
                  ),
                ),
              ),
              new SizedBox(
                width: 20.0,
              ),
            ],
          )),
    );
  }

/*  Widget getItem(){

    return Row(
      children: <Widget>[
        new SvgPicture.asset(image, color: Colors.black,width: 22.0,height: 22.0,),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: new Text(text,style: new TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
    color: Colors.black),
          ),
        ),
        ),
        new Container(
          width: 25.0,
          height: 17.0,
          padding: new EdgeInsets.symmetric(vertical: 1.0,horizontal: 2.0),
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(10.0),
              color: AppColors.kPrimaryBlue
          ),
          child: new Text("1",style: new TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 13.0),),
        ),
        new SizedBox(
          width: 20.0,
        ),
      ],
    );
  }*/

  Widget getAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.0),
      child: Material(
        elevation: 4.0,
        child: Container(
          color: Colors.white,
          margin: new EdgeInsets.only(left: 20.0, right: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 90.0,
                alignment: Alignment.center,
                child: appLogo(),
              ),
              Expanded(
                child: new Container(
                  alignment: Alignment.center,
                  child: new Text(
                    "User Name",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20.0),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Container(
                child: InkWell(
                    onTap: () {
                      if (!_key.currentState.isDrawerOpen) {
                        _key.currentState.openEndDrawer();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: new Icon(
                      Icons.search,
                      size: 25.0,
                      color: Colors.black,
                    )),
              ),
              Container(
                margin: new EdgeInsets.only(left: 10.0),
                child: InkWell(
                    onTap: () {
                      if (!_key.currentState.isDrawerOpen) {
                        _key.currentState.openEndDrawer();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: new Icon(
                      Icons.menu,
                      size: 28.0,
                      color: Colors.black,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          appBar: getAppBar(),
          endDrawer: Container(
            margin: new EdgeInsets.only(right: 20.0, top: 20.0, bottom: 60.0),
            child: ClipRRect(
              // margin: new EdgeInsets.only(right: 20.0,top: 20.0,bottom: 60.0),
              borderRadius: new BorderRadius.circular(10.0),

              child: new Drawer(
                child: new Container(
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(10.0)),
                  child: new Column(
                    children: <Widget>[
                      Container(
                        margin: new EdgeInsets.only(right: 20.0, top: 20.0),
                        alignment: Alignment.centerRight,
                        child: InkWell(
                            onTap: () {
                              if (!_key.currentState.isEndDrawerOpen) {
                                _key.currentState.openEndDrawer();
                              } else {
                                Navigator.pop(context);
                              }
                            },
                            child: new Icon(
                              Icons.menu,
                              size: 25.0,
                              color: Colors.black,
                            )),
                      ),
                      new SizedBox(
                        width: 25.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(left: 30.0),
                        child: new InkWell(
                          child: Container(
                            padding: new EdgeInsets.all(2.0),
                            width: 90.0,
                            height: 90.0,
                            decoration: new BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: new ClipRRect(
                              child: new InkWell(
                                onTap: () {
//                                  _goToEditProfile();
                                },
                                child: getCachedNetworkImage(
                                    url:
                                        "https://i.ytimg.com/vi/sCZzhsd_NNY/maxresdefault.jpg",
                                    fit: BoxFit.cover),
                              ),
                              borderRadius: BorderRadius.circular(90.0),
                            ),
                          ),
                          onTap: () async {},
                        ),
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: 30.0, top: 15.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          "John Brown",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      new SizedBox(
                        height: 4.0,
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: 30.0),
                        alignment: Alignment.centerLeft,
                        child: new Text(
                          "Lorem Ipsum Dummy",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontSize: 13.0, color: Colors.black),
                        ),
                      ),
                      Container(
                          child:
                              const Divider(height: 1.2, color: Colors.white)),
                      new Expanded(
                        child: new Container(
                          child: new ListView(
                            padding: new EdgeInsets.all(0.0),
                            children: <Widget>[
                              getListTile("My Projects",
                                  AssetStrings.myProjectDrawer, 1),
                              getListTile("Create a project",
                                  AssetStrings.createProjectDrawer, 2),
                              getListTile("Join a project",
                                  AssetStrings.joinProjectDrawer, 3),
                              getListTile("Search for talent",
                                  AssetStrings.searchTalentDrawer, 4),
                              getListTile("Browse All Projects",
                                  AssetStrings.browseProjectDrawer, 5),
                              Container(
                                margin: new EdgeInsets.only(left: 20.0),
                              ),
                              Container(
                                  margin: new EdgeInsets.only(top: 28.0),
                                  child: const Divider(
                                      height: 1.2, color: Colors.grey)),
                              getListTile(
                                  "Settings", AssetStrings.settingDrawer, 6),
                              getListTile(
                                  "Log out", AssetStrings.logoutDrawer, 7),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: body),
    );
  }
}
