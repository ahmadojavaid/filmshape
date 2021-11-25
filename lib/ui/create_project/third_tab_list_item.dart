import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/comment/reply_view_comment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ThirdTabListItem extends StatefulWidget {

  
  final ValueChanged<Widget> fullScreenWidget;

  ThirdTabListItem(this.fullScreenWidget);

  @override
  _ThirdTabListItemState createState() => _ThirdTabListItemState();
}

class _ThirdTabListItemState extends State<ThirdTabListItem> {

  HomeListProvider provider;
  CreateProfileSecondProvider createProfileSecondProvider;
  Comments commentsLike = new Comments();

  bool isVisible = false;
  int indexx = 0;
  int moreCommentCount;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  
  Future<void> _checkCommentReplyLike()
  {
    if (createProfileSecondProvider.projectResponse.comments != null &&
        createProfileSecondProvider.projectResponse.comments.length > 0) {
      for (var item in createProfileSecondProvider.projectResponse.comments) {
        if (item.replies != null && item.replies.length > 0) {
          for (var childData in item.replies) {
            if (childData.likedBy != null && childData.likedBy.length > 0) {
              var like = checkLikeUserId(childData.likedBy);
              item?.isLike = like;
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

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    createProfileSecondProvider = Provider.of<CreateProfileSecondProvider>(context);

    return Container(
      child: new Stack(
        children: <Widget>[
          _buildProjectList(),

          new Positioned(
              left: 0.0,
              child: Offstage(
                offstage: createProfileSecondProvider.projectResponse.comments != null &&
                    createProfileSecondProvider.projectResponse.comments.length > 0 &&
                    createProfileSecondProvider.projectResponse.comments[0].replies.length > 0
                    ? false
                    : true,
                child: new Container(
                  margin: new EdgeInsets.only(left: 61.0, top: 53.0),
                  width: 1.0,
                  height: 68.0,
                  color: AppColors.creatreProfileBordercolor,
                ),
              )),
          new Positioned(
              left: 0.0,
              child: Offstage(
                offstage: createProfileSecondProvider.projectResponse.comments != null &&
                    createProfileSecondProvider.projectResponse.comments.length > 0 &&
                    createProfileSecondProvider.projectResponse.comments[0].replies.length > 1
                    ? false
                    : true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 61.0, top: 153),
                      width: 1.0,
                      height: 80.0,
                      color: AppColors.creatreProfileBordercolor,
                    ),
                    Row(
                      children: <Widget>[
                        new SizedBox(
                          width: 55.9,
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
              )),

          Positioned(
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: Offstage(
              offstage:
                  (createProfileSecondProvider.projectResponse.comments?.length??0) > 0 ? true : false,

              child: Container(
                child: new Center(
                    child: new Text("No Comment Found", style: new TextStyle(
                        color: AppColors.kPrimaryBlue,
                        fontSize: 15.0,
                        fontFamily: AssetStrings.lotoBoldStyle),)
                ),
              ),
            ),
          ),
          /*  _buildProjectList()*/
        ],
      ),
    );
  }

  _buildProjectList() {

    moreCommentCount=createProfileSecondProvider.projectResponse?.moreCommentNo??0-2;
    if (createProfileSecondProvider.projectResponse.comments != null &&
        createProfileSecondProvider.projectResponse.comments.length > 0) {
    //  length = createProfileSecondProvider.projectResponse.comments.length;


      if (createProfileSecondProvider.projectResponse.comments[0].replies != null &&
          createProfileSecondProvider.projectResponse.comments[0].replies.length > 0) {
       // length = 2;

        if (createProfileSecondProvider.projectResponse.comments.length == 1) {
          createProfileSecondProvider.projectResponse.comments.add(createProfileSecondProvider.projectResponse.comments[0].replies[0]);
        }
      }
    }
    var commentLen=createProfileSecondProvider.projectResponse.comments?.length??0;
    return Container(
      height: 250.0,
      margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0),
      child: new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: new EdgeInsets.all(0.0),
        itemBuilder: (BuildContext context, int index) {
          return buildItemProject(index, createProfileSecondProvider.projectResponse.comments[index]);
        },
        itemCount:  commentLen> 2 ? 2 : commentLen,
      ),
    );
  }

  Widget buildItemProject(int index, Comments comment) {
    _checkCommentReplyLike();

    String text = moreCommentCount > 2 ? "View ${moreCommentCount-2} more comments ->" : "";

    isVisible = false;

    if (index == 1 && createProfileSecondProvider.projectResponse?.comments[0].replies != null &&
        createProfileSecondProvider.projectResponse?.comments[0].replies.length > 0) {
      isVisible = true;


//      text =
//      createProfileSecondProvider.projectResponse?.comments[0].replies.length > 1 ? "View ${createProfileSecondProvider.projectResponse
//          ?.comments[0].replies
//          .length - 1} more comments ->" : "";

      comment = createProfileSecondProvider.projectResponse?.comments[0].replies[0];
    }


    var date = formatDateTimeString(comment?.created ?? "");
    return Container(
      child: Container(
        margin: new EdgeInsets.only(left: 40.0, right: 30.0),
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
                            goToProfile(context, comment.author.id.toString(),
                                comment.author.fullName.toString());
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
                                    comment?.author != null ? comment.author
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
                                              comment.author.id.toString(),
                                              comment.author.fullName
                                                  .toString());
                                        },
                                        child: new Text(
                                          createProfileSecondProvider.projectResponse != null &&
                                              comment.author != null ? comment
                                              .author
                                              .fullName : "",
                                          style: new TextStyle(
                                              color: AppColors.topTitleColor,
                                              fontSize: 15.0,
                                              fontFamily:
                                              AssetStrings.lotoBoldStyle),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      new Text(
                                        " -$date",
                                        style: new TextStyle(
                                            color: AppColors.tabCommentColor,
                                            fontSize: 14.0,
                                            fontFamily:
                                            AssetStrings.lotoRegularStyle),
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
                                        createProfileSecondProvider.projectResponse != null &&
                                            comment.content != null
                                            ? comment.content
                                            : "",
                                        style: new TextStyle(
                                          color: AppColors.tabCommentColor,
                                          fontFamily:
                                          AssetStrings.lotoSemiboldStyle,
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
                Container(
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
                      InkWell(
                        onTap: () {
                          commentsLike = comment;

                          indexx = index;
                          widget.fullScreenWidget(new ReplyCommentDetails(
                            comment.id
                                .toString(),
                            createProfileSecondProvider.projectResponse.id.toString(),
                            "Project",
                            voidCallBackGetComment,
                            likeUnlikeCommentsCallback, comment,
                            fromHome: true,));
                        },
                        child: new Text(


                          comment.replies_number != null &&
                              comment.replies_number > 1 ? "${comment
                              .replies_number} Replies" : comment
                              .replies_number != null &&
                              comment.replies_number == 1 ? "1 Reply" : "Reply",

                          style: new TextStyle(
                              color: Colors.black87,
                              fontSize: 13.0,
                              fontFamily: AssetStrings.lotoRegularStyle),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("djcnsdnsd");
                    widget.fullScreenWidget(new CommentDetails(
                      createProfileSecondProvider.projectResponse.id.toString(), "Project",
                      callback: voidCallBackComments,
                      callBackLikeProject: voidCallBackLike,
                      callBacklikeUnline: likeUnlikeCommentsCallback,
                      fullScreenWidget: widget.fullScreenWidget,));
                  },
                  child: Offstage(
                    offstage: index == 1 ? false : true,
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
                        if (comment != null) {
                          commentsLike = comment;
                          int type = comment.isLike != null && comment.isLike
                              ? 0
                              : 1;
                          likeUnlikeCommentApi(comment.id, type, index);
                        }
                      },
                      child: new Icon(
                        Icons.favorite,
                        size: 16.0,
                        color: comment.isLike != null && comment.isLike
                            ? AppColors.heartColor
                            : AppColors.heartGrey,
                      ),
                    ),
                    new SizedBox(
                      width: 2.0,
                    ),
                    new Text(
                      comment.likedBy != null ? comment.likedBy.length
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
        createProfileSecondProvider.projectResponse.comments[0].replies.length = type - 1;
      }
      commentsLike.replies_number = type - 1;
      setState(() {

      });
    }
  }


  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    {
      createProfileSecondProvider.projectResponse.isLike = isLIked;

      if (isLIked) {
        createProfileSecondProvider.projectResponse.likedBy.length =
            createProfileSecondProvider.projectResponse.likedBy.length + 1;
      }
      else {
        createProfileSecondProvider.projectResponse.likedBy.length =
            createProfileSecondProvider.projectResponse.likedBy.length - 1;
      }

      setState(() {});
    }
  }



  Future<bool> likeUnlikeCommentApi(int id, int type, int index) async {
    var response =
    await provider.likeUnlikeProjectFeed(context, id, type, "Comment");

    if (response != null && (response is LikesResponse)) {
      /* createProfileSecondProvider.projectResponse?.comments[index]?.likedBy.length = response.likes;*/

      commentsLike.likedBy.length = response.likes;

      if (commentsLike?.isLike == null) {
        commentsLike?.isLike = false;
      }
      commentsLike?.isLike =
      !commentsLike?.isLike;


      /* if (createProfileSecondProvider.projectResponse?.comments[index]?.isLike == null) {
        createProfileSecondProvider.projectResponse?.comments[index]?.isLike = false;
      }
      createProfileSecondProvider.projectResponse?.comments[index]?.isLike =
      !createProfileSecondProvider.projectResponse?.comments[index]?.isLike;*/

      /* if (type == 1) {
        createProfileSecondProvider.projectResponse?.comments[index]?.isLike = true;
      } else {
        createProfileSecondProvider.projectResponse?.comments[index]?.isLike = false;
      }*/

    }

    setState(() {});
  }

  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {

       print("comment_done ${createProfileSecondProvider.projectResponse.moreCommentNo}");
      createProfileSecondProvider.projectResponse.moreCommentNo+=1;
      createProfileSecondProvider.projectResponse?.comments?.insert(0, comments);
      setState(() {

      });
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


    if (createProfileSecondProvider.projectResponse?.comments != null &&
        createProfileSecondProvider.projectResponse?.comments.length > 0) {
      for (int i = 0; i < createProfileSecondProvider.projectResponse?.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == createProfileSecondProvider.projectResponse?.comments[i].id.toString()) {
            changeStatus(model.select, createProfileSecondProvider.projectResponse?.comments[i]);
          }
        }
        else {
          if (createProfileSecondProvider.projectResponse?.comments[0] != null &&
              createProfileSecondProvider.projectResponse?.comments[0].replies.length > 0) {
            var data = createProfileSecondProvider.projectResponse?.comments[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == createProfileSecondProvider.projectResponse?.comments[i].id.toString()) {
                changeStatus(model.select, createProfileSecondProvider.projectResponse?.comments[i]);
              }
            }
          }
          else {
            if (model.name == createProfileSecondProvider.projectResponse?.comments[i].id.toString()) {
              changeStatus(model.select, createProfileSecondProvider.projectResponse?.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {

      });
    }
  }

}




