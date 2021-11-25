import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/firebase_constant.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/ChatList/Chat/group_chat.dart';
import 'package:Filmshape/ui/ChatList/Chat/private_chat.dart';
import 'package:Filmshape/ui/chat/ChatUserWidget.dart';
import 'package:Filmshape/ui/statelesswidgets/empty_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../ChatGroupWidget.dart';

class MessageTabs extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<int> countCallBack;

  MessageTabs(
      {@required this.fullScreenWidget, @required this.countCallBack, Key key})
      : super(key: key);

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MessageTabs>
    with AutomaticKeepAliveClientMixin<MessageTabs> {
  FirebaseProvider firebaseProvider;
  int userId;

  //to avoid listener first time call
  var _firstTimeGroup = true;
  var _firstTimeChatUser = true;
  var _userProfilePic;
  var _userName;

  @override
  void initState() {
    super.initState();
    setData();
    userId = int.parse(MemoryManagement.getuserId() ?? "0");
    Future.delayed(const Duration(milliseconds: 50), () {
      //_hitApi();
      checkNewGroup(userId: userId);
      checkNewUser(userId: userId);
    });
  }

  void setData() {
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      _userName = userResponse.user.fullName ?? "";
      _userProfilePic = userResponse.user.thumbnailUrl ?? "";
    }
  }

  void _hitApi() async {
    firebaseProvider.setLoading();
      if(firebaseProvider.userList.length == 0)
  await firebaseProvider.getUserChatAndGroups(userId: userId);

    sortList();
    firebaseProvider.hideLoader();
    _unreadMessageCount();
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

    setState(() {});
  }

  void _moveToPrivateChatScreen(ChatUser chatUser) {
    var currentUserId = MemoryManagement.getuserId();
    var screen = PrivateChat(
      peerId: chatUser.userId,
      peerAvatar: chatUser.profilePic,
      userName: chatUser.username,
      isGroup: false,
      currentUserId: currentUserId,
      currentUserName: _userName,
      currentUserProfilePic: _userProfilePic,
    );
    //move to private chat screen
    widget.fullScreenWidget(screen);
  }

  void _moveToGroupChatScreen(FilmShapeFirebaseGroup firebaseGroup) {
    var currentUserId = MemoryManagement.getuserId();
    var screen = GroupChat(
      filmShapeFirebaseGroup: firebaseGroup,
      currentUserId: currentUserId,
      currentUserName: _userName,
      currentUserProfilePic: _userProfilePic,
    );
    //move to private chat screen
    widget.fullScreenWidget(screen);
  }

  VoidCallback refreshList() {}

