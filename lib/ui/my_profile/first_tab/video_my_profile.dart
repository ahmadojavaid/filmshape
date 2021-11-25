import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_profile/media/create_profile_media_request.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Model/youtube/channel_model.dart';
import 'package:Filmshape/Model/youtube/video_model.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/comment/full_view_comment.dart';
import 'package:Filmshape/ui/common_video_view/items/awards.dart';
import 'package:Filmshape/ui/common_video_view/items/comment_tab.dart';
import 'package:Filmshape/ui/common_video_view/items/details_tab.dart';
import 'package:Filmshape/ui/youtube/api_service.dart';
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../showreelbottomsheett.dart';

class VideoMyProfileView extends StatefulWidget {
  final VoidCallback callback;
  final Showreel showreel;
  final String userId;
  final ValueChanged<Widget> fullScreenWidget;

  VideoMyProfileView(this.callback, this.showreel,
      this.userId, this.fullScreenWidget);

  @override
  _CoolLoginState createState() => _CoolLoginState();
}

class _CoolLoginState extends State<VideoMyProfileView>

    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<VideoMyProfileView> {

  GlobalKey<YoutubeVimeoInappBrowserState> _videoViewStateKey = new GlobalKey<
      YoutubeVimeoInappBrowserState>();

  TabController tabBarController;
  int _tabIndex = 0;
  String image;
  double currentIndexPage = 0.0;

  String _title;
  String _desc;

  String _videoUrl;
  bool _isLoading = false;

  String _date;
  var screensize;

  Channel _channel;
  HomeListProvider providers;
  VimeoVideosListResponse _vimeoVideosListResponse;

  CreateProfileProvider provider;


  @override
  void initState() {
    tabBarController =
    new TabController(initialIndex: _tabIndex, length: 3, vsync: this);
    widget?.showreel?.isLike = false;
    if (widget?.showreel != null) {
      if (widget.showreel.likedBy != null &&
          widget.showreel.likedBy.length > 0) {
        var like = checkLikeUserId(widget.showreel?.likedBy);

        widget.showreel?.isLike = like;


      }
    }
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);
    providers = Provider.of<HomeListProvider>(context);
    var _isLiked = false;
    var _totalLiked = 0;

    if (widget.showreel != null) {
      _title = widget.showreel?.title ?? "";
      _desc = widget.showreel?.description ?? "";
      _date = formatDateString(widget.showreel?.created ?? "");
      _isLiked = widget?.showreel?.isLike ?? false;
      _totalLiked = widget?.showreel?.likedBy?.length ?? 0;
    }
    screensize = MediaQuery
        .of(context)
        .size;

    return new Container(
      color: Colors.white,
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: 32.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                  "$_title",
                  style: AppCustomTheme.projectHeadingStyle),
            ),
            Container(
              margin: new EdgeInsets.only(left: 32.0, right: 30.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        "$_date",
                        style: AppCustomTheme.projectDateLikeStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      int type = _isLiked ? 0 : 1;
                      likeUnlikeApi(widget.showreel?.id, type);
                    },
                    child: new SvgPicture.asset(
                      AssetStrings.like,
                      width: 20,
                      height: 20,
                      color: _isLiked
                          ? AppColors.kPrimaryBlue
                          : AppColors.kHomeBlack,
                    ),
                  ),
                  SizedBox(width: 4,),
                  new Text("$_totalLiked",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        color: widget.showreel?.isLike != null &&
                            widget.showreel.isLike
                            ? AppColors.kPrimaryBlue
                            : AppColors.kHomeBlack,
                        fontFamily: AssetStrings.lotoRegularStyle),
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
                  height: LIST_PLAYER_HEIGHT,
                  child: Container(
                    child: (
                        (widget.showreel?.mediaEmbed?.length ?? 0) > 0)
                        ? YoutubeVimeoInappBrowser(
                        widget.showreel.mediaEmbed ?? "",key: _videoViewStateKey,)
                        : Container(),
                    decoration: new BoxDecoration(
                      color: Colors.black.withOpacity(0.8),
                    )
                    ,
                  ),
                ),
                (isCurrentUser(widget.userId))
                    ? editData(editshowReelCallBack)
                    : Container(),
              ],
            ),
            Container(
              width: screensize.width,
              margin: new EdgeInsets.only(left: TABS_LEFT_MARGIN),
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
                ]),
            ),
            new Container(
              height: 1.0,
              color: AppColors.dividerColor,
            ),
            Container(
              height: TAB_ITEM_HEIGHT,
              color: Colors.white,
              child: new TabBarView(
                controller: tabBarController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  new CommentTab(
                    commentNumber: widget.showreel?.commentNumber??0,
                    liked: widget.showreel?.comments,
                    projectId: widget.showreel?.id.toString(),
                    model: "Showreel",
                    callbackLikeUnlikeProject: voidCallBackLike,
                    fullScreenWidget: widget.fullScreenWidget,),
                  new DetailsTab(_title, "", "", _desc, ""),
                  new AwardsTab(list: widget.showreel?.awards,),
                  //new TeamTab(),
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
                      color: widget.showreel?.isLike != null &&
                          widget.showreel?.isLike
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
                  top: BorderSide(
                      width: 0.6, color: AppColors.dividerColor),
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


  Future<ValueSetter> voidCallBackCount(int type) async {
    {
      if (type == 1) {
        var isLiked = widget?.showreel?.isLike ?? false;
        int type = isLiked ? 0 : 1;
        likeUnlikeApi(widget.showreel.id, type);
      }
      else if (type == 2) {
        widget.fullScreenWidget(new CommentDetails(
          widget.showreel.id.toString(), "Showreel",
          callback: voidCallBackComments,
          callBackLikeProject: voidCallBackLike,
          callBacklikeUnline: likeUnlikeCommentsCallback,
          fullScreenWidget: widget.fullScreenWidget,));
      }
      else {
        shareData();
      }
    }
  }

  Future<ValueSetter> voidCallBackLike(bool isLIked) async {
    {
      widget.showreel.isLike = isLIked;

      if (isLIked) {
        widget.showreel.likedBy.length = widget.showreel.likedBy.length + 1;
      }
      else {
        widget.showreel.likedBy.length = widget.showreel.likedBy.length - 1;
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


    if (widget.showreel?.comments != null &&
        widget.showreel?.comments.length > 0) {
      for (int i = 0; i < widget.showreel?.comments.length; i++) {
        if (i > 1) {
          break;
        }
        if (i == 0) {
          if (model.name == widget.showreel?.comments[i].id.toString()) {
            changeStatus(model.select, widget.showreel?.comments[i]);
          }
        }
        else {
          if (widget.showreel?.comments[0] != null &&
              widget.showreel?.comments[0].replies.length > 0) {
            var data = widget.showreel?.comments[0].replies[0];


            if (data?.id.toString() == model.name) {
              changeStatus(model.select, data);
            }
            else {
              if (model.name == widget.showreel?.comments[i].id.toString()) {
                changeStatus(model.select, widget.showreel?.comments[i]);
              }
            }
          }
          else {
            if (model.name == widget.showreel?.comments[i].id.toString()) {
              changeStatus(model.select, widget.showreel?.comments[i]);
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
      /*  widget.showreel?.comments?.clear();
      widget.showreel?.comments?.addAll(comments);

*/

      widget.showreel?.commentNumber = widget.showreel?.commentNumber + 1;
      widget.showreel?.comments?.insert(0, comments);

      setState(() {

      });
    }
  }


  Future<bool> likeUnlikeApi(int id, int type) async {
    var response = await providers.likeUnlikeProjectFeed(
        context, id, type, "Showreel");

    if (response is LikesResponse) {
      widget.showreel.likedBy.length = response.likes;
      if (widget.showreel.isLike == null) {
        widget.showreel.isLike = false;
      }
      widget.showreel.isLike = !widget.showreel.isLike;
      /*  if (type == 1) {
        widget.showreel.isLike = true;
      }
      else {
        widget.showreel.isLike = false;
      }*/
    }


    setState(() {

    });
  }



  //show bottom sheet for update reel data for user
  void _settingModalBottomSheet() async {
    if (widget.showreel == null) {
      showInSnackBar("data not loaded");
      return;
    }
    var data = await showModalBottomSheet<String>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0)),
        ),

        builder: (BuildContext bc) {
          return Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets, child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height - 50,
              child: BottomViewDemo(widget.showreel, callBack))
          );
        }
    );
    if (data != null) {
      print(data);
      saveShowReelData(data); //save data to server

    }
  }

  void saveShowReelData(String url) async
  {
    //validate youtube and vimeo link
    if (url.length > 0) {
      var youtubeVideoId = getYouTubeId(url);
      var vimeoVideoId = getVimeoId(url);

      //check if it's youtube or vimeo link
      // print("video id ${getYouTubeId("https://youtu.be/My2FRPA3Gf8")}");
      if (!(youtubeVideoId.isNotEmpty || vimeoVideoId.isNotEmpty)) {
        //invalid video link
        showInSnackBar("Please link a valid Youtube or Vimeo video only");
        return;
      }
    }

    var showReelid = MemoryManagement.getShowReelId();

    provider.setLoading();
    var request = UserShowReelRequest();
    request.title = widget.showreel.title;
    request.description = widget.showreel.description;
    request.media = url;
    request.mediaEmbed=url;



    var response = await provider.updateUserShowReel(
        request, context, showReelid);
    if (response is CreateProfileResponse) {
      print("updated showreel ${response.media}, ${response.mediaEmbed}");
      showInSnackBar("user showreeel data updated");
      widget.showreel.media = response.media;
      widget.showreel.mediaEmbed = response.mediaEmbed;
      //widget.showreel.created=response.created;
      widget.showreel.created = DateTime.now().toUtc().toIso8601String();
      _videoViewStateKey.currentState.reloadNewUrl(response.mediaEmbed);//update with new url
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }

//    setState(() {
//
//    });
  }

  VoidCallback editshowReelCallBack() {
    _settingModalBottomSheet();
  }

  //for opening video list
  ValueChanged callBack(int value) {
    var youtubeToken = MemoryManagement.getYoutubeToken();
    var vimeoToken = MemoryManagement.getVimeoToken();

    if (value == 1) //for youtube
        {
      if (_channel != null) {
        showAllVideosBottomSheet(1); //list already loaded
      }
      else {
        getChannelIdApi(youtubeToken); //get videos from user youtube channel
      }
    }
    else {
      if (_vimeoVideosListResponse != null) {
        showAllVideosBottomSheet(2); //list already loaded show vimeo
      }
      else {
        getVimeoVideosList(vimeoToken); //load vimeo video list
      }
    }
  }

  void showAllVideosBottomSheet(int from) {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0)),
        ),

        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            child: Container(

              child: new Wrap(

                children: <Widget>[

                  Container(
                    margin: new EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Icon(
                                Icons.keyboard_arrow_down, size: 29.0)),

                        new SizedBox(
                          width: 4.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Text(
                            "Close",
                            style: new TextStyle(
                                color: Colors.black,
                                fontSize: 16.0),
                          ),
                        ),

                        new SizedBox(
                          width: 55.0,
                        ),
                        new Image.asset(
                          (from == 1) ? AssetStrings.imageYoutube : AssetStrings
                              .imageVimeo, width: 16.0,
                          height: 16.0,
                          color: (from == 1) ? Colors.red : Colors.blue,),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          (from == 1) ? "YouTube" : "Vimeo",
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 16.0),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 20.0,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            showInSnackBar(_channel.title);
                          },
                          child: new Icon(
                            Icons.account_circle, color: Colors.black,
                            size: 22.0,),
                        )

                      ],
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(
                        left: 30.0, right: 30.0, top: 60.0),
                    alignment: Alignment.center,
                    child: new Text(
                      "Select a video for your project",
                      style: new TextStyle(
                          color: Colors.black,
                          fontSize: 17.0),
                    ),
                  ),

