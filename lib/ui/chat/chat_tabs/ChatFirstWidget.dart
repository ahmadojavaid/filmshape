import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/ChatList/Chat/private_chat.dart';
import 'package:Filmshape/ui/invite_request/project_sent_request_details.dart';
import 'package:Filmshape/ui/statelesswidgets/empty_widget.dart';
import 'package:Filmshape/ui/statelesswidgets/role_stack_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ActiveTabs extends StatefulWidget
{
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<int> countCallBack;

  ActiveTabs(
      {@required this.fullScreenWidget, @required this.countCallBack, Key key})
      : super(key: key);

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<ActiveTabs>
    with AutomaticKeepAliveClientMixin<ActiveTabs> {
  FirebaseProvider firebaseProvider;
  String userId;
  var _firstTimeChatUser = true;

  @override
  void initState() {
    super.initState();
    userId = MemoryManagement.getuserId();
    Future.delayed(const Duration(milliseconds: 100), () {
      _hitApi();
      // checkNewGroup(userId: userId);
      checkNewUser(userId: userId);
    });
  }

  void _hitApi() async {
//    firebaseProvider.setLoading();
//    chatAndGroupUserList = (firebaseProvider.userList.length == 0)
//        ? await firebaseProvider.getUserChatAndGroups(userId: userId)
//        : firebaseProvider.userList;
//  //  sortList();
//    firebaseProvider.hideLoader();
    (firebaseProvider.myFriendsIdList.length == 0)
        ? await firebaseProvider.getFriends(userId: userId)
        : firebaseProvider.myFriendsIdList;

    setState(() {});
  }

  void _moveToPrivateChatScreen(FilmShapeFirebaseUser filmShapeFirebaseUser) {
    var currentUserId = MemoryManagement.getuserId();
    var _userName;
    var _userProfilePic;
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      _userName = userResponse.user.fullName ?? "";
      _userProfilePic = userResponse.user.thumbnailUrl ?? "";
    }
    var screen = PrivateChat(
      peerId: filmShapeFirebaseUser.filmShapeId.toString(),
      peerAvatar: filmShapeFirebaseUser.thumbnailUrl,
      userName: filmShapeFirebaseUser.fullName,
      isGroup: false,
      currentUserId: currentUserId,
      currentUserName: _userName,
      currentUserProfilePic: _userProfilePic,
    );
    //move to private chat screen
    widget.fullScreenWidget(screen);
  }

  VoidCallback refreshList() {}

  Widget _buildContestList() {
    return StreamBuilder<List<FilmShapeFirebaseUser>>(
        stream: firebaseProvider.getActiveFriends(
            userIds:  firebaseProvider.myFriendsIdList),
        builder: (context, AsyncSnapshot<List<FilmShapeFirebaseUser>> result) {
          if (result.hasData) {
            if (result.data.length == 0) {
              return _getEmptyWidget;
            }
            widget.countCallBack(result.data.length);
            return Expanded(
              child: Container(
                child: new ListView.builder(
                  padding: new EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index) {
                    var data = result.data[index];
                    return InkWell(
                        onTap: () {
                          _moveToPrivateChatScreen(data);
                        },
                        child: ActiveItem(data));
                  },
                  itemCount: result.data.length,
                ),
              ),
            );
          } else {
            return _getEmptyWidget;
          }
        });
  }
  get _getEmptyWidget
  {
    return Expanded(
      child: EmptyWidget(
        message: "No Active users",
        callback: refreshList,
        isEnabled: false,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    return new Column(
      children: <Widget>[
        _buildContestList(),
        new SizedBox(
          height: 5.0,
        ),
      ],
    );
  }

  Widget videoLinkViewBottomSheet(String text) {
    return InkWell(
      onTap: () {},
      child: new Container(
        margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border:
              new Border.all(color: Colors.grey.withOpacity(0.3), width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              text,
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: AssetStrings.lotoRegularStyle),
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

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void checkNewUser({@required String userId}) {
    var firestore = Firestore.instance
        .collection("chatfriends")
        .document(userId)
        .collection("friends")
        .orderBy('lastMessageTime', descending: true)
        .snapshots();

    //get the data and convert to list
    firestore.listen((QuerySnapshot snapshot) {
      print("new chat");
      if (!_firstTimeChatUser) {
        checkForNewUserOrLatestMessage(snapshot.documents[0]);
      } else {
        _firstTimeChatUser = false;
      }
    });
  }

  void checkForNewUserOrLatestMessage(DocumentSnapshot documentSnapshot) {
    var chatUser = ChatUser.fromMap(documentSnapshot.data);
    print("new chat user ${chatUser.toJson()}");
    if (firebaseProvider.userList.isNotEmpty) {
      var isOldUser = false;
      for (var data in firebaseProvider.userList) {
        if (data is ChatUser) {
          if (data.userId == chatUser.userId) {
            isOldUser = true;
            print("new_msg ${chatUser.lastMessage}");
            break;
          }
        }
      }
      if (!isOldUser) {
        firebaseProvider.myFriendsIdList.add(int.parse(chatUser.userId));
        setState(() {});
      }
    } else {
      firebaseProvider.myFriendsIdList.add(int.parse(chatUser.userId));
      setState(() {});
    }


  }

}

class ActiveItem extends StatelessWidget {
  final FilmShapeFirebaseUser filmShapeFirebaseUser;

  ActiveItem(this.filmShapeFirebaseUser);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Card(
        elevation: 1.2,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            children: <Widget>[
              Container(
                child: IntrinsicHeight(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          new Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.black, width: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: getCachedNetworkImage(
                                    url:
                                        "${APIs.imageBaseUrl}${filmShapeFirebaseUser.thumbnailUrl}",
                                    fit: BoxFit.cover),
                              )),
                          Positioned(
                            bottom: 0.0,
                            right: 0.0,
                            child: new Container(
                              width: 13.0,
                              height: 13.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      (filmShapeFirebaseUser.isOnline ?? false)
                                          ? Colors.greenAccent
                                          : Colors.grey,
                                  border: new Border.all(
                                      color: Colors.white, width: 1.3)),
                            ),
                          )
                        ],
                      ),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                filmShapeFirebaseUser.fullName ?? "",
                                style: AppCustomTheme.suggestedFriendNameStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              new SizedBox(
                                height: 2.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: new EdgeInsets.only(right: 35.0),
                                  child: new Text(
                                    filmShapeFirebaseUser.bio ?? "",
                                    style: AppCustomTheme
                                        .suggestedFriendMyReelStyle,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  margin: new EdgeInsets.only(top: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ((filmShapeFirebaseUser.roles?.length ?? 0) > 0)
                          ? Container(
                              height: 36,
                              child: RoleStackWidget(
                                  roles: List<String>.from(
                                      filmShapeFirebaseUser.roles),
                                  type: LOADROLEICONFROM.SERVER,
                                  size: 36))
                          : Container(),
                      Expanded(
                        child: new SizedBox(
                          width: 5.0,
                        ),
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

}
