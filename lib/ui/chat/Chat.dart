import 'dart:async';

import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/chat/chat_tabs/ChatFirstWidget.dart';
import 'package:Filmshape/ui/chat/chat_tabs/ChatSecondWidget.dart';
import 'package:Filmshape/ui/chat/chat_tabs/ChatThirdWidget.dart';
import 'package:Filmshape/ui/chat/group_chat/create_group.dart';
import 'package:Filmshape/ui/my_profile/decprator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<BadgeCount> badeCountCallback;

  ChatScreen(
      {@required this.fullScreenWidget,
      @required this.badeCountCallback,
      Key key})
      : super(key: key);

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  String image;
  double currentIndexPage = 0.0;
  FirebaseProvider firebaseProvider;

  final StreamController<int> _streamControllerActiveUsers =
      StreamController<int>();

  final StreamController<int> _streamControllerProjects =
      StreamController<int>();

//to move to inner side  screen
  void moveToScreen(
      Widget screen, ValueSetter<BadgeCount> updateProjectCount) async {
    var status = await Navigator.push<String>(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return screen;
      }),
    );

    if (status != null) {
      updateProjectCount(BadgeCount(type: 2)); // project deleted
    }
  }

  @override
  void initState() {
    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 3, vsync: this);

    Future.delayed(const Duration(milliseconds: 300), () {
      _hitApi();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamControllerActiveUsers.close();
    _streamControllerProjects.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    var screensize = MediaQuery.of(context).size;
    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[
              Material(

                child: Container(
                  decoration: new BoxDecoration(color: Colors.white),
                  padding: new EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: screensize.width,
                          height: 40.0,
                          margin: new EdgeInsets.only(left: 10.0, right: 5.0),
                          child: DecoratedTabBar(
                            decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                ),
                                color: Colors.transparent),
                            tabBar: new TabBar(
                                indicatorColor: Colors.black,
                                labelStyle: new TextStyle(
                                    fontSize: 16.5,
                                    fontFamily: AssetStrings.lotoBoldStyle),
                                indicatorWeight: 2.4,
                                indicatorSize: TabBarIndicatorSize.tab,
                                isScrollable: true,
                                unselectedLabelStyle: new TextStyle(
                                    fontSize: 16.5,
                                    fontFamily: AssetStrings.lotoRegularStyle),
                                unselectedLabelColor: Colors.black87,
                                labelColor: Colors.black,
                                labelPadding: new EdgeInsets.only(left: 15.0),
                                indicatorPadding:
                                new EdgeInsets.only(left: 15.0),
                                controller: tabBarController,
                                tabs: <Widget>[
                                  new StreamBuilder<int>(
                                      stream:
                                      _streamControllerActiveUsers.stream,
                                      initialData: 0,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        var count = snapshot.data;
                                        return new Tab(
                                          text: (count == 0)
                                              ? "Active"
                                              : "Active ($count)",
                                        );
                                      }),
                                  new Tab(
                                    text: "Messages",
                                  ),
                                  new StreamBuilder<int>(
                                      stream: _streamControllerProjects.stream,
                                      initialData: 0,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<int> snapshot) {
                                        var count = snapshot.data;
                                        return new Tab(
                                          text: (count == 0)
                                              ? "Projects"
                                              : "Projects ($count)",
                                        );
                                      }),
                                ]),
                          ),
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(context, new CupertinoPageRoute(
                                builder: (BuildContext context) {
                                  return new CreateGroup();
                                }));
                          },
                          child: SvgPicture.asset(AssetStrings.createGroupIcon,width: 20,height: 20,)),
                          //new Icon(FontAwesomeIcons.edit, size: 27,)),
                      new SizedBox(
                        width: 20.0,
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: new EdgeInsets.only(top: 15.0),
                  child: new TabBarView(
                    controller: tabBarController,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      new ActiveTabs(
                        fullScreenWidget: widget.fullScreenWidget,
                        countCallBack: activeUsersCallBack,
                      ),
                      /*  new MessageTabs(fullScreenWidget: widget.fullScreenWidget,),*/
                      new MessageTabs(
                        fullScreenWidget: widget.fullScreenWidget,
                        countCallBack: unreadMessagesCallBack,
                      ),
                      new ProjectTabs(
                        fullScreenWidget: widget.fullScreenWidget,
                        countCallBack: activeProjectsCallBack,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _hitApi() async {
    var userId = MemoryManagement.getuserId();
    await firebaseProvider.getUserChatAndGroups(userId: int.parse(userId));


    _unreadMessageCount();
    sortList();
  }
  void sortList() {
    firebaseProvider.userList.sort((dynamic a, dynamic b) {
      var lasttime1 = (b is ChatUser)
          ? b.lastMessageTime
          : (b as FilmShapeFirebaseGroup).lastMessageTime;
      var lasttime2 = (a is ChatUser)
          ? a.lastMessageTime
          : (a as FilmShapeFirebaseGroup).lastMessageTime;
      return lasttime1.compareTo(lasttime2);
    });


  }

  void _unreadMessageCount() {
    var count = 0;
    for (var data in firebaseProvider.userList) {
      if (data is ChatUser) {
        count += data.unreadMessageCount;
      }
    }
    widget.badeCountCallback(BadgeCount(type: 2, count: count));
  }

  ValueChanged<int> activeUsersCallBack(int count) {
    // activeNUmber = count.toString();
    _streamControllerActiveUsers.add(count);
  }

  ValueChanged<int> activeProjectsCallBack(int count) {
    // activeNUmber = count.toString();
    //_streamControllerProjects.add(count);
  }

  ValueChanged<int> unreadMessagesCallBack(int count) {
    // activeNUmber = count.toString();
    //_streamControllerProjects.add(count);
    print("unread message coutn $count");
    widget.badeCountCallback(BadgeCount(type: 2, count: count));
  }
}
