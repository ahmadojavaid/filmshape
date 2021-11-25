import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/ui/statelesswidgets/chat_profile_pic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubbleRight extends StatelessWidget {
  final String message;
  final String userName;
  final String profilePic;
  final String time;

  ChatBubbleRight({
    @required this.message,
    @required this.userName,
    @required this.profilePic,
    @required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0, left: 20, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 3.0, right: 50.0),
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
                decoration: BoxDecoration(
                  color: AppColors.kPrimaryBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(right: 60.0, top: 0, left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Linkify(
                              text: userName ?? "",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontFamily: AssetStrings.lotoBoldStyle)),
                          SizedBox(
                            height: 6.0,
                          ),
                          Linkify(
                              onOpen: (link) async {
                                if (await canLaunch(link.url)) {
                                  await launch(link.url);
                                } else {
                                  throw 'Could not launch $link';
                                }
                              },
                              linkStyle: TextStyle(color: Colors.white),
                              text: message ?? "",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: AssetStrings.lotoRegularStyle)),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0.0,
                      right: 10.0,
                      child: Row(
                        children: <Widget>[
                          Text(time ?? "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.0,
                              )),
                          SizedBox(width: 3.0),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                top: 0.0,
                child: ChatProfilePic(profilePic),
              ),
            ],
          )
        ],
      ),
    );
  }
}
