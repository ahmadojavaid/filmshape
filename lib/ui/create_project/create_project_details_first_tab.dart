import 'dart:async';
import 'dart:ffi';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/create_project/create_project_request.dart';
import 'package:Filmshape/Model/create_project/create_project_response.dart';
import 'package:Filmshape/Model/gender/gender_response.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/create_project/common_list_tabs.dart';
import 'package:Filmshape/ui/create_project/create_project_setting_bottom_sheet.dart';
import 'package:Filmshape/ui/statelesswidgets/bottom_sheet_share.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/notifier.dart';
import 'package:provider/provider.dart';

class CreateSuccessFirst extends StatefulWidget {
  final String projectId;
  final bool isRole;
  final ValueChanged<Widget> fullScreenCallBack;
  final VoidCallback callbackProjectDeleted;

  CreateSuccessFirst(this.projectId, this.fullScreenCallBack,
      {Key key, bool this.isRole, this.callbackProjectDeleted})
      : super(key: key);

  @override
  UserProfileState createState() => UserProfileState();
}

class UserProfileState extends State<CreateSuccessFirst>
    with AutomaticKeepAliveClientMixin<CreateSuccessFirst> {
  String projectType;
  String genre;
  String location;
  String payment;
  String projectStatus;
  Notifier _notifier;

  TextEditingController _BioController = new TextEditingController();
  TextEditingController _LocationController = new TextEditingController();
  TextEditingController _TitleController = new TextEditingController();

  FocusNode _BioField = new FocusNode();
  FocusNode _LocationField = new FocusNode();
  FocusNode _NameField = new FocusNode();

  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  JoinProjectProvider provider;
  CreateProfileSecondProvider providerCreateProfile;

  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  ValueNotifier<bool> paidUnpaidNotifier = new ValueNotifier(true);
  ValueNotifier<bool> salaryNotifier = new ValueNotifier(false);
  List<ProjectRoleCalls> myTeam = List();
  GlobalKey<RoleListState> _roleTeamKey = new GlobalKey<RoleListState>();
  ProjectResponse projectResponse;

  @override
  void initState() {
    super.initState();
    print("roles ${widget.isRole}");
    Future.delayed(const Duration(milliseconds: 300), () {
      hitCommonApi(0);
    });
  }

  String setData(ProjectResponse response) {
    this.projectResponse = response;
    if (_TitleController.text.isNotEmpty) {
      _notifier.notify('action', _TitleController.text ?? ""); //update title
      return  _TitleController.text ?? "";
    } else {
      _notifier.notify('action', response.title ?? ""); //update title

    }

    myTeam?.clear();
    _TitleController.text = response.title;
    _LocationController.text = response.location;
    _BioController.text = response.description;
    if (response.projectType != null)
      projectType = response.projectType?.name ?? "";
    if (response.genre != null)
      genre = response.genre?.name ?? "";
    if (response.status != null)
      projectStatus = response.status?.name ?? "";
    if (response.projectRoleCalls != null) {
      myTeam.addAll(response.projectRoleCalls);
    }
    _roleTeamKey.currentState.setRolesData(myTeam); //update role data
    setState(() {

    });

    return null;

  }


  void updateData(Showreel response) {
    _TitleController.text = response.title;
    _BioController.text = response.description;
  }
  Widget buttonAddRole() {
    return InkWell(
      onTap: () {
//        Navigator.push(
//          context,
//          new CupertinoPageRoute(builder: (BuildContext context) {
//            return new AddRequiredRole(
//              widget.projectId,
//              isForEditRole: true,
//            );
//          }),
//        );


        Navigator.pop(context);

      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            color: AppColors.kPrimaryBlue),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 14.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              Icons.person_add,
              color: Colors.white,
              size: 21.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              "Add a role",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
          ],
        ),
      ),
    );
  }


  hitApi() async {
    //create request body
    var _createProjectRequest = new CreateProjectRequest();
    _createProjectRequest.type = "Project";

    //for project type selection
    if (
    provider.projectTypeDataResponse.data != null) {
      for (var data in provider.projectTypeDataResponse.data) {
        if (data.name == projectType) {
          projectResponse.projectType.name=projectType;

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
          projectResponse.genre.name=genre;

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
          projectResponse.status.name=projectStatus;

          _createProjectRequest.status =
              RolesCreateProfile(type: "ProjectStatus", id: data.id);
          break;
        }
      }
    }

    // _createProjectRequest.media = _mediaUrl;

    _createProjectRequest.location = _LocationController.text;
    projectResponse?.location = _LocationController.text;
    _createProjectRequest.title = _TitleController.text;
    projectResponse?.title = _TitleController.text;

    _createProjectRequest.description = _BioController.text;

    projectResponse?.description = _BioController.text;

    //if project already created than just update it
    var response = await providerCreateProfile.updateProject(
        _createProjectRequest, context, widget.projectId);

    //project created successfully
    if (response is CreateProjectResponse) {
      //save current project name for later user

    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
    print("success $response");
  }



  Widget videoLinkView(String text, IconData image, Color color, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          _createProjectBottomSheet(CreateProjectSettingBottomSheet(
            widget.callbackProjectDeleted,
            widget.projectId,
            response: projectResponse,));
        } else {
          showModalBottomSheet<void>(
              isScrollControlled: true,
              context: context,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(7.0),
                    topRight: Radius.circular(7.0)),
              ),
              builder: (BuildContext bc) {
                return ShareBottomSheet();
              });
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: type == 1 ? AppColors.borderSetting : color, width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              image,
              color: color,
              size: 18.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              text,
              style: new TextStyle(
                  color: color,
                  fontSize: 15,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    saveData();
    super.dispose();
  }

  void saveData() {
    hitApi();
    _streamControllerShowLoader.close(); //close the stream on disponsse

  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  hitCommonApi(int type) async {
    var response;
    provider.setLoading();
    switch (type) {
      case 0:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        response = await provider.getCommonData(context, 2, "ProjectGenre/");
        response = await provider.getCommonData(context, 3, "ProjectStatus/");
        provider.hideLoader();

        break;
      case 1:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        break;
      case 2:
        response = await provider.getCommonData(context, 2, "ProjectGenre/");
        break;
      case 3:
        response = await provider.getCommonData(context, 3, "ProjectStatus/");
        break;
    }

    if (response != null && (response is GenderResponse)) {
      //("suvccess");
    } else {
      //("error");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  //show bottom sheet for update reel data for user
  void _createProjectBottomSheet(Widget widget) async {
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
                  child: widget));
        });
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
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
          } else if (type == 3) {
            if (provider.statusList.length == 0) {
              provider.setLoading();
              hitCommonApi(3);
            }
          }
        },
        child: DropDownButtonWidget(
            title: title,
            list: list,
            image: image,
            hint: hint,
            callBack: valueChanged));
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
    _notifier = NotifierProvider.of(context); // to update home screen header

    return Stack(
      children: <Widget>[
        new ListView(
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Colors.white,
              child: new Column(
                children: <Widget>[
                  new SizedBox(
                    height: 35.0,
                  ),
                  videoLinkView(
                      "Project settings", Icons.settings, Colors.black, 1),
                  new SizedBox(
                    height: 25.0,
                  ),
                  getTextField(
                      null,
                      "Project Title",
                      _TitleController,
                      _NameField,
                      _LocationField,
                      false,
                      TextInputType.text,
                      prefixIcon: Icons.edit,
                      notifier: _notifier),
                  sizeBox,
                  getDropdownItem(
                      projectType,
                      provider.projectTypeList,
                      1,
                      AssetStrings.ploject_type,
                      "Project type",
                      projectTypeCallBack),
                  sizeBox,
                  getDropdownItem(genre, provider.genreList, 2,
                      AssetStrings.paint, "Genre", projectGenreCallBack),
                  sizeBox,
                  getLocation(
                      _LocationController, context, _streamControllerShowLoader,
                      iconData: Icons.location_on, iconPadding: 9),
                  sizeBox,
                  getTextField(null, "Description", _BioController, _BioField,
                      _BioField, false, TextInputType.text,
                      prefixIcon: Icons.message, maxlines: 6),
                  sizeBox,
                  getDropdownItem(
                      projectStatus,
                      provider.statusList,
                      3,
                      AssetStrings.ic_tick,
                      "Project status",
                      projectStatusCallBack),
                  new SizedBox(
                    height: 25.0,
                  ),
                  videoLinkView("Share project", Icons.public,
                      AppColors.kPrimaryBlue, 2),
                  new SizedBox(
                    height: 45.0,
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
                  ),

                  //for showing user roles
                  CommonList(
                    widget.projectId,
                    widget.fullScreenCallBack,
                    isRole: widget.isRole,
                    key: _roleTeamKey,
                  )
                ],
              ),
            ),
            new SizedBox(
              height: 40.0,
            ),
          ],
        ),
      ],
    );
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
