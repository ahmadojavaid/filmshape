import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_profile/media/create_profile_media_request.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Model/youtube/channel_model.dart';
import 'package:Filmshape/Model/youtube/video_model.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/ui/following/following_create_profiles.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtube/api_service.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ConnectAccount extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<ConnectAccount> {
  TextEditingController _ShowReelController = new TextEditingController();
  TextEditingController _BioController = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _InputField = new FocusNode();
  FocusNode _BioField = new FocusNode();
  FocusNode _TitleField = new FocusNode();
  CreateProfileSecondProvider provider;
  bool _isLoading = false;

  TextEditingController _InputUrlController = new TextEditingController();

  Channel _channel;
  VimeoVideosListResponse _vimeoVideosListResponse;

  String _videoUrl;

  String _videoThumbNail;
  String _youtubeToken;
  String _vimeoToken;

//authenticate the youtube user
  youtubeAuth() async {
    var response;
    if (Platform.isIOS) {
      response = await Navigator.push(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return new YoutubeAuthWebView();
        }),
      );
    } else {
      response = await androidYoutubeLogin();
    }
    //success response from
    if (response is YoutubeAuthTokenResponse) {
      _youtubeToken = response.accessToken;
      print("access token $_youtubeToken");
      MemoryManagement.setYoutubeToken(token: _youtubeToken);

      setState(() {});
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

  //authenticate the vimeo user
  Future<void> vimeoAuth() async {
    var response = await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new VimeoAuthWebView();
      }),
    );
    //success
    if (response is ViemoAuthTokenResponse) {
      _vimeoToken = response.accessToken;
      print("access token $_vimeoToken");
      MemoryManagement.setVimeoToken(token: _vimeoToken);

      setState(() {});
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

  //get vimeo video list after authentication
  Future<void> getVimeoVideosList() async {
    provider.setLoading();
    var response = await provider.getVimeoVideoList(_vimeoToken);
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
    Channel channel =
        await APIService.instance.fetchChannel(channelId: provider.id);
    setState(() {
      _channel = channel;
    });

    showAllVideosBottomSheet(1);
  }

  Widget videoLinkView(
      String text, String image, int from, bool fromBottomSheet) {
    return InkWell(
      onTap: () {
        //if connectivity
        if (fromBottomSheet) {
          Navigator.pop(context);
        }
        //youtube button clicked and from bottom sheet
        if (from == 1 && fromBottomSheet) //form youtube
        {
          if (_youtubeToken == null)
            youtubeAuth();
          else if (_channel != null) {
            showAllVideosBottomSheet(1); //list already loaded
          } else {
            getChannelIdApi(_youtubeToken);
          }
        }
        //load vimeo video from bottom sheet
        else if (from == 2 && fromBottomSheet) //form vimeo
        {
          if (_vimeoToken == null) {
            vimeoAuth();
          } else if (_vimeoVideosListResponse != null) {
            showAllVideosBottomSheet(2); //list already loaded show vimeo
          } else {
            getVimeoVideosList();
          }
        } else if (_youtubeToken == null && from == 1) {
          youtubeAuth();
        } else if (_vimeoToken == null && from == 2) {
          vimeoAuth();
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: (from == 1 && _youtubeToken != null)
                  ? Colors.red.withOpacity(0.6)
                  : (from == 2 && _vimeoToken != null)
                      ? Colors.blue.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.6),
              width: INPUT_BOX_BORDER_WIDTH),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              image,
              width: 20.0,
              height: 20.0,
              color: (from == 1 && _youtubeToken != null)
                  ? Colors.red.withOpacity(0.6)
                  : (from == 2 && _vimeoToken != null)
                      ? Colors.blue.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
            ),
            new SizedBox(
              width: 12.0,
            ),
            new Text(
              text,
              style: AppCustomTheme.createAccountLink,
            ),
          ],
        ),
      ),
    );
  }

  hitApi() async {
    var showReelid = MemoryManagement.getShowReelId();

    print(showReelid);
    provider.setLoading();
    UserShowReelRequest request = new UserShowReelRequest(
      title: _ShowReelController.text,
      description: _BioController.text,
      media: _videoUrl ?? "",
    );

    var response =
        await provider.updateUserShowReel(request, context, showReelid);

    if (response != null && (response is CreateProfileResponse)) {
      MemoryManagement.setScreen(screen: 3);

      Navigator.push(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return new FollowingCreateProfile();
        }),
      );
    } else {
      APIError apiError = response;
      /*showAlert(
        context: context,
        titleText: "ERROR",
        message: apiError.error,
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar(apiError.error);
    }
  }

  getChannelIdApi(String token) async {
    provider.setLoading();

    var response = await provider.getChannelId(token, context);

    if (response != null && (response is ChannelIdResponse)) {
      _initChannel();
    } else {
      APIError apiError = response;
      print(apiError.error);
      /*  showAlert(
        context: context,
        titleText: "ERROR",
        message: "Authentication Failed",
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar("Authentication Failed");
    }
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

//  Widget videoLinkViewBottomSheet(String text, String image, Color color,
//      Color colorIcon) {
//    return InkWell(
//      onTap: () {
//
//      },
//      child: new Container(
//        margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 20.0),
//        decoration: new BoxDecoration(
//          borderRadius: new BorderRadius.circular(5.0),
//          border: new Border.all(color: color, width: 1.0),
//        ),
//        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 15.0),
//        child: new Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new Image.asset(
//              image, width: 18.0, height: 18.0, color: colorIcon,),
//            new SizedBox(
//              width: 12.0,
//            ),
//            new Text(
//              text,
//              style: AppCustomTheme.createAccountLink,
//            ),
//          ],
//        ),
//      ),
//    );
//  }

  @override
  void initState() {
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

    super.initState();
  }

  Widget getListTileItem(String title, String image) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      child: ListTile(
        leading: new Image.asset(image),
        title: Align(
          child: Text(title),
          alignment: Alignment(-1.2, 0),
        ),
        trailing: Icon(
          Icons.arrow_right,
          color: Colors.black,
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String validatorBio(String value) {
    if (value.isEmpty) {
      return 'Please enter your bio';
    }
  }

  String validatorTitle(String value) {
    if (value.isEmpty) {
      return 'Please enter your title';
    }
  }

  VoidCallback backCallBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileSecondProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: appBarBackButton(onTap: backCallBack),
            body: Form(
              key: _fieldKey,
              child: new SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        height: 25.0,
                      ),
//                      InkWell(
//                        onTap: () {
//                          Navigator.pop(context);
//                        },
//                        child: Container(
//                          margin: new EdgeInsets.only(left: 25.0),
//                          child: new Row(
//                            crossAxisAlignment: CrossAxisAlignment.start,
//                            children: <Widget>[
//                              new Icon(Icons.arrow_back),
//                              new SizedBox(
//                                width: 5.0,
//                              ),
//                              new Text(
//                                "Back",
//                                style: AppCustomTheme.backButtonStyle,
//                              )
//                            ],
//                          ),
//                        ),
//                      ),
                      new SizedBox(
                        height: 35.0,
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                        child: new Text(
                          "Connect my account",
                          style: AppCustomTheme.createProfileSubTitle,
                        ),
                      ),
                      Container(
                        margin: new EdgeInsets.only(
                            left: MARGIN_LEFT_RIGHT, top: 4.0),
                        child: new Text(
                          "Connect account for quick video linking",
                          style: AppCustomTheme.body15Regular,
                        ),
                      ),
                      new SizedBox(
                        height: 30.0,
                      ),
                      videoLinkView(
                          (_youtubeToken == null)
                              ? "Connect my Youtube account"
                              : "Youtube connected",
                          AssetStrings.imageYoutube,
                          1,
                          false),
                      new SizedBox(
                        height: 20.0,
                      ),
                      videoLinkView(
                          (_vimeoToken == null)
                              ? "Connect my Vimeo account"
                              : "Vimeo connected",
                          AssetStrings.imageVimeo,
                          2,
                          false),
                      new SizedBox(
                        height: 50.0,
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                        child: new Text(
                          "Link my showreel",
                          style: AppCustomTheme.createProfileSubTitle,
                        ),
                      ),
                      new SizedBox(
                        height: 25.0,
                      ),
                      Stack(
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: new Container(
                              decoration: (_videoThumbNail == null)
                                  ? new BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                    )
                                  : new BoxDecoration(
                                      color: Colors.black.withOpacity(0.8),
                                      image: new DecorationImage(
                                          image:
                                              new NetworkImage(_videoThumbNail),
                                          fit: BoxFit.cover)),
                              margin:
                                  new EdgeInsets.only(left: 12.0, right: 12.0),
                              width: getScreenSize(context: context).width,
                              child: InkWell(
                                onTap: () {
                                  quickAccessVideoLinkBottomSheet();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: new Container(
                                width:
                                    (MediaQuery.of(context).size.width * 60) /
                                        100,
                                height: 30,
                                padding: new EdgeInsets.symmetric(
                                    horizontal: 3.0, vertical: 5.0),
                                decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.circular(14.0),
                                ),
                                child: new Row(
                                  children: <Widget>[
                                    new SizedBox(
                                      width: 10.0,
                                    ),
                                    new Image.asset(
                                      AssetStrings.imageLink,
                                      width: 14.0,
                                      height: 14.0,
                                    ),
                                    Expanded(
                                        child: InkWell(
                                      onTap: () {
                                        quickAccessVideoLinkBottomSheet();
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: new Text(
                                            _videoUrl == null
                                                ? "Link your showreel"
                                                : _videoUrl,
                                            style:
                                                AppCustomTheme.body14SemiBold,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      getTextField(
                          validatorTitle,
                          "Showreel title",
                          _ShowReelController,
                          _TitleField,
                          _BioField,
                          false,
                          TextInputType.text,
                          prefixIcon: Icons.mode_edit),
                      new SizedBox(
                        height: 20.0,
                      ),
                      getTextField(validatorBio, "Description", _BioController,
                          _BioField, _BioField, false, TextInputType.text,
                          prefixIcon: Icons.message, maxlines: 6),
                      new SizedBox(
                        height: 30.0,
                      ),
                      getContinueProfileSetupButton(
                          callback, "Continue profile setup"),
                      new SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
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
    );
  }

  VoidCallback callback() {
    hitApi();
  }

  String validatorPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
  }

  static String validatorEmail(String value) {
    return emailValidator(email: value);
  }

//  void _settingModalBottomSheet() {
//    GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
//    showModalBottomSheet<void>(
//        isScrollControlled: true,
//        context: context,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(7.0),
//              topRight: Radius.circular(7.0)),
//        ),
//
//        builder: (BuildContext bc) {
//          return Padding(
//            padding: MediaQuery.of(context).viewInsets,
//            child: Form(
//              key: _fieldKey,
//              child: Container(
//
//                child: new Wrap(
//
//                  children: <Widget>[
//
//                    Container(
//                      margin: new EdgeInsets.only(
//                          left: 30.0, right: 30.0, top: 10.0),
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.center,
//                        children: <Widget>[
//
//                          InkWell(
//                              onTap: () {
//                                Navigator.pop(context);
//                              },
//                              child: new Icon(Icons.keyboard_arrow_down,
//                                  size: 29.0)),
//                          new SizedBox(
//                            width: 4.0,
//                          ),
//                          InkWell(
//                            onTap: () {
//                              Navigator.pop(context);
//                            },
//                            child: new Text(
//                              "Close",
//                              style: new TextStyle(
//                                  color: Colors.black,
//                                  fontSize: 16.0),
//                            ),
//                          ),
//
//                          new SizedBox(
//                            width: 55.0,
//                          ),
//                          new Image.asset(AssetStrings.imageVimeo, width: 16.0,
//                            height: 16.0,
//                            color: Colors.lightBlue,),
//                          new SizedBox(
//                            width: 10.0,
//                          ),
//                          new Text(
//                            "Vimeo",
//                            style: new TextStyle(
//                                color: Colors.black,
//                                fontSize: 16.0),
//                          ),
//                          new SizedBox(
//                            width: 20.0,
//                          ),
//                        ],
//                      ),
//                    ),
//                    Container(
//                      margin: new EdgeInsets.only(
//                          left: 30.0, right: 30.0, top: 60.0),
//                      child: new Text(
//                        "Connect my Vimeo account",
//                        style: new TextStyle(
//                            color: Colors.black,
//                            fontSize: 21.0),
//                      ),
//                    ),
//                    Container(
//                      margin: new EdgeInsets.only(top: 10.0),
//                      child: getTextField(
//                          validatorEmail,
//                          "Email address",
//                          _EmailController,
//                          _EmailField,
//                          _PasswordField,
//                          false,
//                          TextInputType.emailAddress,
//                          Icons.email),
//                    ),
//
//                    getTextField(
//                        validatorPassword,
//                        "Password",
//                        _PasswordController,
//                        _PasswordField,
//                        _PasswordField,
//                        true,
//                        TextInputType.text,
//                        Icons.lock),
//
//                    Container(
//                      height: 50.0,
//                      margin: new EdgeInsets.only(
//                          left: 30.0, right: 30.0, top: 50.0),
//                      child: Material(
//                        child: Ink(
//                          decoration: new BoxDecoration(
//                              borderRadius: new BorderRadius.circular(5.0),
//                              boxShadow: [
//                                BoxShadow(
//                                  color: Colors.deepPurpleAccent.withOpacity(
//                                      0.2),
//                                  blurRadius: 8.0,
//                                  // has the effect of softening the shadow
//                                  spreadRadius: 2.0,
//                                  // has the effect of extending the shadow
//                                  offset: Offset(
//                                    2.0, // horizontal, move right 10
//                                    2.0, // vertical, move down 10
//                                  ),
//                                )
//                              ],
//                              color: Colors.deepPurpleAccent),
//                          child: InkWell(
//                            splashColor: Colors.deepPurpleAccent.withOpacity(
//                                0.3),
//                            onTap: () {
//                              if (_fieldKey.currentState.validate()) {
//                                Navigator.pop(context);
//                                showAllVideosBottomSheet();
//                              }
//                              else {
//
//                              }
//                            },
//                            child: new Container(
//                              padding: new EdgeInsets.only(
//                                  left: 20.0, right: 20.0),
//                              child: Row(
//                                children: <Widget>[
//
//                                  new Image.asset(
//                                    AssetStrings.imageVimeo, width: 16.0,
//                                    height: 16.0,
//                                    color: Colors.white,),
//
//                                  Expanded(
//                                    child: Container(
//                                      padding: new EdgeInsets.only(right: 20.0),
//                                      alignment: Alignment.center,
//                                      child: new Text(
//                                        "Connect my account",
//                                        style: AppCustomTheme.button,
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//
//                    new Container(
//                      height: 50.0,
//                      child: new Text("  "),
//                    )
//                  ],
//                ),
//              ),
//            ),
//          );
//        }
//    );
//  }

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
                  return buildVideoItem(
                      video.id, video.thumbnailUrl, video.title, 1);
                },
              ),
            ),
          )
        : new Container();
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
                  var thumbNail = (video.pictures.sizes.length > 3)
                      ? video.pictures.sizes[3].link
                      : video.pictures.sizes[0].link;
                  return buildVideoItem(video.link, thumbNail, video.name, 2);
                },
              ),
            ),
          )
        : new Container();
  }

  void quickAccessVideoLinkBottomSheet() {
    showModalBottomSheet<void>(
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
              child: new Wrap(
                children: <Widget>[
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.keyboard_arrow_down, size: 29.0),
                              new SizedBox(
                                width: 4.0,
                              ),
                              new Text(
                                "Close",
                                style: new TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 55.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_InputUrlController.text.length > 0) {
                              //check if it's youtube or vimeo link
                              if (_InputUrlController.text
                                      .contains("youtube") ||
                                  _InputUrlController.text.contains("vimeo")) {
                                _videoUrl = _InputUrlController.text;
                                setState(() {});
                              }
                              //invalid video link
                              else {
                                showInSnackBar(
                                    "Please link a Youtube or Vimeo video only");
                              }
                            } else //remove video if fields get cleared
                            {
                              _videoUrl = null;
                              _videoThumbNail = null;
                              setState(() {});
                            }

                            Navigator.pop(context);
                          },
                          child: new Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 6.0, horizontal: 13.0),
                            decoration: new BoxDecoration(
                                border: new Border.all(
                                    color: AppColors.delete_save_border,
                                    width: 1.0),
                                borderRadius: new BorderRadius.circular(16.0),
                                color: AppColors.delete_save_background),
                            child: new Row(
                              children: <Widget>[
                                new Icon(
                                  Icons.save,
                                  color: Colors.black45,
                                  size: 17.0,
                                ),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Save",
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 60.0),
                    child: new Text(
                      "Quick access for video linking",
                      style: AppCustomTheme.createAccountLink,
                    ),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 10.0),
                    child: videoLinkView(
                        (_youtubeToken == null)
                            ? "Connect my Youtube account"
                            : "Browse my Youtube videos",
                        AssetStrings.imageYoutube,
                        1,
                        true),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child: videoLinkView(
                        (_vimeoToken == null)
                            ? "Connect my Vimeo account"
                            : "Browse my Vimeo videos",
                        AssetStrings.imageVimeo,
                        2,
                        true),
                  ),
                  getTextFieldBottomSheet(
                      50,
                      null,
                      "Input a URL",
                      _InputUrlController,
                      _InputField,
                      _InputField,
                      false,
                      TextInputType.text,
                      Icons.link),
                  new Container(
                    height: 50.0,
                    child: new Text("  "),
                  )
                ],
              ),
            ),
          );
        });
  }

  void showAllVideosBottomSheet(int from) {
    showModalBottomSheet<void>(
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
              child: new Wrap(
                children: <Widget>[
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Icon(Icons.keyboard_arrow_down,
                                size: 29.0)),
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
                                color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                        new SizedBox(
                          width: 55.0,
                        ),
                        new Image.asset(
                          (from == 1)
                              ? AssetStrings.imageYoutube
                              : AssetStrings.imageVimeo,
                          width: 16.0,
                          height: 16.0,
                          color: (from == 1) ? Colors.red : Colors.blue,
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        new Text(
                          (from == 1) ? "YouTube" : "Vimeo",
                          style: new TextStyle(
                              color: Colors.black, fontSize: 16.0),
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
                            Icons.account_circle,
                            color: Colors.black,
                            size: 22.0,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, right: 30.0, top: 60.0),
                    alignment: Alignment.center,
                    child: new Text(
                      "Select a video for your project",
                      style: new TextStyle(color: Colors.black, fontSize: 17.0),
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
        });
  }

  Widget buildVideoItem(
      String videoUrl, String thumbUrl, String title, int from) {
    return InkWell(
      onTap: () {
        _videoUrl = (from == 1)
            ? "https://www.youtube.com/watch?v=${videoUrl}"
            : videoUrl;
        _InputUrlController.text =
            _videoUrl; //set url to bottom sheet input box
        _videoThumbNail = thumbUrl; //video thumbnail
        setState(() {});
        Navigator.pop(context);
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
                          url: thumbUrl, fit: BoxFit.cover),
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
}
