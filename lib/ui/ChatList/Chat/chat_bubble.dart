
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
//import 'package:flutter_linkify/flutter_linkify.dart';

// todo: disposal
//import 'package:disposal/Utils/ReusableWidgets.dart';

class Bubble extends StatelessWidget {
  Bubble(
      {this.message,
      this.time,
      this.delivered,
      this.isMe,
      this.isGroup,
      this.name});

  final String message, time;
  final delivered, isMe;
  final bool isGroup;
  final String name;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.greenAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius =
        isMe ? BorderRadius.circular(5.0) : BorderRadius.circular(5.0);
    BorderRadius.circular(5.0);
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    right: 65.0, top: (isGroup && (!isMe)) ? 40 : 0),
                child: Container(
                  constraints: BoxConstraints(maxWidth: 250, minWidth: 20),
                  child: Linkify(
                      onOpen: (url) => launchUrl(url.url),
                      text: message,
                      style: TextStyle(fontSize: 16)),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    Icon(
                      icon,
                      size: 12.0,
                      color: Colors.black38,
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

//  Widget _getNameWidget() {
//    return new StreamBuilder<UserData>(
//        stream: _otherFunBloc.getUser(userId),
//        builder: (context, AsyncSnapshot<UserData> result) {
//          if (result.hasData) {
//            var userData = result.data;
//            var userName = "${userData.firstName} ${userData.lastName}";
//            return Text(userName,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),);
//          } else {
//            return Text("");
//          }
//        });
//  }
}
