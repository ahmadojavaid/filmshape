import 'dart:collection';

import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/comment/reply_view_comment.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:Filmshape/ui/statelesswidgets/html_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FeedNormalType extends StatefulWidget {
  final Feed feed;
  final ValueChanged<Widget> fullScreenWidget;

  FeedNormalType(this.feed, this.fullScreenWidget);

  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<FeedNormalType>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FeedNormalType> {
  TabController tabBarController;
  int _tabIndex = 0;
  String image;

  HomeListProvider provider;
  String mediaurl;

  Feed feedProject = new Feed();

  String name = "";
  String role = "";
  String subrole = "";
  String time = "";

  List<String> list = new List();
  LinkedHashSet<String> listLocal = new LinkedHashSet();
  List<String> localRole = new List<String>();

  double currentIndexPage = 0.0;

  int indexs = 0;

  bool isVisible = false;


  Comments commentsLike = new Comments();

  @override
  void initState() {
    if (widget.feed != null) {
      feedProject = widget.feed;

      print("feed role ${feedProject.roleCall}");

      name = widget?.feed?.user?.fullName ?? "";

      if (widget.feed.project != null && widget.feed.project.created != null) {
        time = formatDateTimeString(widget.feed.project.created ?? "");
      }


      if (widget.feed.project != null &&
          widget.feed.project.projectRoleCalls != null&&widget.feed.project.projectRoleCalls.length>0) {
        ProjectRoleCallss roleCallss = widget.feed.project.projectRoleCalls[0];


        subrole = roleCallss.role?.name??"";
        role = roleCallss.role?.category?.name??"";
        if (roleCallss != null) {

          list.add(roleCallss.role?.iconUrl??"");
        }

        //   role = widget.feed.roleCall.category.name;
      }

      if (widget.feed.user != null) {
        list.add(widget.feed.user.thumbnailUrl);
      }
      feedProject.project.isLike = false;

      if (feedProject.project.likedBy != null) {
        var like = checkLikeUserId(feedProject.project.likedBy);
        feedProject.project.isLike = like;

        if (feedProject.comments != null) {

          for (var item in feedProject.comments) {
            if (item.replies != null && item.replies.length > 0) {
              for (var childData in item.replies) {
                if (childData.likedBy != null && childData.likedBy.length > 0) {
                  var like = checkLikeUserId(childData.likedBy);
                  childData?.isLike = like;
                }
              }
            }


            if (item.likedBy != null && item.likedBy.length > 0) {
              var like = checkLikeUserId(item.likedBy);
              item?.isLike = like;
            }
          }
        }
      }

      tabBarController =
          new TabController(initialIndex: _tabIndex, length: 4, vsync: this);
    }
  }



  Future<bool> likeUnlikeApi(int id, int type) async {
    var response =
        await provider.likeUnlikeProjectFeed(context, id, type, "Feed");

    if (response != null && (response is LikesResponse)) {
      feedProject.project.likedBy.length = response.likes;

      if (feedProject.project.isLike == null) {
        feedProject.project.isLike = false;
      }
      feedProject.project.isLike = !feedProject.project.isLike;

    }

    setState(() {});
  }

  Future<void> _moveToDetailScreen(int projectId) async {
    //project detail screen
    await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new JoinProjectDetails(
          projectId,
          previousTabHeading: community,
          fullScreenWidget: widget.fullScreenWidget,
        );
      }),
    );
  }


  var screensize;

  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery.of(context).size;
    provider = Provider.of<HomeListProvider>(context);

    return new Container(
      color: Colors.white,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getCommonHeader(list, 0,
              name: name,
              rolemain: role,
              subrole: subrole,
              time: time,
              userId: feedProject.user.id,
              context: context),


          Container(
            margin: new EdgeInsets.only(left: 32.0, right: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _moveToDetailScreen(feedProject.id);
                    },
                    child: HtmlTextWidget(widget.feed.message),
                  ),

                ),
                InkWell(
                  onTap: () {


                    if (feedProject != null) {
                      int types = feedProject.project.isLike != null &&
                          feedProject.project.isLike ? 0 : 1;
                      likeUnlikeApi(feedProject.project.id, types);
                    }

                  },
                  child: new SvgPicture.asset(AssetStrings.like,
                      width: 20,
                      height: 20,
                      color: feedProject.project.isLike
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack),
                ),
                new Text(
                  " ${feedProject.project.likedBy.length.toString()}",
                  style: new TextStyle(
                      fontSize: 15.0,
                      color: feedProject.project.isLike
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,
                      fontFamily: AssetStrings.lotoRegularStyle),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          new SizedBox(
            height: 30.0,
          ),
          Offstage(
            offstage: feedProject.comments == null ||
                feedProject.comments.length == 0 ? true : false,
            child: new Container(

              height: 1.0,
              color: AppColors.dividerColor,
            ),
          ),
          new Stack(
            children: <Widget>[

              _buildProjectList(feedProject?.comments??List<Comments>()),

              new Positioned(
                  left: 0.0,
                  child: Offstage(
                    offstage: feedProject.comments != null &&
                        feedProject.comments.length > 0 &&
                        feedProject.comments[0].replies.length > 0
                        ? false
                        : true,
                    child: new Container(
                      margin: new EdgeInsets.only(left: 49.0, top: 53.0),
                      width: 1.0,
                      height: 70.0,
                      color: AppColors.creatreProfileBordercolor,
                    ),
                  )),


              new Positioned(
                  left: 0.0,
                  child: Offstage(
                    offstage: feedProject.comments != null &&
                        feedProject.comments.length > 0 &&
                        feedProject.comments[0].replies.length > 1
                        ? false
                        : true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.only(left: 49.0, top: 155),
                          width: 1.0,
                          height: 80,
                          color: AppColors.creatreProfileBordercolor,
                        ),
                        Row(
                          children: <Widget>[
                            new SizedBox(
                              width: 43.9,
                            ),
                            new Container(
                              width: 12.0,
                              height: 12.0,
                              decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.kGrey.withOpacity(0.5)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
          new SizedBox(
            height: 20.0,
          ),
          new Container(
            height: 1,
            color: AppColors.dividerColor,
          ),
          new Container(
            height: 50.0,
            width: screensize.width,
            margin: new EdgeInsets.only(left: 20, right: 20),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                getRowWidget("Like", AssetStrings.like, 1,
                    callback: voidCallBackCount,
                    color: feedProject.project.isLike
                        ? AppColors.kPrimaryBlue
                        : AppColors.kHomeBlack),
                getRowWidget("Comment", AssetStrings.comment, 2,
                    color: AppColors.kHomeBlack,
                    callback: voidCallBackCount),
                getRowWidget("Share", AssetStrings.share, 3,
                    color: AppColors.kHomeBlack,
                    callback: voidCallBackCount)
              ],
            ),
          ),
          new Container(
            height: 20,
            decoration: new BoxDecoration(
              color: AppColors.tabBackground,
              border: Border(
                top: BorderSide(width: 1.0, color: AppColors.dividerColor),
                bottom: BorderSide(width: 1.0, color: AppColors.dividerColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {

        if (feedProject != null) {
          int types = feedProject.project.isLike != null &&
              feedProject.project.isLike ? 0 : 1;
          likeUnlikeApi(feedProject.project.id, types);
        }


      } else if (type == 2) {
        widget.fullScreenWidget(
            new CommentDetails(
              feedProject.project.id.toString(), "Feed",
              callback: voidCallBackComments,
              callBacklikeUnline: likeUnlikeCommentsCallback,
              callBackLikeProject: voidCallBackLike,
              fullScreenWidget: widget.fullScreenWidget,));
      }
      else {
        shareData();
      }
    }
  }


  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    {
      feedProject.project.isLike = isLIked;

      if (isLIked) {
        feedProject.project.likedBy.length =
            feedProject.project.likedBy.length + 1;
      }
      else {
        feedProject.project.likedBy.length =
            feedProject.project.likedBy.length - 1;
      }

      setState(() {});
    }
  }


  changeStatus(bool status, Comments comment) {
    print("model select call status");
    print("model select ${comment.id}");
    print("model select ${comment.isLike}");
    if (status) {
      comment?.isLike = true;
      comment?.likedBy.length = comment?.likedBy.length + 1;
    }
    else {
      comment?.isLike = false;
      comment?.likedBy.length = comment?.likedBy.length - 1;
    }
  }


  Future<ValueSetter> likeUnlikeCommentsCallback(DataModel model) async {
    print("model id ${model.name}");
    print("model select ${model.select}");


    if (feedProject.comments != null && feedProject.comments.length > 0) {
      for (int i = 0; i < feedProject.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == feedProject.comments[i].id.toString()) {
            changeStatus(model.select, feedProject.comments[i]);
          }
        }
        else {
          if (feedProject.comments[0] != null &&
              feedProject.comments[0].replies.length > 0) {
            var data = feedProject.comments[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == feedProject.comments[i].id.toString()) {
                changeStatus(model.select, feedProject.comments[i]);
              }
            }
          }
          else {
            if (model.name == feedProject.comments[i].id.toString()) {
              changeStatus(model.select, feedProject.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {

      });
    }
  }




  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      widget.feed.commentNumber = widget.feed.commentNumber + 1;

      /*  if(feedProject.comments==null)
        feedProject.comments=List<Comments>();*/

      /* feedProject.comments?.clear();*/

      feedProject.comments?.insert(0, comments);
      /*  feedProject.comments?.addAll(comments);*/
      setState(() {

      });
    }
  }


  Widget buildItemProject(Comments like, int index, int length,
      List<Comments> replies) {
    isVisible = false;
    String text = widget.feed.commentNumber > 2 ? "View ${widget.feed.commentNumber -
        2} more comments ->" : "";


    if (index == 1 && replies != null &&
        replies.length > 0) {
      isVisible = true;


//      text =
//      replies.length > 1 ? "View ${replies
//          .length - 1} more comments ->" : "";

      like = replies[0];
    }

    //reply comment text
    String replyCommentText = (like.replies_number == 0)
        ? " Reply"
        : (like.replies_number > 1)
            ? "${like.replies_number} Replies"
            : "${like.replies_number} Reply";

    var date = formatDateTimeString(like.created ?? "");
    return Container(
      child: Container(
        margin: new EdgeInsets.only(left: 32.0, right: 30.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  padding: new EdgeInsets.only(top: 7.0),
                  child: IntrinsicHeight(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[


                        InkWell(
                          onTap: () {
                            goToProfile(context, like.author.id.toString(),
                                like.author.fullName);
                          },
                          child: new Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: Colors.transparent, width: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: getCachedNetworkImageWithurl(
                                    url: like.author.thumbnailUrl,
                                    size: 35,
                                    fit: BoxFit.cover),
                              )),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: new BoxDecoration(
                                border: new Border.all(
                                  color: AppColors.commentBorder,
                                  width: 0.8,
                                ),
                                borderRadius: new BorderRadius.circular(8.0),
                                color: AppColors.CommentItemBackground),
                            child: Container(
                              padding: new EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[

                                      InkWell(
                                        onTap: () {
                                          goToProfile(context,
                                              like.author.id.toString(),
                                              like.author.fullName);
                                        },
                                        child: new Text(
                                          like.author.fullName != null
                                              ? like.author.fullName
                                              : "",
                                          style: new TextStyle(
                                              color: AppColors.topTitleColor,
                                              fontSize: 15.0,
                                              fontFamily:
                                              AssetStrings.lotoBoldStyle),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Expanded(
                                        child: new Text(
                                            " -$date",
                                            style: new TextStyle(
                                                color:
                                                AppColors.tabCommentColor,
                                                fontSize: 14.0,
                                                fontFamily: AssetStrings
                                                    .lotoRegularStyle),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.start),
                                      ),
                                    ],
                                  ),
                                  new SizedBox(
                                    height: 5.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: new EdgeInsets.only(right: 35.0),
                                      height: 36,
                                      child: new Text(
                                        like.content != null
                                            ? like.content
                                            : "",
                                        style: new TextStyle(
                                            color: AppColors.tabCommentColor,
                                            fontFamily:
                                            AssetStrings.lotoSemiboldStyle,
                                            fontSize: 15.0),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                new SizedBox(
                  height: 9.0,
                ),
                InkWell(
                  onTap: () {
                    indexs = index;
                    commentsLike = like;
                    widget.fullScreenWidget(new ReplyCommentDetails(
                      like.id
                          .toString(),
                      feedProject.project.id.toString(),
                      "Feed",
                      voidCallBackGetComment,
                      likeUnlikeCommentsCallback, like, fromHome: true,

                    ));
                  },
                  child: Container(
                    margin: new EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          AssetStrings.reply,
                          width: 16,
                          height: 16,
                        ),
                        new SizedBox(
                          width: 5.0,
                        ),
                        new Text(
                          replyCommentText,
                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 13.0,
                              fontFamily: AssetStrings.lotoRegularStyle),

                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    widget.fullScreenWidget(
                        new CommentDetails(feedProject.project.id.toString(), "Feed",
                          callback: voidCallBackComments,
                          callBacklikeUnline: likeUnlikeCommentsCallback,
                          callBackLikeProject: voidCallBackLike,
                          fullScreenWidget: widget.fullScreenWidget,));
                  },
                  child: Offstage(
                    offstage: index == 1 && length >= 2 ? false : true,
                    child: Container(
                      margin:
                      new EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        text,
                        style: new TextStyle(
                            color: AppColors.tabUnselectedBackground,
                            fontFamily: AssetStrings.lotoSemiboldStyle,
                            fontSize: 14.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              child: Container(
                padding: new EdgeInsets.only(bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        commentsLike = like;

                        if (like != null) {
                          int types = like.isLike != null && like.isLike
                              ? 0
                              : 1;
                          likeUnlikeCommentApi(like.id, types, index);
                        }
                      },
                      child: new Icon(
                        Icons.favorite,
                        size: 16.0,
                        color: like.isLike != null && like.isLike
                            ? AppColors.heartColor
                            : AppColors.heartGrey,
                      ),
                    ),
                    new SizedBox(
                      width: 2.0,
                    ),
                    new Text(
                      like.likedBy != null ? like.likedBy.length
                          .toString() : "0",
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
          ],
        ),
      ),
    );
  }

/*

  Future<ValueSetter> likeUnlikeCommentsCallback(DataModel model) async {
    print("model id ${model.name}");
    print("model select ${model.select}");

    for (var item in list) {
      if (item.replies != null && item.replies.length > 0) {
        var data = item.replies[0];


        if (data?.id.toString() == model.name) {
          if (model.select) {
            data?.isLike = true;
            data?.likedBy.length = data?.likedBy.length + 1;
          }
          else {
            data?.isLike = false;
            data?.likedBy.length = data?.likedBy.length - 1;
          }
        }
      }
    }
    */
/* widget.callback(list);*/ /*

    setState(() {

    });
  }
*/


  Future<ValueSetter> voidCallBackGetComment(int type) async {
    print("disjiofjdsiojfoisjdf");
    print("disjiofjdsiojfoisjdf $indexs");
    print("disjiofjdsiojfoisjdf $isVisible");
    print("disjiofjdsiojfoisjdf $type");
    // feedProject.comments.length=type-1;


    if (isVisible && indexs == 0) {
      feedProject.comments[0].replies.length = type - 1;
    }

    commentsLike.replies_number = type - 1;


    setState(() {

    });
    /*  getComments(0);*/
  }



  Future<bool> likeUnlikeCommentApi(int id, int type, int index) async {
    var response =
    await provider.likeUnlikeProjectFeed(context, id, type, "Comment");

    if (response != null && (response is LikesResponse)) {
      commentsLike.likedBy.length = response.likes;

      if (commentsLike?.isLike == null) {
        commentsLike?.isLike = false;
      }
      commentsLike?.isLike =
      !commentsLike?.isLike;



    }

    setState(() {});
  }


  _buildProjectList(List<Comments> comments) {
    int length = 0;

    if (comments != null && comments.length > 0) {
      length = comments.length;


      if (comments[0].replies != null && comments[0].replies.length > 0) {
        length = 2;

        if (comments.length == 1) {
          comments.add(comments[0].replies[0]);
        }
      }
    }

    return Offstage(
      offstage: comments?.length == 0 ? true : false,
      child: Container(
        height: (comments?.length??0) > 1 ? 250.0 : 110.0,
        margin: new EdgeInsets.only(top: 12.0),
        child: new ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            return buildItemProject(
              comments[index], index, comments.length, comments[0].replies,);
          },
            itemCount: length > 2 ? 2 : length
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}



Future<ValueSetter> likeUnlikeCommentsCallback(DataModel model) async {
  /* print("model id ${model.name}");
    print("model select ${model.select}");

    for (var item in list) {
      if (item.replies != null && item.replies.length > 0) {
        var data = item.replies[0];

        print("data id ${data.id}");
        print("data name ${data.content}");


        if (data?.id.toString() == model.name) {
          if (model.select) {
            data?.isLike = true;
            data?.likedBy.length = data?.likedBy.length + 1;
          }
          else {
            data?.isLike = false;
            data?.likedBy.length = data?.likedBy.length - 1;
          }
        }
      }
    }
    widget.callback(list);
    setState(() {

    });*/
}