//from=1 youtube and from=2 vimeo
                  (from == 1)
                      ? buildYouTubeContestList()
                      : buildVimeoContestList()
                ],
              ),
            ),
          );
        }
    );
  }

  buildYouTubeContestList() {
    return _channel != null
        ? NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollDetails) {
        if (!_isLoading &&
            _channel.videos.length != int.parse(_channel.videoCount) &&
            scrollDetails.metrics.pixels ==
                scrollDetails.metrics.maxScrollExtent) {
          _loadMoreVideos();
        }
        return false;
      },
      child: Container(
        height: getScreenSize(context: context).height / 2,
        margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),

        child: ListView.builder(
          itemCount: _channel.videos.length,
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            Video video = _channel.videos[index];
            return buildVideoItem(video.id, video.thumbnailUrl, video.title, 1);
          },
        ),
      ),
    ) : new Container();
  }

  buildVimeoContestList() {
    return _vimeoVideosListResponse != null
        ? NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollDetails) {
        if (!_isLoading &&
            _vimeoVideosListResponse.data.length !=
                _vimeoVideosListResponse.total &&
            scrollDetails.metrics.pixels ==
                scrollDetails.metrics.maxScrollExtent) {
          //_loadMoreVideos();
        }
        return false;
      },
      child: Container(
        height: getScreenSize(context: context).height / 2,
        margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 15.0),

        child: ListView.builder(
          itemCount: _vimeoVideosListResponse.data.length,
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            Data video = _vimeoVideosListResponse.data[index];
            var thumbNail = (video.pictures.sizes.length > 3) ? video.pictures
                .sizes[3].link : video.pictures.sizes[0].link;
            return buildVideoItem(video.link, thumbNail, video.name, 2);
          },
        ),
      ),
    ) : new Container();
  }

  _loadMoreVideos() async {
    _isLoading = true;
    List<Video> moreVideos = await APIService.instance
        .fetchVideosFromPlaylist(playlistId: _channel.uploadPlaylistId);
    List<Video> allVideos = _channel.videos..addAll(moreVideos);
    setState(() {
      _channel.videos = allVideos;
    });
    _isLoading = false;
  }

  //get vimeo video list after authentication
  Future<void> getVimeoVideosList(String token) async
  {
    provider.setLoading();
    var response = await provider.getVimeoVideoList(token);
    provider.hideLoader();
    //success
    if (response is VimeoVideosListResponse) {
      print("access token ${response.total}");

      _vimeoVideosListResponse = response;
      showAllVideosBottomSheet(2); //for vimeo videos
    }
    //failure
    else if (response is APIError) {
      showInSnackBar(response.error);
    }
    //unknow failure
    else {
      showInSnackBar(Messages.genericError);
    }
  }

  //for youtube
  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: provider.id);
    setState(() {
      _channel = channel;
    });

    showAllVideosBottomSheet(1);
  }

  Widget buildVideoItem(String videoUrl, String thumbUrl, String title,
      int from) {
    return InkWell(
      onTap: () {
        _videoUrl =
        (from == 1) ? "https://www.youtube.com/watch?v=${videoUrl}" : videoUrl;
        //_videoThumbNail = thumbUrl; //video thumbnail
        widget.showreel.media = _videoUrl;

        setState(() {

        });
        Navigator.pop(context);//hide video list
        _settingModalBottomSheet(); //show edit field sheet
      },
      child: Container(
        margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),

        height: 110.0,
        child: Card(
          elevation: 2.0,
          child: Container(

            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(

                    child: ClipRRect(
                      borderRadius: new BorderRadius.circular(4.0),
                      child: getCachedNetworkImage(
                          url:
                          thumbUrl,
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(

                    children: <Widget>[

                      Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            top: 20.0, left: 15.0, right: 5.0),
                        child: new Text(
                          title,
                          style: AppCustomTheme.videoItemTitleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        margin: new EdgeInsets.only(
                            top: 8.0, left: 15.0, right: 5.0),
                        child: new Text(
                          "My Show",
                          style: AppCustomTheme.suggestedFriendMyReelStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getChannelIdApi(String token) async {
    provider.setLoading();

    var response = await provider.getChannelId(token, context);

    if (response != null && (response is ChannelIdResponse)) {
      _initChannel();
    }
    else {
      APIError apiError = response;
      print(apiError.error);
       MemoryManagement.setYoutubeToken(token: null);
      showInSnackBar("Authentication Failed");

    }
  }


  void showInSnackBar(String value) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

}
