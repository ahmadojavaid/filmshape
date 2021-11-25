import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/Utils/singleton_cache_data.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/Notification/NotificationScreen.dart';
import 'package:Filmshape/ui/bottom_nav/custom_showcase_home.dart';
import 'package:Filmshape/ui/browse_project/browse_project.dart';
import 'package:Filmshape/ui/chat/Chat.dart';
import 'package:Filmshape/ui/create_project/create_project.dart';
import 'package:Filmshape/ui/home/home_list/home_list.dart';
import 'package:Filmshape/ui/invite_request/InviteandRequest.dart';
import 'package:Filmshape/ui/join_project/join_project.dart';
import 'package:Filmshape/ui/login/login.dart';
import 'package:Filmshape/ui/my_profile/my_profile.dart';
import 'package:Filmshape/ui/my_project/my_project.dart';
import 'package:Filmshape/ui/search_for_talent.dart';
import 'package:Filmshape/ui/search_project/search_project.dart';
import 'package:Filmshape/ui/settings/SettingScreen.dart';
import 'package:Filmshape/ui/statelesswidgets/badge_counter.dart';
import 'package:badges/badges.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  final int type;

  BottomNavigation({this.type});

  @override
  MainWidgetState createState() => MainWidgetState();
}

class MainWidgetState extends State<BottomNavigation> {
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  GlobalKey<HomeListState> _homeKey = new GlobalKey<HomeListState>();
  GlobalKey<MyProfileState> _myProfileKey = new GlobalKey<MyProfileState>();
  GlobalKey<InviteRequestState> _invitesKey =
      new GlobalKey<InviteRequestState>();
  GlobalKey<ChatScreenState> _chatKey = new GlobalKey<ChatScreenState>();
  GlobalKey<NotificationScreenState> _notificationKey =
      new GlobalKey<NotificationScreenState>();

  List<BottomNavigationBarItem> bottomList = new List();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String _homeHeading = "Community";
  String _userName = "My Profile";
  String _drawerUserName = "";
  String _drawerUserLocation = "";
  String _drawerUserProfilePic = "";
  List<String> rolesList = new List();

  List<Widget> screens;
  Notifier _notifier;

  int _currentIndex = 0;
  BottomNavigationBar bottomNavigationBars;

  FirebaseMessaging _firebaseMessaging;
  FirebaseProvider firebaseProvider;

  final _homeScreen = GlobalKey<NavigatorState>();
  final _profileScreen = GlobalKey<NavigatorState>();
  final _invitesScreen = GlobalKey<NavigatorState>();
  final _chatScreen = GlobalKey<NavigatorState>();
  final _notificationScreen = GlobalKey<NavigatorState>();

  //for show case tutorial
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  String userId;
  int myTotalProjectCount = 0;
  int _clickPos = 0; //to check previous click in bottom navigation bar

  int _inviteCount = 0;
  int _chatCount = 0;
  int _notificationCount = 0;

  bool showToolTip = false;

