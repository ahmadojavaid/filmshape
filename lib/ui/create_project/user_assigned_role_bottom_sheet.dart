import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/addrole/add_role_request.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Model/create_project/filter_role_request.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/create_project_provider.dart';
import 'package:Filmshape/ui/payment_screen/PaymentScreen.dart';
import 'package:Filmshape/ui/statelesswidgets/bottom_sheet_purchase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'add_role_quantity_in_project.dart';

class CreateProjectSecond extends StatefulWidget {
  final int intRoleId;
  final String title;
  final String projectId;
  ValueSetter<int> roleCountCallBack;
  final ValueChanged<Widget> fullScreenCallBack;
  int totalRoleSlectedCount;
  int type;

  CreateProjectSecond(
      this.intRoleId,
      this.title,
      this.projectId,
      this.roleCountCallBack,
      this.totalRoleSlectedCount,
      this.fullScreenCallBack);

  @override
  _CreateProjectSecondState createState() => _CreateProjectSecondState();
}

class _CreateProjectSecondState extends State<CreateProjectSecond>
    with AutomaticKeepAliveClientMixin<CreateProjectSecond> {
  List<DataModel> tabIndicatorList = new List();
  List<int> projectRoleId = new List();

  int _currentPage = -1; //because while adding new tab item increment
  bool checkbox = false;

  CreateProfileProvider provider;
  CreateProjectProvider providers;

  final PageController _pageController = PageController(initialPage: 0);
  String title = "Next";
  var slideList = List<Widget>();
  int _tabCount = 0;

  var _tabsKeysList = new List<
      GlobalKey<AddRoleQuantityInProjectState>>(); //for storing tab related key

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitGetRolesDetailsApi();
    });
  }

  //unpaid user role selected

  void _purchasePlanBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return PurchaseBottomSheet(callbackFullScreen);
        });
  }

  VoidCallback callbackFullScreen() {
    widget.fullScreenCallBack(PaymentScreen());
  }

  addRoleTab({bool isFirstTime = false}) async {
    provider.setLoading();
    var projectType = new Project(type: "Project", id: widget.projectId);
    var roleType = new Project(type: "Role", id: widget.intRoleId.toString());
    var request = new AddRoleRequest(project: projectType, role: roleType);

    var response = await providers.addTab(context, request,status: true);
    provider.hideLoader();
    if (response is AddRoleTabResponse) {
      projectRoleId.add(response.id);

      _tabCount++; //for tab count
      _currentPage++; //move pointer to newly added tab
      _pageController.animateToPage(_tabCount - 1,
          duration: Duration(milliseconds: 300), curve: Curves.linear);

      for (var data in tabIndicatorList) {
        data.select = false; //disable previously selected tab
      }
      //newly added tab make it selected
      var data = DataModel(name: _tabCount.toString(), select: true);
      tabIndicatorList.add(data);
      GlobalKey<AddRoleQuantityInProjectState> key = new GlobalKey();

      slideList.add(AddRoleQuantityInProject(
        response,
        callback,
        null,
        widget.title,
        key: key,
      ));

      _tabsKeysList.add(key); //adding keys to list

      //when count is already added from back screen
      if (!isFirstTime)
        widget.totalRoleSlectedCount += 1; //increment in total role added count

      widget.roleCountCallBack(tabIndicatorList.length);

      setState(() {});
    } else if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  //save all roles
  hitApi() async {
    var isSuccess = false;

    for (int i = 0; i < projectRoleId.length; i++) {
      var tabId = projectRoleId[i];
      //var tabId = _tabsKeysList[_currentPage].currentState.widget.response.id;
      // var tabId = _tabsKeysList[_currentPage].currentState.widget.request.id;
      print("tab id $tabId");
      var currentPageKey = _tabsKeysList[i]; //get key of current page
      SaveRoleCallRequest request = currentPageKey.currentState
          .getRoleInformation(); //get information for the selected screen

      request.role = RolesCreateProfile(type: "Role", id: widget.intRoleId);

      request.project =
          RolesCreateProfile(type: "Project", id: int.parse(widget.projectId));

      print("add role request ${json.encode(request.toJson())}");

      //get the role model for selected tab being saved

      var response = await providers.updateRoleInformation(
          context, request, tabId.toString());
      provider.hideLoader();

      if (response != null && (response is AddRoleTabResponse)) {
        //if not null update data in previous screen

        isSuccess = true;
      } else {
        APIError apiError = response;
        print(apiError.error);
        isSuccess = false;

        /*  showAlert(
        context: context,
        titleText: "ERROR",
        message: "Please enter the Character Name",
        actionCallbacks: {"OK": () {}},
      );*/
        showInSnackBar(apiError.error ?? Messages.genericError);
        break;
      }
    }

    if (isSuccess) {
      widget.roleCountCallBack(
          tabIndicatorList.length); //update total count added for a role
      Navigator.pop(context);
    } else {
      showInSnackBar("Please try again later");
    }
  }

  //remove assign to self
  removeRoleSelfAssigned() async {
    //update status;
    var currentPageKey = _tabsKeysList[_currentPage];
    var roleId = (currentPageKey.currentState.widget.response != null)
        ? currentPageKey.currentState.widget.response.id
        : currentPageKey.currentState.widget.addedRoleResponse.id;

    provider.setLoading();
    var response = await providers.unassignToSelf(context, roleId.toString());
    provider.hideLoader();

    if ((response is APIError)) {
      showInSnackBar(response.error ?? Messages.genericError);
    } else {
      currentPageKey.currentState.showHide();
      widget.roleCountCallBack(
          tabIndicatorList.length); //update total count added for a role

    }
  }

  //save role count here
  hitGetRolesDetailsApi() async {
    provider.setLoading();
    //for filter rolees
    var reqeust = FilterRoleRequest(
        project: Project(type: "Project", id: widget.projectId),
        role: Project(type: "Role", id: widget.intRoleId.toString()));

    var response =
        await providers.getProfileRoles(context, jsonEncode(reqeust.toJson()));

    provider.hideLoader();

    if (response != null && (response is GetRolesMainsDetails)) {
      if (response.data != null && response.data.length > 0) {
        for (var dataModel in response.data) {
          projectRoleId.add(dataModel.id);

          _tabCount++; //for tab count

          if (tabIndicatorList.length > 0) {
            for (var data in tabIndicatorList) {
              data.select = false; //disable previously selected tab
            }
          }

          //newly added tab make it selected
          var data = DataModel(name: _tabCount.toString(), select: true);
          tabIndicatorList.add(data);
          GlobalKey<AddRoleQuantityInProjectState> key = new GlobalKey();

          slideList.add(AddRoleQuantityInProject(
            null,
            callback,
            dataModel,
            widget.title,
            key: key,
          ));

          _tabsKeysList.add(key); //adding keys to list

        }

        _pageController.animateToPage(_tabCount - 1,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
      _currentPage = _tabCount - 1;
      //  widget.roleCountCallBack(tabIndicatorList.length);
      setState(() {});

      //if not null update data in previous screen

      //showInSnackBar("Project Updated Successfully.");
    } else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar(apiError.error);
    }

    if (slideList.length == 0) {
      addRoleTab(isFirstTime: true);
    }
  }

  VoidCallback callback(int id) {
    if (id == -1) {
      removeRoleSelfAssigned(); //remove role assigned to self
    }
    //to assign a role to self
    else if (id != 0) {
      addAssignToRole(id.toString());
    } else {
      //to delete individual role

      /* _showDialog(
          "Delete Entry", "Are you sure, you want to delete this entry ?", 1);
    }*/

      quickAccessVideoLinkBottomSheet(
          "Delete instance of this role?",
          "By deleting instance of this role you will remove this role and vacancy you have created for it.",
          2);
    }
  }

  addAssignToRole(String roleId) async {
    provider.setLoading();
    var response = await providers.assignMySelf(context, roleId);

    provider.hideLoader();

    if ((response is APIError)) {
      showInSnackBar(response.error);
    } else {
      var currentPageKey = _tabsKeysList[_currentPage];
      currentPageKey.currentState.showHide();
      widget.roleCountCallBack(
          tabIndicatorList.length); //update total count added for a role

    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<CreateProfileProvider>(context);
    providers = Provider.of<CreateProjectProvider>(context);
    print("add_quantity ${widget.totalRoleSlectedCount}");
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: getAppBar(),
            backgroundColor: Colors.white,
            body: Container(
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new SizedBox(
                      height: 23.0,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Text(
                        widget.title != null ? widget.title : "Actor",
                        style: AppCustomTheme.createProfileSubTitle,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: MARGIN_LEFT_RIGHT, top: 12.0),
                      child: new Text(
                        "Role quantity",
                        style: AppCustomTheme.body15Regular,
                      ),
                    ),
                    new SizedBox(
                      height: 20.0,
                    ),
                    new Container(
                      height: 1,
                      color: AppColors.dividerColor,
                    ),
                    new Container(
                      height: 50.0,
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Row(
                        children: <Widget>[
                          Container(height: 31.0, child: buildAddItem()),
                          Expanded(
                            child: Container(
                              height: 32.0,
                              child: new ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return buildSearchItem(index);
                                  },
                                  itemCount: tabIndicatorList.length),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slideList.length,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (ctx, index) => slideList[index],
                      ),
                    )
                  ]),
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

  Widget buildSearchItem(int index) {
    return InkWell(
      onTap: () {
        //unselct previous selected tabs
        // for (int i = 0; i < tabIndicatorList.length; i++) {
        tabIndicatorList[_currentPage].select = false;
        //}
        tabIndicatorList[index].select = true;
        _currentPage = index;
        _pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.linear);

        setState(() {});
      },
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
        margin: new EdgeInsets.only(left: 20.0),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(18.0),
            color: tabIndicatorList[index].select
                ? AppColors.kPrimaryBlue
                : AppColors.gray_tab),
        child: new Text(
          tabIndicatorList[index].name,
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
        ),
      ),
    );
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void deleteRoleQuantityTab(int id) async {
    provider.setLoading();
    var response = await providers.removeTab(context, id.toString());
    provider.hideLoader();
    print("loader status ${provider.getLoading()}");
    if (response is APIError) {
      showInSnackBar(response.error);
    } else {
      //deleted successfully
      //hit api here in response adjust local
      slideList.removeAt(_currentPage); //remove current tab
      _tabsKeysList.removeAt(_currentPage); //remove current tab key
      tabIndicatorList.removeAt(_currentPage); //remove current tab indicator
      projectRoleId.removeAt(_currentPage);

//      widget.roleCountCallBack(tabIndicatorList.length);

      if (tabIndicatorList.length > 0 && _currentPage > 0) {
        _currentPage = _currentPage - 1;
        tabIndicatorList[_currentPage].select = true;
        _pageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
      //if user deletes 1 tab than select next remaing one
      else if (tabIndicatorList.length > 0) {
        tabIndicatorList[_currentPage].select = true;
        _pageController.animateToPage(_currentPage,
            duration: Duration(milliseconds: 300), curve: Curves.linear);
      }
      //to update the tab indicator no after deleting tab from list
      for (var cnt = 1; cnt <= tabIndicatorList.length; cnt++) {
        var dataModel = tabIndicatorList[cnt - 1];
        dataModel.name = cnt.toString();
      }

      //decrease the tab global counter so that next no should be after previous one
      _tabCount--;
      //manage total role count
      widget.totalRoleSlectedCount -= 1;

      widget.roleCountCallBack(
          tabIndicatorList.length); //update total count added for a role

      if (tabIndicatorList.length == 0) {
        Navigator.pop(context);
      }

      setState(() {});
    }
  }

  void quickAccessVideoLinkBottomSheet(String title, String msg, int type) {
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
                        new EdgeInsets.only(left: 30.0, right: 30.0, top: 17.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.keyboard_arrow_left, size: 29.0),
                              new SizedBox(
                                width: 4.0,
                              ),
                              new Text(
                                "Back",
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
                      ],
                    ),
                  ),
                  new Container(
                    height: 1,
                    color: AppColors.dividerColor,
                    margin: new EdgeInsets.only(top: 17.0),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
                    child: new Text(
                      title,
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 19.0),
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                    child: new Text(
                      msg,
                      style: new TextStyle(
                          color: AppColors.introBodyColor,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 14.0),
                    ),
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(top: 30, right: 40.0, left: 40.0),
                    child: new Row(
                      children: <Widget>[
                        Expanded(child: attributeHeading("Cancel", 0, type)),
                        new SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                            child: attributeHeading("Delete role", 1, type)),
                      ],
                    ),
                  ),
                  new Container(
                    height: 20.0,
                    child: new Text("  "),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget attributeHeading(String text, int type, int apitype) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        if (type == 1 && apitype == 1) {
          deleteAllRoleQuantityTab();
        } else if (type == 1 && apitype == 2) {
          deleteRoleQuantityTab(projectRoleId[_currentPage]);
        }
      },
      child: new Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: new Border.all(
                color: type == 1
                    ? AppColors.heartColor
                    : AppColors.creatreProfileBordercolor,
                width: INPUT_BOX_BORDER_WIDTH),
            color: Colors.white),
        padding: new EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: new Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AssetStrings.lotoRegularStyle,
              fontSize: 15),
        ),
      ),
    );
  }

  //delete all role
  void deleteAllRoleQuantityTab() async {
    var isSuccess = false;

    provider.setLoading();
    for (var item in projectRoleId) {
      var response = await providers.removeTab(context, item.toString());
      if (response is APIError) {
        isSuccess = false;
        provider.hideLoader();
        showInSnackBar(response.error);
      } else {
        //deleted successfully
        //hit api here in response adjust local

        isSuccess = true;
      }
    }

    provider.hideLoader();

    if (isSuccess) {
      slideList.clear(); //remove current tab
      _tabsKeysList.clear(); //remove current tab key
      tabIndicatorList.clear(); //remove current tab indicator
      projectRoleId.clear();
      _tabCount = 0;
      _currentPage = 0;
      widget.roleCountCallBack(
          0); //remove deleted role form selected add role screen
      Navigator.pop(context);
    }

    setState(() {});
  }

