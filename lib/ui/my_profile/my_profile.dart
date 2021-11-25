import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Model/following_suggestion/follow_response.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_response.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/Utils/singleton_cache_data.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/my_profile.dart';
import 'package:Filmshape/notifier_provide_model/suggestion_notifier.dart';
import 'package:Filmshape/ui/ChatList/Chat/private_chat.dart';
import 'package:Filmshape/ui/create_project/invite_project_bottom_sheet.dart';
import 'package:Filmshape/ui/edit_profile/edit_profile.dart';
import 'package:Filmshape/ui/following/following_users.dart';
import 'package:Filmshape/ui/my_profile/first_tab/credit_tab.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

import 'decprator.dart';
import 'first_tab/first_tab.dart';

class MyProfile extends StatefulWidget {
  final ValueChanged<MyProfileResponse> callBack;
  final ValueChanged<List<String>> rolesCallback;
  final ValueChanged<Widget> fullScreenWidget;
  String previousTabHeading;
  UserData userData;
  final String userId;
  final bool fromComment;
  bool fromSearchScreen = false;

  MyProfile(
      this.callBack, this.rolesCallback, this.fullScreenWidget, this.userId,
      {Key key,
      this.previousTabHeading,
      this.userData,
      this.fromComment,
      this.fromSearchScreen})
      : super(key: key);

  @override
  MyProfileState createState() => MyProfileState();
}

class MyProfileState extends State<MyProfile>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MyProfile> {
  TabController tabBarController;

  int _tabIndex = 0;
  String _youtubeToken = null;
  String _vimeoToken = null;
  List<String> roleList = new List();

  MyProfileProvider provider;
  MyProfileResponse responseProfile;
  SuggestionProvider providers;

  double _rolesHeight = 50;
  String _userName;
  String _location;
  String _profilePic;
  String _bio;
  bool _isOnline;
  int type = 1;
  String followUnfollow = "Follow";
  Notifier _notifier;
  bool isFirstTmeDataLoaded = false;
  FirebaseProvider firebaseProvider;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<UserProfileFirstTabState> _profileFirstTab =
      new GlobalKey<UserProfileFirstTabState>();