  //move to in view screen
  ValueChanged<String> moveToInViewScreen(Widget screen) {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(screen, updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(screen, updateProjectCount);
          break;
        }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    MemoryManagement.init();

    var mail = MemoryManagement.getVerifyMail();
    MemoryManagement.setVerifyMailTemp(verify: mail);
    addBottomItem();
    setData();
    handlingNavigation();

    _firebaseMessaging = FirebaseMessaging();
    configurePushNotification();

    userId = MemoryManagement.getuserId();

    _initPushNotification();

    var showToolTipState = MemoryManagement.getToolTipState() ?? -1;

    Future.delayed(const Duration(milliseconds: 300), () {
      hitApi(true);
      if (showToolTipState ==
          TUTORIALSTATE.HOME
              .index) //if user is new (new registered user) than show showcase view
        showBottomShowCase();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose
    hitApi(false); //mark user offline

  }

  void hitApi(bool isOnline) async {
    await firebaseProvider?.updateUserOnlineOfflineStatus(status: isOnline);
  }

  //handing navigation when user successfully creates a project
  //choose option for create project, join project and add a credit
  void handlingNavigation() {
    Future.delayed(const Duration(milliseconds: 500), () {
      switch (widget.type) {
        //create project
        case 1:
          {
            _homeKey.currentState.moveToScreen(
                new CreateProject(screenToFullScreen, updateProjectCount),
                updateProjectCount);
            break;
          }
        //join project
        //add a credit
        case 2:
        case 3:
          {
            _homeKey.currentState.moveToScreen(
                new JoinProject(screenToFullScreen), updateProjectCount);
            break;
          }
      }
    });
  }

  void showNotification(
      String title, String body, Map<String, dynamic> data) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        new AndroidNotificationDetails(
            'your channel id', 'your channel name', 'your channel description');
    IOSNotificationDetails iOSPlatformChannelSpecifics =
        new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    int type = int.tryParse(data["data"]["type"]);
    await flutterLocalNotificationsPlugin.show(
        100, title, body, platformChannelSpecifics,
        payload: type.toString());
  }

  void configurePushNotification() async {
    print("config Notification");

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("config Notification onMessage");
        print("onMessage $message");
        String body = message['notification']['body']?.toString();
        String title = message['notification']['title']?.toString();
        showNotification(title, body, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("config Notification onResume");
        //  print("onResume: ${message}");
        print("onResume: ${message['data']['type']}");

        String payload = message['data']['type'];

        moveToScreenFromPush(int.tryParse(payload)); //w
//        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("config Notification onLaunch");
        print("onLaunch $message");
        int type = int.tryParse(message["data"]["type"]);
        moveToScreenFromPush(type);
      },
    );

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      print("DevToken   $token");
      if (token != null) {
        setDeviceToken(token);
        updateTokenToFirebase(token); //save to firebase
      }
    });
  }

  void _initPushNotification() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<void> updateTokenToFirebase(String token) async {
    var platForm = "IOS";
    if (Platform.isAndroid) {
      platForm = "ANDROID";
    }

    var userName = "";
    var userId = "";

    // hit api update token
/*
    try {
      if (MemoryManagement.getUserInfo() != null) {

        var infoData = jsonDecode(MemoryManagement.getUserInfo());
        var userinfo = LoginResponseTest.fromJson(infoData);
        userName =
            userinfo.data.user.firstName + " " + userinfo.data.user.lastName;
        userId = userinfo.data.user.id.toString();
      }
    } catch (ex) {
      print("error ${ex.toString()}");
      return null;
    }
    await _dashBoardBloc.updateDeviceToken(
        deviceToken: token,
        userId: userId,
        deviceType: platForm,
        userName: userName);*/
  }

  void setDeviceToken(String token) async {
    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {},
      onSuccess: () {},
    );

    if (gotInternetConnection) {
      // api hit
      /*var request = new DeviceTokenRequest(deviceToken: token);
      var response = await _dashBoardBloc.setDeviceToken(
          context: context, devicetokenRequest: request);

      //logged in successfully
      if (response != null && (response is ChangePasswordResponse)) {
        print(response.message);
      } else {}*/
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
//      Map valueMap = json.decode(payload);
      print("type $payload");
      moveToScreenFromPush(int.tryParse(payload)); //when click in push

    }
  }

