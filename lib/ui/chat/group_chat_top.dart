import 'package:Filmshape/Model/filmshape_firebase_group.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Model/followfollowing/followingfollowersresponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/material.dart';

import 'group_chat/create_group.dart';

class GroupChatTop extends StatefulWidget {
  final FilmShapeFirebaseGroup filmShapeFirebaseGroup;
  final List<FilmShapeFirebaseUser> usersList;
  final bool isAdmin;

  GroupChatTop(
      {@required this.filmShapeFirebaseGroup,
      @required this.usersList,
      @required this.isAdmin});

  @override
  _GroupChatTopState createState() => _GroupChatTopState();
}

class _GroupChatTopState extends State<GroupChatTop>
    with AutomaticKeepAliveClientMixin<GroupChatTop> {
  var userNameList = List<String>();

  @override
  Widget build(BuildContext context) {
    userNameList.clear();
    print("group id ${widget.filmShapeFirebaseGroup.groupId}");
    if(widget.usersList!=null)
    for (var member in widget.usersList) {
      userNameList.add(member.fullName);
    }
    var timeStamp = widget.filmShapeFirebaseGroup.lastMessageTime;
    var date =
        "${readTimestampGroupChatTop(timeStamp, "EEE")} ${readTimestampGroupChatTop(timeStamp, "dd")}th " +
            "${readTimestampGroupChatTop(timeStamp, "MMMM yyyy")} at ${readTimestampGroupChatTop(timeStamp, "hh:mm a")}";

    //print("video thumbnail $videoThumbNail");
    return Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: Container(
          height: 120.0,
          padding: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
          child: Column(
            children: <Widget>[
              Container(
                child: Expanded(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[]
                      ..add(Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: new Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[]
                              // todo: make dynamic
                              ..addAll(new List.generate(
                                  widget.usersList?.length??0, (index) {
                                return new Padding(
                                  padding: new EdgeInsets.only(
                                    right: index *
                                        (28.0), // give left and remove alignment for reverse type
                                  ),
                                  child: new Container(
                                    width: 40,
                                    height: 40,
                                    decoration: new BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        width: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: getCachedNetworkImageWithurl(
                                          /*   url: list[index] ?? "", */

                                          url: widget.usersList[index]
                                                  .thumbnailUrl ??
                                              "",
                                          size: 36.0,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              })),
                          ),
                        ),
                      ))
                      ..add(
                        (widget.isAdmin)?InkWell(
                          onTap: () async {
                            var newlyAddedUsers =
                                await Navigator.push<List<FollowFollowingUser>>(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CreateGroup(
                                        groupUserList: widget
                                            .filmShapeFirebaseGroup
                                            .groupMembersId,
                                        groupId: widget
                                            .filmShapeFirebaseGroup.groupId,
                                      )),
                            );
                            if (newlyAddedUsers != null) {
                              for (var user in newlyAddedUsers) {
                                widget.usersList.add(FilmShapeFirebaseUser(
                                    fullName: user.fullName,
                                    thumbnailUrl: user.thumbnailUrl));
                              }
                            }
                          },
                          child: Container(
                              padding: new EdgeInsets.only(bottom: 5.0),
                              margin: new EdgeInsets.only(left: 25.0),
                              child: new Container(
                                height: double.infinity,
                                child: new Icon(Icons.person_add, size: 22.0),
                              )),
                        ):Container(),
                      ),
                  ),
                ),
              ),
              new SizedBox(
                height: 13.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.only(left: 5.0),
                child: new Text(
                  "${userNameList.join(", ")}",
                  style: new TextStyle(
                      color: AppColors.kprojectTitle,
                      fontSize: 16.0,
                      fontFamily: AssetStrings.lotoSemiboldStyle),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              new SizedBox(
                height: 5.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.only(left: 5.0),
                child: new Text(
                  "Last message: $date",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: 14.0,
                      fontFamily: AssetStrings.lotoRegularStyle),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