/*
  void deleteAllTab() async {
    var tabId = listProjectId[_currentPage];
    //  var tabId = _tabsKeysList[_currentPage].currentState.widget.request.id;
    print("taabid $tabId");
    provider.setLoading();

    var response = await providers.removeTab(context, tabId.toString());
    if (response is APIError) {
      showInSnackBar(response.error);
    }
    else { //deleted successfully
      //hit api here in response adjust local
      slideList.removeAt(_currentPage); //remove current tab
      _tabsKeysList.removeAt(_currentPage); //remove current tab key
      tabIndicatorList.removeAt(_currentPage); //remove current tab indicator

      widget.voidcallback(tabIndicatorList.length.toString());
      setState(() {

      });

      setState(() {

      });
    }
  }
*/

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
              InkWell(
                onTap: () {
                  quickAccessVideoLinkBottomSheet(
                      "Delete all instances of this role?",
                      "By deleting all instances of this role you will remove the entire role and every vacancy you have created for it.",
                      1);
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
                        Icons.delete,
                        color: AppColors.heartColor,
                        size: 17.0,
                      ),
                      new SizedBox(
                        width: 5.0,
                      ),
                      InkWell(
                        onTap: () {
                          quickAccessVideoLinkBottomSheet(
                              "Delete all instances of this role?",
                              "By deleting all instances of this role you will remove the entire role and every vacancy you have created for it.",
                              1);
                        },
                        child: new Text(
                          "Delete",
                          style: new TextStyle(
                              color: Colors.black, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              new SizedBox(
                width: 10.0,
              ),
              InkWell(
                onTap: () {
                  hitApi();
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
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddItem() {
    print("build_item_role_count ${widget.totalRoleSlectedCount}");
    return InkWell(
      onTap: () {
        print("role_count ${widget.totalRoleSlectedCount}");
        if (isProUser() ||
            widget.totalRoleSlectedCount < ROLE_SELECT_COUNT_CHECK) {
          addRoleTab();
        } else {
          _purchasePlanBottomSheet();
        }
      },
      child: new Container(
          padding: new EdgeInsets.symmetric(horizontal: 14.0),
          alignment: Alignment.center,
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(18.0),
              border: new Border.all(color: AppColors.kPrimaryBlue)),
          child: new Icon(
            Icons.add,
            color: AppColors.kPrimaryBlue,
            size: 20,
          )),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
