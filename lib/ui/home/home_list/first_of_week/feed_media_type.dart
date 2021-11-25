import 'dart:collection';

import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/common_video_view/items/awards.dart';
import 'package:Filmshape/ui/common_video_view/items/comment_tab.dart';
import 'package:Filmshape/ui/common_video_view/items/details_tab.dart';
import 'package:Filmshape/ui/common_video_view/items/team.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:Filmshape/ui/statelesswidgets/html_text_widget.dart';
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class FeedMediaType extends StatefulWidget {
  final Feed feed;
  final ValueChanged<Widget> fullScreenWidget;

  FeedMediaType(this.feed, this.fullScreenWidget);

  /* CreateSuccessFirst(this.projectId,this.fullScreenCallBack, {Key key, bool this.isRole})
      : super(key: key);*/

/*  @override
  UserProfileState createState() => UserProfileState();*/

  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<FeedMediaType>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FeedMediaType> {
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

  List<String> userRoleThumbnail = new List();
  LinkedHashSet<String> listLocal = new LinkedHashSet();
  List<String> localRole = new List<String>();

  double currentIndexPage = 0.0;

  int index = 0;

  Notifier _notifier;

  @override
  void initState() {
    if (widget.feed != null) {
      feedProject = widget.feed;
      mediaurl = widget.feed.project.mediaEmbed;

      if (widget.feed.user != null && widget.feed.user.fullName != null) {
        name = widget.feed.user.fullName;
      }

      /*  if (widget.feed.roleCall != null && widget.feed.roleCall.name != null) {
        subrole = widget.feed.roleCall.name;
      }
*/
      if (widget.feed.project != null && widget.feed.project.created != null) {
        time = formatDateTimeString(widget.feed.project.created ?? "");
      }
/*
      if (widget.feed.roleCall != null &&
          widget.feed.roleCall.category.name != null) {
        role = widget.feed.roleCall.category.name;
      }*/

      /*  if (feedProject.roleCall != null) {
        list.add(feedProject.roleCall.iconUrl);
      }*/

      if (widget.feed.project != null &&
          widget.feed.project.projectRoleCalls != null) {
        ProjectRoleCallss roleCallss = widget.feed.project.projectRoleCalls[0];

        subrole = roleCallss.role.name;
        role = roleCallss.role.category.name;
        if (roleCallss != null) {
          userRoleThumbnail.add(roleCallss.role.iconUrl);
        }
      }
      if (widget.feed.user != null) {
        userRoleThumbnail.add(widget.feed.user.thumbnailUrl);
      }

      if (feedProject.project.likedBy != null &&
          feedProject.project.likedBy.length > 0) {
        feedProject.project.isLike =
            checkLikeUserId(feedProject.project.likedBy);
      }
    }

    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 4, vsync: this);
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
      /*
      if (type == 1) {
        feedProject.project.isLike = true;
      } else {
        feedProject.project.isLike = false;
      }*/
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
    _notifier = NotifierProvider.of(context); // to update home screen header
    return new Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getCommonHeader(userRoleThumbnail, 0,
                name: name,
                rolemain: role,
                subrole: subrole,
                time: time,
                userId: widget.feed.user.id,
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
                        child: HtmlTextWidget(widget.feed.message)),
//                    child: new RichText(
//                      text: new TextSpan(
//                        text: "${widget.feed.user.fullName}",
//                        recognizer: TapGestureRecognizer()
//                          ..onTap = () {
//                            goToProfile(context, feedProject.user.id.toString(),
//                                feedProject.user.fullName);
//                          },
//                        style: new TextStyle(
//                            color: Colors.black,
//                            fontSize: 16.0,
//                            fontFamily: AssetStrings.lotoBoldStyle),
//                        children: <TextSpan>[
//                          new TextSpan(
//                              text: ' has joined ',
//                              style: new TextStyle(
//                                  fontFamily: AssetStrings.lotoRegularStyle)),
//                          new TextSpan(
//                              text: "${widget.feed.project.title}",
//                              recognizer: TapGestureRecognizer()
//                                ..onTap = () {
//                                  _moveToDetailScreen(feedProject.id);
//                                },
//                              style: new TextStyle(
//                                  fontSize: 16,
//                                  fontFamily: AssetStrings.lotoBoldStyle)),
//                        ],
//                      ),
//                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (feedProject != null) {
                        int types = feedProject.project.isLike != null &&
                                feedProject.project.isLike
                            ? 0
                            : 1;
                        likeUnlikeApi(feedProject.project.id, types);
                      }
                    },
                    child: new SvgPicture.asset(
                      AssetStrings.like,
                      width: 20,
                      height: 20,
                      color: feedProject.project?.isLike ?? false
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,
                    ),
                  ),
                  new Text(
                    " ${widget.feed.project.likedBy.length.toString()}",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: feedProject.project?.isLike ?? false
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
              height: 20.0,
            ),
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  height: LIST_PLAYER_HEIGHT,
                  child: Container(
                    child: (mediaurl != null && mediaurl.length > 0)
                        ? YoutubeVimeoInappBrowser(mediaurl ?? "")
                        : Container(),
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                    ),
                  ),
                ),

                /* Container(
                  height: screensize.height / 3.2,
                  width: screensize.width,
                  color: Colors.blueGrey,
                  child: new PageView.builder(
                      controller: _controller,
                      itemCount: _pages.length,
                      reverse: false,
                      onPageChanged: (int index) {
                        currentIndexPage = index.toDouble();
                        setState(() {});
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return _pages[index];
                      }),
                ),
                */
              ],
            ),
            Container(
              width: screensize.width,
              margin: new EdgeInsets.only(left: 20.0),
              child: new TabBar(
                  indicatorColor: AppColors.kPrimaryBlue,
                  labelStyle: AppCustomTheme.tabSelectedVideoTextStyle,
                  indicatorWeight: 2.5,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelColor: AppColors.kPrimaryBlue,
                  isScrollable: true,
                  unselectedLabelStyle:
                      AppCustomTheme.tabUnSelectedVideoTextStyle,
                  controller: tabBarController,
                  unselectedLabelColor: AppColors.tabUnselectedBackground,
                  tabs: <Widget>[
                    new Tab(
                      text: "Comments",
                    ),
                    new Tab(
                      text: "Details",
                    ),
                    new Tab(
                      text: "Awards",
                    ),
                    new Tab(
                      text: "Team",
                    )
                  ]),
            ),
            new Container(
              height: 1.0,
              color: AppColors.dividerColor,
            ),
            Container(
              height: 280.0,
              color: Colors.black,
              child: new TabBarView(
                controller: tabBarController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  new CommentTab(
                    commentNumber: feedProject.commentNumber,
                    fullScreenWidget: widget.fullScreenWidget,
                    liked: feedProject.project.comments,
                    model: "Feed",
                    callbackLikeUnlikeProject: voidCallBackLike,
                    projectId: feedProject.id.toString(),
                  ),
                  new DetailsTab(
                      feedProject?.project?.title ?? "",
                      feedProject?.project?.location ?? "",
                      feedProject?.project?.genre?.name ?? "",
                      feedProject?.project?.description ?? "",
                      feedProject?.project?.projectType?.name ?? ""),
                  new AwardsTab(
                    list: feedProject.project.awards,
                  ),
                  new TeamTab(
                    roleCalls: feedProject.project.projectRoleCalls,
                  ),
                ],
              ),
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
                      color: feedProject.project?.isLike ?? false
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack),
                  getRowWidget("Comment", AssetStrings.comment, 2,
                      color: AppColors.kHomeBlack, callback: voidCallBackCount),
                  getRowWidget("Share", AssetStrings.share, 3,
                      color: AppColors.kHomeBlack, callback: voidCallBackCount)
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
      ),
    );
  }

  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      /*feedProject.project?.comments?.clear();
      feedProject.project?.comments?.addAll(comments);*/
      feedProject.project.commentNumber = feedProject.project.commentNumber + 1;

      feedProject.project?.comments?.insert(0, comments);

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
    } else {
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
        } else {
          if (feedProject.comments[0] != null &&
              feedProject.comments[0].replies.length > 0) {
            var data = feedProject.comments[0].replies[0];

            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            } else {
              if (model.name == feedProject.comments[i].id.toString()) {
                changeStatus(model.select, feedProject.comments[i]);
              }
            }
          } else {
            if (model.name == feedProject.comments[i].id.toString()) {
              changeStatus(model.select, feedProject.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {});
    }
  }


  /* Future<ValueSetter> voidCallBackLike(bool isLIked) async {




    feedProject.=isLIked;

      if(isLIked){

        widget.response.likedBy.length=    widget.response.likedBy.length+1;
      }
      else{

        widget.response.likedBy.length=    widget.response.likedBy.length-1;
      }


      setState(() {});
    }
  }*/


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

  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {
        if (feedProject != null) {
          int types =
              feedProject.project.isLike != null && feedProject.project.isLike
                  ? 0
                  : 1;

          likeUnlikeApi(feedProject.project.id, types);
        }
      } else if (type == 2) {
        //moving to comment section pause running video if any
        _notifier?.notify('pausevideo', "pausevideo"); //update heading

        //call the pause video notifier with null to avoid frequent call of notifier
        //which might cause to pause resume of video
        Future.delayed(const Duration(milliseconds: 50), () {
          _notifier?.notify('pausevideo', null); //
        });

        widget.fullScreenWidget(new CommentDetails(
          feedProject.project.id.toString(),
          "Feed",
          callback: voidCallBackComments,
          callBacklikeUnline: likeUnlikeCommentsCallback,
          fullScreenWidget: widget.fullScreenWidget,
          callBackLikeProject: voidCallBackLike,
        ));
      } else {
        shareData();
      }
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
