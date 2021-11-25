import 'dart:async';

import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/firebase_constant.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/statelesswidgets/chat_group_image.dart';
import 'package:Filmshape/ui/statelesswidgets/empty_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChatGroupWidget extends StatefulWidget {
  final FilmShapeFirebaseGroup filmShapeFirebaseGroup;

  ChatGroupWidget(this.filmShapeFirebaseGroup);

  @override
  _ChatUserWidgetState createState() => _ChatUserWidgetState();
}

class _ChatUserWidgetState extends State<ChatGroupWidget>
    with AutomaticKeepAliveClientMixin<ChatGroupWidget> {
  FirebaseProvider firebaseProvider;
  String userId;

  String _profilePic1;
  String _profilePic2;

  String _time;
  String _lastMessage;


  var userNameList = List<String>();

  StreamController<String> _streamControllerProfilePic;

  StreamController<String> _streamControllerGroupName;

  @override
  void initState() {
    super.initState();
    // print("group_widget_created ${widget.filmShapeFirebaseGroup.groupId}");
//    userId = MemoryManagement.getuserId();
//    _profilePic = APIs.imageBaseUrl + widget.chatUser.profilePic;
//    _userName = widget.chatUser.username;
//    _lastMessage = widget.chatUser.lastMessage;
    _streamControllerProfilePic = StreamController<String>();
    _streamControllerGroupName = StreamController<String>();
    Future.delayed(const Duration(milliseconds: 50), () {
      // _hitApi();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamControllerProfilePic?.close();
    _streamControllerProfilePic = null;
    _streamControllerGroupName?.close();
    _streamControllerGroupName = null;
  }

  void _hitApi() async {
    print("group_api_called ${widget.filmShapeFirebaseGroup.groupId}");
    userNameList = List<String>();
    var groupUserList =
    firebaseProvider.groupUserList[widget.filmShapeFirebaseGroup.groupId];

    print("list_found $groupUserList");
    if (groupUserList == null) {
      groupUserList = await firebaseProvider.getGroupFriends(
          userIds: widget.filmShapeFirebaseGroup.groupMembersId,
          groupId: widget.filmShapeFirebaseGroup.groupId);
    }

    for (var member in groupUserList) {
      userNameList.add(member.fullName);
    }
    _streamControllerGroupName?.add(userNameList.join(","));

    //get the profile pci of creator
    for (var member in groupUserList) {
      if (member.filmShapeId.toString() ==
          widget.filmShapeFirebaseGroup.createdBy) {
        _profilePic1 = member.thumbnailUrl;
        break;
      }
    }

    //get the profile pic of second memeber if group totoal members are 2
    if (groupUserList.length == 2) {
      for (var member in groupUserList) {
        if (member.filmShapeId.toString() !=
            widget.filmShapeFirebaseGroup.createdBy) {
          _profilePic2 = member.thumbnailUrl;
          break;
        }
      }

    }
    _streamControllerProfilePic?.add(_profilePic1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    _lastMessage = widget.filmShapeFirebaseGroup.lastMessage;
    _time =
        readTimestamp(widget.filmShapeFirebaseGroup.lastMessageTime.toString());
    _hitApi();
    return buildItem();
  }

  Widget buildItem() {
    return Container(
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
                        new StreamBuilder<String>(
                            stream: _streamControllerProfilePic.stream,
                            initialData: "",
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {

                              return ChatGroupImage(
                                totalMembers: widget.filmShapeFirebaseGroup
                                    .groupTotalMembers,
                                firstProfilePic: _profilePic1,
                                secondPoriflePic: _profilePic2,
                              );
                            })
                        ,
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
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new StreamBuilder<String>(
                                          stream:
                                          _streamControllerGroupName.stream,
                                          initialData: "",
                                          builder: (BuildContext context,
                                              AsyncSnapshot<String> snapshot) {
                                            var data = snapshot.data ?? "";
                                            return new Text(
                                              data,
                                              style: AppCustomTheme
                                                  .chatUserNameStyle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            );
                                          }),
                                    ),
                                    Text(_time,
                                        style: TextStyle(
                                          color: Colors.black38,
                                          fontSize: 10.0,
                                        ))
                                  ],
                                ),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    child: new Text(
                                      (_lastMessage ?? "").contains(
                                          "https://firebasestorage")
                                          ? "Sent a photo"
                                          : _lastMessage ?? "",
                                      style: new TextStyle(
                                          color: AppColors.kChatDEsc,
                                          fontFamily:
                                          AssetStrings.lotoRegularStyle,
                                          fontSize: 13.0),
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
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
