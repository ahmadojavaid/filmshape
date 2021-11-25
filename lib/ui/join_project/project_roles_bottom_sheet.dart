import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/apply_project_role/ApplyForProjectRole.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/filter_role_request.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_project_provider.dart';
import 'package:Filmshape/ui/statelesswidgets/button_invite_apply.dart';
import 'package:Filmshape/ui/statelesswidgets/close_buttom_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinProjectBottomSheet extends StatefulWidget {
  final String roleId;
  final String projectId;

  JoinProjectBottomSheet(this.roleId, this.projectId);

  @override
  _JoinPrpjectDetailsState createState() => _JoinPrpjectDetailsState();
}

class _JoinPrpjectDetailsState extends State<JoinProjectBottomSheet> {
  List<DataModel> list = new List();

  CreateProjectProvider provider;

  final PageController _pageController = PageController(initialPage: 0);

  var slideList = List<Widget>();
  int _tabCount = 0;
  int _currentPage = -1;
  List<int> ProjectRoleId = new List();
  List<DataModel> tabIndicatorList = new List();
  GlobalKey<ScaffoldState> _globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      hitGetRolesDetailsApi();
    });
  }

  void showInSnackBar(String value) {
    _globalKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  void _applyForRole() async {
    provider.setLoading();
    ApplyRoleRequest applyRoleRequest = ApplyRoleRequest();
    RoleCall roleCall=new RoleCall();
    roleCall.id = ProjectRoleId[_currentPage];
    roleCall.type = "RoleCall";
    applyRoleRequest.roleCall=roleCall;
    applyRoleRequest.message = "I want to apply for this role";

    var response = await provider.applyForRoleCall(context, applyRoleRequest);
    if (response is APIError) {
      showInSnackBar(Messages.genericError);
    } else {
      showInSnackBar("Applied for role successfully");
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pop(context); //go back to screen
      });

    }
  }

  hitGetRolesDetailsApi() async {
    provider.setLoading();
    //for filter roles
    var request = FilterRoleRequest(
        project: Project(type: "Project", id: widget.projectId),
        role: Project(type: "Role", id: widget.roleId));

    var response =
        await provider.getProfileRoles(context, jsonEncode(request.toJson()));

    provider.hideLoader();

    if (response != null && (response is GetRolesMainsDetails)) {
      if (response.data != null && response.data.length > 0) {
        for (var dataModel in response.data) {
          ProjectRoleId.add(dataModel.id);

          _tabCount++; //for tab count

          //disable all previous tab
          for (var data in tabIndicatorList) {
            data.select = false; //disable previously selected tab
          }

          //newly added tab make it selected
          var data = DataModel(name: _tabCount.toString(), select: true);
          tabIndicatorList.add(data);

          slideList.add(getPager(dataModel));
        }

        _pageController.animateToPage(
            _tabCount - 1, duration: Duration(milliseconds: 300),
            curve: Curves.linear);
      }
      _currentPage = _tabCount - 1;
      setState(() {

      });

      //if not null update data in previous screen

      //showInSnackBar("Project Updated Successfully.");
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);

    }
  }


  Widget getAttributeBottomSheetItem(String title, String value) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: AppCustomTheme.myProfileAttributeHeadingJoinProject,
          ),
          new SizedBox(
            height: 5.0,
          ),
          new Text(
            value != null ? value : "",
            style: new TextStyle(fontSize: 16.0),
            //style: AppCustomTheme.myProfileAttributeStyle,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProjectProvider>(context);

    return Stack(
      children: <Widget>[
        Scaffold(
          key: _globalKey,
          body: SingleChildScrollView(
            child: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: new EdgeInsets.only(
                        left: 30.0, right: 15.0, top: 15.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.pop(context); //close the bottom sheet
                            },
                            child: SheetBackButton()),
                        Expanded(
                          child: new SizedBox(
                            width: 55.0,
                          ),
                        ),
                        InkWell(onTap: () {
                          _applyForRole(); //apply for current selected role
                        }, child: ButtonInviteApply(title: "Apply now"))
                      ],
                    ),
                  ),
                  new Container(
                    height: 1,
                    margin: new EdgeInsets.only(top: 15.0),
                    color: AppColors.dividerColor,
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 10.0, left: 40.0),
                    child: new Text(
                      "Actor",
                      style: AppCustomTheme.createProfileSubTitle,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 15.0, left: 40.0),
                    child: new Text(
                      "Select the role",
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
                    margin: new EdgeInsets.only(left: 40),
                    child: new Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            height: 32.0,
                            child: new ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context, int index) {
                                  return buildSearchItem(index);
                                },
                                itemCount: tabIndicatorList.length),
                          ),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    height: 1,
                    margin: new EdgeInsets.only(top: 2.0),
                    color: AppColors.dividerColor,
                  ),


                  Container(
                    height: getScreenSize(context: context).height / 1.6,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: slideList.length,

                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (ctx, index) => slideList[index],

                    ),
                  )

                ],
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
    );
  }


  Widget getPager(AddRoleDetails data) {
    return new Container(
      alignment: Alignment.centerLeft,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getAttributeBottomSheetItem(
              "Character Name", data.name != null ? data.name : ""),
          getAttributeBottomSheetItem(
              "Description", data.description != null ? data.description : ""),
          getAttributeBottomSheetItem(
              "Gender", data.gender != null ? data.gender.name : ""),
          getAttributeBottomSheetItem(
              "Height(min)", data.height != null ? data.height.toString() : ""),
          getAttributeBottomSheetItem(
              "Weight(max)", data.weight != null ? data.weight.toString() : ""),
          getAttributeBottomSheetItem("Expenses",
              data.expensesPaid != null && data.expensesPaid
                  ? "Paid"
                  : "Unpaid")
        ],
      ),
    );
  }

  Widget buildSearchItem(int index) {
    return InkWell(
      onTap: () {
        for (int i = 0; i < tabIndicatorList.length; i++) {
          tabIndicatorList[i].select = false;
        }
        tabIndicatorList[index].select = true;
        _currentPage = index;
        _pageController.animateToPage(
            index, duration: Duration(milliseconds: 300), curve: Curves.linear);

        setState(() {

        });
      },
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 7.0, horizontal: 20.0),
        margin: new EdgeInsets.only(right: 20.0),
        alignment: Alignment.center,
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(18.0),
            color: tabIndicatorList[index].select
                ? AppColors.kPrimaryBlue
                : AppColors.tabUnselectedBackground),
        child: new Text(
          tabIndicatorList[index].name,
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
        ),
      ),
    );
  }
}
