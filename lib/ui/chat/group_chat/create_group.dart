import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Model/followfollowing/followingfollowersresponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/suggestion_notifier.dart';
import 'package:Filmshape/ui/statelesswidgets/user_profile_with_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  List<int> groupUserList;
  String groupId;

  CreateGroup({this.groupUserList, this.groupId});

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<DataModel> list = new List();

  bool itemValue = false;

  SuggestionProvider provider;
  FirebaseProvider firebaseProvider;

  List<FollowFollowingUser> listHorizontal = new List();
  List<FollowFollowingUser> dataList = new List();
  List<FollowFollowingUser> mainList = new List();

  int _page = 1;
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  @override
  void initState() {
    dataList = new List();
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitApi();
      //update header
    });

    _setScrollListener();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  //update group
  void _addMemberToGroup(String groupId) async {
    var groupMembers = List<FilmShapeFirebaseGroupMember>();
    var groupMembersId = List<int>();
    //add previous group ids
    if (widget.groupUserList != null) {
      groupMembersId.addAll(widget.groupUserList); //add previous group ids
    }
    var group = FilmShapeFirebaseGroup();
    for (var user in listHorizontal) {
      var member = FilmShapeFirebaseGroupMember(
          isAdmin: false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          isBlocked: false,
          userId: user.id.toString());
      groupMembers.add(member); //add other group member in list
      groupMembersId.add(user.id); //save user id
    }
    group.groupMembersId = groupMembersId;
    group.groupTotalMembers = groupMembersId.length;

    if (groupMembers.length >= 1) {
      firebaseProvider.setLoading();
      await firebaseProvider.addNewMembersToGroup(
          filmShapeFirebaseGroup: group,
          members: groupMembers,
          groupId: groupId);
      showInSnackBar("New members added successfully");
      Navigator.pop(context, listHorizontal); //go back to previous screen
    } else {
      showInSnackBar("Please select the users");
    }
  }

  void _createGroup() async {
    var userId = MemoryManagement.getuserId();
    var group = FilmShapeFirebaseGroup(
        groupName: "test",
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        createdBy: userId,
        groupId: "",
        groupThumbnail: "",
        groupTotalMembers: listHorizontal.length + 1); //+1 including admin too
    var groupMembers = List<FilmShapeFirebaseGroupMember>();
    var groupMembersId = List<int>();
    var admin = FilmShapeFirebaseGroupMember(
        isAdmin: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isBlocked: false,
        userId: userId);
    groupMembersId.add(int.parse(userId)); //add admin to group list
    groupMembers.add(admin); //add admin to list
    for (var user in listHorizontal) {
      var member = FilmShapeFirebaseGroupMember(
          isAdmin: false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          isBlocked: false,
          userId: user.id.toString());
      groupMembers.add(member); //add other group member in list
      groupMembersId.add(user.id); //save user id
    }
    group.groupMembersId = groupMembersId;
    group.lastMessage = "group created";
    group.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    if (groupMembers.length > 1) {
      firebaseProvider.setLoading();
      await firebaseProvider.createGroup(group, groupMembers);
      showInSnackBar("Group created successfully");
      Navigator.pop(context); //go back to previous screen
    } else {
      showInSnackBar("Please select the users");
    }
  }

  Widget _bottomSheetTop() {
    return new Container(
        margin: new EdgeInsets.only(
            left: BOTTOMSHEET_MARGIN_LEFT_RIGHT, right: 30, top: 20.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Icon(Icons.arrow_back)),
              Container(
                margin: new EdgeInsets.only(left: 10.0),
                child: new Text(
                  "Add recipient(s)",
                  style: new TextStyle(
                      color: Colors.black,
                      fontFamily: AssetStrings.lotoRegularStyle,
                      fontSize: 18.0),
                ),
              ),
              Expanded(
                child: new SizedBox(
                  width: 55.0,
                ),
              ),
              InkWell(
                onTap: () {
                  //only when user is selected
                  (listHorizontal.length > 0 && widget.groupUserList == null)
                      ? _createGroup()
                      : _addMemberToGroup(widget.groupId);
                },
                child: Container(
                  margin: new EdgeInsets.only(left: 10.0),
                  child: new Text(
                    "Next",
                    style: (listHorizontal.length > 0)
                        ? new TextStyle(
                            color: Colors.black,
                            fontFamily: AssetStrings.lotoBoldStyle,
                            fontSize: 15.0)
                        : new TextStyle(
                            color: Colors.grey,
                            fontFamily: AssetStrings.lotoBoldStyle,
                            fontSize: 15.0),
                  ),
                ),
              ),
            ]));
  }

  Iterable<Widget> get actorWidgets sync* {
    for (FollowFollowingUser data in dataList) {
      yield buildItem(data);
    }
  }

  Widget buildItem(FollowFollowingUser data) {
    return InkWell(
      onTap: () {
        data.isSelect = !data.isSelect;

        if (data.isSelect) {
          listHorizontal.add(data);
        } else {
          removeData(data);
        }

        setState(() {});
      },
      child: Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: Stack(children: <Widget>[
          Column(children: <Widget>[
            Container(
              child: IntrinsicHeight(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UserProfileWithIndicator(
                      profilePic: data.thumbnailUrl,
                      isOnline: data.isOnline,
                    ),
                    new SizedBox(
                      width: 10.0,
                    ),
                    nameBio(data),
                    checkBox(data),
                  ],
                ),
              ),
            )
          ]),
        ]),
      ),
    );
  }

  Widget checkBox(FollowFollowingUser data) {
    return Container(
      margin: new EdgeInsets.only(top: 5),
      child: Transform.scale(
        scale: 0.8,
        child: Container(
          child: Transform.scale(
            scale: 0.8,
            child: Container(
                child: data.isSelect
                    ? SvgPicture.asset(
                        AssetStrings.checkBoxCheck,
                      )
                    : SvgPicture.asset(
                        AssetStrings.checkBoxUnCheck,
                      )),
          ),
        ),
      ),
    );
  }

  Widget nameBio(FollowFollowingUser data) {
    return Expanded(
      child: Container(
        padding: new EdgeInsets.symmetric(vertical: 3.0, horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "${data?.fullName ?? ""}",
              style: AppCustomTheme.chatUserNameStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            new SizedBox(
              height: 5.0,
            ),
            Expanded(
              child: Container(
                padding: new EdgeInsets.only(right: 35.0),
                child: new Text(
                  "${data?.bio ?? ""}",
                  style: new TextStyle(
                      color: AppColors.kChatDEsc,
                      fontFamily: AssetStrings.lotoRegularStyle,
                      fontSize: 13.0),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  hitApi() async {
    var userId = MemoryManagement.getuserId();
    if (!isPullToRefresh) {
      provider.setLoading();
    }

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }

    var response = await provider.followerFollowing(context, userId, 0, _page);

    if (response is FollowersFollowingReponse) {
      if (_page == 1) {
        dataList.clear();
      }

      if (response.followingFollowers != null &&
          response.followingFollowers.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }

      if (response.followingFollowers != null &&
          response.followingFollowers.length > 0) {
        for (FollowFollowingUser data in response.followingFollowers) {
          if (data.isFollowing == null) {
            data.isFollowing = false;
          }
          if (data.isSelect == null) {
            data.isSelect = false;
          }
        }
      }
      if (widget.groupUserList != null) {
        for (var user in response.followingFollowers) {
          if (!widget.groupUserList.contains(user.id)) {
            dataList.add(user);
            mainList.add(user);
          }
        }
      } else {
        dataList.addAll(response.followingFollowers);
        mainList.addAll(response.followingFollowers);
      }

      setState(() {});
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }

  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (dataList.length >= (PAGINATION_SIZE * _page) && _loadMore) {
          isPullToRefresh = true;
          hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  void removeData(FollowFollowingUser data) {
    for (var localData in dataList) {
      if (data.id.toString() == localData.id.toString()) {
        listHorizontal.remove(data);

        localData.isSelect = false;
      }
    }

    setState(() {});
  }

  Widget buildItemHorizontal(FollowFollowingUser data) {
    return Container(
      child: Container(
        margin: new EdgeInsets.only(right: 20.0),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          removeData(data);
                        },
                        child: UserProfileWithIndicator(
                          profilePic: data.thumbnailUrl,
                          isOnline: data.isOnline,
                        ),
                      ),
                      Positioned(
                        top: 0.0,
                        right: 0.0,
                        child: InkWell(
                          onTap: () {
                            removeData(data);
                          },
                          child: new Container(
                            width: 15.0,
                            height: 15.0,
                            alignment: Alignment.center,
                            child: Container(
                                child: new Icon(
                              Icons.clear,
                              size: 11.0,
                            )),
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.grey,
                                border: new Border.all(
                                    color: AppColors.gray_tab.withOpacity(0.2),
                                    width: 1.2)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  margin: new EdgeInsets.only(top: 5.0),
                  child: new Text(
                    "${data?.fullName ?? ""}",
                    style: AppCustomTheme.chatUserNameStyle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  onSearchTextChanged(String text) async {
    dataList.clear();
    if (text.trim().length > 0) {
      for (var data in mainList) {
        if (data.fullName.toLowerCase().contains(text.toLowerCase())) {
          dataList.add(data);
        }
      }
    } else {
      dataList.addAll(mainList);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SuggestionProvider>(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  _bottomSheetTop(),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Container(
                    height: 40.0,
                    margin: new EdgeInsets.only(left: 30.0, right: 30.0),
                    child: new Container(
                      padding: new EdgeInsets.only(left: 5.0),
                      decoration: new BoxDecoration(
                          color: AppColors.seacrhBackground,
                          borderRadius: new BorderRadius.circular(25.0)),
                      child: new TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        style: new TextStyle(
                            color: AppColors.kHomeBlack,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 14.0),
                        decoration: new InputDecoration(
                          fillColor: Colors.green,
                          border: InputBorder.none,
                          prefixIcon: new Padding(
                              padding: new EdgeInsets.only(top: 2.0),
                              child: new Icon(
                                Icons.search,
                                color: AppColors.seacrhIcon,
                                size: 21.0,
                              )),
                          contentPadding:
                          new EdgeInsets.only(bottom: 2.0, top: 6.0),
                          hintText: "Search",
                          hintStyle: new TextStyle(
                              color: AppColors.kHomeBlack,
                              fontFamily: AssetStrings.lotoRegularStyle,
                              fontSize: 14.0),
                        ),
                        onChanged: (String text) {
                          print(text);
                          onSearchTextChanged(text);
                        },
                      ),
                    ),
                  ),
                  Offstage(
                    offstage:
                        listHorizontal != null && listHorizontal.length > 0
                            ? false
                            : true,
                    child: Container(
                      height: 60.0,
                      margin: new EdgeInsets.only(
                          left: BOTTOMSHEET_MARGIN_LEFT_RIGHT, top: 20.0),
                      child: new ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return buildItemHorizontal(listHorizontal[index]);
                          },
                          itemCount: listHorizontal.length),
                    ),
                  ),
                  Offstage(
                    offstage:
                        dataList != null && dataList.length > 0 ? false : true,
                    child: Container(
                      padding: new EdgeInsets.only(top: 15.0, left: 30.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "Friends",
                        style: new TextStyle(
                            color: Colors.black54,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 15.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () async {
                          isPullToRefresh = true;
                          _loadMore = false;
                          await hitApi();
                        },
                        child: Container(
                          color: Colors.white,
                          margin: new EdgeInsets.only(
                              left: BOTTOMSHEET_MARGIN_LEFT_RIGHT,
                              right: 30,
                              top: 10.0),
                          child: new ListView.builder(
                              controller: scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return buildItem(dataList[index]);
                              },
                              itemCount: dataList.length),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          (dataList.length == 0)
              ? new Center(child: getNoData("No data found"))
              : Container(),
          new Center(
            child: getHalfScreenProviderLoader(
              status: (provider.getLoading() || firebaseProvider.getLoading()),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
