import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/join_project/join_project_details_response.dart';
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
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class JoinProjectVideo extends StatefulWidget {
  final ValueChanged<Widget> fullScreenWidget;

  JoinProjectVideo(this.fullScreenWidget, {Key key}) : super(key: key);

  @override
  JoinProjectVideoState createState() => JoinProjectVideoState();
}

class JoinProjectVideoState extends State<JoinProjectVideo>
    with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  double currentIndexPage = 0.0;
  var screensize;

  String _title;
  String _desc;
  String _dateTime;
  HomeListProvider provider;
  String _mediaUrl;
  JoinProjectDetailsResponses responses = new JoinProjectDetailsResponses();
  GlobalKey<DetailsTabState> _detailTabKey = new GlobalKey<DetailsTabState>();

  @override
  void initState() {
    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 3, vsync: this);
  }

  Future<bool> likeUnlikeApi(int id, int type) async {
    var response =
        await provider.likeUnlikeProjectFeed(context, id, type, "Project");

    if (response != null && (response is LikesResponse)) {
      responses.likedBy.length = response.likes;

      if (responses.isLike == null) {
        responses.isLike = false;
      }

      responses.isLike = !responses.isLike;
      /* if (type == 1) {
        responses.isLike = true;
      }
      else {
        responses.isLike = false;
      }*/
    }

    setState(() {});
  }

//set data for
  void setData(JoinProjectDetailsResponses response) {
    _title = response.title ?? "";
    _dateTime = formatDateString(response.created ?? "");
    _mediaUrl = response.mediaEmbed ?? "";
    _desc = response.description ?? "";
    responses = response;
    print("_media url ${response.commentNumber}");

    if (responses.likedBy != null && responses.likedBy.length > 0) {
      responses?.isLike = checkLikeUserId(response.likedBy);
    }

//    _detailTabKey.currentState.setData(
//        response.title ?? "", response.description ?? "");
  }

  @override
  Widget build(BuildContext context) {
    screensize = MediaQuery.of(context).size;
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
                _title ?? "",
                style: new TextStyle(
                    fontSize: 19.0,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    color: AppColors.topNavColor),
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
                      _dateTime ?? "",
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
                      if (responses != null) {
                        int type = responses.isLike != null && responses.isLike
                            ? 0
                            : 1;

                        likeUnlikeApi(responses.id, type);
                      }
                    },
                    child: new SvgPicture.asset(
                      AssetStrings.like,
                      width: 20,
                      height: 20,
                      color: responses.isLike != null && responses.isLike
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,
                    ),
                  ),
                  new Text(
                    responses.likedBy != null && responses.likedBy.length > 0
                        ? " ${responses.likedBy.length.toString()}"
                        : "",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: responses.isLike != null && responses.isLike
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
            Container(
              height: LIST_PLAYER_HEIGHT,
              child: Container(
                child: (_mediaUrl != null && _mediaUrl.length > 0)
                    ? YoutubeVimeoInappBrowser(_mediaUrl ?? "")
                    : Container(),
                decoration: new BoxDecoration(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
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
                      text: "Details",
                    ),
                    new Tab(
                      text: "Comments",
                    ),
                    new Tab(
                      text: "Awards",
                    ),
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
                  new DetailsTab(
                    _title,
                    responses?.location ?? "",
                    responses?.genre?.name ?? "",
                    _desc,
                    responses?.projectType?.name ?? "",
                    key: _detailTabKey,
                  ),
                  new CommentTab(
                    commentNumber: responses.commentNumber,
                    fullScreenWidget: widget.fullScreenWidget,
                    projectId: responses?.id?.toString(),
                    liked: responses?.comments,
                    model: "Project",
                    callbackLikeUnlikeProject: voidCallBackLike,
                  ),

                  new AwardsTab(list: responses.awards),
                  //  new TeamTab(),
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
                  getRowWidget(
                    "Like",
                    AssetStrings.like,
                    1,
                    callback: voidCallBackCount,
                    color: responses.isLike != null && responses.isLike
                        ? AppColors.kPrimaryBlue
                        : AppColors.kHomeBlack,
                  ),
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


  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    responses.isLike = isLIked;

    if (isLIked) {
      responses.likedBy.length = responses.likedBy.length + 1;
    }
    else {
      responses.likedBy.length = responses.likedBy.length - 1;
    }


    setState(() {});
  }


  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {
        int types = responses.isLike != null && responses.isLike ? 0 : 1;
        likeUnlikeApi(responses.id, types);
      } else if (type == 2) {
        widget.fullScreenWidget(new CommentDetails(
          responses.id.toString(),
          "Project",
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

    if (responses.comments != null && responses.comments.length > 0) {
      for (int i = 0; i < responses.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == responses.comments[i].id.toString()) {
            changeStatus(model.select, responses.comments[i]);
          }
        } else {
          if (responses.comments[0] != null &&
              responses.comments[0].replies.length > 0) {
            var data = responses.comments[0].replies[0];

            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            } else {
              if (model.name == responses.comments[i].id.toString()) {
                changeStatus(model.select, responses.comments[i]);
              }
            }
          } else {
            if (model.name == responses.comments[i].id.toString()) {
              changeStatus(model.select, responses.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {});
    }
  }

  ValueChanged<String> videoFullView(String url) {
    //widget.fullVideCallBack(url);
  }

  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      /*  print("called");
      responses.comments.clear();
      responses.comments.addAll(comments);*/

      responses.commentNumber = responses.commentNumber + 1;

      responses.comments?.insert(0, comments);
      setState(() {});
    }
  }
}
