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
import 'package:Filmshape/ui/statelesswidgets/hide_credits_bottom_sheet.dart';
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VideoCreateTabProfileView extends StatefulWidget {
  final Project response;
  final ValueChanged<Widget> fullScreenWidget;
   bool saveAward;
  VideoCreateTabProfileView(this.response, this.fullScreenWidget,{this.saveAward=true});

  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<VideoCreateTabProfileView>
    with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  String image;

  List<String> list = new List();

  double currentIndexPage = 0.0;
  var monVal = false;

  String mediaurl;
  HomeListProvider provider;


  @override
  void initState() {
    print("save award step 1 ${widget.saveAward}");
    super.initState();
    list.add(AssetStrings.imageMusic);
    list.add(AssetStrings.imageLighting);


    if (widget.response != null) {
      mediaurl = widget.response?.mediaEmbed;
    }

    if (widget.response?.likedBy != null &&
        widget.response.likedBy.length > 0) {
      var like = checkLikeUserId(widget.response?.likedBy);
      widget.response?.isLike = like;
    }

    tabBarController =
    new TabController(initialIndex: _tabIndex, length: 4, vsync: this);
  }

  Widget _getPager(String image) {
    return new Image.asset(
      image,
      width: getScreenSize(context: context).width,
      height: 250.0,
      fit: BoxFit.fill,
    );
  }

  void hideCreditBottomSheet(String projectId)async {
   bool status=await  showModalBottomSheet<bool>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0)),
        ),

        builder: (BuildContext bc) {
        return HideCreditBottomSheetWidget(projectId: projectId,);
        }
    );
   print("status $status");
   if(status!=null&&status)
     {
       showAlert(
         context: context,
         titleText: "Success",
         message: "Operation successful",
         actionCallbacks: {"OK": () {}},
       );
     }

  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    var width=MediaQuery.of(context).size.width;
    return new Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: LIST_PLAYER_HEIGHT,
                  child: Container(
                    child: (mediaurl != null &&
                        mediaurl.length > 0)
                        ? YoutubeVimeoInappBrowser(
                        mediaurl ?? "")
                        : Container(),
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                    )
                    ,
                  ),
                ),


              ],
            ),
            Row(children: <Widget>[
              Expanded(
                child: Container(
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
                        new Tab(
                          text: "Team",
                        ),

                      ]),
                ),
              ),

              InkWell(
                onTap: (){
                  hideCreditBottomSheet(widget.response.id.toString());
                },
                child: Container(
                  margin: new EdgeInsets.only(right: 10.0),
                  child: new Icon(
                    Icons.more_vert,
                    color: AppColors.kPrimaryBlue,
                    size: 24.0,
                  ),
                ),
              ),

            ],),

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
                    widget.response.title,
                    widget.response.location != null ? widget.response
                        .location : "", widget.response.genre != null
                      ? widget.response.genre.name
                      : "", widget.response.description,
                    widget.response.projectType != null
                        ? widget.response.projectType.name
                        : "", project: widget.response,),
                  new CommentTab(
                    liked: widget.response.comments,
                    commentNumber: widget.response.commentNumber,
                    fullScreenWidget: widget.fullScreenWidget,
                    model: "Project",
                      callbackLikeUnlikeProject: voidCallBackLike,
                    projectId: widget.response.id.toString()),
                  new AwardsTab(list: widget.response.awards,saveAward: widget.saveAward,),
                  new TeamTab(roleCalls: widget.response.projectRoleCalls),
                  //    new Container(),
                ],
              ),
            ),
            new Container(
              height: 1,
              color: AppColors.dividerColor,
            ),
            new Container(
              height: 50.0,
              width: width,
              margin: new EdgeInsets.only(left: 20, right: 20),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  getRowWidget("Like", AssetStrings.like, 1,
                      callback: voidCallBackCount,
                      color: widget.response.isLike != null &&
                          widget.response.isLike
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
                  top: BorderSide(
                    width: 0.6, color: AppColors.dividerColor,),
                  bottom: BorderSide(
                      width: 0.6, color: AppColors.dividerColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<bool> likeUnlikeApi(int id, int type) async {
    var response = await provider.likeUnlikeProjectFeed(
        context, id, type, "Project");

    if (response != null && (response is LikesResponse)) {
      widget.response.likedBy.length = response.likes;
      if (widget.response.isLike == null) {
        widget.response.isLike = false;
      }
      widget.response.isLike = !widget.response.isLike;

    }


    setState(() {

    });
  }

  Future<ValueSetter> voidCallBackComments(Comments comments) async {
    {
      widget.response?.commentNumber = widget.response?.commentNumber + 1;
      widget.response?.comments?.insert(0, comments);
      /* widget.response.comments?.clear();
      widget.response..comments?.addAll(comments);*/
      print("call backkk");
      setState(() {

      });
    }
  }


  changeStatus(bool status, Comments comment) {

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


    if (widget.response?.comments != null &&
        widget.response?.comments.length > 0) {
      for (int i = 0; i < widget.response?.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == widget.response?.comments[i].id.toString()) {
            changeStatus(model.select, widget.response?.comments[i]);
          }
        }
        else {
          if (widget.response?.comments[0] != null &&
              widget.response?.comments[0].replies.length > 0) {
            var data = widget.response?.comments[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == widget.response?.comments[i].id.toString()) {
                changeStatus(model.select, widget.response?.comments[i]);
              }
            }
          }
          else {
            if (model.name == widget.response?.comments[i].id.toString()) {
              changeStatus(model.select, widget.response?.comments[i]);
            }
          }
        }
      }
      /* widget.callback(list);*/
      setState(() {

      });
    }
  }

  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    {
      widget.response.isLike = isLIked;

      if (isLIked) {
        widget.response.likedBy.length = widget.response.likedBy.length + 1;
      }
      else {
        widget.response.likedBy.length = widget.response.likedBy.length - 1;
      }


      setState(() {});
    }
  }


  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {
        if (widget.response != null) {
          int type = widget.response.isLike != null && widget.response.isLike
              ? 0
              : 1;
          likeUnlikeApi(widget.response.id, type);
        }
      }
      else if (type == 2) {
        widget.fullScreenWidget(new CommentDetails(
          widget.response.id.toString(), "Project",
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
}