  ScrollController _scrollController = ScrollController();
  int _stopPos = 0; //to track last scrolled position

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

//authenticate the youtube user
  youtubeAuth() async {
    var response;
    if (Platform.isIOS) {
      response = await Navigator.push(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return new YoutubeAuthWebView();
        }),
      );
    } else {
      response = await androidYoutubeLogin();
    }
    //success response from
    if (response is YoutubeAuthTokenResponse) {
      print("youdata ${response.toJson()}");
      _youtubeToken = response.accessToken;
      MemoryManagement.setYoutubeToken(token: _youtubeToken);
      quickAccessVideoLinkBottomSheet();
    }
    //failure
    else if (response is APIError) {
      print("error! ${response.error}");
      showInSnackBar(response.error);
    }
    //unknown failure
    else {
      print("error2 generic error");

      showInSnackBar(Messages.genericError);
    }
  }

  //authenticate the videmo user
  Future<void> vimeoAuth() async {
    var response = await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new VimeoAuthWebView();
      }),
    );
    //success
    if (response is ViemoAuthTokenResponse) {
      _vimeoToken = response.accessToken;
      print("access token $_vimeoToken");
      MemoryManagement.setVimeoToken(token: _vimeoToken);
      quickAccessVideoLinkBottomSheet();
    }
    //failure
    else if (response is APIError) {
      showInSnackBar(response.error);
    }
    //unknown failure
    else {
      showInSnackBar(Messages.genericError);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  ValueChanged callBackUpdateRoles(List<String> roleDataList) {
//    roleList.clear();
//    LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
//    listLocal.addAll(roleDataList);
//    roleList.addAll(listLocal);
//    //update role list
//    if(widget.rolesCallback!=null)
//      {
//        widget.rolesCallback(roleList);
//      }
//    setState(() {
//
//    });
    hitGetMyProfileApi();
  }

  @override
  void initState() {
    super.initState();
    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 2, vsync: this);
    tabBarController.addListener(_handleTabSelection);

    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

    //rotation for horizontal video mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    setData(); //set data
    Future.delayed(const Duration(milliseconds: 300), () {
      hitGetMyProfileApi();
    });

    _scrollController.addListener(_handleScrolling);
  }

  void _handleScrolling() {
    var currentPos = _scrollController.offset.toInt();
    if (currentPos % 50 == 0 && (_stopPos != currentPos)) {
      _stopPos = currentPos;
      print("scroll pos ${currentPos}");
      pauseVideoIfAnyPlaying();
    }
  }

  void setData() {
    if (widget.userData != null) {
      //if it's not current user than update top header
      if (!isCurrentUser(widget.userId)) {
        Future.delayed(const Duration(milliseconds: 100), () {
          _notifier?.notify('action', widget.userData.fullName); //update title
        });
        _userName = widget.userData.fullName;
        _location = widget.userData.location;
        _profilePic = widget.userData.thumbnailUrl;
      }
    }
  }

  @override
  void dispose() {
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);
    //remove rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  //hit this api when user edit profile in edit screen
  VoidCallback callback() {
    hitGetMyProfileApi();
  }

  void quickAccessVideoLinkBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.keyboard_arrow_down, size: 29.0),
                              new SizedBox(
                                width: 4.0,
                              ),
                              new Text(
                                "Close",
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 55.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 60.0),
                    child: new Text(
                      "Connect my account",
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                    child: new Text(
                      "Connect account for quick video linking",
                      style: new TextStyle(
                          color: AppColors.introBodyColor,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 30.0),
                    child: videoLinkViews(
                        (_youtubeToken == null)
                            ? "Connect my Youtube account"
                            : "Youtube connected",
                        AssetStrings.imageYoutube,
                        1,
                        true),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child: videoLinkViews(
                        (_vimeoToken == null)
                            ? "Connect my Vimeo account"
                            : "Vimeo connected",
                        AssetStrings.imageVimeo,
                        2,
                        true),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Text("  "),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget videoLinkViews(
      String text, String image, int from, bool fromBottomSheet) {
    return InkWell(
        onTap: () {
          if (_youtubeToken == null && from == 1) {
            Navigator.pop(context); //close bottom sheet
            youtubeAuth();
          } else if (_vimeoToken == null && from == 2) {
            Navigator.pop(context); //close bottom sheet
            vimeoAuth();
          }
          //disconnect it youtube account
          else if (_youtubeToken != null && from == 1) {
            Navigator.pop(context); //close bottom sheet
            showBottomDisconnectAccount(
                "Disconnect my Youtube account", from, image);
          }
          //disconnect it vimeo account
          else if (_vimeoToken != null && from == 2) {
            Navigator.pop(context); //close bottom sheet
            showBottomDisconnectAccount(
                "Disconnect my Vimeo account", from, image);
          }
        },
        child: Container(
          margin: new EdgeInsets.only(left: 40.0, right: 40.0),
          child: YoutubeVimeoButton(
            youtubeToken: _youtubeToken,
            vimeoToken: _vimeoToken,
            iconImage: image,
            text: text,
            buttonType: from,
          ),
        ));
  }

// Show Disconnect Bottom Sheet

  void showBottomDisconnectAccount(String text, int type, String imageIcon) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Colors.white,
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin:
                        new EdgeInsets.only(top: 20.0, left: 30.0, right: 20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context, "Back");
                      },
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.arrow_back_ios,
                            size: 18.0,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          new Text(
                            "Back",
                            style: new TextStyle(
                                color: AppColors.kHomeBlack, fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      margin: new EdgeInsets.only(
                          top: 30.0, left: 30.0, right: 30.0),
                      child: new Text(
                        "Disconnect my account",
                        style: new TextStyle(
                            fontFamily: AssetStrings.lotoSemiboldStyle,
                            color: AppColors.kHomeBlack,
                            fontSize: 18),
                      )),
                  Container(
                      margin: new EdgeInsets.only(
                          top: 5.0, left: 30.0, right: 30.0),
                      child: new Text(
                        "Confirm you want to disconnect this account.",
                        style: new TextStyle(
                            fontFamily: AssetStrings.lotoRegularStyle,
                            color: AppColors.introBodyColor,
                            fontSize: 15.5),
                      )),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); //close bototm sheet
                      //for youtube
                      //disconnect it
                      if (type == 1) {
                        _youtubeToken = null;
                        MemoryManagement.setYoutubeToken(token: null);
                      } else {
                        _vimeoToken = null;
                        MemoryManagement.setVimeoToken(token: null);
                      }
                      setState(() {});
                    },
                    child: Container(
                      margin:
                          new EdgeInsets.only(left: 30.0, right: 40.0, top: 20),
                      child: YoutubeVimeoButton(
                          youtubeToken: _youtubeToken,
                          vimeoToken: _vimeoToken,
                          iconImage: imageIcon,
                          text: text,
                          buttonType: type),
                    ),
                  ),
                  new SizedBox(
                    height: 30,
                    child: new Text(""),
                  )
                ],
              ),
            ),
          );
        });
  }

  hitGetMyProfileApi() async {
    provider.setLoading();
    var response = await provider.getProfileData(
        widget.userId, context); // demo for use id 3

    if (response is MyProfileResponse) {
      print("my_profile_data ${response.toJson()}");
      isFirstTmeDataLoaded =
          true; //data loaded no need to call api on tab change

      responseProfile = response;
      LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
      //update user name in action bar from home screen
      //because action bar is common for all tabs
      if (widget.callBack != null) {
        widget.callBack(response);
      }
      roleList.clear();
      //add user role
      for (var role in response.roles) {
        listLocal.add(role.iconUrl);
      }

      roleList.addAll(listLocal);

      String id = MemoryManagement.getuserId();

      if (responseProfile != null &&
          responseProfile.followersIds != null &&
          responseProfile.followersIds.length > 0) {
        if (responseProfile.followersIds.contains(int.parse(id))) {
          type = 0;
          followUnfollow = "Unfollow";
        }
      }

      _profileFirstTab.currentState.setData(response); //update first tab data
      //sending data to chat screen of user
      _userName = response.fullName;
      _location = response.location;
      _profilePic = response.thumbnailUrl;
      _bio = response.bio;
      _isOnline = response.isOnline;

      //if it's not current user than update top header
      if (!isCurrentUser(widget.userId)) {
        _notifier?.notify('action', _userName); //update title

      }

      //if currrent opened profile is current user than update the data
      if (isCurrentUser(widget.userId)) {
        //set userinfo for later use
        SingletonCacheData singletonCacheData = SingletonCacheData();
        var userInfo = singletonCacheData.getUserInfo();
        userInfo.user.thumbnailUrl = response.thumbnailUrl;
        userInfo.user.fullName = response.fullName;
        userInfo.user.location = response.location;
        userInfo.user.bio = response.bio;
        singletonCacheData.updateCache(userInfo);
        //update data to firebase as well
        //update user info to fire store user collection
        var firebaseUser = await firebaseProvider.getCurrentUser();
        await firebaseProvider
            .updateFirebaseUser(getUser(response, firebaseUser.uid));
        //save user email
      }
      setState(() {});
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error ?? Messages.genericError);
    }
  }

  //create user model for firebase to update user
  FilmShapeFirebaseUser getUser(
      MyProfileResponse myProfileResponse, String firebaseId) {
    var listRoles = List<String>();
    for (var data in myProfileResponse.roles) {
      listRoles.add(data.iconUrl);
    }
    return new FilmShapeFirebaseUser(
        fullName: myProfileResponse.fullName ?? "",
        email: myProfileResponse.username ?? "",
        location: myProfileResponse.location ?? "",
        updated: DateTime.now().toIso8601String(),
        filmShapeId: myProfileResponse.id,
        firebaseId: firebaseId,
        isOnline: true,
        bio: myProfileResponse.bio ?? "",
        thumbnailUrl: myProfileResponse.thumbnailUrl ?? "",
        gender: myProfileResponse.gender?.name ?? "",
        roles: listRoles);
  }

  void _handleTabSelection() {
    _tabIndex = tabBarController.index;
    if (_tabIndex == 0)
      _profileFirstTab.currentState
          .setData(responseProfile); //update first tab data

    pauseVideoIfAnyPlaying();
    setState(() {});
  }

  Widget videoLinkView(String text) {
    return InkWell(
      onTap: () {
        quickAccessVideoLinkBottomSheet();
      },
      child: new Container(
        color: AppColors.backgroundAccountView,
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 15.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              text,
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.3,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
            new SizedBox(
              width: 18.0,
            ),
            new Image.asset(
              AssetStrings.imageVimeo,
              width: 16.0,
              height: 16.0,
              color: (_vimeoToken == null) ? Colors.black : Colors.blue,
            ),
            new SizedBox(
              width: 8.0,
            ),
            new Image.asset(AssetStrings.imageYoutube,
                width: 16.0,
                height: 16.0,
                color: (_youtubeToken == null) ? Colors.black : Colors.red),
          ],
        ),
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
                fontFamily: AssetStrings.lotoBoldStyle,
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            new TextSpan(
                text: text,
                style: new TextStyle(
                  fontFamily: AssetStrings.lotoRegularStyle,
                  color: AppColors.kTextNewAppIconColor,
                  fontSize: 15.0,
                )),
          ],
        ));
  }

  Widget getAppBarNew() {
    return PreferredSize(
      preferredSize: Size.fromHeight(.0),
      child: Container(),
    );
  }

  void _moveToFollowFollowing() async {
    var data = await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new FollowingUsers(
          _userName ?? "",
          userId: widget.userId,
          type: 0,
        );
      }),
    );

    print("data $data");
    //update profile for follow following count
    if (data != null) {
      hitGetMyProfileApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    double topViewHeight = (!isCurrentUser(widget.userId) ? 70 : 0) +
        650 -
        ((roleList.length == 0) ? (_rolesHeight + 10) : 0) +
        0.0 -
        (((responseProfile?.bio == null) ||
                (responseProfile?.bio != null &&
                    responseProfile?.bio?.length == 0))
            ? 40
            : 0);
    _notifier = NotifierProvider.of(context); // to update home screen header
    provider = Provider.of<MyProfileProvider>(context);
    providers = Provider.of<SuggestionProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        appBar: widget.fromComment != null && widget.fromComment
            ? getAppbar(responseProfile != null ? responseProfile.fullName : "")
            : getAppBarNew(),
        body: Stack(
          children: <Widget>[
            NestedScrollView(
              // controller: _scrollController,
              // physics: ScrollPhysics(parent: PageScrollPhysics()),
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
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
                            height: 40.0,
                          ),
                          Container(
                              margin:
                                  new EdgeInsets.only(left: 40.0, right: 45.0),
                              child: getProfileWidget(_profilePic ?? "")),
                          Container(
                            margin: new EdgeInsets.only(left: 40.0, top: 10.0),
                            child: new Text(
                              _userName ?? "",
                              style: AppCustomTheme.profileUserStyle,
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.only(left: 40.0, top: 5.0),
                            child: new Text(
                              _location ?? "",
                              style: AppCustomTheme.profileUserLocationStyle,
                            ),
                          ),
                          (roleList.length > 0)
                              ? Container(
                                  height: _rolesHeight,
                                  margin: new EdgeInsets.only(
                                      left: 35.0, top: 12.0),
                                  child: getStackItem(roleList, 0, 40))
                              : Container(),
                          Container(
                            margin: new EdgeInsets.only(left: 40.0, top: 16.0),
                            child: new Row(
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        new CupertinoPageRoute(
                                            builder: (BuildContext context) {
                                          return new FollowingUsers(
                                            _userName ?? "",
                                            userId: widget.userId,
                                            type: 1,
                                          );
                                        }),
                                      );
                                    },
                                    child: getRichText(
                                        "${responseProfile?.totalFollowers ?? 0}",
                                        " Followers")),
                                new SizedBox(
                                  width: 40.0,
                                ),
                                InkWell(
                                    onTap: () {
                                      _moveToFollowFollowing();
                                    },
                                    child: getRichText(
                                        "${responseProfile?.totalFollowing ?? 0}",
                                        " Following"))
                              ],
                            ),
                          ),
                          (responseProfile?.bio != null)
                              ? Container(
                                  margin: new EdgeInsets.only(
                                      left: 40.0, top: 20.0, right: 35.0),
                                  child: new Text(
                                    responseProfile?.bio != null
                                        ? responseProfile?.bio
                                        : "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      color: AppColors.kTextNewAppBlackColor,
                                      fontSize: 14.5,
                                      height: 1.2,
                                      fontFamily: AssetStrings.lotoRegularStyle,
                                    ),
                                  ),
                                )
                              : Container(),
                          new SizedBox(
                            height: 40.0,
                          ),
                          (isCurrentUser(widget.userId))
                              ? editProfileButton()
                              : Container(),
                          (isCurrentUser(widget.userId))
                              ? new SizedBox(
                                  height: 40.0,
                                )
                              : new SizedBox(height: 20.0),
                          (isCurrentUser(widget.userId))
                              ? videoLinkView(
                                  "Connect account for quick video links",
                                )
                              : Container(),
                          (!isCurrentUser(widget.userId))
                              ? inviteUser()
                              : Container(),
                          new SizedBox(
                            height: 40.0,
                          ),
                          new Container(
                            height: 1.0,
                            color: AppColors.dividerColor,
                          ),
                          new SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: topViewHeight.toDouble() - 45,
                    bottom: DecoratedTabBar(
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.dividerColor,
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
                              icon: new Icon(Icons.account_circle,
                                  size: 20.0,
                                  color: tabBarController.index == 0
                                      ? AppColors.kPrimaryBlue
                                      : Colors.black87),
                            ),
                            new Tab(
                              text: "Credits",
                              icon: new Icon(Icons.assignment,
                                  size: 20.0,
                                  color: tabBarController.index == 1
                                      ? AppColors.kPrimaryBlue
                                      : Colors.black87),
                            ),
                          ]),
                    ),
                  )
                ];
              },
              body:

