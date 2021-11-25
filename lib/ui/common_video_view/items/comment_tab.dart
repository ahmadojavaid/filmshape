import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/comment/reply_view_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CommentTab extends StatefulWidget {
  final List<Comments> liked;
  final ValueChanged<Widget> fullScreenWidget;
  final String projectId;
  final String model;
  final int commentNumber;
  final ValueChanged<bool> callbackLikeUnlikeProject;


  CommentTab(
      {this.fullScreenWidget, this.projectId, this.liked, this.model, this.commentNumber = 0, this.callbackLikeUnlikeProject});

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<CommentTab>
    with AutomaticKeepAliveClientMixin<CommentTab> {
  HomeListProvider provider;

  bool isVisible = false;
  int indexx = 0;

  Comments commentsLike = new Comments();
  int _totalComment=0;



  @override
  void initState() {
    super.initState();

    if (widget.liked != null && widget.liked.length > 0) {
      for (var item in widget.liked) {
        if (item.replies != null && item.replies.length > 0) {
          for (var childData in item.replies) {
            if (childData.likedBy != null && childData.likedBy.length > 0) {
              var like = checkLikeUserId(childData.likedBy);
              childData?.isLike = like;
            }
          }
        }


        if (item.likedBy != null && item.likedBy.length > 0) {
          var dataReoky = item.likedBy;

          item?.isLike = checkLikeUserId(dataReoky);
        }
      }
    }


     }

  _buildContestList() {
    int length = 0;

    if (widget.liked != null && widget.liked.length > 0) {
      length = widget.liked.length;


      if (widget.liked[0].replies != null &&
          widget.liked[0].replies.length > 0) {
        length = 2;

        if (widget.liked.length == 1) {
          widget.liked.add(widget.liked[0].replies[0]);
        }


      }

    }
    return Stack(
      children: <Widget>[
        Container(
          height: 250,
          margin: new EdgeInsets.only(top: 12.0),
          child: new ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: new EdgeInsets.all(0.0),
            itemBuilder: (BuildContext context, int index) {
              return buildItem(
                  widget.liked[index], index, widget.liked[0].replies);
            },
            itemCount: length > 2 ? 2 : length,
          ),
        ),

        new Positioned(
            left: 0.0,
            child: Offstage(
              offstage: widget.liked != null && widget.liked.length > 0 &&
                  widget.liked[0].replies.length > 0 ? false : true,
              child: new Container(
                margin: new EdgeInsets.only(left: 49.0, top: 64.0),
                width: 1.0,
                height: 61.5,
                color: AppColors.creatreProfileBordercolor,
              ),
            )),


        new Positioned(
            left: 0.0,
            child: Offstage(
              offstage: widget.liked != null &&
                  widget.liked.length > 0 &&
                  widget.liked[0].replies.length > 1
                  ? false
                  : true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: new EdgeInsets.only(left: 49.0, top: 159),
                    width: 1.0,
                    height: 63.0,
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
    );
  }


  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      /* print("project_details_comments ${comments.length}");
      widget.liked.clear();
      widget.liked.addAll(comments);*/

      widget.liked.insert(0, comments);

      _totalComment++;
      print("reply_count ${widget.commentNumber}");
      print("step2 $_totalComment}");
      setState(() {

      });
    }
  }


  Future<bool> likeUnlikeCommentApi(int id, int type, int index) async {
    var response =
    await provider.likeUnlikeProjectFeed(context, id, type, "Comment");

    if (response != null && (response is LikesResponse)) {
      commentsLike.likedBy.length = response.likes;
      if (commentsLike?.isLike == null) {
        commentsLike?.isLike = false;
      }
      commentsLike?.isLike = !commentsLike?.isLike;

      /*   widget.liked[index]?.likedBy.length = response.likes;
      if (widget.liked[index]?.isLike == null) {
        widget.liked[index]?.isLike = false;
      }
      widget.liked[index]?.isLike = !widget.liked[index]?.isLike;*/
    }

    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          new Container(
            color: Colors.white,
            child: new Column(
              children: <Widget>[
                _buildContestList(),
                new SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ),

          Offstage(
            offstage: widget.liked == null || widget.liked.length == 0
                ? false
                : true,
            child: Center(
              child: new Text(
                "No comments have been made yet.", style: new TextStyle(
                  color: AppColors.kHomeBlack,
                  fontSize: 15.0,
                  fontFamily: AssetStrings.lotoBoldStyle),),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(Comments likedBy, int index, List<Comments> replies) {
    var totalCommentNumber=widget.commentNumber+_totalComment;

    print("step 3$totalCommentNumber");
    String moreCommentText = totalCommentNumber > 2 ? "View ${totalCommentNumber -
        2} more comments ->" : "";

    isVisible = false;

    if (index == 1 && widget.liked[0].replies != null &&
        widget.liked[0].replies.length > 0) {
      isVisible = true;

//      text = widget.liked[0].replies.length > 1
//          ? "View ${widget.liked[0].replies.length - 1} more comments ->"
//          : "";

      likedBy = widget.liked[0].replies[0];
    }

    //reply comment text
    String replyCommentText = (likedBy.replies_number == 0)
        ? " Reply"
        : (likedBy.replies_number > 1)
            ? "${likedBy.replies_number} Replies"
            : "${likedBy.replies_number} Reply";

    var date = formatDateTimeString(likedBy.created ?? "");





    return Container(
      child: Container(
        margin: new EdgeInsets.only(left: 32.0, right: 32.0, top: 10.0),
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
                            goToProfile(context, likedBy.author.id.toString(),
                                likedBy.author.fullName);
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
                                    url:
                                    likedBy.author != null ? likedBy.author
                                        .thumbnailUrl : "",
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
                                              likedBy.author.id.toString(),
                                              likedBy.author.fullName);
                                        },
                                        child: new Text(
                                          widget.liked != null &&
                                              likedBy.author != null ? likedBy
                                              .author
                                              .fullName : "",
                                          style: new TextStyle(
                                              color: AppColors.topTitleColor,
                                              fontSize: 15.0,
                                              fontFamily: AssetStrings
                                                  .lotoBoldStyle),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      new Text(
                                        " -$date",
                                        style: new TextStyle(
                                            color: AppColors.tabCommentColor,
                                            fontSize: 14.5,
                                            fontFamily: AssetStrings
                                                .lotoRegularStyle),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  new SizedBox(
                                    height: 5.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: new EdgeInsets.only(right: 35.0),
                                      child: new Text(
                                        widget.liked != null &&
                                            likedBy.content != null
                                            ? likedBy.content
                                            : "",
                                        style: new TextStyle(
                                          color: AppColors.tabCommentColor,
                                          fontFamily: AssetStrings
                                              .lotoSemiboldStyle,
                                          fontSize: 15.0,),
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
                    indexx = index;
                    commentsLike = likedBy;
                    widget.fullScreenWidget(new ReplyCommentDetails(
                      likedBy.id
                          .toString(),
                      widget.projectId, widget.model,
                      voidCallBackGetComment,
                      likeUnlikeCommentsCallback,
                      likedBy, fromHome: true,));
                  },
                  child: Container(
                    margin: new EdgeInsets.only(left: 50.0, right: 50.0),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset(
                          AssetStrings.reply, width: 16, height: 16,),
                        new SizedBox(
                          width: 5.0,
                        ),
                        new Text(
                          replyCommentText,
                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 14.0,
                              fontFamily: AssetStrings.lotoRegularStyle),
                        ),
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: index == 1 ? false : true,
                  child: Container(
                    margin:
                    new EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0),
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: (){
                        widget.fullScreenWidget(new CommentDetails(
                          widget.projectId, widget.model != null ? widget
                            .model : "Project",
                          callBacklikeUnline: likeUnlikeCommentsCallback,
                          callBackLikeProject: voidCallBackLike,
                          callback: voidCallBackComments,));
                      },
                      child: new Text(
                        moreCommentText,
                        style: new TextStyle(
                            color: AppColors.tabUnselectedBackground,
                            fontFamily: AssetStrings.lotoRegularStyle,
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
                        commentsLike = likedBy;
                        if (likedBy != null) {
                          int type = likedBy.isLike != null && likedBy.isLike
                              ? 0
                              : 1;

                          likeUnlikeCommentApi(likedBy.id, type, index);
                        }
                      },
                      child: new Icon(
                        Icons.favorite,
                        size: 16.0,
                        color: likedBy.isLike != null && likedBy.isLike
                            ? AppColors.heartColor
                            : AppColors.heartGrey,
                      ),
                    ),
                    new SizedBox(
                      width: 2.0,
                    ),
                    new Text(
                      likedBy.likedBy != null ? likedBy.likedBy.length
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


  Future<ValueSetter> voidCallBackGetComment(int type) async {
    {

      if (isVisible && indexx == 0) {
        widget.liked[0].replies.length = type - 1;
      }

      commentsLike.replies_number = type - 1;


      setState(() {

      });
    }
  }


  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    if (widget.callbackLikeUnlikeProject != null) {
      widget.callbackLikeUnlikeProject(isLIked);
    }

    setState(() {

    });


    /*.isLike=isLIked;

      if(isLIked){

        widget.response.likedBy.length=    widget.response.likedBy.length+1;
      }
      else{

        widget.response.likedBy.length=    widget.response.likedBy.length-1;
      }


      setState(() {});
    }*/
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


    if (widget.liked != null && widget.liked.length > 0) {
      for (int i = 0; i < widget.liked.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == widget.liked[i].id.toString()) {
            changeStatus(model.select, widget.liked[i]);
          }
        }
        else {
          if (widget.liked[0] != null && widget.liked[0].replies.length > 0) {
            var data = widget.liked[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == widget.liked[i].id.toString()) {
                changeStatus(model.select, widget.liked[i]);
              }
            }
          }
          else {
            if (model.name == widget.liked[i].id.toString()) {
              changeStatus(model.select, widget.liked[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {

      });
    }
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

