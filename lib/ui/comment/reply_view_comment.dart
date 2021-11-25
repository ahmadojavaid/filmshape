import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/comment/CommentRequest.dart';
import 'package:Filmshape/Model/comment/get_comment_response.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/read_more_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class ReplyCommentDetails extends StatefulWidget {
  final String id;
  final String projectid;
  final String model;
  final ValueSetter<int> callback;
  final ValueSetter<DataModel> callbackLikeUnlike;
  final Comments comments;
  final bool fromNotification;
  final bool fromHome;

  ReplyCommentDetails(this.id, this.projectid, this.model, this.callback,
      this.callbackLikeUnlike, this.comments,
      {this.fromNotification, this.fromHome});

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<ReplyCommentDetails> {
  List<Comments> list = new List();

  bool itemValue = false;

  ScrollController _scrollController = new ScrollController();

  // Controllers
  final TextEditingController _newMessageFieldController =
      new TextEditingController();

  HomeListProvider provider;
  Notifier _notifier;

  @override
  void initState() {
    // TODO: implement initState'

    if (widget.fromNotification != null && widget.fromNotification) {
      Future.delayed(const Duration(milliseconds: 200), () {
        getTHreadComments();
      });
    } else {
      Future.delayed(const Duration(milliseconds: 300), () {
        getReplyComments();
        pauseVideoIfAnyPlaying();
      });
    }

    super.initState();
  }

  void pauseVideoIfAnyPlaying() {
    //moving to comment section pause running video if any
    _notifier?.notify('pausevideo', "pausevideo"); //update heading

    //call the pause video notifier with null to avoid frequent call of notifier
    //which might cause to pause resume of video
    Future.delayed(const Duration(milliseconds: 50), () {
      _notifier?.notify('pausevideo', null); //
    });
  }

  postReplyComment(String id) async {
    provider.setLoading();

    ReplyTo reply = new ReplyTo(type: "Comment", id: int.parse(id));

    CommentRequest request = new CommentRequest(
        content: _newMessageFieldController.text, replyTo: reply);

    var response = await provider.postComments(
        widget.projectid, context, request, widget.model);

    if (response != null && (response is Comments)) {
      try {
        list.insert(1, response);
      } on Exception catch (exception) {} catch (error) {}

      _newMessageFieldController.text = "";
      _scrollController.animateTo(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );

      if (widget.fromHome != null &&
          widget.fromHome &&
          widget.callback != null) {
        print("call back");

        widget.callback(list.length);
      } else {
        print("call back not");

        widget.callback(1);
      }

      setState(() {});
    } else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar("Getting Failed");
    }
  }

  Future<bool> likeUnlikeCommentApi(int id, int type, int index) async {
    var response =
        await provider.likeUnlikeProjectFeed(context, id, type, "Comment");

    if (response != null && (response is LikesResponse)) {
      list[index].likedBy.length = response.likes;

      if (list[index].isLike == null) {
        list[index].isLike = false;
      }
      list[index].isLike = !list[index].isLike;

      /*  if (type == 1) {
        list[index].isLike = true;
      } else {
        list[index].isLike = false;
      }*/

      var datamodel = new DataModel(
          name: list[index].id.toString(), select: list[index].isLike);

      widget.callbackLikeUnlike(datamodel);
    } else {}

    setState(() {});
  }

  getTHreadComments() async {
    print("projectid ${widget.id}");
    print("projectModel ${widget.model}");

    provider.setLoading();

    var response = await provider.getThreadComments(widget.id, context);

    provider.hideLoader();

    if (response is GetCommentMainResponse) {
      list.clear();
      list.addAll(response.data);
      print("list ${list.length}");

      for (var item in list) {
        if (item.likedBy != null && item?.likedBy?.length > 0) {
          var like = checkLikeUserId(item.likedBy);

          if (like) {
            item?.isLike = true;
          } else {
            item?.isLike = false;
          }
        }

        if (item.replies != null && item.replies.length > 0) {
          var dataReoky = item.replies[0];

          var like = checkLikeUserId(dataReoky.likedBy);

          if (like) {
            dataReoky?.isLike = true;
          } else {
            dataReoky?.isLike = false;
          }
        }
      }

      setState(() {});
    } else {
      APIError apiError = response;
    }
  }

  getReplyComments() async {
    provider.setLoading();
    var response =
        await provider.getReplyComments(widget.id, context, widget.model);

    if (response != null && (response is GetCommentMainResponse)) {
      list.addAll(response.data);
      _scrollController.animateTo(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );

      for (var item in list) {
        if (item.likedBy != null && item?.likedBy?.length > 0) {
          var like = checkLikeUserId(item.likedBy);

          if (like) {
            item?.isLike = true;
          } else {
            item?.isLike = false;
          }

          /*  for (var data in item.likedBy) {
            var id = MemoryManagement.getuserId();
            if (data?.id.toString() == id) {
              item?.isLike = true;
            }
            else {
              item?.isLike = false;
            }
          }*/
        }
      }

      if (widget.comments != null) {
        list.insert(0, widget.comments);
      }

      setState(() {});
    } else {
      APIError apiError = response;
    }
  }

  // Returns write Message field bar
  get _getWriteMessageFieldBar {
    return new Container(
      width: getScreenSize(context: context).width,
      decoration: new BoxDecoration(
        border: new Border(
          top: new BorderSide(width: 0.8, color: AppColors.dividerColors),
        ),
      ),
      padding: new EdgeInsets.symmetric(
        vertical: 14.0,
        horizontal: 12.0,
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              height: 42.0,
              margin: new EdgeInsets.only(left: 15.0, right: 15.0),
              constraints: const BoxConstraints(
                maxHeight: 90.0,
              ),
              child: new TextField(
                controller: _newMessageFieldController,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: AppColors.fontBlackColor,
                  fontFamily: AssetStrings.lotoRegularStyle,
                ),
                maxLines: null,
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: Colors.red,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  enabledBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: AppColors.chatButtonBorder,
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide: new BorderSide(
                      color: AppColors.textColors,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  contentPadding: new EdgeInsets.only(
                      left: 20.0, right: 20, top: 10, bottom: 0),
                  fillColor: AppColors.CommentItemBackground,
                  filled: true,
                  hintText: "Write a comment...",
                  hintStyle: new TextStyle(
                      fontSize: 14.0,
                      fontFamily: AssetStrings.lotoRegularStyle,
                      color: AppColors.fontBlackColor),
                  suffixIcon: new IconButton(
                    icon: new Icon(
                      Icons.send,
                      color: AppColors.fontBlackColor,
                      size: 18,
                    ),
                    onPressed: () {
                      if (_newMessageFieldController.text.length > 0) {
                        print("dljfljdsf");
                        postReplyComment(widget.id);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget buildItemSingleComment(int index, Comments response) {
    var date = formatDateTimeString(response.created ?? "");
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(
                left: index == 0 ? 25 : 40, right: 30, top: 12.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.only(top: 7.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              goToProfile(
                                  context,
                                  response.author.id.toString(),
                                  response.author.fullName,
                                  fromComments: true);
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
                                      url: response.author.thumbnailUrl,
                                      size: index == 0 ? 40 : 35),
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
                                            goToProfile(
                                                context,
                                                response.author.id.toString(),
                                                response.author.fullName,
                                                fromComments: true);
                                          },
                                          child: new Text(
                                            response.author.fullName,
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
                                    /*  Expanded(
                                      child: Container(
                                        padding:
                                        new EdgeInsets.only(right: 35.0),
                                        height: 36,
                                        child: new Text(
                                          response.content,
                                          style: new TextStyle(
                                              color:
                                              AppColors.tabCommentColor,
                                              fontFamily: AssetStrings
                                                  .lotoSemiboldStyle,
                                              fontSize: 14.0),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
*/
                                    ReadMoreText(
                                      response.content,
                                      trimLines: 2,
                                      colorClickableText:
                                          AppColors.kPrimaryBlue,
                                      trimMode: TrimMode.Line,
                                      style: new TextStyle(
                                        color: AppColors.tabCommentColor,
                                        fontFamily:
                                            AssetStrings.lotoSemiboldStyle,
                                        fontSize: 15.0,
                                      ),
                                      trimCollapsedText: '..show more',
                                      trimExpandedText: ' show less',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new SizedBox(
                      height: 9.0,
                    ),
                    /* Container(
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
                            "Reply",
                            style: new TextStyle(
                                color: Colors.black87,
                                fontSize: 13.0,
                                fontFamily: AssetStrings.lotoRegularStyle),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),*/
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
                            if (response != null) {
                              int type =
                                  response.isLike != null && response.isLike
                                      ? 0
                                      : 1;
                              likeUnlikeCommentApi(response.id, type, index);
                            }
                          },
                          child: new Icon(
                            Icons.favorite,
                            size: 16.0,
                            color: response.isLike != null && response.isLike
                                ? AppColors.heartColor
                                : AppColors.heartGrey,
                          ),
                        ),
                        new SizedBox(
                          width: 2.0,
                        ),
                        new Text(
                          response.likedBy != null
                              ? response.likedBy.length.toString()
                              : "0",
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
          new SizedBox(
            height: 12.0,
          ),
          new Container(
            height: 1,
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  VoidCallback backButtonPressed() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    _notifier = NotifierProvider.of(
        context); // to update video player if running on previous screen
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: appBarBackButton(onTap: backButtonPressed),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: new EdgeInsets.only(top: 10.0),
                          child: new ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                return buildItemSingleComment(
                                    index, list[index]);
                              },
                              itemCount: list.length),
                        ),
                      ),
                      _getWriteMessageFieldBar,
                    ],
                  ),
                ),
                Offstage(
                  offstage: list.length == 0 ? false : true,
                  child: Container(
                    margin: new EdgeInsets.only(bottom: 60.0),
                    child: new Center(
                        child: new Text(
                      "No Comment Found",
                      style: new TextStyle(
                          color: AppColors.kPrimaryBlue,
                          fontSize: 15.0,
                          fontFamily: AssetStrings.lotoBoldStyle),
                    )),
                  ),
                ),
              ],
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
}
