import 'package:Filmshape/Model/Login/add_manager_request.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/ui/showcaseviews/project_setting_show_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class CreateProjectSettingBottomSheet extends StatefulWidget {
  final VoidCallback callbackProjectDeleted;
  final String projectId;
  final ProjectResponse response;

  CreateProjectSettingBottomSheet(this.callbackProjectDeleted, this.projectId,
      {this.response});

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<CreateProjectSettingBottomSheet> {
/*  ValueNotifier<bool> paidUnpaidNotifier = new ValueNotifier(true);*/
  ValueNotifier<bool> salaryNotifier = new ValueNotifier(false);

  List<Creator> userList = new List();

  bool itemValue = false;

  CreateProfileSecondProvider providers;

  bool showToolTip;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    if (widget.response != null) {
      if (widget.response.team != null && widget.response.team.length > 0) {
        for (var team in widget.response.team) {
          //check for featured team member and it's should be not current user
          if (team.isFeatured && (!isCurrentUser(team.id.toString())))
            userList.add(team);
        }
      }


      if (widget.response.isPrivate != null) {
        salaryNotifier.value = widget.response.isPrivate;
      }
    }
    //get tutorial state
    var tutorialState = MemoryManagement.getToolTipState() ?? -1;
    showToolTip = (tutorialState ==
        TUTORIALSTATE.PROJECTSETTINGS.index); //check tutorial state

    //check if no user no need to show tooltip
    if(userList.length==0)
    {
      showToolTip=false;
    }
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget _bottomSheetTop() {
    return new Container(
        margin: new EdgeInsets.only(
            left: BOTTOMSHEET_MARGIN_LEFT_RIGHT, right: 20, top: 10.0),
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
                      style: new TextStyle(color: Colors.black, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: new SizedBox(
                  width: 55.0,
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              InkWell(
                onTap: () {
                  addManagerApi();
                },
                child: new Container(
                  padding:
                      new EdgeInsets.symmetric(vertical: 6.0, horizontal: 13.0),
                  decoration: new BoxDecoration(
                      border: new Border.all(
                          color: AppColors.delete_save_border, width: 1.0),
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
                        style:
                            new TextStyle(color: Colors.black, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
              ),
            ]));
  }

  Iterable<Widget> get actorWidgets sync* {
    for (var item in userList) {
      yield buildItem(item);
    }
  }

  Widget buildItem(Creator model) {
    if (model.select == null) {
      model.select = false;
    }
    return Container(
      child: Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: IntrinsicHeight(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: Colors.transparent, width: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: getCachedNetworkImageWithurl(
                                      url: model.thumbnailUrl,
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: new Container(
                                width: 13.0,
                                height: 13.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent,
                                    border: new Border.all(
                                        color: Colors.white, width: 1.3)),
                              ),
                            )
                          ],
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  model.fullName != null ? model.fullName : "",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: new EdgeInsets.only(right: 35.0),
                                    child: new Text(
                                      model.description != null
                                          ? model.description
                                          : "",
                                      style: new TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 25.0,
                          width: 25.0,
                          child: Checkbox(
                            value: model.select != null ? model.select : false,
                            activeColor: AppColors.kBlack,
                            onChanged: (bool value) {
                              model.select = !model.select;

                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  hideSalary(bool status) async {
    providers.setLoading();

    /*  HideSalaryRequest request = new HideSalaryRequest(private: isBoolen);*/
    var response =
        await providers.hideSalary(context, status, widget.projectId);

    providers.hideLoader();

    if ((response is APIError)) {
      showInSnackBar("Failed !! try again");
    } else {
      salaryNotifier.value = status;
      widget.response.isPrivate = status;
    }
  }

// hit this method for add manager
  addManagerApi() async {
    List<RolesManager> listNew = new List();

    for (var data in userList) {
      if (data.select) {
        var roles = RolesManager(type: "User", id: data.id);

        listNew.add(roles);
      }
    }

    if (listNew.length > 0) {
      providers.setLoading();

      AddManagerRequest request = new AddManagerRequest(managers: listNew);

      var response =
          await providers.addManagers(context, request, widget.projectId);

      providers.hideLoader();

      if ((response is APIError)) {
        showInSnackBar("Failed !! try again");
      } else {
        showInSnackBar("add manager successfully");
      }
    } else {
      showInSnackBar("please add minimum 1 user");
    }
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Project'),
          content: Text('Are you sure you want to delete this project?'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteProject();
              },
            ),
          ],
        );
      },
    );
  }

  deleteProject() async {
    providers.setLoading();

    var response = await providers.deleteProject(context, widget.projectId);

    providers.hideLoader();

    if ((response is APIError)) {
      showInSnackBar("Failed !! try again");
    } else {
      Navigator.pop(context); //close the bottom sheet
      widget.callbackProjectDeleted();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    providers = Provider.of<CreateProfileSecondProvider>(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor:
              !showToolTip ? Colors.white : Colors.grey.withOpacity(0.2),
          body: Container(
            height: MediaQuery.of(context).size.height - 50,
            child: Column(
              children: <Widget>[
                _bottomSheetTop(),
                divider(),
                Expanded(
                  child: new ListView(
                    children: <Widget>[
                      Container(
                        margin: new EdgeInsets.only(
                            left: 40.0, right: 40.0, top: 30.0),
                        child: new Text(
                          "Project managers",
                          style: new TextStyle(
                              color: Colors.black,
                              fontFamily: AssetStrings.lotoRegularStyle,
                              fontSize: 21.0),
                        ),
                      ),
                      Container(
                        margin: new EdgeInsets.only(
                            left: MARGIN_LEFT_RIGHT, top: 10.0),
                        child: new Text(
                          "Project owners can edit, hide and delete the project,\nThey also can add and remove users.",
                          style: new TextStyle(
                              color: Colors.black54, fontSize: 14.0),
                        ),
                      ),
                      divider(),
                      Stack(
                        children: <Widget>[
                          new Container(
                              margin: new EdgeInsets.only(
                                  top: 20.0, left: 40, right: 40),
                              child: new Wrap(
                                children: actorWidgets.toList(),
                              )),
                        ],
                      ),
                      new SizedBox(
                        height: 10.0,
                      ),
                      divider(),
                      sizeBox,
                      sizeBox,
                      InkWell(
                        onTap: () {},
                        child: Container(
                            height: 45.0,
                            margin: new EdgeInsets.only(top: 10.0),
                            child: getHideSalary()),
                      ),
                      InkWell(
                        onTap: () {
                          _showAlertDialog();
                        },
                        child: Container(
                            height: 45.0,
                            alignment: Alignment.center,
                            margin: new EdgeInsets.only(
                                left: 40.0, right: 40.0, top: 20.0),
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(5.0),
                              border: new Border.all(
                                  color: AppColors.heartColor,
                                  width: INPUT_BOX_BORDER_WIDTH),
                            ),
                            padding: new EdgeInsets.symmetric(
                              horizontal: 11.0,
                            ),
                            child: new Text(
                              "Delete project",
                              style: new TextStyle(
                                  fontFamily: AssetStrings.lotoRegularStyle,
                                  color: AppColors.kBlack,
                                  fontSize: 15),
                            )),
                      ),
                      sizeBox,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        new Center(
          child: getHalfScreenProviderLoader(
            status: providers.getLoading(),
            context: context,
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 0.0,
          left: 0.0,
          top: 0.0,
          child: Offstage(
              offstage: !showToolTip,
              child: InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: new Container(),
              )),
        ),
        Positioned(
          bottom: 30.0,
          right: 0.0,
          left: 0.0,
          child: Offstage(
              offstage: !showToolTip,
              child: ProjectSettingShowCase(
                callback: toolTipCallBack,
              )),
        )
      ],
    );
  }

  VoidCallback toolTipCallBack() {
    showToolTip = false; //hide tool tip
    setState(() {});
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
                  hideSalary(value);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