//screen redirection for chat
  moveToScreenFromPush(int type) {
    switch ((type)) {
      case 1:
        //moveToLenderScreen();
        break;
      case 2:
        //  movetoBorrowScreen(1);
        break;
    }
  }

  void setData() {
    //set userinfo for later use
    SingletonCacheData singletonCacheData = SingletonCacheData();
    singletonCacheData.getUserInfo();
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      _userName = userResponse.user.fullName ?? "";
      _drawerUserName = userResponse.user.fullName ?? "";
      _drawerUserLocation = userResponse.user.location ?? "";
      _drawerUserProfilePic = userResponse.user.thumbnailUrl ?? "";

      rolesList.clear();
      LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
      //add user role
      for (var role in userResponse.user.roles) {
        listLocal.add(role.iconUrl);
      }

      rolesList.addAll(listLocal);
    }
  }

  void showDialogs() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 300,
            child: SizedBox.expand(child: FlutterLogo()),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
    );
  }

  Future<bool> pop() async {
    return false;
  }

  void showBottomShowCase() {
    //set tutorial for next state
    MemoryManagement.setToolTipState(
        state: TUTORIALSTATE.PROJECTSETTINGS.index);
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        isDismissible: false,
        builder: (BuildContext bc) {
          return WillPopScope(
            onWillPop: pop,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                color: Colors.white,
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        margin: new EdgeInsets.only(
                            top: 30.0, left: 30.0, right: 20.0),
                        child: new Text(
                          "Welcome to your activity feed!",
                          style: new TextStyle(
                              fontFamily: AssetStrings.lotoSemiboldStyle,
                              color: AppColors.kHomeBlack,
                              fontSize: 16),
                        )),
                    Container(
                        margin: new EdgeInsets.only(
                            top: 10.0, left: 30.0, right: 20.0),
                        child: new Text(
                          "To get you started we've followed 10 popular accounts, you can keep or unfollow them at any time from your profile.",
                          style: new TextStyle(
                              fontFamily: AssetStrings.lotoRegularStyle,
                              color: AppColors.introBodyColor,
                              fontSize: 15.5),
                        )),
                    InkWell(
                      onTap: () {
//                        final dynamic tooltip = _toolTipKey.currentState;
//                        tooltip.ensureTooltipVisible();
//                        ShowCaseWidget.of(myContext)
//                            .startShowCase([_one, _two, _three]);
                        showToolTip=true; //show tool tip
                        Navigator.pop(context);
                      setState(() {

                      });
                        },
                      child: Container(
                          margin: new EdgeInsets.only(
                              top: 20.0, left: 30.0, right: 20.0),
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              new Text(
                                "Next",
                                style: new TextStyle(
                                    fontFamily: AssetStrings.lotoSemiboldStyle,
                                    color: AppColors.kPrimaryBlue,
                                    fontSize: 16.5),
                              ),
                              new SizedBox(
                                width: 10.0,
                              ),
                              new Icon(
                                Icons.arrow_forward,
                                color: AppColors.kPrimaryBlue,
                                size: 20.0,
                              )
                            ],
                          )),
                    ),
                    new SizedBox(
                      height: 20,
                      child: new Text(""),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  //get update user name here
  ValueChanged callBack(MyProfileResponse response) {
    _userName = response.fullName ?? "";
    _drawerUserName = response.fullName ?? "";
    _drawerUserLocation = response.location ?? "";
    _drawerUserProfilePic = response.thumbnailUrl ?? "";

    rolesList.clear();
    LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
    //add user role
    for (var role in response.roles) {
      listLocal.add(role.iconUrl);
    }

    rolesList.addAll(listLocal);

    //update user fullname user cache data
    updateUserInfo(1, response?.fullName ?? "");
    //update user location in user cache data
    updateUserInfo(3, response?.location ?? "");

    myTotalProjectCount = response.projects.length; //my total project count
    setState(() {});
  }

  ValueChanged callBackUpdateRoles(List<String> roleDataList) {
    rolesList.clear();
    LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
    listLocal.addAll(roleDataList);
    rolesList.addAll(listLocal);
    setState(() {});
  }

  void callInviteAndNotificaitonApi() {
    _invitesKey.currentState?.callBothTabApis();
    _notificationKey.currentState?.getNewNotification(); //hit notifcation api
  }

  Widget getAppBar() {
    var data = MemoryManagement.getVerifyMailTemp();
    return PreferredSize(
      preferredSize: data == null || !data
          ? Size.fromHeight(115.0)
          : Size.fromHeight(70.0),
      child: Material(
        elevation: 0.5,
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Offstage(
                offstage: data == null || !data ? false : true,
                child: new Container(
                  color: AppColors.kVerifyBackground,
                  height: 45.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: new EdgeInsets.only(left: 30.0),
                          alignment: Alignment.center,
                          child: SvgPicture.asset(
                            AssetStrings.ic_tick,
                            height: 19.0,
                            width: 19.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: new Container(
                            margin: new EdgeInsets.only(left: 10.0),
                            child: new Text(
                              "Please verify your email address",
                              style: AppCustomTheme.headline21,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: 10.0, right: 20),
                        child: InkWell(
                            onTap: () {
                              // Navigator.pop(context);
                              MemoryManagement.setVerifyMailTemp(verify: true);
                              setState(() {});
                            },
                            child: new Icon(
                              Icons.clear,
                              size: 19.0,
                              color: Colors.white,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    new EdgeInsets.only(top: data == null || !data ? 15 : 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        _onTap(0); //set home screen tab
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          _homeHeading = "Community";
                          _notifier?.notify(
                              'action', _homeHeading); //update heading

                          setState(() {});
                        });
                      },
                      child: Container(
                        margin: new EdgeInsets.only(left: 20.0),
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          AssetStrings.filmLogo,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                        alignment: Alignment.center,
                        child: Notifier.of(context).register<String>('action',
                            (data) {
                          var heading = data.data ?? _homeHeading;
                          _homeHeading = heading;
                          return Center(
                            child: new Text(
                              heading,
                              style: AppCustomTheme.headline20,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(right: 5),
                      child: InkWell(
                          onTap: () {
                            if (_globalKey.currentState.isDrawerOpen) {
                              Navigator.pop(context);
                            }

                            screenToFullScreen(
                                SearchProject(screenToFullScreen));
                          },
                          child: new Icon(
                            Icons.search,
                            size: 24.0,
                            color: Colors.black,
                          )),
                    ),

                    Container(
                      margin: new EdgeInsets.only(left: 10.0, right: 20),
                      child: InkWell(
                          onTap: () {
                            if (!_globalKey.currentState.isDrawerOpen) {
                              _globalKey.currentState.openEndDrawer();
                            } else {
                              Navigator.pop(context);
                            }
                            // We create the tooltip on the first use
                          },
//                        child: Tooltip(
//                          key: _toolTipKey,
//                          child: IconButton(icon: Icon(Icons.menu, size: 24.0,color: Colors.black)),
//                          message: 'Lorem ipsum dolor sit amet, consectetur '
//                              'adipiscing elit, sed do eiusmod tempor incididunt '
//                              'ut labore et dolore magna aliqua. '
//                              'Ut enim ad minim veniam, quis nostrud exercitation '
//                              'ullamco laboris nisi ut aliquip ex ea commodo consequat',
//                          padding: EdgeInsets.all(20),
//                          margin: EdgeInsets.all(20),
//                          showDuration: Duration(seconds: 10),
//                          decoration: BoxDecoration(
//                            color: Colors.grey
//                            ,
//                            borderRadius: const BorderRadius.all(Radius.circular(4)),
//                          ),
//                          textStyle: TextStyle(color: Colors.black),
//                          preferBelow: true,
//                          verticalOffset: 20,
//                        ),

                          child: new Icon(
                            Icons.menu,
                            size: 24.0,
                            color: Colors.black,
                          )),
                    ),
//              Notifier.of(context).register<String>('fullvideoview', (data) {
//                var videoUrl = data.data;
//                print('video url $videoUrl');
//                if (videoUrl != null) {
//                  moveToFullViewScreen(videoUrl); //show video in full screen
//                }
//                return Container();
//              })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //to full view of add role screen
  ValueChanged<Widget> screenToFullScreen(Widget screen) {
    _moveToFullScreenView(screen);
  }

  Future<void> _moveToFullScreenView(Widget screen) async {
    await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return screen;
      }),
    );
  }

  ValueSetter<BadgeCount> updateProjectCount(BadgeCount badgeCount) {
    if (badgeCount.type == 1) {
      myTotalProjectCount++; //new project created
    } else {
      myTotalProjectCount--; //project delted
    }
    setState(() {});
  }

  void drawerMoveCreateProject() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new CreateProject(
                screenToFullScreen,
                updateProjectCount,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new CreateProject(
                screenToFullScreen,
                updateProjectCount,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new CreateProject(
                screenToFullScreen,
                updateProjectCount,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new CreateProject(
                screenToFullScreen,
                updateProjectCount,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new CreateProject(
                screenToFullScreen,
                updateProjectCount,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  void drawerMoveJoinProject() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new JoinProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new JoinProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new JoinProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new JoinProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new JoinProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  void drawerMoveSearchForTalent() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new SearchForTalent(
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new SearchForTalent(
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new SearchForTalent(
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new SearchForTalent(
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new SearchForTalent(
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  void drawerMoveToMyProjectScreen() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new MyProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new MyProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new MyProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new MyProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new MyProject(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  void drawerMoveToSettingsScreen() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new SettingScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new SettingScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new SettingScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new SettingScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new SettingScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  void drawerMoveToMyBrowseProjectScreen() {
    switch (_currentIndex) {
      case 0:
        {
          _homeKey.currentState.moveToScreen(
              new BrowseProjectScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 1:
        {
          _myProfileKey.currentState.moveToScreen(
              new BrowseProjectScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 2:
        {
          _invitesKey.currentState.moveToScreen(
              new BrowseProjectScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 3:
        {
          _chatKey.currentState.moveToScreen(
              new BrowseProjectScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
      case 4:
        {
          _notificationKey.currentState.moveToScreen(
              new BrowseProjectScreen(
                screenToFullScreen,
                previousTabHeading: _homeHeading,
              ),
              updateProjectCount);
          break;
        }
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: _globalKey.currentContext,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () async {
                Navigator.of(context).pop();
                SingletonCacheData singletonCacheData = SingletonCacheData();
                singletonCacheData.resetCache();
                await firebaseProvider.updateUserOnlineOfflineStatus(
                    status: false); //mark user offline
                await firebaseProvider.signOut();
                firebaseProvider.clearAllCache();
                MemoryManagement.clearMemory(); //remove all cached data
                MemoryManagement.init();

                Navigator.pushAndRemoveUntil(
                  _globalKey.currentContext,
                  new CupertinoPageRoute(builder: (BuildContext context) {
                    return new LoginScreen();
                  }),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  void goToProfiles() {
    Navigator.pop(context);
    _onTap(1); //move to user profile section
  }

  Widget getListTile(String text, String image, int pos) {
    return InkWell(
      onTap: () {
        pauseVideoIfAnyPlaying(); //stop video playing anywhere if navigating
        unselectAll();
        _clickPos = -1;
        Navigator.pop(context); //close navigation drawer

        if (pos == 1) {
          drawerMoveToMyProjectScreen();
        }
        //create project
        else if (pos == 2) {
          drawerMoveCreateProject(); //state move
        }
        //join project
        else if (pos == 3) {
          drawerMoveJoinProject();
        }
        //search for talent in project
        else if (pos == 4) {
          drawerMoveSearchForTalent();
        } else if (pos == 5) {
          drawerMoveToMyBrowseProjectScreen();
        } else if (pos == 6) {
          drawerMoveToSettingsScreen();
        } else if (pos == 7) {
          _showAlertDialog(); //logout confirmation dialog
        }
      },
      child: Container(
          margin: new EdgeInsets.only(left: 30.0, top: 30.0),
          child: Row(
            children: <Widget>[
              new SvgPicture.asset(
                image,
                color: Colors.black,
                width: 16.0,
                height: 16.0,
              ),
              Expanded(
                child: Container(
                  margin: new EdgeInsets.only(left: 15.0),
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    text,
                    style: new TextStyle(
                        fontSize: 16,
                        fontFamily: AssetStrings.lotoRegularStyle),
                  ),
                ),
              ),
              (myTotalProjectCount > 0 && pos == 1)
                  ? counterWidget()
                  : Container(),
              new SizedBox(
                width: 20.0,
              ),
            ],
          )),
    );
  }

  Widget counterWidget() {
    return new Container(
      width: 28,
      height: 20,
      padding: new EdgeInsets.only(bottom: 2, top: 1),
      alignment: Alignment.center,
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(11.0),
          color: Colors.deepPurpleAccent),
      child: Center(
        child: Text(
          "$myTotalProjectCount",
          style: new TextStyle(
              color: Colors.white,
              fontFamily: AssetStrings.lotoRegularStyle,
              fontSize: 12.0),
        ),
      ),
    );
  }

  Widget getEndDrawer() {
    return Container(
      margin: new EdgeInsets.only(right: 20.0, top: 20.0, bottom: 20.0),
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
                        if (!_globalKey.currentState.isEndDrawerOpen) {
                          _globalKey.currentState.openEndDrawer();
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
                InkWell(
                  onTap: () {
                    goToProfiles();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: new EdgeInsets.only(left: 30.0),
                    child: getProfileWidget(_drawerUserProfilePic),
                  ),
                ),
                (_drawerUserName.length > 0)
                    ? InkWell(
                        onTap: () {
                          goToProfiles();
                        },
                        child: Container(
                          margin: new EdgeInsets.only(left: 30.0, top: 15.0),
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            _drawerUserName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppCustomTheme.profileUserStyle,
                          ),
                        ),
                      )
                    : Container(),
                new SizedBox(
                  height: 4.0,
                ),
                Container(
                  margin: new EdgeInsets.only(left: 30.0, right: 15.0),
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    _drawerUserLocation,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppCustomTheme.profileUserLocationStyle,
                  ),
                ),
                (rolesList.length > 0)
                    ? InkWell(
                        onTap: () {
                          goToProfiles();
                        },
                        child: Container(
                            margin: new EdgeInsets.only(left: 30.0, top: 15.0),
                            child: getStackItem(rolesList, 0, 40)),
                      )
                    : Container(),
                Container(
                    child: const Divider(height: 1.2, color: Colors.white)),
                new Expanded(
                  child: new Container(
                    child: new ListView(
                      padding: new EdgeInsets.all(0.0),
                      children: <Widget>[
                        getListTile(
                            "My Projects", AssetStrings.myProjectDrawer, 1),
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
                            child:
                                const Divider(height: 1.2, color: Colors.grey)),
                        getListTile("Settings", AssetStrings.settingDrawer, 6),
                        getListTile("Log out", AssetStrings.logoutDrawer, 7),
                        SizedBox(
                          height: 30,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    bool canPop = false;
    switch (_currentIndex) {
      case 0:
        {
          canPop = _homeScreen.currentState.canPop();
          if (canPop) _homeScreen.currentState.pop();
          break;
        }
      case 1:
        {
          canPop = _profileScreen.currentState.canPop();
          if (canPop) _profileScreen.currentState.pop();

          break;
        }
      case 2:
        {
          canPop = _invitesScreen.currentState.canPop();
          if (canPop) _invitesScreen.currentState.pop();

          break;
        }
      case 3:
        {
          canPop = _chatScreen.currentState.canPop();
          if (canPop) _chatScreen.currentState.pop();

          break;
        }
      case 4:
        {
          canPop = _notificationScreen.currentState.canPop();
          if (canPop) _notificationScreen.currentState.pop();

          break;
        }
    }
    if (!canPop) //check if screen popped or not and showing home tab data
      return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Exit the app?'),
                content: Text('Do you want to exit an App'),
                actions: <Widget>[
                  FlatButton(
                    child: Text('NO'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  FlatButton(
                    child: Text('YES'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                      exit(0); //close app
                    },
                  ),
                ],
              );
            },
          ) ??
          false;
  }

  @override
  Widget build(BuildContext ctx) {
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header
    var data = MemoryManagement.getVerifyMailTemp();

    return SafeArea(
      child: Stack(
        children: <Widget>[
          WillPopScope(
              onWillPop: _onBackPressed,
              child: Scaffold(
                  key: _globalKey,
                  appBar: getAppBar(),
                  endDrawer: getEndDrawer(),
                  body: IndexedStack(
                    index: _currentIndex,
                    children: <Widget>[
                      Navigator(
                        key: _homeScreen,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => HomeList(
                            screenToFullScreen,
                            key: _homeKey,
                          ),
                        ),
                      ),
                      Navigator(
                        key: _profileScreen,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => MyProfile(
                            callBack,
                            callBackUpdateRoles,
                            screenToFullScreen,
                            userId,
                            key: _myProfileKey,
                          ),
                        ),
                      ),
                      Navigator(
                        key: _invitesScreen,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => InviteRequest(
                            key: _invitesKey,
                            badeCountCallback: badeCountCallback,
                            fullScreenWidget: screenToFullScreen,
                          ),
                        ),
                      ),
                      Navigator(
                        key: _chatScreen,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => ChatScreen(
                            fullScreenWidget: screenToFullScreen,
                            badeCountCallback: badeCountCallback,
                            key: _chatKey,
                          ),
                        ),
                      ),
                      Navigator(
                        key: _notificationScreen,
                        onGenerateRoute: (route) => MaterialPageRoute(
                          settings: route,
                          builder: (context) => NotificationScreen(
                            key: _notificationKey,
                            fullScreenWidget: screenToFullScreen,
                            badeCountCallback: badeCountCallback,
                            moveToInviteCallBack: moveToInviteSection,
                          ),
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _currentIndex,
                    onTap: (val) => _onTap(val),
                    backgroundColor: AppColors.white,
                    items: bottomList,
                  ))),
          Offstage(
            offstage: !showToolTip,
            child: new Container(
              color:
                  data == null || !data ? Colors.black45 : Colors.transparent,
            ),
          ),
          Container(
            child: new Positioned(
                right: 0.0,
                top: 0.0,
                left: 0.0,
                child: Offstage(
                  offstage: !showToolTip,
                  child: Container(
                      margin: new EdgeInsets.only(
                          top: data == null || data == false ? 100.0 : 60,
                          left: 30.0,
                          right: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Container(
                            margin: new EdgeInsets.only(right: 12.0, top: 0.0),
                            child: new SvgPicture.asset(
                              AssetStrings.trianlge,
                              width: 40.0,
                              height: 18.0,
                              color: Colors.white,
                            ),
                          ),
                          new CustomShowCaseHome(
                            callback: toolTipCallBack,
                          ),
                        ],
                      )),
                )),
          )
        ],
      ),
    );
  }

  VoidCallback toolTipCallBack() {
    showToolTip = false; //hide tool tip
    setState(() {});
  }

  void addBottomItem() {
    bottomList.clear();

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomHomeSelected),
        icon: nonActiveItem(AssetStrings.bottomHomeUnSelected),
        title: itemTitle("Feed")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomProfileSelected),
        icon: nonActiveItem(AssetStrings.bottomProfileUnSelected),
        title: itemTitle("Profile")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomInviteSelected),
        icon: nonActiveItem(AssetStrings.bottomInviteUnSelected),
        title: itemTitle("Invites")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomChatSelected),
        icon: nonActiveItem(AssetStrings.bottomChatUnSelected),
        title: itemTitle("Chat")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomNotificationSelected),
        icon: nonActiveItem(AssetStrings.bottomNotificationUnSelected),
        title: itemTitle("Notifications")));
  }

  void unselectAll() {
    bottomList.clear();

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomHomeUnSelected),
        icon: nonActiveItem(AssetStrings.bottomHomeUnSelected),
        title: itemTitleNew("Feed")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomProfileUnSelected),
        icon: nonActiveItem(AssetStrings.bottomProfileUnSelected),
        title: itemTitleNew("Profile")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomInviteUnSelected),
        icon: nonActiveItem(AssetStrings.bottomInviteUnSelected),
        title: itemTitleNew("Invites")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomChatUnSelected),
        icon: nonActiveItem(AssetStrings.bottomChatUnSelected),
        title: itemTitleNew("Chat")));

    bottomList.add(BottomNavigationBarItem(
        activeIcon: activeItem(AssetStrings.bottomNotificationUnSelected),
        icon: nonActiveItem(AssetStrings.bottomNotificationUnSelected),
        title: itemTitleNew("Notifications")));
    setState(() {});
  }

  Widget activeItem(String imageString) {
    if (imageString == AssetStrings.bottomInviteSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _inviteCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _inviteCount),
          child: SvgPicture.asset(
            imageString,
            width: SELECT_TAB_ICON_SIZE,
            height: SELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else if (imageString == AssetStrings.bottomChatSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _chatCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _chatCount),
          child: SvgPicture.asset(
            imageString,
            width: SELECT_TAB_ICON_SIZE,
            height: SELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else if (imageString == AssetStrings.bottomNotificationSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _notificationCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _notificationCount),
          child: SvgPicture.asset(
            imageString,
            width: SELECT_TAB_ICON_SIZE,
            height: SELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SvgPicture.asset(
          imageString,
          width: SELECT_TAB_ICON_SIZE,
          height: SELECT_TAB_ICON_SIZE,
        ),
      );
    }
  }

  Widget nonActiveItem(String imageString) {
    if (imageString == AssetStrings.bottomInviteUnSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _inviteCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _inviteCount),
          child: SvgPicture.asset(
            imageString,
            width: UNSELECT_TAB_ICON_SIZE,
            height: UNSELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else if (imageString == AssetStrings.bottomChatUnSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _chatCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _chatCount),
          child: SvgPicture.asset(
            imageString,
            width: UNSELECT_TAB_ICON_SIZE,
            height: UNSELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else if (imageString == AssetStrings.bottomNotificationUnSelected) {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Badge(
          showBadge: _notificationCount > 0,
          badgeColor: AppColors.kPrimaryBlue,
          badgeContent: BadgeCounter(count: _notificationCount),
          child: SvgPicture.asset(
            imageString,
            width: UNSELECT_TAB_ICON_SIZE,
            height: UNSELECT_TAB_ICON_SIZE,
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(top: 5),
        child: SvgPicture.asset(
          imageString,
          width: UNSELECT_TAB_ICON_SIZE,
          height: UNSELECT_TAB_ICON_SIZE,
        ),
      );
    }
//    return Padding(
//      padding: const EdgeInsets.only(top: 5.0),
//      child: SvgPicture.asset(imageString,
//          width: UNSELECT_TAB_ICON_SIZE, height: UNSELECT_TAB_ICON_SIZE),
//    );
  }

  Widget itemTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Text(title),
    );
  }

  Widget itemTitleNew(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: Text(
        title,
        style: new TextStyle(color: Colors.grey),
      ),
    );
  }

  void _onTap(int val) {
    pauseVideoIfAnyPlaying(); //stop video playing anywhere if navigating
    addBottomItem();
    var _appBarHeading = "";
    switch (val) {
      case 0:
        _homeHeading = "Community";
        _appBarHeading = "Community";
        _homeScreen.currentState?.popUntil((route) => route.isFirst);
        allowOrientationChange();
        //refresh notification and
        callInviteAndNotificaitonApi();
        break;
      case 1:
        _homeHeading = _userName;
        _appBarHeading = _userName;

        //_homeHeading = "My Profile";
        _profileScreen.currentState?.popUntil((route) => route.isFirst);
        //check if first time loading
        if (!_myProfileKey.currentState.isFirstTmeDataLoaded) {
          _myProfileKey.currentState.hitGetMyProfileApi();
        }
        allowOrientationChange();
        callInviteAndNotificaitonApi();
        break;

      case 2:
        _homeHeading = INVITENREQUEST;
        _appBarHeading = INVITENREQUEST;

        _invitesScreen.currentState?.popUntil((route) => route.isFirst);
        disableOrientation();
        break;
      case 3:
        _homeHeading = "Chat & Messages";
        _appBarHeading = "Chat & Messages";

        _chatScreen.currentState?.popUntil((route) => route.isFirst);
        disableOrientation();
        break;
      case 4:
        _homeHeading = "Notifications";
        _appBarHeading = "Notifications";

        _notificationScreen.currentState?.popUntil((route) => route.isFirst);
        //check for new notification
        _notificationKey.currentState.getNewNotification();
        disableOrientation();
        break;

      default:
        _homeHeading = "";
    }
    setState(() {
      _currentIndex = val;
    });

    int timer =
        1000; //default timer to popback other screen and set right header at time
    //check to check if click at bottom bar came from different screen
    if (_clickPos == 0 ||
        _clickPos == 1 ||
        _clickPos == 2 ||
        _clickPos == 3 ||
        _clickPos == 4) {
      timer = 0;
    }
    _clickPos = val;
    Future.delayed(Duration(milliseconds: timer), () {
      _notifier?.notify('action', _appBarHeading); //update heading
    });
  }

  ValueChanged<BadgeCount> badeCountCallback(BadgeCount badgeCount) {
    print("badge received ${badgeCount.toJson()}");
    //for notification badge
    if (badgeCount.type == 3) {
      _notificationCount = badgeCount.count;
    }
    //for chat badge
    if (badgeCount.type == 2) {
      _chatCount = badgeCount.count;
    }
    //for invites badge
    if (badgeCount.type == 1) {
      _inviteCount = badgeCount.count;
    }

    setState(() {
      addBottomItem();
    });
  }

  //move to invite tab of user
  VoidCallback moveToInviteSection() {
    _onTap(2); //move to user profile section
  }

  void allowOrientationChange() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void disableOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void pauseVideoIfAnyPlaying() {
    //moving to comment section pause running video if any
    _notifier?.notify('pausevideo', "pausevideo"); //update heading

    //call the pause video notifier with null to avoid frequent call of notifier
    //which might cause to pause resume of video
    Future.delayed(const Duration(milliseconds: 50), () {
      _notifier?.notify('pausevideo', null); //
    });
  }
}
