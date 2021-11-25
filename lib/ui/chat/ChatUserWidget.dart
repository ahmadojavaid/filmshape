import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/ui/statelesswidgets/badge_counter.dart';
import 'package:Filmshape/ui/statelesswidgets/empty_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChatUserWidget extends StatefulWidget {
  final ChatUser chatUser;

  ChatUserWidget(this.chatUser);

  @override
  _ChatUserWidgetState createState() => _ChatUserWidgetState();
}

class _ChatUserWidgetState extends State<ChatUserWidget>
    with AutomaticKeepAliveClientMixin<ChatUserWidget> {
  FirebaseProvider firebaseProvider;
  String userId;
  String _profilePic;
  String _userName;
  String _lastMessage;
  bool _isOnline = false;
  String _time;
  int _unreadCount;

  @override
  void initState() {
    super.initState();
    print("user widget called");
    userId = MemoryManagement.getuserId();
    Future.delayed(const Duration(milliseconds: 50), () {
      _hitApi();
    });
  }

  void _hitApi() async {
    var userInfo = await firebaseProvider.getUserInfo(
        userId: int.parse(widget.chatUser.userId));
    if (userInfo != null) {
      widget.chatUser.username = userInfo.fullName;
      widget.chatUser.profilePic = userInfo.thumbnailUrl;
      widget.chatUser.isOnline = userInfo.isOnline ?? false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    _profilePic = APIs.imageBaseUrl + widget.chatUser.profilePic;
    _userName = widget.chatUser.username;
    _lastMessage = widget.chatUser.lastMessage;
    _time = readTimestamp(widget.chatUser.lastMessageTime.toString());
    _isOnline = widget.chatUser.isOnline;
    _unreadCount = widget.chatUser.unreadMessageCount;
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
                        Stack(
                          children: <Widget>[
                            new Container(
                                width: 38.0,
                                height: 38.0,
                                decoration: new BoxDecoration(

                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: getCachedNetworkImage(
                                      url: _profilePic, fit: BoxFit.cover),
                                )),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: new Container(
                                width: 13.0,
                                height: 13.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (_isOnline)
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
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: new Text(
                                        _userName,
                                        style: AppCustomTheme.chatUserNameStyle,
                                        maxLines: 1,

                                        overflow: TextOverflow.ellipsis,
                                      ),
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
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          (_lastMessage ?? "").contains(
                                                  "https://firebasestorage")
                                              ? "Sent a photo"
                                              : _lastMessage ?? "",
                                          style: new TextStyle(
                                              color: AppColors.kChatDEsc,
                                              fontFamily: AssetStrings
                                                  .lotoRegularStyle,
                                              fontSize: 13.0),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    (_unreadCount!=0)?Container(
                                      height: 20,
                                      width: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppColors.kPrimaryBlue),
                                      child: Center(
                                        child: BadgeCounter(count:_unreadCount),
                                      ),
                                    ):Container()
                                  ],
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
