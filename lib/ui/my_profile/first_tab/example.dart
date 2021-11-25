import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/profile/create_profile.dart';

import '../decprator.dart';

class SliverWithTabBar extends StatefulWidget {
  @override
  _SliverWithTabBarState createState() => _SliverWithTabBarState();
}

class _SliverWithTabBarState extends State<SliverWithTabBar>
    with SingleTickerProviderStateMixin {
  TabController tabBarController;

  int _tabIndex = 0;

  @override
  void initState() {
    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 2, vsync: this);
    tabBarController.addListener(_handleTabSelection);

    // TODO: implement initState
  }

  void _handleTabSelection() {
    setState(() {});
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  Widget videoLinkView(String text, String image) {
    return new Container(
      color: Colors.lightBlueAccent.withOpacity(0.06),
      padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 12.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            text,
            style: new TextStyle(color: Colors.black, fontSize: 14.0),
          ),
          new SizedBox(
            width: 18.0,
          ),
          new Image.asset(
            AssetStrings.imageVimeo,
            width: 12.0,
            height: 12.0,
            color: Colors.lightBlueAccent,
          ),
          new SizedBox(
            width: 8.0,
          ),
          new Image.asset(image, width: 12.0, height: 12.0),
        ],
      ),
    );
  }

  Widget getRichText(String item, String text) {
    return new RichText(
        textAlign: TextAlign.center,
        text: new TextSpan(
          children: <TextSpan>[
            new TextSpan(
              text: item,
              style: new TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 17.0,
              ),
            ),
            new TextSpan(
                text: text,
                style: new TextStyle(
                  fontWeight: FontWeight.normal,
                  color: Colors.black38,
                  fontSize: 17.0,
                )),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: false,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: new EdgeInsets.only(left: 30.0),
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.arrow_back),
                            new SizedBox(
                              width: 5.0,
                            ),
                            new Text(
                              "Back",
                              style: new TextStyle(fontSize: 17.0),
                            )
                          ],
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        height: 90.0,
                        width: 90.0,
                        margin: new EdgeInsets.only(left: 45.0, right: 45.0),
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            border: new Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0),
                            color: Colors.grey.withOpacity(0.2)),
                        child: ClipOval(
                          child: getCachedNetworkImage(
                              url:
                                  "https://i.ytimg.com/vi/sCZzhsd_NNY/maxresdefault.jpg",
                              fit: BoxFit.cover),
                        )),
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 10.0),
                      child: new Text(
                        "Particia Jane",
                        style: new TextStyle(
                            color: AppColors.kBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 5.0),
                      child: new Text(
                        "Bournemouth, UK",
                        style:
                            new TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 20.0),
                      child: new Row(
                        children: <Widget>[
                          getRichText("20.4k", " Followers"),
                          new SizedBox(
                            width: 40.0,
                          ),
                          getRichText("20.4k", " Following")
                        ],
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 40.0, top: 20.0, right: 40.0),
                      child: new Text(
                        "Here is my bio, I love making films and interacting with a collaborative that are as passionate as I am about film and TV.",
                        style: new TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 40.0,
                    ),
                    Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
                      child: Material(
                        child: Ink(
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      AppColors.kPrimaryBlue.withOpacity(0.2),
                                  blurRadius: 8.0,
                                  // has the effect of softening the shadow
                                  spreadRadius: 2.0,
                                  // has the effect of extending the shadow
                                  offset: Offset(
                                    2.0, // horizontal, move right 10
                                    2.0, // vertical, move down 10
                                  ),
                                )
                              ],
                              color: AppColors.kPrimaryBlue),
                          child: InkWell(
                            splashColor:
                                AppColors.kPrimaryBlue.withOpacity(0.3),
                            onTap: () {},
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Image.asset(
                                  AssetStrings.bottomUser,
                                  color: Colors.white,
                                  width: 14.0,
                                  height: 14.0,
                                ),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "Edit profile",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 40.0,
                    ),
                    videoLinkView("Connect account for quick video links",
                        AssetStrings.imageYoutube),
                    new SizedBox(
                      height: 30.0,
                    ),
                    new Container(
                      height: 1.0,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    new SizedBox(
                      height: 30.0,
                    ),
                  ],
                ),
              ),
              expandedHeight: 600.0,
              bottom: DecoratedTabBar(
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 1.0,
                      ),
                    ),
                    color: Colors.white),
                tabBar: new TabBar(
                    indicatorColor: AppColors.kPrimaryBlue,
                    labelStyle: new TextStyle(fontSize: 16.0),
                    indicatorWeight: 2.0,
                    unselectedLabelStyle: new TextStyle(fontSize: 16.0),
                    unselectedLabelColor: Colors.black87,
                    labelColor: AppColors.kPrimaryBlue,
                    controller: tabBarController,
                    isScrollable: false,
                    tabs: <Widget>[
                      new Tab(
                        text: "Profile",
                        icon: new Image.asset(AssetStrings.bottomUser,
                            width: 14.0,
                            height: 14.0,
                            color: tabBarController.index == 0
                                ? AppColors.kPrimaryBlue
                                : Colors.black87),
                      ),
//                    new Tab(
//                      text: "Approved",
//                    ),

                      new Tab(
                        text: "Credits",
                        icon: new Image.asset(AssetStrings.bottomEmail,
                            width: 14.0,
                            height: 14.0,
                            color: tabBarController.index == 1
                                ? AppColors.kPrimaryBlue
                                : Colors.black87),
                      ),
                    ]),
              ),
            )
          ];
        },
        body: new TabBarView(
          controller: tabBarController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[new CreateProfile(), new CreateProfile()],
        ),
      ),
    );
  }
}
