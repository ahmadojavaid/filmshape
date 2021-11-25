import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/addrole/add_role_request.dart';
import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/filter_role_request.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/create_project_provider.dart';
import 'package:Filmshape/ui/create_project/expendable_join.dart';
import 'package:Filmshape/ui/create_project/user_assigned_role_bottom_sheet.dart';
import 'package:Filmshape/ui/payment_screen/PaymentScreen.dart';
import 'package:Filmshape/ui/project_details/create_project_final_screen.dart';
import 'package:Filmshape/ui/statelesswidgets/bottom_sheet_purchase.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddRequiredRole extends StatefulWidget {
  final String projectId;
  final bool isForEditRole;
  final List<String> myTeam;
  final int type;
  final ValueChanged<Widget> fullScreenCallBack;

  AddRequiredRole(this.projectId, this.fullScreenCallBack,
      {this.isForEditRole = false, this.myTeam, this.type});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<AddRequiredRole>
    with AutomaticKeepAliveClientMixin<AddRequiredRole> {
  CreateProfileProvider provider;
  List<String> _searchDataList;
  List<AddRoleModelBottom> listRoles = new List();
  Map<String, AddRoleModelBottom> _selectedRolesMaps = Map();
  int count = 0;

  String titleDeleted;

  DataModel modelCount = new DataModel();

  TextEditingController _SearchController = new TextEditingController();
  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  int _selectedRolesCount = 0;

  CreateProjectProvider providers;

  bool _isCameFromFinalScreen = false;

  bool _showRolesView = false;

  @override
  void initState() {
    super.initState();
    //if came to edit roles
/*    if (widget.isForEditRole) {
      Future.delayed(const Duration(milliseconds: 300), () {
       hitRolesApi();
      });
    }*/

    Future.delayed(const Duration(milliseconds: 300), () {
      hitRolesApi();
    });
  }

  @override
  void dispose() {
    _streamControllerShowLoader.close();
    super.dispose();
  }

  hitRolesApi() async {
    provider.setLoading();
    var response = await provider.getRoles(context);

    if (response != null && (response is GetRolesResponseMain)) {
      _searchDataList = new List();
      _searchDataList.addAll(provider.listAllRolesItem);

      if (widget.type != null) {
        checkedUncheckedPreSelectData();
      }
    } else {
      APIError error = response;
      showInSnackBar(error.error);
    }
    _showRolesView = true; //show the roles list now
  }

  //callback to role count added for each section
  Future<ValueSetter> voidCallBackCount(int count) async {
    //remove checked role from
    if (count == 0) {
      deleteToView();
      print("deletecalled $_selectedRolesCount");
    } else {
      modelCount.count = count;
      modelCount.isSelect = true;
      print("deletenot $_selectedRolesCount");

      _streamControllerShowLoader.add(true);
    }
    await countTotal();
    setState(() {});
  }

  //to get total selected roles
  void countTotal() async {
    _selectedRolesCount = 0;
    for (var data in listRoles) {
      for (var childData in data.list) {
        _selectedRolesCount += childData.count;
      }
    }

    print("total_selected_role_count $_selectedRolesCount");

    MemoryManagement.setRoleCount(role: _selectedRolesCount);
  }

  Future<ValueSetter> roleSelectedCallBack(List<String> list) async {
    Map<String, AddRoleModelBottom> _selectedRolesMapsLocal = Map();
    listRoles.clear(); //remove previous data

    String title = "";
    String icons = "";

    //this loop for show data bottom sheet

    if (provider.rolesList != null) {
      for (var data in provider.rolesList) {
        List<DataModel> dataList = List();
        for (var childData in data.roles) {
          if (childData.isChecked) {
            DataModel dataModel = new DataModel(
                name: childData.name, count: 1, roleId: childData.id);
            dataList.add(dataModel);
            icons = data.category.iconUrl;
            title = data.category.name;
          }
        }

        if (dataList.length > 0) {
          AddRoleModelBottom model = new AddRoleModelBottom(
              title: title, iconurl: icons, list: dataList);
          listRoles.add(model);
          //to keep tract of previously selected roles
          if (!_selectedRolesMapsLocal.containsKey(title)) {
            _selectedRolesMapsLocal[title] = model;
          }
        }
      }
    }
    //getting back previous count too
    if (_selectedRolesMaps.length > 0) {
      for (var data in listRoles) {
        if (_selectedRolesMaps.containsKey(data.title)) {
          var dataListPrevious = _selectedRolesMaps[data.title].list;
          for (var newModel in data.list) {
            for (var oldModel in dataListPrevious) {
              if (newModel.name == oldModel.name) {
                newModel.count = oldModel.count;
                break;
              }
            }
          }
        }
      }
    }
    await countTotal();
    _selectedRolesMaps.clear();
    _selectedRolesMaps.addAll(_selectedRolesMapsLocal);

    _streamControllerShowLoader.add(true);
    setState(() {});
  }

  goToView(String title) async {
    //this loop for show data bottomsheet

    if (provider.rolesList != null) {
      for (var data in provider.rolesList) {
        for (var childData in data.roles) {
          if (childData.isChecked) {
            if (childData.name == title) {
              titleDeleted = childData.name;

              MemoryManagement.setRoleCount(role: _selectedRolesCount);
              Navigator.push(context,
                  new CupertinoPageRoute(builder: (BuildContext context) {
                return new CreateProjectSecond(
                    childData.id,
                    childData.name,
                    widget.projectId,
                    voidCallBackCount,
                    _selectedRolesCount,
                    widget.fullScreenCallBack);
              }));
              break;
            }
          }
        }
      }
    }
  }

  deleteToView() async {
    //this loop for show data bottomsheet

    if (provider.rolesList != null) {
      for (var data in provider.rolesList) {
        for (var childData in data.roles) {
          if (childData.isChecked) {
            if (childData.name == titleDeleted) {
              childData.isChecked = false;
              break;
            }
          }
        }
      }
      roleSelectedCallBack(null);
    }

    setState(() {});
  }

  void addData(String data) async {
    for (GetRolesResponse list in provider.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data && !provider.list.contains(data)) {
          childItem.isChecked = true;
          list.category.isExpend = true;
          provider.listId.add(childItem.id);
          provider.list.add(childItem.name);
          provider.setRoleList(provider.listId);
          print(provider.list);
          print(provider.listId);
          AddRoleModel addmodel = new AddRoleModel(
              title: childItem.category.name,
              iconurl: childItem.iconUrl,
              list: childItem.name);

          var lists = List<String>();
          /*  lists.add(childItem.id.toString());
          lists.add(childItem.name.toString());
*/
          /* DataModel dataModel=new DataModel(name: childItem.name,count: "");
          lists.add(dataModel);
          */
          roleSelectedCallBack(lists);

          provider.addRoleBottomData(addmodel);
          break;
        }
      }
      setState(() {});
    }
  }

  Future<List<String>> getLocationSuggestionsList(String locationText) async {
    List<String> suggestionList = provider.listAllRolesItem
        .where((f) => f.toLowerCase().startsWith(locationText.toLowerCase()))
        .toList();

    return suggestionList;
  }

  Widget getDivider() {
    return new Container(
      height: 20.0,
      decoration: new BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: AppColors.dividerColor),
          left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
          right: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
          bottom: BorderSide(width: 1.0, color: AppColors.dividerColor),
        ),
        color: Colors.grey.withOpacity(0.1),
      ),
    );
  }

  Widget getRowItem(String title, String image) {
    return Container(
      color: Colors.white,
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

  Widget getAttributeItem(String title, String value) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: AppCustomTheme.myProfileAttributeHeadingStyle,
          ),
          new SizedBox(
            height: 5.0,
          ),
          new Text(
            value,
            style: new TextStyle(fontSize: 16.0),
            //style: AppCustomTheme.myProfileAttributeStyle,
          ),
        ],
      ),
    );
  }

  Widget getBoxDataItem(List<DataModel> model, int index) {
    print("count ${count}");

    if (index == 0) {
      count = 0;
    }

    if (model[index].count > 0) {
      count = count + model[index].count;
      print("selectrolenewss $count");
    }

    return InkWell(
      onTap: () {
        modelCount = model[index];
        goToView(model[index].name);
      },
      child: Container(
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () {
                  modelCount = model[index];
                  goToView(model[index].name);
                },
                child: Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 11.0, horizontal: 17.0),
                    child: Row(
                      children: <Widget>[
                        new Text(
                          model[index].name,
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
                                  model[index].count > 0 &&
                                  model[index].count != 0
                              ? false
                              : true,
                          child: new Text(
                            "(${model[index].count})",
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

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  VoidCallback callBackAppBar() {
    //if came here from create project screen
    if (_isCameFromFinalScreen ||
        (widget.isForEditRole != null && widget.isForEditRole)) {
      moveToFinalScreen();
      // Navigator.pop(context);
    }
    //if came back from final screen
    else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);
    providers = Provider.of<CreateProjectProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: backButton("Back", callBackAppBar),
        body: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 30.0),
                      child: new Text(
                        "Select required roles",
                        style: AppCustomTheme.createProfileSubTitle,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: MARGIN_LEFT_RIGHT,
                          right: MARGIN_LEFT_RIGHT,
                          top: 30.0),
                      child: AutoCompleteTextView(
                        defaultPadding: 0,
                        isLocation: false,
                        hintText: "Search for a role",
                        suggestionsApiFetchDelay: 100,
                        focusGained: () {},
                        onTapCallback: (String text) async {
                          addData(text);
                          closeKeyboard();
                        },
                        focusLost: () {
                          print("focust lost");
                        },
                        onValueChanged: (String text) {
                          print("called $text");
                        },
                        controller: _SearchController,
                        suggestionStyle: Theme.of(context).textTheme.body1,
                        getSuggestionsMethod: getLocationSuggestionsList,
                        tfTextAlign: TextAlign.left,
                        tfStyle: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                        tfTextDecoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for a role",
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 15.0,
                    ),
                    Offstage(
                      offstage: !_showRolesView,
                      child: Container(
                          child: SampleExpendableAddRole(
                        roleSelectedCallBack: roleSelectedCallBack,
                        type: 3,
                        callBackPaymentScreen: paymentScreen,
                        totalRoleSlectedCount: _selectedRolesCount,
                      )),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 30.0),
                      child: new Text(
                        "Enter quantities and descriptions",
                        style: AppCustomTheme.createProfileSubTitle,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: 40.0, right: 40.0, top: 5.0),
                      child: new Text(
                        (_selectedRolesCount > 1)
                            ? "$_selectedRolesCount  Roles selected"
                            : "$_selectedRolesCount  Role selected",
                        style: new TextStyle(
                            color: AppColors.introBodyColor,
                            fontFamily: AssetStrings.lotoRegularStyle,
                            fontSize: 16.0),
                      ),
                    ),
                    new StreamBuilder<bool>(
                        stream: _streamControllerShowLoader.stream,
                        initialData: false,
                        builder: (BuildContext context,
                            AsyncSnapshot<bool> snapshot) {
                          bool status = snapshot.data;
                          return Container(
                            margin: new EdgeInsets.only(top: 30.0),
                            child: new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              padding: new EdgeInsets.all(0.0),
                              itemBuilder: (BuildContext context, int indexx) {
                                return getBoxItem(
                                    listRoles[indexx]); //for extra space
                              },
                              itemCount: listRoles.length,
                            ),
                          );
                        }),
                    new SizedBox(
                      height: 40.0,
                    ),
                    getContinueProfileSetupButtonLightWithoutIcon(
                        callback, "Complete project setup"),
                    new SizedBox(
                      height: 40.0,
                    ),
                  ],
                ),
                new Center(
                  child: getHalfScreenProviderLoader(
                    status: provider.getLoading(),
                    context: context,
                  ),
                ),
                new Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: Container(
                    margin: new EdgeInsets.only(bottom: 120.0),
                    child: getHalfScreenProviderLoader(
                      status: providers.getLoading(),
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  checkSelectUnselect() async {
    var projectType = new Project(type: "Project", id: widget.projectId);
    bool isSuccess = true;

    providers.setLoading();

    for (AddRoleModelBottom item in listRoles) {
      for (DataModel dataModel in item.list) {
        //check if previously loaded role is here
        if (widget.myTeam != null) {
          for (var teamData in widget.myTeam) {
            if (dataModel.name ==
                teamData) //check if team role in available list
            {
              dataModel.isSelect = true;
              break;
            }
          }
        }
        if (dataModel.count == 1 && dataModel.isSelect == null) {
          dataModel.isSelect =
              true; //if user comes back to add screen from final screen to avoid add same role again
          var roleType =
              new Project(type: "Role", id: dataModel.roleId.toString());
          var request =
              new AddRoleRequest(project: projectType, role: roleType);
          var response = await providers.addTab(context, request, status: true);
          if (response is AddRoleTabResponse) {
          } else {
            isSuccess = false;
            showInSnackBar("Error Please try again later");
            break;
          }
        }
      }
    }
    providers.hideLoader();

    if (isSuccess) {
      moveToFinalScreen();
    } else {}
  }

  void checkedUncheckedPreSelectData() async {
    Map<String, AddRoleModelBottom> _selectedRolesMapsLocal = Map();
    listRoles.clear(); //remove previous data
    provider.list.clear();
    String title = "";
    String icons = "";

    _selectedRolesCount = widget.myTeam.length;
    for (var item in widget.myTeam) {
      for (var data in provider.rolesList) {
        for (var childData in data.roles) {
          if (childData.name == item) {
            data.category.isExpend = true;
            childData.isChecked = true;

            print("namr ${childData.name}");
          } else {
            data.category.isExpend = false;
          }
        }
      }
    }

    if (provider.rolesList != null) {
      for (var data in provider.rolesList) {
        List<DataModel> dataList = List();
        for (var childData in data.roles) {
          if (childData.isChecked) {
            data.category.isExpend = true;

            int count = 0;
            for (var data in widget.myTeam) {
              if (data == childData.name) {
                count = count + 1;
              }
            }

            DataModel dataModel = new DataModel(
                name: childData.name, count: count, roleId: childData.id);
            dataList.add(dataModel);
            provider.list.add(childData.name);
            icons = data.category.iconUrl;
            title = data.category.name;
          }
        }

        if (dataList.length > 0) {
          AddRoleModelBottom model = new AddRoleModelBottom(
              title: title, iconurl: icons, list: dataList);
          listRoles.add(model);
          //to keep tract of previously selected roles
          if (!_selectedRolesMapsLocal.containsKey(title)) {
            _selectedRolesMapsLocal[title] = model;
          }
        }
      }
    }
    _selectedRolesMaps.clear();
    _selectedRolesMaps.addAll(_selectedRolesMapsLocal); //count for later use
    await countTotal(); //check selected role count
    setState(() {});
  }

  //move to payment screen
  VoidCallback paymentScreen() {
    widget.fullScreenCallBack(PaymentScreen());
  }

  //move to project final screen
  void moveToFinalScreen() async {
    var data = await Navigator.push(context,
        new CupertinoPageRoute(builder: (BuildContext context) {
      return new CreateProjectFinalScreen(
          widget.projectId, widget.fullScreenCallBack, null);
    }));

    print("data from $data");
    if (data != null) {
      _isCameFromFinalScreen = true; //came back from final screen
    }
  }

  VoidCallback callback() {
    //if user came back here to edit role
    print("count $count");
    if (isProUser() || count <= ROLE_SELECT_COUNT_CHECK ) {
      checkSelectUnselect();
    } else {
      _warningUpgradeAccountBottomSheet(); //show payment bottom sheet
    }

    // checkSelectUnselect();
  }

  VoidCallback callbackPayment() {
    //if user came back here to edit role

    widget.fullScreenCallBack(PaymentScreen());
  }

  Widget getAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(120.0),
      child: Material(
        elevation: 1.0,
        child: Container(
          color: Colors.white,
          padding: new EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SizedBox(
                width: 15.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.arrow_back, size: 25.0),
                    new SizedBox(
                      width: 4.0,
                    ),
                    new Text(
                      "Back",
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
            ],
          ),
        ),
      ),
    );
    ;
  }

  void _warningUpgradeAccountBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return PurchaseBottomSheet(callbackPayment);
        });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
