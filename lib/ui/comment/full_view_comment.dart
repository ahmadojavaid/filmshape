import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/comment/CommentRequest.dart';
import 'package:Filmshape/Model/comment/get_comment_response.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/read_more_text.dart';
import 'package:Filmshape/ui/comment/reply_view_comment.dart';
import 'package:Filmshape/ui/statelesswidgets/html_text_widget.dart';
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class CommentDetails extends StatefulWidget {
  final String projectId;
  final String model;
  final ValueSetter<Comments> callback;
  final ValueChanged<Widget> fullScreenWidget;
  final ValueChanged<DataModel> callBacklikeUnline;
  final ValueChanged<bool> callBackLikeProject;


  CommentDetails(this.projectId, this.model,
      {this.callback, this.fullScreenWidget, this.callBacklikeUnline, this.callBackLikeProject});


  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<CommentDetails>
    with AutomaticKeepAliveClientMixin<CommentDetails> {
  List<Comments> list = new List();
  List<String> listRole = new List();

  bool itemValue = false;

  ProjectResponse projectResponse = new ProjectResponse();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // Controllers
  final TextEditingController _newMessageFieldController =
      new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  HomeListProvider providers;
  CreateProfileSecondProvider provider;

  String name = "";
  String role = "";
  String subrole = "";
  String time = "";
  int userId = 0;

  Comments commentsModel;
  Reply replyModel;
  final GlobalKey<YoutubeVimeoInappBrowserState> _videoScreenKey =
  new GlobalKey<YoutubeVimeoInappBrowserState>();
  Notifier _notifier;

  @override
  void initState() {
    // TODO: implement initState


    Future.delayed(const Duration(milliseconds: 200), () {
      _hitAapi();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      getComments(1);
      pauseVideoIfAnyPlaying(); //pause if any video playing in previous screen
    });

    super.initState();
  }

  void pauseVideoIfAnyPlaying()
  {
    //moving to comment section pause running video if any
    _notifier?.notify('pausevideo', "pausevideo"); //update heading

    //call the pause video notifier with null to avoid frequent call of notifier
    //which might cause to pause resume of video
    Future.delayed(const Duration(milliseconds: 50), () {
      _notifier?.notify('pausevideo', null); //
    });
  }

  void _hitAapi() async
  {
    var response = await provider.getProjectDetails(widget.projectId, context);
    print("project response $response");
    if (response is ProjectResponse) {
      projectResponse = response;


      if (projectResponse.creator != null &&
          projectResponse.creator.fullName != null) {
        name = projectResponse.creator.fullName;
      }

      if (projectResponse.projectRoleCalls != null &&
          projectResponse.projectRoleCalls.length > 0) {
        ProjectRoleCalls roleCallss = projectResponse.projectRoleCalls[0];


        subrole = roleCallss.role.name;
        role = roleCallss.role.category.name;
        if (roleCallss != null) {
          listRole.add(roleCallss.role.iconUrl);
        }
      }

      if (projectResponse != null && projectResponse.created != null) {
        time = formatDateTimeString(projectResponse.created ?? "");
      }


      if (projectResponse.creator != null) {
        listRole.add(projectResponse.creator.thumbnailUrl);
        userId = projectResponse.creator.id;
      }


      if (projectResponse.likedBy != null &&
          projectResponse.likedBy.length > 0) {
        var like = checkLikeUserId(projectResponse.likedBy);

        if (like) {
          projectResponse?.isLike = true;
        }
        else {
          projectResponse?.isLike = false;
        }
      }


      setState(() {

      });
    } else {
      APIError apiError = response;
    }
  }




  Future<ValueSetter> voidCallBackGetComment(int type) async {
    {
      getComments(0);
    }
  }


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
    /* widget.callback(list);*/
    setState(() {

    });
  }


  Widget getTop() {
    return new Column(
      children: <Widget>[
        getCommonHeader(listRole, 0,
            name: name,
            rolemain: role,
            subrole: subrole,
            time: time,
            userId: userId,
            context: context),
        Container(
          margin: new EdgeInsets.only(left: 32.0, right: 30.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: HtmlTextWidget(projectResponse.title),
              ),
              InkWell(
                onTap: () {
                  if (projectResponse != null) {
                    int types = projectResponse.isLike != null &&
                        projectResponse.isLike ? 0 : 1;
                    likeUnlikeApi(projectResponse.id, types);
                  }
                },
                child: new SvgPicture.asset(
                  AssetStrings.like,
                  width: 20,
                  height: 20,
                  color: projectResponse.isLike != null &&
                      projectResponse.isLike
                      ? AppColors.kPrimaryBlue
                      : AppColors.kHomeBlack,
                ),
              ),
              new Text(
                " ${projectResponse.likedBy.length.toString()}",
                style: TextStyle(
                    fontSize: 15.0,
                    color:
                        projectResponse.isLike != null && projectResponse.isLike
                            ? AppColors.kPrimaryBlue
                            : AppColors.kHomeBlack,
                    fontFamily: AssetStrings.lotoRegularStyle),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !(projectResponse.mediaEmbed != null &&
              projectResponse.mediaEmbed.length > 0),
          child: Container(
            margin: const EdgeInsets.only(top:15),
            height: LIST_PLAYER_HEIGHT,
            child: Container(
              child: (projectResponse.mediaEmbed != null &&
                      projectResponse.mediaEmbed.length > 0)
                  ? YoutubeVimeoInappBrowser(projectResponse.mediaEmbed,
                      key: _videoScreenKey)
                  : Container(),
              decoration: new BoxDecoration(
                color: Colors.black.withOpacity(0.8),
              ),
            ),
          ),
        ),
        new SizedBox(
          height: 20.0,
        ),
      ],
    );
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
                      width: 1,
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
                      color: AppColors.fontBlackColor
                  ),
                  suffixIcon: new IconButton(
                    icon: new Icon(
                      Icons.send, color: AppColors.fontBlackColor, size: 18,),
                    onPressed: () {
                      if (_newMessageFieldController.text.length > 0) {
                        postComment();
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

  postComment() async {
    providers.setLoading();

    CommentRequest request =
        new CommentRequest(content: _newMessageFieldController.text);

    var response = await providers.postComments(
        widget.projectId, context, request, widget.model);

    if (response is Comments) {
      list.insert(0, response);
      _newMessageFieldController.text = "";
      var scrollToIndex=0.0;
      if(projectResponse.mediaEmbed != null)
        {
          scrollToIndex=1.0;
        }
      _scrollController.animateTo(
        scrollToIndex,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );

      if (list != null && list.length > 0) {
        widget.callback(list[0]);
      }


      print("list ${list.length}");

      setState(() {});
    } else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar(apiError.error);
    }
  }


  Future<bool> likeUnlikeCommentApi(int id, int type, int viewType,
      Comments comments, { Comments reply}) async {
    var response =
    await providers.likeUnlikeProjectFeed(context, id, type, "Comment");

    if (response != null && (response is LikesResponse)) {
      if (viewType == 1) {
        comments.likedBy.length = response.likes;
        if (comments.isLike == null) {
          comments.isLike = false;
        }
        comments.isLike = !comments.isLike;
        /* if (type == 1) {
          comments.isLike = true;
        } else {
          comments.isLike = false;
        }*/
      }
      else {
        reply.likedBy.length = response.likes;
        if (reply.isLike == null) {
          reply.isLike = false;
        }
        reply.isLike = !reply.isLike;
        /* if (type == 1) {
          reply.isLike = true;
        } else {
          reply.isLike = false;
        }*/
      }
    }
    if (widget.callBacklikeUnline != null) {
      var datamodel = new DataModel(
          name: id.toString(),
          select: viewType == 1 ? comments.isLike : reply.isLike);

      widget.callBacklikeUnline(datamodel);
    }



    setState(() {});
  }


  Future<bool> likeUnlikeApi(int id, int type,) async {
    var response =
    await providers.likeUnlikeProjectFeed(context, id, type, widget.model);

    if (response != null && (response is LikesResponse)) {
      projectResponse.likedBy.length = response.likes;
      if (projectResponse.isLike == null) {
        projectResponse.isLike = false;
      }
      projectResponse.isLike = !projectResponse.isLike;

      if (widget.callBackLikeProject != null) {
        widget.callBackLikeProject(projectResponse.isLike);
      }
    }

    setState(() {});
  }




  getComments(int type) async {
    print("projectid ${widget.projectId}");
    print("projectModel ${widget.model}");
    if (type == 1) {
      providers.setLoading();
    }

    var response = await providers.getComments(
        widget.projectId, context, widget.model);

    if (response is GetCommentMainResponse) {
      list.clear();
      list.addAll(response.data);
      print("list ${list.length}");

      /*    if(list!=null && list.length>0){

        widget.callback(list[0]);
      }*/

      /*   _scrollController.animateTo(
        0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );*/
      for (var item in list) {
        if (item.likedBy != null &&
            item?.likedBy?.length > 0) {
          var like = checkLikeUserId(item.likedBy);

          if (like) {
            item?.isLike = true;
          }
          else {
            item?.isLike = false;
          }


          /* for (var data in item.likedBy) {
            var id = MemoryManagement.getuserId();
            if (data?.id.toString() == id) {
              item?.isLike = true;
            }
            else {
              item?.isLike = false;
            }
          }*/
        }

        if (item.replies != null && item.replies.length > 0) {
          var dataReoky = item.replies[0];

          var like = checkLikeUserId(dataReoky.likedBy);

          if (like) {
            dataReoky?.isLike = true;
          }
          else {
            dataReoky?.isLike = false;
          }

          /*  for (var data in dataReoky.likedBy) {
            var id = MemoryManagement.getuserId();
            if (data?.id.toString() == id) {
              dataReoky?.isLike = true;
            }
            else {
              dataReoky?.isLike = false;
            }
          }*/
        }
      }

      setState(() {});

    } else {
      APIError apiError = response;

    }
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value)));
  }


  getFeaturedProjects(Comments response, int index) {
    return response.replies != null && response.replies.length > 0
        ? buildItem(response, response.replies[0])
        : buildItemSingleComment(response, index);
  }


  Widget buildItem(Comments model, Comments reply) {
    return new Container(
      color: Colors.white,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /*  new SizedBox(
            height: 10.0,
          ),*/
          new Stack(
            children: <Widget>[
              _buildProjectList(model, reply),
              new Positioned(
                  left: 0.0,
                  child: Offstage(
                    offstage: false,
                    child: new Container(
                      margin: new EdgeInsets.only(left: 61.0, top: 54.0),
                      width: 1.0,
                      height: 67.0,
                      color: AppColors.creatreProfileBordercolor,
                    ),
                  )),
              new Positioned(
                  left: 0.0,
                  child: Offstage(
                    offstage: model.replies != null && model.replies.length > 1
                        ? false
                        : true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          margin: new EdgeInsets.only(left: 61.0, top: 155),
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
                  ))
            ],
          ),
          new SizedBox(
            height: 10.0,
          ),
          new Container(
            height: 1,
            color: AppColors.dividerColor,
          ),
        ],
      ),
    );
  }

  _buildProjectList(Comments model, Comments reply) {
    return Container(
      height: model.replies != null && model.replies.length > 1 ? 250.0 : 210,
      margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 12.0),
      child: new ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            return buildItemProject(model, index, reply);
          },
          itemCount: 2),
    );
  }

  Widget buildItemProject(Comments model, int index, Comments reply) {
    var date = formatDateTimeString(model.created ?? "");
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
                            goToProfile(context,
                                index == 0 ? model.author.id.toString() : reply
                                    .author.id.toString(), index == 0
                                    ? model.author.fullName.toString()
                                    : reply.author.fullName.toString(),
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
                                    url: index == 0
                                        ? model.author.thumbnailUrl
                                        : reply.author.thumbnailUrl, size: 35),
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
                                              index == 0 ? model.author.id
                                                  .toString() : reply.author.id
                                                  .toString(),
                                              index == 0 ? model.author.fullName
                                                  .toString() : reply.author
                                                  .fullName.toString(),
                                              fromComments: true);
                                        },
                                        child: new Text(
                                          index == 0
                                              ? model.author.fullName
                                              : reply.author.fullName,
                                          style: new TextStyle(
                                              color: AppColors.topTitleColor,
                                              fontSize: 14.0,
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
                                      height: 36,
                                      child: new Text(
                                        index == 0 ? model.content : reply
                                            .content,
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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(builder: (BuildContext context) {
                          return new ReplyCommentDetails(index == 0 ? model.id
                              .toString() : reply.id.toString(),
                              widget.projectId, widget.model,
                              voidCallBackGetComment,
                              likeUnlikeCommentsCallback,
                              index == 0 ? model : reply);
                        }));
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
                          index == 0 ? model.replies_number != null &&
                              model.replies_number > 1 ? "${model
                              .replies_number} Replies" :
                          model.replies_number != null &&
                              model.replies_number == 1 ? "1 Reply" : "Reply"
                              : reply.replies_number != null &&
                              reply.replies_number > 1 ? "${reply
                              .replies_number} Replies" : reply
                              .replies_number != null &&
                              reply.replies_number == 1 ? "1 Reply" : "Reply",



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
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(builder: (BuildContext context) {
                          return new ReplyCommentDetails(model.id
                              .toString(),
                              widget.projectId, widget.model,
                              voidCallBackGetComment,
                              likeUnlikeCommentsCallback, model);
                        }));
                  },
                  child: Offstage(
                    offstage: index == 1 && model.replies.length > 1
                        ? false
                        : true,
                    child: Container(
                      margin:
                      new EdgeInsets.only(left: 50.0, right: 50.0, top: 15.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        "View ${ model.replies.length - 1} more comments ->",
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
                        int type = 1;

                        if (index == 0) {
                          if (model != null) {
                            type = model.isLike != null && model.isLike ? 0 : 1;
                          }
                        }
                        else {
                          if (reply != null) {
                            type = reply.isLike != null && reply.isLike ? 0 : 1;
                          }
                        }

                        likeUnlikeCommentApi(
                            index == 0 ? model.id : reply.id, type,
                            index == 0 ? 1 : 0, model, reply: reply);
                      },
                      child: new Icon(
                        Icons.favorite,
                        size: 16.0,
                        color: index == 0 ? model.isLike != null && model.isLike
                            ? AppColors.heartColor
                            : AppColors.heartGrey : reply.isLike != null &&
                            reply.isLike ? AppColors.heartColor : AppColors
                            .heartGrey,
                      ),
                    ),
                    new SizedBox(
                      width: 2.0,
                    ),
                    new Text(index == 0 ? model.likedBy != null &&
                          model.likedBy.length > 0
                          ? "${model.likedBy.length}"
                          : "0" : reply.likedBy != null &&
                          reply.likedBy.length > 0
                          ? "${reply.likedBy.length}"
                          : "0",
                      style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 13.0,
                          fontFamily: AssetStrings.lotoRegularStyle),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ]
                ),
              )
            )

          ],
        ),
      ),
    );
  }

  Widget buildItemSingleComment(Comments response, int index) {
    var date = formatDateTimeString(response.created ?? "");
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 40.0, right: 30.0, top: 12.0),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: new EdgeInsets.only(top: 2.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[


                          InkWell(
                            onTap: () {
                              goToProfile(
                                  context, response.author.id.toString(),
                                  response.author.fullName.toString(),
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
                                      size: 35),
                                )),
                          ),
                          new SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: Container(
                              decoration: new BoxDecoration(
                                  border: new Border.all(
                                    color:
                                    AppColors.commentBorder,
                                    width: 0.8,
                                  ),
                                  borderRadius:
                                  new BorderRadius.circular(8.0),
                                  color: AppColors.CommentItemBackground),
                              child: Container(
                                padding: new EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 5.0),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[

                                        InkWell(
                                          onTap: () {
                                            goToProfile(context,
                                                response.author.id.toString(),
                                                response.author.fullName
                                                    .toString(),
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
                                              color:
                                              AppColors.tabCommentColor,
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
                                    ReadMoreText(
                                      response.content,
                                      trimLines: 2,
                                      colorClickableText: AppColors
                                          .kPrimaryBlue,
                                      trimMode: TrimMode.Line,
                                      style: new TextStyle(
                                          color:
                                          AppColors.tabCommentColor,
                                          fontFamily: AssetStrings
                                              .lotoSemiboldStyle,
                                        fontSize: 15.0,),
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
                    InkWell(
                      onTap: () {
                        commentsModel = response;
                        Navigator.push(
                            context,
                            new CupertinoPageRoute(builder: (BuildContext context) {
                              return new ReplyCommentDetails(
                                  response.id.toString(), widget.projectId,
                                  widget.model, voidCallBackGetComment,
                                  likeUnlikeCommentsCallback, response);
                            }));
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
                              response.replies_number != null &&
                                  response.replies_number > 0 ? "${response
                                  .replies_number} Replies" : "Reply",
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
                              int type = response.isLike != null &&
                                  response.isLike ? 0 : 1;
                              likeUnlikeCommentApi(
                                  response.id, type, 1, response);
                            }
                          },
                          child: new Icon(
                            Icons.favorite,
                            size: 16.0,
                            color: response?.isLike != null && response?.isLike
                                ? AppColors.heartColor
                                : AppColors.heartGrey,
                          ),
                        ),
                        new SizedBox(
                          width: 2.0,
                        ),
                        new Text(
                          response != null && response?.likedBy?.length > 0
                              ? "${ response?.likedBy?.length}"
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
  VoidCallback backCallBack()
  {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    providers = Provider.of<HomeListProvider>(context);
    provider = Provider.of<CreateProfileSecondProvider>(context);
    _notifier = NotifierProvider.of(context); // to update video player if running on previous screen
    int count = (projectResponse != null && projectResponse.creator != null)
        ? 1
        : 0;
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.white,
            appBar: appBarBackButton(onTap: backCallBack),
            body: Stack(
              children: <Widget>[
                Container(
                  color: Colors.white,
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: new EdgeInsets.only(top: 2.0),
                          child: new ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: _scrollController,
                              itemBuilder: (BuildContext context, int index) {
                                if (count == 1 && index == 0) {
                                  return getTop();
                                }
                                else {
                                  var pos = (count == 1) ? (index - 1) : index;
                                  return getFeaturedProjects(
                                      list[pos], pos);
                                }
                              },
                              itemCount: (list.length + count)),
                        ),
                      ),
                      _getWriteMessageFieldBar,
                    ],
                  ),
                ),
                Offstage(
                  offstage: list.length == 0 &&
                      !(projectResponse.mediaEmbed != null &&
                          projectResponse.mediaEmbed.length > 0) ? false : true,
                  child: Container(
                    margin: new EdgeInsets.only(bottom: 60.0),
                    child: new Center(
                        child: new Text(
                          "No Comment Found", style: new TextStyle(
                            color: AppColors.kPrimaryBlue,
                            fontSize: 15.0,
                            fontFamily: AssetStrings.lotoBoldStyle),)
                    ),
                  ),
                ),
              ],
            ),
          ),


          new Center(
            child: getHalfScreenProviderLoader(
              status: providers.getLoading(),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
