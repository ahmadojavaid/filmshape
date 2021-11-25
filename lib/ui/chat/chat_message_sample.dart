import 'package:Filmshape/ui/chat/chat_bubble_left.dart';
import 'package:Filmshape/ui/chat/chat_bubble_right.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatefulWidget {
  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List<Object> list = new List();

  @override
  void initState() {
    list.add(1);
    list.add("a");
    list.add(1);
    list.add("a");
    list.add(1);
    list.add("a");
    list.add(1);
    list.add("a");
    list.add(1);
    list.add("a");
    list.add(1);
    list.add("a");
  }

  _buildContestList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        margin: new EdgeInsets.only(top: 20.0),
        child: new ListView.builder(
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            if (list[index] is int) {
              return ChatBubbleRight(
                message: "hgkuh",
                userName: "dkh ",
                time: "12:30",
                profilePic: "",);
            } else {
              return ChatBubbleLeft(message: "kj",
                chatId: "1",
                isGroup: false,
                isLiked: false,
                userName: "sasf",
                messageId: "12",

                time: "12:30",
                profilePic: "",);
            }
          },
          itemCount: list.length,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new Column(
      children: <Widget>[_buildContestList()],
    ));
  }
}
