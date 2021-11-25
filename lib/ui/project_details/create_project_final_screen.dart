import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_project/create_project_request.dart';
import 'package:Filmshape/Model/create_project/create_project_response.dart';
import 'package:Filmshape/Model/create_project/youtube_vimeo_video_model.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Model/youtube/channel_model.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/suggestion_notifier.dart';
import 'package:Filmshape/ui/create_project/create_project_details_first_tab.dart';
import 'package:Filmshape/ui/create_project/create_project_second_tab.dart';
import 'package:Filmshape/ui/create_project/create_project_third_tab.dart';
import 'package:Filmshape/ui/create_project/videoslistbottomsheet.dart';
import 'package:Filmshape/ui/my_profile/decprator.dart';
import 'package:Filmshape/ui/my_profile/showreelbottomsheett.dart';
import 'package:Filmshape/ui/payment_screen/PaymentScreen.dart';
import 'package:Filmshape/ui/youtube/api_service.dart';
import 'package:Filmshape/videoplayer/youtube_vidmeo_inapp_webview_palyer.dart';
import 'package:Filmshape/videoplayer/youtube_vimeo_full_web_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class CreateProjectFinalScreen extends StatefulWidget {
  final String projectId;
  final ValueChanged<Widget> fullScreenCallBack;
  final ProjectData projectData;
  String previousTabHeading;
  bool fromMyProject;
  final bool isRole;

  CreateProjectFinalScreen(
      this.projectId, this.fullScreenCallBack, this.projectData,
      {this.previousTabHeading,
      this.isRole,
      this.fromMyProject =
          false //to manage back screen when project gets deleted
      });

  @override
  _SliverWithTabBarState createState() => _SliverWithTabBarState();
}

class _SliverWithTabBarState extends State<CreateProjectFinalScreen>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<CreateProjectFinalScreen> {
  GlobalKey<YoutubeVimeoInappBrowserState> _videoViewStateKey =
      new GlobalKey<YoutubeVimeoInappBrowserState>();

  TabController tabBarController;
  int _tabIndex = 0;
  String image;
  String _mediaUrl;
  double currentIndexPage = 0.0;
  CreateProfileSecondProvider provider;
  SuggestionProvider suggestionProvider;
  String _title;
  String _dateTime;
  Notifier _notifier;
  HomeListProvider providers;

  GlobalKey<UserProfileState> _projectKey = new GlobalKey<UserProfileState>();
  GlobalKey<CommentTabsSecond> _projectKeySecond =
      new GlobalKey<CommentTabsSecond>();
  GlobalKey<CommentTabs> _projectKeyThird = new GlobalKey<CommentTabs>();

  ProjectResponse responses = new ProjectResponse();

  Showreel _showReel;

  Channel _channel;
  VimeoVideosListResponse _vimeoVideosListResponse;
  CreateProfileSecondProvider providerCreateProfile;
  int _likeCount = 0;
  bool _isLikeBy = false;

  //ProjectResponse responses = new ProjectResponse();
  bool upgradedAccount = false;
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _showReel = Showreel();
    tabBarController =
        new TabController(initialIndex: _tabIndex, length: 3, vsync: this);
    tabBarController.addListener(_handleTabSelection);
    upgradedAccount =
        MemoryManagement.getUpgradedAccount() ?? false; //mark account purchased

    _setData(); //set top view data

