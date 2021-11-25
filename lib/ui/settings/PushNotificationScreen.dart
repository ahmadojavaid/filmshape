import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';

class PushNotificationScreen extends StatefulWidget {
  @override
  _PushNotificationScreenState createState() => _PushNotificationScreenState();
}

class _PushNotificationScreenState extends State<PushNotificationScreen> {
  bool isSwitched = false;
  var _projectInviteValue = false;
  var _likesInviteValue = false;
  var _commentsValue = false;
  var _repliesValue = false;
  var _chatValue = false;
  var _newFollowersValue = false;
  var _mentionValue = false;
  var _newVideoValue = false;

//  var _projectInviteValue=false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar:  appBarBackButton(onTap: () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Container(
                margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                child: new Text(
                  "Push Notification",
                  style: AppCustomTheme.createProfileSubTitle,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _getNameToggleRow(
                  txt: "Project invites",
                  initialValue: _projectInviteValue,
                  action: (value) {
                    setState(() {
                      _projectInviteValue = !_projectInviteValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "Likes",
                  initialValue: _likesInviteValue,
                  action: (value) {
                    setState(() {
                      _likesInviteValue = !_likesInviteValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "Comments",
                  initialValue: _commentsValue,
                  action: (value) {
                    setState(() {
                      _commentsValue = !_commentsValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "Replies",
                  initialValue: _repliesValue,
                  action: (value) {
                    setState(() {
                      _repliesValue = !_repliesValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "Chats & messages",
                  initialValue: _chatValue,
                  action: (value) {
                    setState(() {
                      _chatValue = !_chatValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "New followers",
                  initialValue: _newFollowersValue,
                  action: (value) {
                    setState(() {
                      _newFollowersValue = !_newFollowersValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "Mentions",
                  initialValue: _mentionValue,
                  action: (value) {
                    setState(() {
                      _mentionValue = !_mentionValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "My project updates",
                  initialValue: _newVideoValue,
                  action: (value) {
                    setState(() {
                      _newVideoValue = !_newVideoValue;
                    });
                  }),
              _getView(),
              _getNameToggleRow(
                  txt: "New video from people you follow",
                  initialValue: _projectInviteValue,
                  action: (value) {
                    setState(() {
                      _projectInviteValue = !_projectInviteValue;
                    });
                  }),
              _getView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getView() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 10.0,
        ),
        new Container(
          height: 1.0,
          color: Colors.blueGrey.withOpacity(0.1),
        ),
        SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  Widget _getNameToggleRow({String txt, bool initialValue, action(value)}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_LEFT_RIGHT),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                txt,
                style: TextStyle(color: Colors.black54, fontSize: 16.0),
              ),
              Switch(
                value: initialValue,
                activeTrackColor: AppColors.payment_background.withOpacity(0.2),
                activeColor: AppColors.payment_background,
                onChanged: (bool value) => action(value),
              )
            ],
          ),
        ),
      ],
    );
  }
}
