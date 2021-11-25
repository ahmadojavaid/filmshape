import 'dart:async';


import 'package:Filmshape/Model/chatuser/chat_user.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleChatData extends StatefulWidget {
  ChatUser chatUser;

  int pos;

  SingleChatData(this.chatUser);

  @override
  _SingleChatDataState createState() => _SingleChatDataState();
}

class _SingleChatDataState extends State<SingleChatData> {
  //DashboardBLoC _dashBoardBloc;

  //to show navigation
  final StreamController<bool> _streamControllerShowHideView =
      new StreamController<bool>.broadcast();

  @override
  Widget build(BuildContext context) {
    // _dashBoardBloc = DashboardProvider.of(context);

    return Container(child: _getChatItem());
  }

  // Returns chat list
  _getChatItem() {
    return new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                width: getScreenSize(context: context).width * 0.20,
                height: getScreenSize(context: context).width * 0.20,
                padding: const EdgeInsets.all(16.0),
                child: new ClipOval(
                  child: new Container(
                    color: Colors.grey,
                    child: getCachedNetworkImage(
                      url: widget.chatUser?.profilePic,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              new Expanded(
                child: new Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: new Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: new Text(
                              "${widget.chatUser.username ?? ""}",
                              style: AppCustomTheme.headline20,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Todo: time format
                          new Text(
                            readTimestamp(
                                widget.chatUser.lastMessageTime.toString()),
                            style: new TextStyle(
                              fontSize: 12.0,
                              color: 0.isEven
                                  ? AppColors.kGrey
                                  : Colors.grey.shade500,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      getSpacer(
                        height: 4.0,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Expanded(
                            child: _isImageOrText(widget.chatUser.lastMessage),
                          ),
                          // Todo: time format
                          widget.chatUser.unreadMessageCount > 0
                              ? new Material(
                                  color: Colors.red,
                                  shape: StadiumBorder(),
                                  child: new Center(
                                    child: new Padding(
                                      padding: const EdgeInsets.only(
                                        left: 4.2,
                                        right: 3.9,
                                        top: 2.0,
                                        bottom: 1.0,
                                      ),
                                      child: new Container(
//                                          color: Colors.cyanAccent,
                                        child: new Text(
                                          "${widget.chatUser.unreadMessageCount}",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : new Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _isImageOrText(String message) {
    return (message.contains("https://"))
        ? _chatImageMessage()
        : _chatText(message);
  }

  Widget _chatImageMessage() {
    return new Row(
      children: <Widget>[
        new Icon(
          Icons.image,
          size: 24,
        ),
        SizedBox(
          height: 16,
        ),
        new Text("Image")
      ],
    );
  }

  Widget _chatText(String message) {
    return new Text(
      message ?? "",
      style: AppCustomTheme.labelSingup,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _streamControllerShowHideView.close();
  }
}
