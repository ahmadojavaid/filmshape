import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Model/create_project/filter_role_request.dart';
import 'package:Filmshape/Model/create_project_model/DataModel.dart';
import 'package:Filmshape/Model/invite_send_received/invite_request.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_project_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/create_project/send_invite_role_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SendInviteBottomSheet extends StatefulWidget {

  final String projectID;
  final String roleID;
  final String title;
  final String userId;

  SendInviteBottomSheet(this.projectID, this.roleID, this.title, this.userId);

  @override
  _JoinPrpjectDetailsState createState() => _JoinPrpjectDetailsState();
}

class _JoinPrpjectDetailsState extends State<SendInviteBottomSheet> {
  List<DataModel> list = new List();

  CreateProjectProvider provider;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController(
      initialPage: 0);

  var slideList = List<Widget>();
  int _tabCount = 0;
  int _currentPage = -1;
  List<int> listProjectId = new List();
  List<DataModel> tabIndicatorList = new List();


  JoinProjectProvider providers;
  CreateProjectProvider providerss;

  var _tabsKeysList = new List<
      GlobalKey<SendInviteRoleItemState>>();


  @override
  void initState() {
    super.initState();


    Future.delayed(const Duration(milliseconds: 300), () {

      if(widget.projectID!=null){
        hitGetRolesDetailsApi();
      }

    });
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }


  hitGetRolesDetailsApi() async {
    provider.setLoading();
    //for filter rolees
    var reqeust = FilterRoleRequest(
        project: Project(type: "Project", id: widget.projectID),
        role: Project(type: "Role", id: widget.roleID));


    var response = await provider.getProfileRoles(
        context, jsonEncode(reqeust.toJson()));


    provider.hideLoader();

    if (response != null && (response is GetRolesMainsDetails)) {
      if (response.data != null && response.data.length > 0) {
        for (var dataModel in response.data) {
          listProjectId.add(dataModel.id);

          _tabCount++; //for tab count


          if (tabIndicatorList.length > 0) {
            for (var data in tabIndicatorList) {
              data.select = false; //disable previously selected tab
            }
          }


          //newly added tab make it selected
          var data = DataModel(name: _tabCount.toString(), select: true);
          tabIndicatorList.add(data);


          GlobalKey<SendInviteRoleItemState> key = new GlobalKey();

          slideList.add(
              SendInviteRoleItem(
                widget.projectID, widget.roleID, widget.title, widget.userId,
                dataModel, key: key,));

          _tabsKeysList.add(key);
        }

        _pageController.animateToPage(
            _tabCount - 1, duration: Duration(milliseconds: 300),
            curve: Curves.linear);
      }
      _currentPage = _tabCount - 1;
      print(slideList);

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


  updateUserRole() async {
    provider.setLoading();
    var currentPageKey = _tabsKeysList[_currentPage]; //get key of current page
    SaveRoleCallRequest request = currentPageKey.currentState
        .getRoleInformation(); //get information for the selected screen


    print("add role request ${json.encode(request.toJson())}");

    //get the role model for selected tab being saved

    var response = await providerss.updateRoleInformation(
        context, request, listProjectId[_currentPage].toString());


    if (response != null && (response is AddRoleTabResponse)) {
      print("update rol info success");

      hitSendRequest();
      //if not null update data in previous screen

    } else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar(apiError.error ?? Messages.genericError);
    }
  }

  void hitSendRequest() async {
    //for filter rolees
    provider.setLoading();

    var currentPageKey = _tabsKeysList[_currentPage]; //get key of current page
    String text = currentPageKey.currentState
        .getMessageText(); //get information for the selected screen


    var reqeust = SendInviteRequest(
        roleCall: RoleCall(type: "Role", id: int.parse(widget.roleID)),
        message: text);


    var response = await provider.sendInviteRequest(
        context, reqeust, listProjectId[_currentPage].toString(),
        widget.userId);


    provider.hideLoader();

    if (response is AddRoleTabResponse) {
      showInSnackBar("Invite Send Successfully");

      //invite send
      Future.delayed(const Duration(milliseconds: 1000), () {
        Navigator.pop(context);
      });


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
    providers = Provider.of<JoinProjectProvider>(context);
    providerss = Provider.of<CreateProjectProvider>(context);


    return Stack(
      children: <Widget>[
        Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: new Column(

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
                          Navigator.pop(context);
                        },
                        child: new Icon(
                            Icons.keyboard_arrow_left, size: 29.0)),
                    new SizedBox(
                      width: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 50.0,
                        alignment: Alignment.center,
                        child: new Text(
                          "Back",
                          style:
                          new TextStyle(color: Colors.black, fontSize: 16.0),
                        ),
                      ),
                    ),
                    Expanded(
                      child: new SizedBox(
                        width: 55.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        updateUserRole();
                        //   hitSendRequest();
                      },
                      child: new Container(
                        alignment: Alignment.center,
                        width: 135.0,
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 8.5, bottom: 8.5),
                        decoration: new BoxDecoration(
                            color: AppColors.kPrimaryBlue,
                            borderRadius: new BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text(
                              "Send Invite",
                              style: new TextStyle(
                                  fontFamily: AssetStrings
                                      .lotoSemiboldStyle,
                                  color: Colors.white,
                                  fontSize: 15.0),
                            ),
                            new SizedBox(width: 10.0),
                            new SvgPicture.asset(
                              AssetStrings.send,
                              color: Colors.white,
                              width: 15.5,
                              height: 15.5,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 1,
                margin: new EdgeInsets.only(top: 15.0),
                color: AppColors.dividerColor,
              ),
              Container(
                margin: new EdgeInsets.only(top: 30.0, left: 40.0),
                child: new Text(
                  widget.title != null ? widget.title : "",
                  style: AppCustomTheme.createProfileSubTitle,
                ),
              ),
              Container(
                margin: new EdgeInsets.only(top: 15.0, left: 40.0),
                child: new Text(
                  "Select the role",
                  style: new TextStyle(
                      fontFamily: AssetStrings.lotoBoldStyle,
                      fontSize: 14.0,
                      color: AppColors.kBlack
                  ),
                ),
              ),
              new SizedBox(
                height: 15.0,
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


              Expanded(
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

        new Center(
          child: getHalfScreenProviderLoader(
            status: provider.getLoading(),
            context: context,
          ),
        ),
      ],
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
                : AppColors.gray_tab),
        child: new Text(
          tabIndicatorList[index].name,
          style: new TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.0),
        ),
      ),
    );
  }
}
