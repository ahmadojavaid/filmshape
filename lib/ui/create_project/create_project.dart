import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/create_project/create_project_request.dart';
import 'package:Filmshape/Model/create_project/create_project_response.dart';
import 'package:Filmshape/Model/create_project/youtube_vimeo_video_model.dart';
import 'package:Filmshape/Model/gender/gender_response.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Model/youtube/channel_model.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/create_project/add_required_role.dart';
import 'package:Filmshape/ui/create_project/videoslistbottomsheet.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:Filmshape/ui/youtube/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

import 'mediabottomsheet.dart';

class CreateProject extends StatefulWidget {
  final ValueChanged<Widget> fullScreenCallBack;
  final ValueSetter<BadgeCount> callBackUpdateProjectCount;
  String previousTabHeading;

  CreateProject(this.fullScreenCallBack, this.callBackUpdateProjectCount,
      {this.previousTabHeading});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<CreateProject>
    with WidgetsBindingObserver {
  String projectType;
  String genre;
  String location;
  String payment;
  String projectStatus;
  String _projectId;

  TextEditingController _BioController = new TextEditingController();
   TextEditingController _LocationController = new TextEditingController();
  TextEditingController _TitleController = new TextEditingController();


  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _BioField = new FocusNode();
  FocusNode _LocationField = new FocusNode();
  FocusNode _NameField = new FocusNode();


  final StreamController<bool> _streamControllerShowLoader =
  StreamController<bool>();

  final StreamController<String> _streamControllerProjectTitle =
  StreamController<String>();


  JoinProjectProvider provider;
  CreateProfileSecondProvider providerCreateProfile;


  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String profile;

  Channel _channel;
  VimeoVideosListResponse _vimeoVideosListResponse;

  String _youtubeToken;
  String _vimeoToken;
  String _mediaUrl;

  Notifier _notifier;
  String _videoThumbNail;

  CreateProjectRequest _createProjectRequest;

  ValueNotifier<bool> salaryNotifier = new ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

    Future.delayed(const Duration(milliseconds: 300), () {
      hitCommonApi(0);
      _notifier?.notify('action', 'Create Project');
     });
  }

  @override
  void dispose() {
    _streamControllerShowLoader.close(); //close the stream on dispose
    _streamControllerProjectTitle.close(); //close when title gets update

    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify(
          'action', widget.previousTabHeading);

    super.dispose();
  }




