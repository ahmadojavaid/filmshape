
import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Chat/private_chat.dart';
import 'normal_message_model.dart';

class ChatListScreen extends StatefulWidget {
  final String userId;

  ChatListScreen(this.userId);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<ChatListScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  List<ChatUser> mUserList = List();

  var timeout = const Duration(seconds: 3);
  var ms = const Duration(milliseconds: 1);

  //DashboardBloc _dashBoardBloc;
  var streamBuilerLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    // userId = (widget.studentid != null) ? widget.studentid : getUserId();

    streamBuilerLoaded = true;
    //startTimeoutLoadData(200);
    print("userId $widget.userId");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   // _dashBoardBloc = DashboardProvider.of(context);
    return new Scaffold(
      appBar: getAppbar("Chat"),
      body: new SafeArea(
        top: false,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: _home(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _home() {
    return StreamBuilder<List<ChatUser>>(
     //   stream: _dashBoardBloc.getChatFriends(userId: widget.userId),
        builder: (context, AsyncSnapshot<List<ChatUser>> result) {
          if (result.hasData) {
            if (result.data.length == 0) {
              return _getNoDataWidget();
            }
            mUserList.clear();
            mUserList.addAll(result.data);
            refresh();
            return ListView.separated(
              itemCount: mUserList.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: _getListItem(mUserList[index]),
                  onTap: () {
                    _moveToChatScreen(mUserList[index]);
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return getItemDivider();
              },
            );
          } else {
            return _getNoDataWidget();
          }
        });
  }

  _getNoDataWidget() {
    return getEmptyRefreshWidget(context, "No Chat Found", () {}, true);
  }

  void refresh() {
    print("list shorted");
    mUserList.sort((ChatUser a, ChatUser b) =>
        b.lastMessageTime.compareTo(a.lastMessageTime));
  }

  Widget _getListItem(ChatUser user) {
    print("isGroup" + user.isGroup.toString());

//    return new DashboardProvider(
//      child: SingleChatData(user),
//      authBloc: new DashboardBloc(
//        dashBoardApi: new DashboardServiceAPi(),
//      ),
//    );
  }

  void _moveToChatScreen(ChatUser chatUser) {
    // chatUser.unreadMessageCount = 0; //set last message count to
    //refresh(); //refresh list
    print("chating user id ${chatUser.userId}");
//    Navigator.push(
//        context,
//        CupertinoPageRoute(
//            builder: (context) => DashboardProvider(
//                child: PrivateChat(
//                  peerId: chatUser.userId,
//                  currentUserId: widget.userId,
//                  peerAvatar: chatUser.profilePic,
//                  userName: chatUser.username,
//                  isGroup: false,
//                ),
//                authBloc: new DashboardBloc(
//                  dashBoardApi: new DashboardServiceAPi(),
//                ))));
  }

  Widget _chatText(String message) {
    return new Text(
      message ?? "",
      style: new TextStyle(fontSize: 14, color: AppColors.kAppBlue),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget getBandage({@required int count}) {
    return Container(
        height: 14,
        width: 14,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColors.kAppBlue,
            borderRadius: BorderRadius.all(new Radius.circular(10))),
        child: Text(
          count.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 8),
        ));
  }

  void checkForNewUser(ChatUser chatUser) {
    //check if update listener gets newly addedd user
    var status = false;

    for (var data in mUserList) {
      if (data.userId == chatUser.userId) {
        status = true; //user alredy exists in list
        break;
      }
    }
    //new user found add him to list
    if (!status) {
      mUserList.add(chatUser);
      setState(() {});
    }
  }

  Widget _emptyScreen() {
    return (mUserList.length == 0) ? Text("No contact found") : Container();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
