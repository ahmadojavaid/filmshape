import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Constants/firebase_constant.dart';
import 'package:Filmshape/Utils/Dialog.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/chat/chat_bubble_image_left.dart';
import 'package:Filmshape/ui/chat/chat_bubble_image_right.dart';
import 'package:Filmshape/ui/chat/chat_bubble_left.dart';
import 'package:Filmshape/ui/chat/chat_bubble_right.dart';
import 'package:Filmshape/ui/chat/group_chat_top.dart';
import 'package:Filmshape/ui/statelesswidgets/chat_input_widget.dart';
import 'package:Filmshape/ui/statelesswidgets/chat_project_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'ImageFullScreenView.dart';

class ChoicePrivate {
  const ChoicePrivate({this.title, this.icon});

  final String title;
  final IconData icon;
}

class ChoiceGroup {
  const ChoiceGroup({this.title, this.icon});

  final String title;
  final IconData icon;
}

class GroupChat extends StatefulWidget {
  final String currentUserId;
  final String currentUserName;
  final String currentUserProfilePic;
  final FilmShapeFirebaseGroup filmShapeFirebaseGroup;
  ProjectData projectData;
  ProjectResponse projectResponse;

  GroupChat(
      {Key key,
      @required this.currentUserId,
      @required this.currentUserName,
      @required this.currentUserProfilePic,
      @required this.filmShapeFirebaseGroup,
      this.projectData,
      this.projectResponse})
      : super(key: key);

  @override
  State createState() => new _GroupChatState(
      currentUserId: currentUserId,
      currentUserAvatar: currentUserName,
      currentUseerName: currentUserProfilePic,
      filmShapeFirebaseGroup: filmShapeFirebaseGroup);
}

class _GroupChatState extends State<GroupChat> {
  _GroupChatState(
      {Key key,
      @required this.currentUserId,
      @required this.currentUserAvatar,
      @required this.currentUseerName,
      @required this.filmShapeFirebaseGroup});

//  var timeout = const Duration(seconds: 3);
//  var ms = const Duration(milliseconds: 1);

  String currentUserId;
  String currentUserAvatar;
  String currentUseerName;
  FilmShapeFirebaseGroup filmShapeFirebaseGroup;

  var listMessage;
  String groupChatId;
  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  bool isUserBlocked = false;
  bool isUserBlockedBy;
  bool userWindowStatus = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider firebaseProvider;

  var groupUserListUsers = List<FilmShapeFirebaseUser>();

  List<ChoicePrivate> choicesPrivate = const <ChoicePrivate>[
    const ChoicePrivate(title: 'Block', icon: Icons.block),
    const ChoicePrivate(title: 'Report', icon: Icons.report),
  ];

  List<ChoicePrivate> choicesGroup = const <ChoicePrivate>[
    //  const ChoicePrivate(title: 'Block', icon: Icons.block),
    const ChoicePrivate(title: 'Report', icon: Icons.report),
  ];

  //to show  loader
  final StreamController<bool> _streamControllerUserStatus =
      new StreamController<bool>();

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  var _isAdmin = false;

  @override
  void initState() {
    MemoryManagement.init();
    focusNode.addListener(onFocusChange);
    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    groupChatId = filmShapeFirebaseGroup.groupId;
    readLocal();
    if (widget.projectResponse != null) {
      //create project data item
      var projectData = ProjectData();
      var listThumbnails = List<String>();
      for (var data in widget.projectResponse.team) {
        listThumbnails.add(data.thumbnailUrl);
      }
      projectData.createTeam(listThumbnails);
      projectData.location = widget.projectResponse.location;
      projectData.likedBy = widget.projectResponse.likedBy;
      projectData.description = widget.projectResponse.description;
      widget.projectData = projectData;
    }
    Future.delayed(const Duration(milliseconds: 100), () {
      _hitApi();
    });
    super.initState();
  }

