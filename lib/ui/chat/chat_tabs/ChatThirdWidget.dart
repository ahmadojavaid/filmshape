import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/myprojects/my_project_filter.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/ChatList/Chat/group_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProjectTabs extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<int> countCallBack;

  ProjectTabs({@required this.fullScreenWidget, this.countCallBack, Key key})
      : super(key: key);

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<ProjectTabs>
    with AutomaticKeepAliveClientMixin<ProjectTabs> {
  List<ProjectData> dataList = new List();

  JoinProjectProvider provider;

  int _page = 1;
  int dataStatus = 0;
  int position = 0;

  bool offstagenodata = true;
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  HomeListProvider providers;
  FirebaseProvider firebaseProvider;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitApi();
    });
    _setScrollListener();


  }

  hitApi() async {
    var userId = MemoryManagement.getuserId();
    var filter =
        new MyProjectFilters(creator: CreatorInfo(type: "User", id: userId));

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }
    if (provider.myProjectList.length != 0 && _page == 1) {
      dataList.addAll(provider.myProjectList);
      setState(() {});
    } else {
      if (!isPullToRefresh) {
        provider.setLoading();
      }
      var response = await provider.searchForMyProjects(filter, context, _page);

      if (response is APIError) {
        showInSnackBar(response.error);
        dataStatus = 1;
      } else if (response is MyProjectResponse) {
        print("my_project${response.listData.length}");

        if (_page == 1) {
          dataList.clear();
        }

        if (response.listData != null &&
            response.listData.length < PAGINATION_SIZE) {
          _loadMore = false;
        } else {
          _loadMore = true;
        }

        dataList.addAll(response.listData);

        //check if user liked the post
        for (var item in dataList) {
          if (item.likedBy != null && item.likedBy?.length > 0) {
            var like = checkLikeUserId(item.likedBy);
            item?.isLike = like;
          }
        }
        _checkEmptyScreen();
      }
    }
    //update projects counter in tab
    widget.countCallBack(dataList.length);
  }

  void _checkEmptyScreen() {
    //check data
    if (dataList.length == 0) {
      dataStatus = 1;
    } else {
      dataStatus = 0;
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

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  /*_buildContestList() {
    return Expanded(
      child: Container(
        child: new ListView.builder(
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            return buildItem(dataList[index],index);
          },
          itemCount: dataList.length,
        ),
      ),
    );
  }
*/

  _buildContestList() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () async {
          isPullToRefresh = true;
          _loadMore = false;
          await hitApi();
        },
        child: Container(
          child: new ListView.builder(
            padding: new EdgeInsets.all(0.0),
            controller: scrollController,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var projectData = dataList[index];
              return InkWell(
                  onTap: () {
                    position = index;

                    _checkGroupExistAlready(projectData);
                  },
                  child: buildItem(projectData, index));
            },
            itemCount: dataList.length,
          ),
        ),
      ),
    );
  }

  void _checkGroupExistAlready(ProjectData projectData) async {
    firebaseProvider.setLoading();
    var oldGroup = await firebaseProvider
        .getGroup(getProjectGroupId(projectData.id.toString()));
    if (oldGroup is FilmShapeFirebaseGroup) {
      _moveToGroupChatScreen(oldGroup, projectData);
    } else {
      _createGroup(projectData);
    }
  }

  void _getGroup(ProjectData projectData) async {
    firebaseProvider.setLoading();
    var groupId = getProjectGroupId(projectData.id.toString());
    var oldGroup = await firebaseProvider.getGroup(groupId);
    if (oldGroup is FilmShapeFirebaseGroup) {
      await firebaseProvider.getGroupFriends(
          userIds: oldGroup.groupMembersId, groupId: groupId);
      _moveToGroupChatScreen(oldGroup, projectData);
    } else {
      showInSnackBar("No group found for given id");
    }
  }

  void _moveToGroupChatScreen(
      FilmShapeFirebaseGroup firebaseGroup, ProjectData projectData) {
    var _userName;
    var _userProfilePic;
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      _userName = userResponse.user.fullName ?? "";
      _userProfilePic = userResponse.user.thumbnailUrl ?? "";
    }
    var currentUserId = MemoryManagement.getuserId();
    var screen = GroupChat(
      filmShapeFirebaseGroup: firebaseGroup,
      currentUserId: currentUserId,
      currentUserName: _userName ?? "",
      currentUserProfilePic: _userProfilePic ?? "",
      projectData: projectData,
    );
    //move to private chat screen
    widget.fullScreenWidget(screen);
  }

  void _createGroup(ProjectData projectData) async {
    var userId = MemoryManagement.getuserId();
    var group = FilmShapeFirebaseGroup(
      groupName: "test",
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      createdBy: userId,
      groupId: "",
      groupThumbnail: "",
    );
    var groupMembers = List<FilmShapeFirebaseGroupMember>();
    var groupMembersId = List<int>();
    var admin = FilmShapeFirebaseGroupMember(
        isAdmin: true,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
        isBlocked: false,
        userId: userId);
    groupMembersId.add(int.parse(userId));
    groupMembers.add(admin); //add admin to list
    for (var user in projectData.team) {
      //because creator already in the list
      if (user.id.toString() == userId) {
        continue;
      }
      var member = FilmShapeFirebaseGroupMember(
          isAdmin: false,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
          isBlocked: false,
          userId: user.id.toString());
      groupMembers.add(member); //add other group member in list
      groupMembersId.add(user.id); //save user id
    }
    group.groupTotalMembers = groupMembersId.length;
    group.groupMembersId = groupMembersId;
    group.lastMessage = "group created";
    group.lastMessageTime = DateTime.now().millisecondsSinceEpoch;
    if (groupMembers.length >= 1) {
      firebaseProvider.setLoading();
      await firebaseProvider.createGroupProject(
          group, groupMembers, getProjectGroupId((projectData.id.toString())));
      showInSnackBar("Group created successfully");
      _getGroup(projectData); //move to chat screen
    } else {
      showInSnackBar("No Team members found!");
    }
  }

  Future<bool> likeUnlikeApi(int id, int type, int index) async {
    /*  provider.setLoading();*/
    var response =
        await providers.likeUnlikeProjectFeed(context, id, type, "Project");

    if (response is LikesResponse) {
      dataList[index].likedBy.length = response.likes;
      dataList[index].isLike = !dataList[index].isLike;
    }

    provider.hideLoader();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<JoinProjectProvider>(context);
    providers = Provider.of<HomeListProvider>(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Container(
      child: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: getScreenSize(context: context).height / 1.6,
              child: new Column(
                children: <Widget>[_buildContestList()],
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: (provider.getLoading() || firebaseProvider.getLoading()),
              context: context,
            ),
          ),
          (dataStatus == 1) ? getEmptyView("No projects found") : Container(),
        ],
      ),
    );
  }

  Widget buildItem(ProjectData projectData, int index) {
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
                  ]..add(

                    teamList != null && teamList.length > 0 ? Expanded(
                        child: Container(child: getSvgNetworkCacheImage(
                            teamList, 36, noOfShowing: 8))) : Expanded(
                        child: new Container()),
                  )
                    ..add(
                      Container(
                        padding: new EdgeInsets.only(bottom: 5.0),
                        margin: new EdgeInsets.only(left: 25.0),
                        child: InkWell(
                          onTap: () {
                            if (projectData != null) {
                              int type = projectData.isLike != null &&
                                      projectData.isLike
                                  ? 0
                                  : 1;
                              likeUnlikeApi(projectData.id, type, index);
                            }
                          },
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
                      color: AppColors.chatCReateUserProject,
                      fontSize: 16.0,
                      fontFamily: AssetStrings.lotoBoldStyle),
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
                  style: new TextStyle(color: AppColors.chatCReateUserProject,
                      fontSize: 14.0,
                      fontFamily: AssetStrings.lotoRegularStyle),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