  Widget attributeHeading(String text, IconData image) {
    return InkWell(onTap: () {
     // FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
      quickAccessVideoLinkBottomSheet();
    },

      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: new Border.all(color: AppColors.buttonBorder,
                width: INPUT_BOX_BORDER_WIDTH),
            color: AppColors.white
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),
            new Icon(
              image,
              color: AppColors.kPrimaryBlue,
              size: 19.0,
            ),
            new SizedBox(
              width: 11.0,
            ),

            new Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AssetStrings.lotoRegularStyle,
                  fontSize: 15
              ),
            ),
          ],
        ),
      ),
    );
  }


  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }


  hitApi() async {
    bool _projectStatus = (_projectId != null) ? true : false;
    //for project being created or updated
    (_projectStatus)?providerCreateProfile.setLoading():provider.setLoading();

    //create request body
    _createProjectRequest = new CreateProjectRequest();
    _createProjectRequest.type = "Project";

    //for project type selection
    if (
    provider.projectTypeDataResponse.data != null) {
      for (var data in provider.projectTypeDataResponse.data) {
        if (data.name == projectType) {
          _createProjectRequest.project_type =
              RolesCreateProfile(type: "ProjectType",
                  id: data.id);
          break;
        }
      }
    }

    //project genre selection
    if (
    provider.projectGenreDataResponse.data != null) {
      for (var data in provider.projectGenreDataResponse.data) {
        if (data.name == genre) {
          _createProjectRequest.genre =
              RolesCreateProfile(type: "ProjectGenre",
                  id: data.id);
          break;
        }
      }
    }
    //for project status
    if (
    provider.projectStatusDataResponse.data != null) {
      for (var data in provider.projectStatusDataResponse.data) {
        if (data.name == projectStatus) {
          _createProjectRequest.status =
              RolesCreateProfile(type: "ProjectStatus",
                  id: data.id);
          break;
        }
      }
    }

    _createProjectRequest.media = _mediaUrl;


    if (_LocationController.text.length > 0) {
      _createProjectRequest.location = _LocationController.text;
    }

    if (_TitleController.text.length > 0) {
      _createProjectRequest.title = _TitleController.text;
    }

    if (_BioController.text.length > 0) {
      _createProjectRequest.description = _BioController.text;
    }


    //if project already created than just update it
    var response = (_projectStatus) ? await providerCreateProfile.updateProject(
        _createProjectRequest, context,_projectId) : await provider.createProject(
        _createProjectRequest, context);

    //project created successfully
    if (response is CreateProjectResponse) {
      //if fresh project is being created
      if (!_projectStatus) {
        widget
            .callBackUpdateProjectCount(
            BadgeCount(type: 1)); //update navigation bar project count
      }
      //save current project name for later user
      MemoryManagement.setCurrentProjectName(_TitleController.text);

      _projectId = response.id.toString(); //project id to update project later


      hideSalary(salaryNotifier.value);


    }
    else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
    print("success $response");
  }


  hitCommonApi(int type) async {
    var response;
    provider.setLoading();
    switch (type) {
      case 0:
        response = await provider.getCommonData(
            context, 1, "ProjectType/", isCreating: true);
        response = await provider.getCommonData(
            context, 2, "ProjectGenre/", isCreating: true);
        response = await provider.getCommonData(
            context, 3, "ProjectStatus/", isCreating: true);
        provider.hideLoader();

        break;
      case 1:
        response = await provider.getCommonData(
            context, 1, "ProjectType/", isCreating: true);
        break;
      case 2:
        response = await provider.getCommonData(
            context, 2, "ProjectGenre/", isCreating: true);
        break;
      case 3:
        response = await provider.getCommonData(
            context, 3, "ProjectStatus/", isCreating: true);
        break;
    }
    provider.hideLoader();

    if (response != null && (response is GenderResponse)) {
      //("suvccess");
    } else {
      //("error");
    }
  }


  hideSalary(bool status) async {
    provider.setLoading();

    /*  HideSalaryRequest request = new HideSalaryRequest(private: isBoolen);*/
    var response = await providerCreateProfile.hideSalary(
        context, status, _projectId);

    provider.hideLoader();

    if ((response is APIError)) {
      showInSnackBar("Failed !! try again");
    }
    else {
      Navigator.push(
          context,
          new CupertinoPageRoute(builder: (BuildContext context) {
            return new AddRequiredRole(
                response.id.toString(),
                widget.fullScreenCallBack);
          }));
    }

    setState(() {

    });
  }


  Widget getHideSalary() {
    return new Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: AppColors.creatreProfileBordercolor, width: 1.5),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 11.0, vertical: 1.0),
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: new Text(
                "Hide project from search result",
                style: new TextStyle(
                    fontFamily: AssetStrings.lotoRegularStyle,
                    color: AppColors.kBlack,
                    fontSize: 15),
              )),
          ValueListenableBuilder(
            valueListenable: salaryNotifier,
            builder: (context, value, _) {
              return new Checkbox(
                value: salaryNotifier.value,
                activeColor: AppColors.kBlack,
                onChanged: (bool value) {
                  salaryNotifier.value = value;
                },
              );
            },
          ),
        ],
      ),
    );
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    // FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    return InkWell(
      onTap: () {
        if (type == 1) {
          if (provider.projectTypeList.length == 0) {
            provider.setLoading();
            hitCommonApi(1);
          }
        } else if (type == 2) {
          if (provider.genreList.length == 0) {
            provider.setLoading();
            hitCommonApi(2);
          }
        }
        else if (type == 3) {
          if (provider.statusList.length == 0) {
            provider.setLoading();
            hitCommonApi(3);
          }
        }
      },
        child: DropDownButtonWidget(title: title,
            list: list,
            image: image,
            hint: hint,
            callBack: valueChanged)
    );
  }

  ValueChanged<String> projectTypeCallBack(String value) {
    projectType = value;
  }

  ValueChanged<String> projectGenreCallBack(String value) {
    genre = value;
  }

  ValueChanged<String> projectStatusCallBack(String value) {
    projectStatus = value;
  }



  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    providerCreateProfile = Provider.of<CreateProfileSecondProvider>(context);

    _notifier = NotifierProvider.of(context);// to update home screen header
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: AppColors.white,
            key: _scaffoldKey,
            body: Container(
              height: getScreenSize(context: context).height,
              child: Form(
                key: _fieldKey,
                child: new SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            MediaWidget(_videoThumbNail),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Center(
                                child: attributeHeading(
                                    "Link a film or trailer",
                                    Icons.videocam),
                              ),
                            )
                          ],
                        ),


                        new Container(
                          color: Colors.white,
                          child: new Column(

                            children: <Widget>[
                              new SizedBox(
                                height: 45.0,
                              ),

                              getTextField(
                                  validatorProjectTitle,
                                  "Project Title",
                                  _TitleController,
                                  _NameField,
                                  _LocationField,
                                  false,
                                  TextInputType.text,
                                  prefixIcon: Icons.edit,
                                  notifier: _notifier //to update title on change
                              ),
                              sizeBox,
                              getDropdownItem(
                                  projectType, provider.projectTypeList, 1,
                                  AssetStrings.ploject_type, "Project type",
                                  projectTypeCallBack),
                              sizeBox,
                              getDropdownItem(genre, provider.genreList, 2,
                                  AssetStrings.paint, "Genre",
                                  projectGenreCallBack),
                              sizeBox,
                              getLocation(_LocationController, context,
                                  _streamControllerShowLoader,
                                  iconData: Icons.location_on,
                                  iconPadding: ICON_LEFT_PADDING
                              ),

                              sizeBox,
                              getTextField(
                                  null,
                                  "Description",
                                  _BioController,
                                  _BioField,
                                  _BioField,
                                  false,
                                  TextInputType.text,
                                  prefixIcon: Icons.message,
                                  maxlines: 6
                              ),
                              sizeBox,

                              getDropdownItem(
                                  projectStatus, provider.statusList, 3,
                                  AssetStrings.ic_tick, "Project status",
                                  projectStatusCallBack),


                              sizeBox,


                              getHideSalary(),

                              new SizedBox(
                                height: 40.0,
                              ),

                              getContinueProfileSetupButtonLight(
                                  callback, "Continue to required roles"),

                            ],
                          ),
                        ),

                        new SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: (provider.getLoading()||providerCreateProfile.getLoading()),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  VoidCallback callback() {
    if (_fieldKey.currentState.validate()) {
      hitApi();
    }
  }

  void quickAccessVideoLinkBottomSheet() async {
    var videoUrl = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: MediaBottomViewDemo(callBack, _mediaUrl),
              ));
        });


    //if got the data from
    if (videoUrl != null) {
      _mediaUrl = videoUrl;
      setState(() {

      });
    }
  }

  void showAllVideosBottomSheet(int type) async {
    var response = await showModalBottomSheet<YoutubeVimeoVideoModel>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0)),
        ),

        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery
                .of(context)
                .size
                .height / 2,
            child: Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: VideosListBottomViewDemo(
                  type, _channel, _vimeoVideosListResponse),
            ),
          );
        }
    );
    //if got the data from
    if (response != null) {
      _mediaUrl = response.videoUrl;
      _videoThumbNail = response.thumbNail;
      print("selected url $_mediaUrl , $_videoThumbNail");
      setState(() {

      });
    }
  }

  //for opening video list
  ValueChanged callBack(int value) {
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

    if (value == 1) //for youtube
        {
      if (_channel != null) {
        showAllVideosBottomSheet(
            1); //list already loaded show youtube video list
      }
      else {
        getChannelIdApi(); //get videos from user youtube channel
      }
    }
    else {
      if (_vimeoVideosListResponse != null) {
        showAllVideosBottomSheet(2); //list already loaded show vimeo
      }
      else {
        getVimeoVideosList(); //load vimeo video list
      }
    }
  }

  //get vimeo video list after authentication
  Future<void> getVimeoVideosList() async
  {
    providerCreateProfile.setLoading();
    var response = await providerCreateProfile.getVimeoVideoList(_vimeoToken);
    providerCreateProfile.hideLoader();
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

  getChannelIdApi() async {
    providerCreateProfile.setLoading();
    var response = await providerCreateProfile.getChannelId(
        _youtubeToken, context);

    if (response != null && (response is ChannelIdResponse)) {
      _initChannel();
    }
    else {
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
      _youtubeToken = null;
      MemoryManagement.setYoutubeToken(token: null);
    }
    else {
      _vimeoToken = null;
      MemoryManagement.setVimeoToken(token: null);
    }
  }

  //for youtube
  _initChannel() async {
    providerCreateProfile.setLoading();
    Channel channel = await APIService.instance
        .fetchChannel(channelId: providerCreateProfile.id);
    setState(() {
      _channel = channel;
    });
    providerCreateProfile.hideLoader();
    showAllVideosBottomSheet(1);
  }


}

class MediaWidget extends StatelessWidget {
  final String videoThumbNail;

  MediaWidget(this.videoThumbNail);

  @override
  Widget build(BuildContext context) {
    //print("video thumbnail $videoThumbNail");
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
          decoration: (videoThumbNail == null) ? new BoxDecoration(
            color: AppColors.noVideoBackground,
          ) : new BoxDecoration(
              color: AppColors.noVideoBackground,
              image: new DecorationImage(image: new NetworkImage(
                  videoThumbNail),
                  fit: BoxFit.cover))),
    );
  }
}