//                IndexedStack(
//        index: _tabIndex,
//        children: <Widget>[
//          Navigator(
//            key: _profileScreen,
//            onGenerateRoute: (route) =>
//                MaterialPageRoute(
//                  settings: route,
//                  builder: (context) =>
//                  new FirstTabProfile(
//                    callBackUpdateRoles,
//                    widget.fullScreenWidget,
//                    widget.userId,
//                    key: _profileFirstTab,),
//
//                ),
//          ),
//          Navigator(
//            key: _creditsScreen,
//            onGenerateRoute: (route) =>
//                MaterialPageRoute(
//                  settings: route,
//                  builder: (context) =>
//                  new CreditTabProfile(
//                      widget.userId,
//                      widget.fullScreenWidget,
//                      response: responseProfile),
//                ),
//          ),
//        ],)

                  Container(
                child: new TabBarView(
                  controller: tabBarController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    new FirstTabProfile(
                      callBackUpdateRoles,
                      widget.fullScreenWidget,
                      widget.userId,
                      key: _profileFirstTab,
                    ),
                    new CreditTabProfile(widget.userId, widget.fullScreenWidget,
                        response: responseProfile),
                  ],
                ),
              ),
            ),

            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            //for only other user profile screen
            //if user comes from search screen hide it
            getBackButton(
                widget.userId, context, !(widget.fromSearchScreen ?? false))
          ],
        ),
      ),
    );
  }

  Widget editProfileButton() {
    return Container(
      height: 50.0,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(0.2),
            blurRadius: 2.0,
            // has the effect of softening the shadow
            spreadRadius: 2.0,
            // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      child: Material(
        child: Ink(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.kPrimaryBlue.withOpacity(0.2),
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
              splashColor: AppColors.kPrimaryBlue.withOpacity(0.3),
              onTap: () {
                widget.fullScreenWidget(
                    new EditProfile(callback, null, responseProfile));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SvgPicture.asset(
                    AssetStrings.personMyProfile,
                    color: Colors.white,
                    width: 18.0,
                    height: 18.0,
                  ),
                  new SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Edit profile",
                      style: AppCustomTheme.button,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget inviteUser() {
    return new Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            sendInviteBottomSheet();
          },
          child: Container(
            margin: new EdgeInsets.only(top: 15.0),
            child: inviteUserAttributeHeading("Invite to a project",
                Icons.add_circle, AppColors.creatreProfileBordercolor),
          ),
        ),
        Container(
          margin: new EdgeInsets.only(top: 15.0),
          child: InkWell(
            onTap: () {
              //to check user data loaded or not
              if (_userName != null) {
                var _currentUserName;
                var _currentUserProfilePic;
                var userData = MemoryManagement.getUserData();
                if (userData != null) {
                  Map<String, dynamic> data = jsonDecode(userData);
                  LoginResponse userResponse = LoginResponse.fromJson(data);
                  _currentUserName = userResponse.user.fullName ?? "";
                  _currentUserProfilePic = userResponse.user.thumbnailUrl ?? "";
                }
                var currentUserId = MemoryManagement.getuserId();
                var screen = PrivateChat(
                  peerId: widget.userId,
                  peerAvatar: _profilePic,
                  userName: _userName,
                  isGroup: false,
                  currentUserId: currentUserId,
                  currentUserName: _currentUserName ?? "",
                  currentUserProfilePic: _currentUserProfilePic ?? "",
                  bio: _bio,
                  isOnline: _isOnline,
                );
                //move to private chat screen
                Navigator.push<String>(
                  context,
                  new CupertinoPageRoute(builder: (BuildContext context) {
                    return screen;
                  }),
                );
              }
            },
            child: inviteUserAttributeHeading("Send a message", Icons.message,
                AppColors.creatreProfileBordercolor),
          ),
        ),
        InkWell(
          onTap: () {
            hitFollowUnfollowApi(int.parse(widget.userId), type);
          },
          child: Container(
            margin: new EdgeInsets.only(top: 15.0),
            child: inviteUserAttributeHeading(
                "$followUnfollow ${_userName ?? ""}",
                FontAwesomeIcons.solidUser,
                AppColors.creatreProfileBordercolor),
          ),
        ),
      ],
    );
  }

  hitFollowUnfollowApi(int id, int types) async {
    provider.setLoading();

    print("types $types");
    var response = await providers.followUser(context, id, types);

    provider.hideLoader();

    if (response != null && (response is FollowResponse)) {
      if (type == 0) {
        type = 1;
        followUnfollow = "Follow";
      } else {
        type = 0;
        followUnfollow = "Unfollow";
      }

      setState(() {});
    } else {
      APIError apiError = response;
      print(apiError.error);
      /* showAlert(
        context: context,
        titleText: "ERROR",
        message: "Failed! Try Again.",
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar("Failed! Try Again.");
    }
  }

  void sendInviteBottomSheet() async {
    await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height - 30,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: InviteProjectBottomSheet(responseProfile?.fullName ?? "",
                  responseProfile?.id?.toString()),
            ),
          );
        });
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class YoutubeVimeoButton extends StatelessWidget {
  final String youtubeToken;
  final String vimeoToken;
  final String iconImage;
  final String text;
  final buttonType;

  YoutubeVimeoButton(
      {@required this.youtubeToken,
      @required this.vimeoToken,
      @required this.iconImage,
      @required this.text,
      @required this.buttonType});

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: (buttonType == 1 && youtubeToken != null)
                ? Colors.red.withOpacity(0.6)
                : (buttonType == 2 && vimeoToken != null)
                    ? Colors.blue.withOpacity(0.6)
                    : Colors.grey.withOpacity(0.6),
            width: INPUT_BOX_BORDER_WIDTH),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Image.asset(
            iconImage,
            width: 20.0,
            height: 20.0,
            color: (buttonType == 1 && youtubeToken != null)
                ? Colors.red
                : (buttonType == 2 && vimeoToken != null)
                    ? Colors.blue
                    : Colors.black,
          ),
          new SizedBox(
            width: 12.0,
          ),
          new Text(
            text,
            style: AppCustomTheme.createAccountLink,
          ),
        ],
      ),
    );
  }
}
