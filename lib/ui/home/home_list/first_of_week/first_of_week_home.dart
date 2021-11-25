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
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class FirstofWeekHome extends StatefulWidget {

  final List<FeaturedProjects> featureproject;
  final ValueChanged<Widget> fullScreenWidget;
  FirstofWeekHome(this.featureproject, this.fullScreenWidget);

  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<FirstofWeekHome>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<FirstofWeekHome> {
  HomeListProvider provider;
  TabController tabBarController;
  var screensize;
  double currentIndexPage = 0.0;
  int currentItemIndex = 0;
  String _mediaUrl;
  bool _visibleNextButton=true;
  bool _visiblePreviousButton=false;

  FeaturedProjects featureproject = new FeaturedProjects();
  LinkedHashSet<String> listLocal = new LinkedHashSet();
  List<String> list = new List();
  var totalFeaturedProject = 0;
  var _likedByCount = 0;
  var _isLikedByMe = false;

  final GlobalKey<YoutubeVimeoInappBrowserState> _videoScreenKey =
      new GlobalKey<YoutubeVimeoInappBrowserState>();

  @override
  void initState() {
    if (widget.featureproject != null && widget.featureproject.length > 0) {
      //total featured project count
      totalFeaturedProject = widget.featureproject.length;
      featureproject = widget.featureproject[0];
      //set data for first index
      _mediaUrl = featureproject.mediaEmbed;
      _likedByCount = featureproject.likedBy?.length ?? 0;

      if (featureproject.projectRoleCalls != null &&
          featureproject.projectRoleCalls.length > 0) {
        for (var item in featureproject.projectRoleCalls) {
          listLocal.add(item.role.iconUrl);
        }

        if (listLocal.length > 0) {
          list.addAll(listLocal);
        }

        if (featureproject.likedBy != null &&
            featureproject.likedBy.length > 0) {
          _isLikedByMe = checkLikeUserId(featureproject.likedBy);
          featureproject?.isLike = _isLikedByMe;
        }
      }
    }

    tabBarController =
    new TabController(initialIndex: 0, length: 4, vsync: this);
  }

  Future<bool> likeUnlikeApi(int id, int type) async {
    var response = await provider.likeUnlikeProjectFeed(
        context, id, type, "Project");

    if (response is LikesResponse) {
      featureproject.likedBy.length = response.likes;
      featureproject.isLike = (type == 1);
      //update current view like status
      _likedByCount = featureproject.likedBy?.length ?? 0;
      _isLikedByMe = featureproject.isLike;
    }

    setState(() {

    });
  }

  void nextData() {
    if (currentItemIndex < (totalFeaturedProject-1)) {
      currentItemIndex++;
      updateList();
    }
  }

  void previousData() {
    if (currentItemIndex > 0) {
      currentItemIndex--;
      updateList();
    }
  }


  void updateList() {
    featureproject = widget.featureproject[currentItemIndex];
    //set data for first index
    _mediaUrl = featureproject.mediaEmbed;
    _likedByCount = featureproject.likedBy?.length ?? 0;
    _isLikedByMe = false;
    if (featureproject.likedBy != null && featureproject.likedBy.length > 0) {
      _isLikedByMe = checkLikeUserId(featureproject.likedBy);
      featureproject?.isLike = _isLikedByMe;
    }

    //handling for next previous button
    if(currentItemIndex==0) //first item loaded right now
      {
        _visibleNextButton=true;
        _visiblePreviousButton=false;
      }
    else if(currentItemIndex==(totalFeaturedProject-1)) //reached at end
      {
        _visibleNextButton=false;
        _visiblePreviousButton=true;
      }
    else //currently at mid
      {
        _visibleNextButton=true;
        _visiblePreviousButton=true;
      }

    setState(() {

    });
    //reload the new url
    if (_mediaUrl != null && _mediaUrl.length > 0) {
      _videoScreenKey.currentState.reloadNewUrl(_mediaUrl);
    }
  }


  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery
        .of(context)
        .size;
    provider = Provider.of<HomeListProvider>(context);


    return new Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: 32.0, right: 30.0, top: 25.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                "Films of the week",
                style: new TextStyle(
                    fontSize: 19.0,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    color: AppColors.fileOfTheWeekHeaderColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              margin: new EdgeInsets.only(left: 32.0, right: 30.0, top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: new Text(
                      "${featureproject.title}",
                      style: new TextStyle(
                          fontSize: 16.0,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          color: AppColors.topNavColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      int type = _isLikedByMe ? 0 : 1;
                      likeUnlikeApi(featureproject.id, type);
                    },
                    child: new SvgPicture.asset(
                      AssetStrings.like,
                      width: 20,
                      height: 20,
                      color: _isLikedByMe
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,
                    ),
                  ),
                  new Text(
                    " $_likedByCount",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: _isLikedByMe
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
              height: 13.0,
            ),
            Stack(
              children: <Widget>[
                Container(
                  height: LIST_PLAYER_HEIGHT,
                  child: Container(
                    child: (_mediaUrl != null &&
                        _mediaUrl.length > 0)
                        ? YoutubeVimeoInappBrowser(
                        _mediaUrl, key: _videoScreenKey)
                        : Container(),
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                    )
                    ,
                  ),
                ),


                new Positioned(
                    top: 0.0,
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: new Container(
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[


                          Offstage(
                            offstage: !_visiblePreviousButton,
                            child: InkWell(
                              onTap: () {
                                previousData();
                              },
                              child: new Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 30.0,
                              ),
                            ),
                          ),


                          Offstage(
                            offstage: !_visibleNextButton,
                            child: InkWell(
                              onTap: () {
                                nextData();
                              },
                              child: new Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 30.0),
                            ),
                          )
                        ],
                      ),
                    ))
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
                    commentNumber: featureproject.commentNumber,
                    fullScreenWidget: widget.fullScreenWidget,
                    projectId: featureproject.id.toString(),
                    liked: featureproject.comments,
                    callbackLikeUnlikeProject: voidCallBackLike,
                    model: "Project",
                  ),
                  new DetailsTab(
                      featureproject.title ?? "",
                      featureproject?.location ?? "",
                      featureproject.genre?.name ?? "",
                      featureproject?.description ?? "",
                      featureproject.projectType?.name ?? ""),
                  new AwardsTab(
                    list: featureproject.awards,saveAward: false,
                  ),
                  new TeamTab(
                    roleCalls: featureproject.projectRoleCalls,
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
                      color: featureproject.isLike
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,),
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
      ),
    );
  }

  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {

        if (featureproject != null) {
          int types = featureproject.isLike != null && featureproject.isLike
              ? 0
              : 1;
          likeUnlikeApi(featureproject.id, types);
        }
      }
      else if (type == 2) {
        widget.fullScreenWidget(new CommentDetails(
          featureproject.id.toString(), "Project",
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
      featureproject.isLike = isLIked;

      if (isLIked) {
        featureproject.likedBy.length = featureproject.likedBy.length + 1;
      }
      else {
        featureproject.likedBy.length = featureproject.likedBy.length - 1;
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


    if (featureproject.comments != null && featureproject.comments.length > 0) {
      for (int i = 0; i < featureproject.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == featureproject.comments[i].id.toString()) {
            changeStatus(model.select, featureproject.comments[i]);
          }
        }
        else {
          if (featureproject.comments[0] != null &&
              featureproject.comments[0].replies.length > 0) {
            var data = featureproject.comments[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == featureproject.comments[i].id.toString()) {
                changeStatus(model.select, featureproject.comments[i]);
              }
            }
          }
          else {
            if (model.name == featureproject.comments[i].id.toString()) {
              changeStatus(model.select, featureproject.comments[i]);
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
      /*  featureproject.comments.clear();
      featureproject.comments.addAll(comments);*/

      featureproject.commentNumber = featureproject.commentNumber + 1;

      featureproject.comments?.insert(0, comments);
      setState(() {

      });
    }
  }

  @override
// TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


}
