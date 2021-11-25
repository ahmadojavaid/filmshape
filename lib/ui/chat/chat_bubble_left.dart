import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatBubbleLeft extends StatefulWidget {
  final String message;
  final String userName;
  final String profilePic;
  final String time;
  final String chatId;
  final String messageId;
  bool isLiked;
  final bool isGroup;

  ChatBubbleLeft(
      {@required this.message,
      @required this.userName,
      @required this.profilePic,
      @required this.time,
      @required this.isLiked,
      @required this.chatId,
      @required this.messageId,
      @required this.isGroup});

  @override
  _ChatBubbleLeftState createState() => _ChatBubbleLeftState();
}

class _ChatBubbleLeftState extends State<ChatBubbleLeft>
    with AutomaticKeepAliveClientMixin<ChatBubbleLeft> {
  FirebaseProvider firebaseProvider;

  void _likeUnlike() async {
    print("called ${widget.isGroup}");
    var userId = MemoryManagement.getuserId();
    if (widget.isGroup)
      widget.isLiked = await firebaseProvider.groupChatMessageChatLikedUnliked(
          widget.isLiked, widget.chatId, widget.messageId, int.parse(userId));
    else
      widget.isLiked = await firebaseProvider.privateChatLikedUnliked(
          widget.isLiked, widget.chatId, widget.messageId, int.parse(userId));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              new Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: new BoxDecoration(
                    color: Colors.grey,
                    border: new Border.all(color: Colors.white, width: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: getCachedNetworkImageWithurl(
                        url: widget.profilePic ?? "", size: 32),
                  )),
              Stack(
                children: <Widget>[
                  Container(
                    margin:
                        const EdgeInsets.only(left: 50.0, right: 3.0, top: 6.0),
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, top: 4.0, bottom: 8.0),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: .5,
                            spreadRadius: 1.0,
                            color: Colors.black.withOpacity(.12))
                      ],
                      color: AppColors.CommentItemBackground,
                      border: new Border.all(
                        color: AppColors.commentBorder,
                        width: 0.8,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding:
                              EdgeInsets.only(right: 60.0, top: 0, left: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Linkify(
                                  text: widget.userName ?? "",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.kHomeBlack,
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
                                  text: widget.message ?? "",
                                  linkStyle: TextStyle(color: Colors.blue),
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.tabCommentColor,
                                      fontFamily:
                                          AssetStrings.lotoRegularStyle)),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          right: 0.0,
                          child: Row(
                            children: <Widget>[
                              Text(widget.time ?? "",
                                  style: TextStyle(
                                    color: AppColors.tabCommentColor,
                                    fontSize: 10.0,
                                  )),
                              SizedBox(width: 3.0),
//                              Icon(
//                                Icons.done,
//                                size: 12.0,
//                                color: AppColors.tabCommentColor,
//                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: 0.0,
                    top: 0.0,
                    child: InkWell(
                      onTap: () {
                        _likeUnlike();
                      },
                      child: Container(
                        padding: new EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            (widget.isLiked)
                                ? new Icon(Icons.favorite,
                                    size: 16.0, color: AppColors.heartColor)
                                : new Icon(Icons.favorite,
                                    size: 16.0, color: AppColors.heartGrey),
                            new SizedBox(
                              width: 2.0,
                            ),
                            new Text(
                              "",
                              style: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.0,
                                  fontFamily: AssetStrings.lotoRegularStyle),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
