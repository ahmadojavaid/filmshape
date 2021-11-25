import 'dart:async';
import 'dart:collection';

import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/notifier_provide_model/my_profile.dart';
import 'package:Filmshape/ui/create_project/send_invite_bottom_sheet.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InviteProjectBottomSheet extends StatefulWidget {
  final String userFullName;
  final String userId;

  InviteProjectBottomSheet(this.userFullName, this.userId);

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<InviteProjectBottomSheet> {
  JoinProjectProvider provider;
  MyProfileProvider myProfileProvider;

  String projectType = "Select project";
  DataModel modelCount = new DataModel();
  List<String> list = new List();

  List<List<String>> listSend = new List();
  HashMap<String, List<AddRoleModelBottom>> maps = new HashMap();
  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  List<AddRoleModelBottom> listRoles = new List();

  String selectedPopupRoute = "My Home";

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  void _showPopupMenu(Offset offset) async {
    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(52, 150, 60, 0),
      items: list.map((String popupRoute) {
        return new PopupMenuItem<String>(
          child: Container(
              width: MediaQuery.of(context).size.width - 50,
              child: new Text(popupRoute)),
          value: popupRoute,
        );
      }).toList(),
      elevation: 8.0,
    );

    if (selected != null) {
      projectType = selected;

      print(projectType);

      maps.forEach((keys, value) {
        if (keys == projectType) {
          listRoles.clear();
          listRoles.addAll(value);
          setState(() {});
        }
      });

      setState(() {});
    }
  }

  @override
  void dispose() {
    _streamControllerShowLoader.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitGetMyProfileApi();
    });
  }

  hitGetMyProfileApi() async {
    var userId = MemoryManagement.getuserId();
    provider.setLoading();
    var response = await myProfileProvider.getProfileData(
        userId, context); // get current user profile
    provider.hideLoader();

    LinkedHashMap roleCategoryMap =
        new LinkedHashMap<String, AddRoleModelBottom>();
    LinkedHashMap roleNameMap = new LinkedHashMap<String, DataModel>();

    if (response is MyProfileResponse) {
      for (var item in response.projects) {
        List<AddRoleModelBottom> listRolesLocal = new List();
        var title = item.title != null ? item.title : "Null";
        list.add(title);

        if (item.projectRoleCalls.length > 0) {
          for (var role in item.projectRoleCalls) {
            var titleRole = role.role.category.name;
            var icon = role.role.category.iconUrl;

            //check if same role already exists
            if (roleCategoryMap.containsKey(titleRole)) {
              AddRoleModelBottom mainModel =
                  roleCategoryMap[titleRole]; //get the main role category
              List<DataModel> childRoleList =
                  mainModel.list; //get the role list form
              //if same role exists
              if (roleNameMap.containsKey(role.role.name)) {
                //get the same role and increate the count
                DataModel roleData = roleNameMap[role.role.name];
                roleData.count += 1; //increase the count for same role
              } else {
                //create new role under same role category and add to list
                //category like Direction, Actor and Animator etc
                DataModel dataModel = new DataModel(
                    name: role.role.name, count: 1, roleId: role.role.id);
                childRoleList.add(dataModel);
              }
            } else //not exists its new role
            {
              List<DataModel> childRoleList =
                  new List(); //role category role item list
              //create role item with count
              DataModel dataModel = new DataModel(
                  name: role.role.name, count: 1, roleId: role.role.id);
              childRoleList.add(dataModel);
              //add role to map
              roleNameMap[role.role.name] = dataModel;

              //create category role item
              var mainModel = new AddRoleModelBottom(
                  title: titleRole != null ? titleRole : "",
                  iconurl: icon != null ? icon : "",
                  list: childRoleList);

              roleCategoryMap[titleRole] = mainModel;
              listRolesLocal.add(mainModel);
            }
          }
        }

        maps[title] = listRolesLocal;
      }

      setState(() {});
    } else {
      print("error");
    }
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
            ]));
  }

  Widget _getSizeBox(double value) {
    return new SizedBox(
      height: value,
    );
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    return InkWell(
        onTap: () {},
        child: DropDownButtonWidget(
            title: title, list: list, hint: hint, callBack: valueChanged));
  }

  ValueChanged<String> projectTypeCallBack(String value) {
    projectType = value;

    maps.forEach((keys, value) {
      if (keys == projectType) {
        listRoles.clear();
        listRoles.addAll(value);
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    myProfileProvider = Provider.of<MyProfileProvider>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Container(
          height: MediaQuery.of(context).size.height - 10,
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _bottomSheetTop(),
                    divider(),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 30.0),
                      child: new Text(
                        "Select project",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 21.0),
                      ),
                    ),
                    new SizedBox(
                      height: 30.0,
                    ),
                    new GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _showPopupMenu(details.globalPosition);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 55.0,
                        padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                        margin: new EdgeInsets.only(
                            left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                                color: AppColors.borderSetting, width: 1.0),
                            borderRadius: new BorderRadius.circular(5.0)),
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: new Text(
                                  projectType,
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: AssetStrings.lotoRegularStyle,
                                      fontSize: 18.0),
                                ),
                              ),
                            ),
                            new SizedBox(
                              width: 5,
                            ),
                            new Icon(Icons.arrow_drop_down)
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: MARGIN_LEFT_RIGHT, top: 30.0),
                      child: new Text(
                        widget.userFullName != null
                            ? "Select a role for ${widget.userFullName}"
                            : "",
                        style: new TextStyle(
                            color: Colors.black,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 21.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: new EdgeInsets.only(top: 30.0),
                        child: new ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          padding: new EdgeInsets.all(0.0),
                          itemBuilder: (BuildContext context, int indexx) {
                            return getBoxItem(
                                listRoles[indexx]); //for extra space
                          },
                          itemCount: listRoles.length,
                        ),
                      ),
                    )
                  ],
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
      ),
    );
  }

  void sendInviteBottomSheet(
      String projectID, String roleID, String name) async {
    var videoUrl = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height - 30,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child:
                SendInviteBottomSheet(projectID, roleID, name, widget.userId),
          );
        });
  }

  Widget getBoxDataItem(List<DataModel> model, int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  modelCount = model[index];
                  if (modelCount.count > 0) {
                    List<String> localList = new List();
                    for (int i = 0; i < modelCount.count; i++) {
                      localList.add(modelCount.name);
                    }
                    int projectid;
                    for (var item
                        in myProfileProvider.profileResponse.projects) {
                      var title = item.title != null ? item.title : "Null";
                      if (title == projectType) {
                        projectid = item.id;
                        break;
                      }
                    }
                    sendInviteBottomSheet(projectid.toString(),
                        modelCount.roleId.toString(), modelCount.name);
                  }
                },
                child: Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 11.0, horizontal: 17.0),
                    child: Row(
                      children: <Widget>[
                        new Text(
                          model != null ? model[index].name : "",
                          style: new TextStyle(
                              color: AppColors.introBodyColor,
                              fontSize: 15,
                              fontFamily: AssetStrings.lotoRegularStyle),
                        ),
                        new SizedBox(
                          width: 6,
                        ),
                        Offstage(
                          offstage: model[index].count != null &&
                                  model[index].count > 0
                              ? false
                              : true,
                          child: new Text(
                            model != null ? "(${model[index].count})" : "",
                            style: new TextStyle(
                                color: AppColors.introBodyColor,
                                fontSize: 15,
                                fontFamily: AssetStrings.lotoRegularStyle),
                          ),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 8,
                          ),
                        ),
                        new Icon(Icons.arrow_right)
                      ],
                    )),
              ),
              index != model.length - 1
                  ? new Container(
                      height: 1.5,
                      color: Colors.grey.withOpacity(0.2),
                    )
                  : Container(),
            ]),
      ),
    );
  }

  Widget getRowItem(String title, String image) {
    return Container(
      child: new Row(
        children: <Widget>[
          getSvgNetworkImage(url: image, size: 16),
          new SizedBox(
            width: 8.0,
          ),
          new Text(
            title,
            style: new TextStyle(
                fontSize: 14.0,
                color: AppColors.kPrimaryBlue,
                fontFamily: AssetStrings.lotoRegularStyle),
          ),
        ],
      ),
    );
  }

  Widget getBoxItem(AddRoleModelBottom model) {
    return Container(
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getRowItem(model.title, model.iconurl),
            new SizedBox(
              height: 8.0,
            ),
          ]
            ..add(new Container(
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                    border: new Border.all(
                        color: Colors.grey.withOpacity(0.2), width: 1.5)),
                child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index) {
                    return getBoxDataItem(model.list, index); //for extra space
                  },
                  itemCount: model.list.length,
                )))
            ..add(new SizedBox(
              height: 20,
            )),
        ),
      ),
    );
  }

  Widget getHideSalary(ValueNotifier<bool> changeNotifier) {
    return new Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: changeNotifier.value == true
                ? AppColors.kPrimaryBlue
                : AppColors.kHideSalary,
            width: INPUT_BOX_BORDER_WIDTH),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 11.0, vertical: 1.0),
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: new Text(
            "Hide salary until position field",
            style: new TextStyle(
                fontFamily: AssetStrings.lotoRegularStyle,
                color: AppColors.kPrimaryBlue,
                fontSize: 15),
          )),
          ValueListenableBuilder(
            valueListenable: changeNotifier,
            builder: (context, value, _) {
              return new Checkbox(
                value: changeNotifier.value,
                activeColor: AppColors.kPrimaryBlue,
                onChanged: (bool value) {
                  changeNotifier.value = value;
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