//
//  Widget _buildContestList() {
//    return StreamBuilder<List<ChatUser>>(
//        stream: firebaseProvider.getChatFriends(userId: userId.toString()),
//        builder: (context, AsyncSnapshot<List<ChatUser>> result) {
//          if (result.hasData) {
//            if (result.data.length == 0) {
//              return EmptyWidget(
//                message: "No Active user yet",
//                callback: refreshList,
//                isEnabled: false,
//              );
//            }
//
//            return Expanded(
//              child: Container(
//                child: new ListView.builder(
//                  padding: new EdgeInsets.all(0.0),
//                  itemBuilder: (BuildContext context, int index) {
//                    return InkWell(
//                        onTap: () {
//                          _moveToPrivateChatScreen(result.data[index]);
//                        },
//                        child: ChatUserWidget(result.data[index]));
//                  },
//                  itemCount: result.data.length,
//                ),
//              ),
//            );
//          } else {
//            return EmptyWidget(
//              message: "No Active user yet",
//              callback: refreshList,
//              isEnabled: false,
//            );
//          }
//        });
//  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    return new Stack(
      children: <Widget>[
        // _buildContestList(),

        Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: new ListView.builder(
                padding: new EdgeInsets.all(0.0),
                itemBuilder: (BuildContext context, int index) {
                  var data = firebaseProvider.userList[index];
                  return (data is ChatUser)
                      ? InkWell(
                          onTap: () {
                            _moveToPrivateChatScreen(data);
                          },
                          child: ChatUserWidget(data))
                      : InkWell(
                          onTap: () {
                            _moveToGroupChatScreen(data);
                          },
                          child: ChatGroupWidget(data));
                },
                itemCount: firebaseProvider.userList.length,
              ),
            ),
            SizedBox(height: 10,)
          ],
        ),
        (firebaseProvider.userList.length == 0) ? _getEmptyWidget : Container(),
        new Center(
          child: getHalfScreenProviderLoader(
            status: firebaseProvider.getLoading(),
            context: context,
          ),
        ),
      ],
    );
  }

  get _getEmptyWidget {
    return EmptyWidget(
      message: "No Messages",
      callback: refreshList,
      isEnabled: false,
    );
  }

  Widget buildItem(int index) {
    return InkWell(
        onTap: () {},
        child: Container(
          child: Container(
            margin: new EdgeInsets.only(top: 15.0, left: 25.0, right: 25.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      child: IntrinsicHeight(
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                new Container(
                                    width: 38.0,
                                    height: 38.0,
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.black, width: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: getCachedNetworkImage(
                                          url:
                                              "file:///home/avinash/Downloads/savour%20apps%20images%20and%20icons/image1.png",
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
                                        color: Colors.greenAccent,
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
                                      "Aaron Klein",
                                      style: new TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    new SizedBox(
                                      height: 5.0,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          "Beautiful! can't wait for your next masterpiece checked it",
                                          style: new TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12.0),
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
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void checkNewUser({@required int userId}) {
    var firestore = Firestore.instance
        .collection("chatfriends")
        .document(userId.toString())
        .collection("friends")
        .orderBy('updatedAt', descending: true)
        .limit(1)
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

  void checkNewGroup({@required int userId}) {
    var firestore = Firestore.instance
        .collection(GROUPS)
        //.where('groupMembersId', arrayContains: int.parse(userId))
        .orderBy('lastMessageTime', descending: true)
        .limit(1)
        .snapshots();

    //get the data and convert to list
    firestore.listen((QuerySnapshot snapshot) {
      print("new group");
      if (!_firstTimeGroup) {
        checkForNewGroupOrLatestMessage(snapshot.documents[0]);
      } else {
        _firstTimeGroup = false;
      }
    });
  }

  void checkForNewGroupOrLatestMessage(DocumentSnapshot documentSnapshot) {
    var firebaseGroup = FilmShapeFirebaseGroup.fromJson(documentSnapshot.data);
    print("new group ${firebaseGroup.toJson()}");

      var isOldGroup = false;
      for (var data in firebaseProvider.userList) {
        if (data is FilmShapeFirebaseGroup) {
          if (data.groupId == firebaseGroup.groupId) {
            data.lastMessageTime = firebaseGroup.lastMessageTime;
            data.lastMessage = firebaseGroup.lastMessage;
            data.groupTotalMembers = firebaseGroup.groupTotalMembers;
            data.groupMembersId = firebaseGroup.groupMembersId;
            isOldGroup = true;
            break;
          }
        }
      }
      if (!isOldGroup) {
          firebaseProvider.userList.add(firebaseGroup);
          sortList();

      } else {
        sortList();
      }

  }

  void checkForNewUserOrLatestMessage(DocumentSnapshot documentSnapshot) {
    var chatUser = ChatUser.fromMap(documentSnapshot.data);
    print("new chat user ${chatUser.toJson()}");
    if (firebaseProvider.userList.isNotEmpty) {
      var isOldUser = false;
      for (var data in firebaseProvider.userList) {
        if (data is ChatUser) {
          if (data.userId == chatUser.userId) {
            data.lastMessageTime = chatUser.lastMessageTime;
            data.lastMessage = chatUser.lastMessage;
            data.unreadMessageCount = chatUser.unreadMessageCount;
            isOldUser = true;
            print("new_msg ${chatUser.lastMessage}");
            break;
          }
        }
      }
      if (!isOldUser) {
        firebaseProvider.userList.add(chatUser);
        sortList();
      } else {
        sortList();
      }
    } else {
      firebaseProvider.userList.add(chatUser);
      sortList();
    }
    _unreadMessageCount();
  }

  void _unreadMessageCount()
  {
    var count=0;
    for (var data in firebaseProvider.userList) {
      if (data is ChatUser) {
        count+=data.unreadMessageCount;
      }
    }
    widget.countCallBack(count);
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