    //rotation for horizontal video mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    Future.delayed(const Duration(milliseconds: 300), () {
      _notifier.notify('action', widget.projectData?.title ?? ""); //set title
      _hitAapi();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    super.dispose();
  }

  void _setData() {
    if (widget.projectData != null) {
      //setProfileData(response);
      _title = widget.projectData.title;
      _dateTime = formatDateString(widget.projectData.created ?? "");
      _mediaUrl = widget.projectData.mediaEmbed ?? "";
      //for media section
      _showReel.title = widget.projectData.title;
      _showReel.description = widget.projectData.description;
      _showReel.media = widget.projectData.mediaEmbed;
      _showReel.mediaOldLink = widget.projectData.mediaEmbed;
    }
  }

  void _hitAapi() async {
    provider.setLoading();
    var response = await provider.getProjectDetails(widget.projectId, context);

    if (response is ProjectResponse) {
      //setProfileData(response);
      _title = response.title;
      _dateTime = formatDateString(response.created ?? "");
      _mediaUrl = response.mediaEmbed ?? "";
      _projectKey.currentState.setData(provider.projectResponse); //set data on first tab
      // _projectKeySecond.currentState?.setData(response); //set data on first tab
      // _projectKeyThird.currentState?.setData(response); //set data on first tab

      responses = responses;

      if (response.likedBy != null && response.likedBy.length > 0) {
        _likeCount = response.likedBy.length;
        var isLikedBy = checkLikeUserId(response.likedBy);
        response?.isLike = isLikedBy;
        _isLikeBy = isLikedBy;
      }

      //for media section
      _showReel.title = response.title;
      _showReel.description = response.description;
      _showReel.media = response.mediaEmbed;
      _showReel.mediaOldLink = response.mediaEmbed;
     // _controller.jumpTo(0); //scroll to top

      setState(() {});

      //to fix auto scroll of the page
      Future.delayed(const Duration(milliseconds: 100), () {
        _controller.jumpTo(_controller.position.minScrollExtent);
      });

       print("my media $_mediaUrl");
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  void _handleTabSelection() {
    _tabIndex = tabBarController.index;
    if (_tabIndex == 0) {
      var title = _projectKey.currentState
          .setData(provider.projectResponse); //set data on first tab
      //receive the latest title and update it
      if (title != null) {
        _title = title; //update the title
      }
    } else if (_tabIndex == 1) {
      _projectKeySecond.currentState
          ?.setData(provider.projectResponse); //set data on second tab

    }

    checkStatus();
    setState(() {});
  }

  VoidCallback callback(bool call) {
    if (call) {
      upgradedAccount = MemoryManagement.getUpgradedAccount() ??
          false; //mark account purchased

      setState(() {});
    }
  }

  checkStatus() {
    upgradedAccount =
        MemoryManagement.getUpgradedAccount() ?? false; //mark account purchased

    if (_tabIndex == 1 && !upgradedAccount) {
      widget.fullScreenCallBack(PaymentScreen(
        callback: callback,
      ));
      tabBarController.animateTo(0);
    }
  }

/*
  Future<bool> likeUnlikeApi(int id, int type) async {
    var response = await providers.likeUnlikeProjectFeed(
        context, id, type, "Project");

    if (response != null && (response is LikesResponse)) {
      if (response.likes == 1) {
        responses.likedBy.length =
            responses.likedBy.length + 1;
        responses.isLike = true;
      }
      else {
        responses.likedBy.length =
            responses.likedBy.length - 1;
        responses.isLike = false;
      }
    }
    else {


    }

    setState(() {

    });
  }*/

  Widget attributeHeading(String text, IconData image) {
    return InkWell(
      onTap: () {},
      child: new Container(
        height: 45.0,
        margin: new EdgeInsets.only(left: 30.0, right: 30.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: new Border.all(
                color: AppColors.creatreProfileBordercolor, width: 2),
            color: (_mediaUrl == null) ? Colors.white : AppColors.kPrimaryBlue),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),
            new Icon(
              image,
              color:
                  (_mediaUrl == null) ? AppColors.kPrimaryBlue : Colors.white,
              size: 19.0,
            ),
            new SizedBox(
              width: 11.0,
            ),

            new Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: (_mediaUrl == null) ? Colors.black : Colors.white,
                  fontFamily: AssetStrings.lotoRegularStyle,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<CreateProfileSecondProvider>(context);
    providerCreateProfile = Provider.of<CreateProfileSecondProvider>(context);
    suggestionProvider = Provider.of<SuggestionProvider>(context);

    _notifier = NotifierProvider.of(context); // to update home screen header

    return SafeArea(
      child: Scaffold(

        body: Stack(
          children: <Widget>[
            NestedScrollView(
              controller: _controller,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    pinned: false,
                    backgroundColor: Colors.white,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      background: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: new EdgeInsets.only(
                                left: 32.0, right: 30.0, top: 25.0),
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
                            margin: new EdgeInsets.only(
                                left: 32.0, right: 30.0, top: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: new Text(
                                    _dateTime ?? "",
                                    style: new TextStyle(
                                        fontSize: 16.0,
                                        fontFamily:
                                            AssetStrings.lotoRegularStyle,
                                        color: AppColors.topNavColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    likeUnlikeApi(widget.projectId);
                                  },
                                  child: new SvgPicture.asset(
                                    AssetStrings.like,
                                    width: 20,
                                    height: 20,
                                    color: _isLikeBy
                                        ? AppColors.kPrimaryBlue
                                        : AppColors.kHomeBlack,
                                  ),
                                ),
                                new Text(
                                  " $_likeCount",
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: _isLikeBy
                                          ? AppColors.kPrimaryBlue
                                          : AppColors.kHomeBlack,
                                      fontFamily:
                                          AssetStrings.lotoRegularStyle),
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
                                          _mediaUrl ?? "",
                                          key: _videoViewStateKey,
                                        )
                                      : Container(),
                                  decoration: new BoxDecoration(
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ),
                              editData(editshowReelCallBack),
                            ],
                          ),
                          new Container(
                            height: 1.0,
                            color: AppColors.dividerColor,
                          ),
                          new Container(
                            height: 10.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                    expandedHeight: (LIST_PLAYER_HEIGHT + 150),
                    bottom: DecoratedTabBar(
                      decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.dividerColor,
                              width: 1.0,
                            ),
                          ),
                          color: Colors.white),
                      tabBar: new TabBar(
                          indicatorColor: AppColors.kPrimaryBlue,
                          labelStyle: new TextStyle(fontSize: 16.0),
                          indicatorWeight: 2.0,
                          unselectedLabelStyle: new TextStyle(fontSize: 16.0),
                          unselectedLabelColor: Colors.black87,
                          labelColor: AppColors.kPrimaryBlue,
                          controller: tabBarController,
                          isScrollable: false,
                          tabs: <Widget>[
                            new Tab(
                              text: "Details",
                              icon: new SvgPicture.asset(AssetStrings.files,
                                  width: 20.0,
                                  height: 20.0,
                                  color: tabBarController.index == 0
                                      ? AppColors.kPrimaryBlue
                                      : Colors.black87),
                            ),
                            new Tab(
                              text: "Awards",
                              icon: upgradedAccount
                                  ? new SvgPicture.asset(AssetStrings.imgStar,
                                      width: 20.0,
                                      height: 20.0,
                                      color: tabBarController.index == 1
                                          ? AppColors.kPrimaryBlue
                                          : Colors.black87)
                                  : new SvgPicture.asset(AssetStrings.lock,
                                      width: 20.0,
                                      height: 20.0,
                                      color: tabBarController.index == 1
                                          ? AppColors.kPrimaryBlue
                                          : Colors.black87),
                            ),
                            new Tab(
                              text: "Comments",
                              icon: new SvgPicture.asset(AssetStrings.comment,
                                  width: 20.0,
                                  height: 20.0,
                                  color: tabBarController.index == 2
                                      ? AppColors.kPrimaryBlue
                                      : Colors.black87),
                            ),
                          ]),
                    ),
                  )
                ];
              },
              body: Container(
                child: new TabBarView(
                  controller: tabBarController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    new CreateSuccessFirst(
                      widget.projectId,
                      widget.fullScreenCallBack,
                      key: _projectKey,
                      isRole: widget.isRole,
                      callbackProjectDeleted: callbackRemoveProject,
                    ),
                    new CreateProjectSecondTab(
                      widget.projectId,
                      widget.fullScreenCallBack,
                      key: _projectKeySecond,
                      isRole: widget.isRole,
                    ),
                    new CreateProjectThirdTab(
                      widget.projectId,
                      widget.fullScreenCallBack,
                      key: _projectKeyThird,
                      isRole: widget.isRole,
                      callback: likeUnlikeStatus,
                    ),
                  ],
                ),
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
      ),
    );
  }

  VoidCallback callbackRemoveProject() {
    if (widget.fromMyProject) {
      Navigator.pop(context, "deleted"); //move to my projects screen
    } else //move to home screen
    {
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context, "deleted");
    }
  }

  VoidCallback editshowReelCallBack() {
    _showProjectInfoBottomSheet();
  }

  //show bottom sheet for update reel data for user
  void _showProjectInfoBottomSheet() async {
    var data = await showModalBottomSheet<String>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                  height: MediaQuery.of(context).size.height - 50,
                  child: BottomViewDemo(_showReel, callBack)));
        });
    if (data != null) {
      print(data);
      updateProjectData(data); //save data to server

    }
  }

  void updateProjectData(String url) async {
    //validate youtube link
    if (url.length > 0) {
      var youtubeVideoId = getYouTubeId(url);
      var vimeoVideoId = getVimeoId(url);

      //check if it's youtube or vimeo link
      // print("video id ${getYouTubeId("https://youtu.be/My2FRPA3Gf8")}");
      if (!(youtubeVideoId.isNotEmpty || vimeoVideoId.isNotEmpty)) {
        //invalid video link
        showInSnackBar("Please link a Youtube or Vimeo video only");
        return;
      }
    }

    provider.setLoading();
    //create request body
    CreateProjectRequest updateRequest = new CreateProjectRequest();
    updateRequest.type = "Project";

    updateRequest.title = _showReel.title;
    updateRequest.description = _showReel.description;
    updateRequest.media = _showReel.media;
    updateRequest.mediaEmbed = _showReel.media;

    var response =
        await provider.updateProject(updateRequest, context, widget.projectId);

    //project created successfully
    if (response is CreateProjectResponse) {
      _projectKey.currentState
          .updateData(_showReel); //update title and description
      showInSnackBar("Information updated");
      _mediaUrl = response.mediaEmbed;
      print("embede url ${response.toJson()}");
      //update the url
      _videoViewStateKey.currentState.reloadNewUrl(_mediaUrl);
      //update title and date time
      _title = widget.projectData.title;
      _dateTime = formatDateString(DateTime.now().toIso8601String());
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
  }

  //for opening video list
  ValueChanged callBack(int value) {
    var youtubeToken = MemoryManagement.getYoutubeToken();
    var vimeoToken = MemoryManagement.getVimeoToken();

    if (value == 1) //for youtube
    {
      if (_channel != null) {
        showAllVideosBottomSheet(1); //list already loaded
      } else {
        getChannelIdApi(youtubeToken); //get videos from user youtube channel
      }
    } else {
      if (_vimeoVideosListResponse != null) {
        showAllVideosBottomSheet(2); //list already loaded show vimeo
      } else {
        getVimeoVideosList(vimeoToken); //load vimeo video list
      }
    }
  }

  //get vimeo video list after authentication
  Future<void> getVimeoVideosList(String token) async {
    provider.setLoading();
    var response = await providerCreateProfile.getVimeoVideoList(token);
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
    //unknown failure
    else {
      showInSnackBar(Messages.genericError);
    }
  }

  void showAllVideosBottomSheet(int type) async {
    var response = await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: VideosListBottomViewDemo(
                  type, _channel, _vimeoVideosListResponse),
            ),
          );
        });
    //back to previous bottom sheet
    if (response is String) {
      _showProjectInfoBottomSheet(); //save video url
    }
    //if got the data from
    else if (response is YoutubeVimeoVideoModel) {
      //_mediaUrl = response.videoUrl;
      _showReel.media = response.videoUrl;
      print("selected url $_mediaUrl");
      _showProjectInfoBottomSheet(); //save video url
    }
  }

  getChannelIdApi(String token) async {
    provider.setLoading();
    var response = await providerCreateProfile.getChannelId(token, context);

    if (response is ChannelIdResponse) {
      _initChannel();
    } else {
      provider.hideLoader();
      showInSnackBar(response.error);
      //token expired
      if (response.status == 401) {
        invalidateToken(1); //for youtube token
      }
    }
  }

  void invalidateToken(int type) {
    if (type == 1) //for _youtubeToken
    {
      MemoryManagement.setYoutubeToken(token: null);
    } else {
      MemoryManagement.setVimeoToken(token: null);
    }
  }

  //for youtube
  _initChannel() async {
    Channel channel = await APIService.instance
        .fetchChannel(channelId: providerCreateProfile.id);
    setState(() {
      _channel = channel;
    });
    provider.hideLoader();
    showAllVideosBottomSheet(1);
  }

  ValueChanged<String> videoFullView(String url) {
    var currentWidget = _videoViewStateKey.currentState.widget;
    //widget.fullVideoViewCallBack(url);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => YoutubeViemoFullVideoPlayer(currentWidget)),
    );
  }

  //like unlike the proejct
  Future<bool> likeUnlikeApi(String projectId) async {
    var response = await suggestionProvider.likeUnlikeProject(
        context, int.parse(projectId), _isLikeBy ? 1 : 0);

    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      if (_isLikeBy) {
        _isLikeBy = false;
        _likeCount = _likeCount - 1;
        provider?.projectResponse?.isLike = false;
      } else {
        _isLikeBy = true;
        _likeCount = _likeCount + 1;
        provider?.projectResponse?.isLike = true;
      }
    }
  }

  ValueChanged<bool> likeUnlikeStatus(bool status) {
    _isLikeBy = status;
    provider.projectResponse?.isLike = status;
    if (status) {
      _likeCount = _likeCount + 1;
    } else {
      _likeCount = _likeCount - 1;
    }

    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