  void _hitApi() async {
    //load list in case if not loaded
     if(firebaseProvider.groupUserList[widget.filmShapeFirebaseGroup.groupId]==null)
     await firebaseProvider.getGroupFriends(
        userIds: widget.filmShapeFirebaseGroup.groupMembersId,
        groupId: widget.filmShapeFirebaseGroup.groupId);

    _isAdmin = await firebaseProvider.checkGroupMemberIsAdmin(
        userId: widget.currentUserId,
        groupId: widget.filmShapeFirebaseGroup.groupId);
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    setOnlineOfflineStatusOnWindow(false);
    super.dispose();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  //reset unread message count
  Future<Null> resetCount() async {
//    _dashBoardBloc.resetUnreadMessageCount(
//        userId: currentUseerId, chatUserId: peerId);
  }

  readLocal() async {
    setOnlineOfflineStatusOnWindow(true); //set user on chat screen
    getUserUserStatusOnChatWindow();
    _checkIsUserBockedOrBlockedBy(); //check user block status
  }

  void getUserUserStatusOnChatWindow() {
    var docRef = Firestore.instance
        .collection(GROUPS)
        .document(groupChatId)
        .collection("chatwindowstatus")
        .document(currentUserId)
        .snapshots();

    docRef.listen((DocumentSnapshot snapshot) {
      if (snapshot.data == null) {
        userWindowStatus = false;
      } else {
        userWindowStatus = snapshot.data["isOnline"];
      }
      print("isonline $userWindowStatus");
      _streamControllerUserStatus.add(userWindowStatus);
    });
  }

  void _checkIsUserBockedOrBlockedBy() {
    //check if user whom chatting is blocked
    var docRef = Firestore.instance
        .collection(GROUPS)
        .document(groupChatId)
        .collection("blockstatus")
        .document(currentUserId)
        .snapshots();

    docRef.listen((DocumentSnapshot result) {
      if (result.data == null) {
        isUserBlocked = false;
      } else {
        isUserBlocked = result.data["isBlocked"];
      }
    });

    //check if user blocked by chatting user
    var docRef2 = Firestore.instance
        .collection(GROUPS)
        .document(groupChatId)
        .collection("blockstatus")
        .document(currentUserId)
        .snapshots();

    docRef2.listen((DocumentSnapshot result) {
      if (result.data == null) {
        isUserBlockedBy = false;
      } else {
        isUserBlockedBy = result.data["isBlocked"];
      }
    });
  }

  void _blockUnblockUser(bool status) {
    var docRef = Firestore.instance
        .collection(GROUPS)
        .document(groupChatId)
        .collection("blockstatus")
        .document(currentUserId);

    docRef.setData({'isBlocked': status}).then((results) {
      isUserBlocked = status;
      if (status) //if user is blocked
        showAlertDialog(USER_BLOCKED_MESSAGE);
      else //if user is unblocked
        showAlertDialog(USER_UNBLOCKED_MESSAGE);
    });
  }

  void showAlertDialog(String message) {
    Dialogs.AppAlertDialogSuccess(context, message, "OK", callBackDialog);
  }

  void showWarningDialog(String message) {
    Dialogs.warningDialog(
        context, message, "CANCEL", "UNBLOCK", warningDialogCallBack);
  }

  VoidCallback callBackDialog() {}

  ValueSetter<int> warningDialogCallBack(int status) {
    if (status == 2) {
      _blockUnblockUser(false); //unblock the user
    }
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future uploadFile() async {
    var user = "user+${MemoryManagement.getuserId()}";
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference =
        FirebaseStorage.instance.ref().child(user).child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });

      showInSnackBar('This file is not an image');
    });
  }

  void onSendMessage(String content, int type) async {
    //check for user block status
    //if user is blocked to whom is chatting
    if (isUserBlocked) {
      showWarningDialog(USER_BLOCKED_ALERT_MESSAGE);
      return;
    }

    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();
      var timeStamp = DateTime.now().millisecondsSinceEpoch;
      var documentReference = Firestore.instance
          .collection(GROUPS)
          .document(groupChatId)
          .collection('items')
          .document(timeStamp.toString());

      documentReference.setData(
        {
          'idFrom': currentUserId,
          'idTo': groupChatId,
          'timestamp': timeStamp,
          'content': content,
          'type': type
        },
      ).then((onvalue) {
        print("saved ");
      }).catchError((error) {
        print("error ${error.toString()} ");
      });

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      firebaseProvider.updateGroupMessage(
          message: content, timestamp: timeStamp, groupId: groupChatId);
    } else {
      showInSnackBar('Nothing to send');
    }

    //check if user online or offline
    if (!userWindowStatus) {
      //  setPushNotification(content);
    }
  }

  void setOnlineOfflineStatusOnWindow(bool status) async {
    var statusData = new Map<String, dynamic>();
    statusData["isOnline"] = status;
    var docRef = Firestore.instance
        .collection(GROUPS)
        .document(groupChatId)
        .collection("chatwindowstatus")
        .document(currentUserId);

    docRef.setData(statusData).catchError((e) {
      print("error ${e.toString()}");
    });
  }

  Widget _myChatBubbleMessage(String content, num timeStamp, int index) {
    return Column(
      children: <Widget>[
//        Bubble(
//          message: content,
//          time: readTimestamp(timeStamp),
//          delivered: false,
//          isMe: true,
//          isGroup: widget.isGroup,
//          name: listMessage[index]['idFrom'],
//        ),
        ChatBubbleRight(
          message: content,
          time: readTimestamp(timeStamp.toString()),
          userName: widget.currentUserName,
          profilePic: widget.currentUserProfilePic,
        ),
        // Container(height:100,child: ChatLeft()),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _myChatBubbleImage(String content, num timeStamp, int index) {
    return ChatBubbleImageRight(
      content: content,
      timeStamp: timeStamp,
      profilePic: widget.currentUserProfilePic,
    );
  }

  void moveToImageFullScreen(String imageUrl) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            ImageFullScreen(imageUrl)));
  }

  Tuple2 _checkUserName(String userId) {
    var userList = firebaseProvider.groupUserList[groupChatId];
    if (userList != null) {
      for (var data in userList) {
        if (int.parse(userId) == data.filmShapeId) {
          return Tuple2<String, String>(data.fullName, data.thumbnailUrl);
        }
      }
    }
    return Tuple2<String, String>("", "");
  }

  Widget _otherChatMessageBubble(String content, num timeStamp, int index) {
    var tuppleData = _checkUserName(listMessage[index]['idFrom']);
    var isLiked = false;
    var likedBy = listMessage[index]['likedby'];
    if (likedBy != null) {
      isLiked =
          List<int>.from(likedBy).contains(int.parse(widget.currentUserId));
    }
    return Column(
      children: <Widget>[
//        Bubble(
//          message: content,
//          time: readTimestamp(timeStamp),
//          delivered: false,
//          isMe: false,
//          isGroup: widget.isGroup,
//          name: listMessage[index]['idFrom'],
//        ),
        ChatBubbleLeft(
          message: content,
          time: readTimestamp(timeStamp.toString()),
          userName: tuppleData.item1,
          profilePic: tuppleData.item2,
          isLiked: isLiked,
          chatId: groupChatId,
          messageId: timeStamp.toString(),
          isGroup: true,
        ),

        SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget _otherChatImageBubble(String content, num timeStamp, int index) {
    var tuppleData = _checkUserName(listMessage[index]['idFrom']);
    return ChatBubbleImageLeft(
      content: content,
      timeStamp: timeStamp,
      profilePic: tuppleData.item2,
    );
  }


  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == currentUserId) {
      // Right (my message)
      return Column(
        children: <Widget>[
          document['type'] == 0
          // Text
              ? _myChatBubbleMessage(
              document['content'], document['timestamp'], index)
              : document['type'] == 1
          // Image
              ? _myChatBubbleImage(
              document['content'], document['timestamp'], index)
          // Sticker
              : Container(
            child: new Image.asset(
              'images/${document['content']}.gif',
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(
                bottom: isLastMessageRight(index) ? 10.0 : 10.0,
                right: 10.0),
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            isLastMessageLeft(index)
                ? Container()
//                    ? Material(
//                        child: CachedNetworkImage(
//                          placeholder: (context, url) => Container(
//                                child: CircularProgressIndicator(
//                                  strokeWidth: 1.0,
//                                  valueColor: AlwaysStoppedAnimation<Color>(
//                                      AppColors.themeColor),
//                                ),
//                                width: 35.0,
//                                height: 35.0,
//                                padding: EdgeInsets.all(10.0),
//                              ),
//                          imageUrl: peerAvatar,
//                          width: 35.0,
//                          height: 35.0,
//                          fit: BoxFit.cover,
//                        ),
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(18.0),
//                        ),
//                        clipBehavior: Clip.hardEdge,
//                      )
//                    :
                : Container(),
            document['type'] == 0
                ? _otherChatMessageBubble(
                document['content'], document['timestamp'], index)
                : document['type'] == 1
                ? Container(
              child: _otherChatImageBubble(document['content'],
                  document['timestamp'], index),
              margin: EdgeInsets.only(left: 10.0),
            )
                : Container(
//                  child: new Image.asset(
//                    'images/${document['content']}.gif',
//                    width: 100.0,
//                    height: 100.0,
//                    fit: BoxFit.cover,
//                  ),
              margin: EdgeInsets.only(
                  bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                  right: 10.0),
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
              child: Text(
                DateFormat('dd MMM kk:mm').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        document['timestamp'])),
                style: TextStyle(
                    color: AppColors.kGrey,
                    fontSize: 12.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: "RobotoRegular"),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
            )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] == currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1]['idFrom'] != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  ///This will show loader through stream
  Widget _userStatus() {
    return new StreamBuilder<bool>(
        stream: _streamControllerUserStatus.stream,
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          bool status = snapshot.data;
          return status ? _circle(Colors.greenAccent) : _circle(Colors.grey);
        });
  }

  Widget _circle(Color color) {
    return new Container(
      width: 10,
      height: 10,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  void _showReportDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Report"),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Report Message:',
                      hintText: 'Enter your message'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("REPORT"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget popupMenuPrivate() {
    return PopupMenuButton<ChoicePrivate>(
      icon: Icon(
        Icons.menu,
        color: AppColors.kBlack,
      ),
      onSelected: onItemMenuPressPrivate,
      itemBuilder: (BuildContext context) {
        return choicesPrivate.map((ChoicePrivate choice) {
          return PopupMenuItem<ChoicePrivate>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: AppColors.kAppBlue,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(
                        color: AppColors.kAppBlue, fontFamily: "RobotoRegular"),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  Widget popupMenuGroup() {
    return PopupMenuButton<ChoicePrivate>(
      icon: Icon(
        Icons.menu,
        color: AppColors.kWhite,
      ),
      onSelected: onItemMenuPressPrivate,
      itemBuilder: (BuildContext context) {
        return choicesGroup.map((ChoicePrivate choice) {
          return PopupMenuItem<ChoicePrivate>(
              value: choice,
              child: Row(
                children: <Widget>[
                  Icon(
                    choice.icon,
                    color: AppColors.kAppBlue,
                  ),
                  Container(
                    width: 10.0,
                  ),
                  Text(
                    choice.title,
                    style: TextStyle(
                        color: AppColors.kAppBlue, fontFamily: "RobotoRegular"),
                  ),
                ],
              ));
        }).toList();
      },
    );
  }

  void onItemMenuPressPrivate(ChoicePrivate choice) {
    if (choice.title == 'Block') {
      _blockUnblockUser(true); //block or unblock user
    } else {
      _showReportDialog();
    }
  }

  void onItemMenuPressGroup(ChoiceGroup choice) {
    if (choice.title == 'Block') {
      _blockUnblockUser(true); //block or unblock user
    } else {
      _showReportDialog();
    }
  }

  // Getters
  _getAppbar(String userName) {
    return new AppBar(
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(
        color: Colors.black, //change your color here
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            userName,
            style: AppCustomTheme.headline20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _userStatus(),
          )
        ],
      ),
      centerTitle: true,
      actions: <Widget>[popupMenuPrivate()],
    );
  }

  void setPushNotification(String content) async {
//    bool gotInternetConnection = await hasInternetConnection(
//      context: context,
//      mounted: mounted,
//      canShowAlert: true,
//      onFail: () {},
//      onSuccess: () {},
//    );
//
//    if (gotInternetConnection) {
//      var request = new SendNotificationRequest(
//          toId: peerId, fromId: currentUseerId, message: content);
//      var response = await _dashBoardBloc.sendNotification(
//          context: context, sendNotificationRequest: request);
//
//
//      //push sent
//      if (response != null && (response is SendNotificationResponse)) {
//        print(response.message);
//      } else {
//        print(response);
//      }
//    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    print("group count ${firebaseProvider.groupUserList.length}");
    return SafeArea(
      child: new Scaffold(
        backgroundColor: AppColors.white,
        key: _scaffoldKey,
        appBar: appBarBackButton(onTap: () {
          Navigator.pop(context);
        }),
        body: new SafeArea(
          top: false,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: new EdgeInsets.only(top: 10.0, bottom: 20),
                child: (widget.projectData == null)
                    ? GroupChatTop(
                        filmShapeFirebaseGroup: filmShapeFirebaseGroup,
                        usersList: firebaseProvider.groupUserList[groupChatId],
                        isAdmin: _isAdmin,
                      )
                    : ChatProjectWidget(widget.projectData),
              ),
              Container(
                height: 1,
                color: AppColors.gray_tab.withOpacity(0.5),
              ),
              new Expanded(
                child: _getBodyWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  ValueChanged<int> callBack(int value) {
    if (value == 1) //for sending text message
        {
      onSendMessage(textEditingController.text, 0);
    }
    else //for sending image
        {
      _imagePicker();
    }
  }

  Widget _getBodyWidget() {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Input content
             // buildInput(),
              ChatInputWidget(callBack, textEditingController),
            ],
          ),

          // Loading
          buildLoading()
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CupertinoActivityIndicator(
                  radius: LOADER_RADIUS,
                ),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: _imagePicker,
                color: AppColors.kAppBlue,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                    color: AppColors.kAppBlue,
                    fontSize: 15.0,
                    fontFamily: "RobotoRegular"),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(
                      color: AppColors.kGrey, fontFamily: "RobotoRegular"),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: AppColors.kAppBlue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(
              top: new BorderSide(color: AppColors.kGrey, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection(GROUPS)
            .document(groupChatId)
            .collection('items')
            .orderBy('timestamp', descending: true)
            .limit(100)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CupertinoActivityIndicator(
              radius: LOADER_RADIUS,
            ));
          } else {
            print("data size ${snapshot.data.documents.length}");
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  void _imagePicker() {
    _crupitinoActionSheet();
  }

  _crupitinoActionSheet() {
    return containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: const Text(CAMERA),
              onPressed: () {
                _getCameraImage();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(GALLARY),
              onPressed: () {
                _getGalleryImage();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(CANCEL),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          )),
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Future _getCameraImage() async {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);

    if (imageFile != null) {
      // imageFile=await rotateAndCompressAndSaveImage(imageFile);
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future _getGalleryImage() async {
    imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);

    if (imageFile != null) {
      //imageFile=await rotateAndCompressAndSaveImage(imageFile);
      setState(() {
        isLoading = true;
      });
      uploadFile();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }
}
