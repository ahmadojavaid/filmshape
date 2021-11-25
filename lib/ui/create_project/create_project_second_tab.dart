import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/ui/common_video_view/items/awards.dart';
import 'package:Filmshape/ui/create_project/add_awards_bottom_sheet.dart';
import 'package:Filmshape/ui/create_project/common_list_tabs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateProjectSecondTab extends StatefulWidget {

  final String projectId;
  final bool isRole;
  final ValueChanged<Widget> fullScreenCallBack;

  CreateProjectSecondTab(this.projectId, this.fullScreenCallBack,
      {Key key, bool this.isRole})
      : super(key: key);


  @override
  CommentTabsSecond createState() => CommentTabsSecond();
}

class CommentTabsSecond extends State<CreateProjectSecondTab>
    with AutomaticKeepAliveClientMixin<CreateProjectSecondTab>
{

  List<ProjectRoleCalls> myTeam = List();
  List<Award> listAwards = List();

  int type = 0;

  Color color = Colors.grey.withOpacity(0.7);

  GlobalKey<RoleListState> _keyRoleList = new GlobalKey<RoleListState>();

  ProjectResponse _projectResponse;
  bool _isClassCreated = false;


  @override
  void initState() {
    // TODO: implement initState
    _isClassCreated = true;
    super.initState();
  }

  void setData(ProjectResponse response) {
    _projectResponse=response;
    myTeam.clear();
    if (response.projectRoleCalls != null) {
      myTeam.addAll(response.projectRoleCalls);
    }

    listAwards.clear();

    if (response.awards != null) {
      listAwards.addAll(response.awards);
    }
    _keyRoleList.currentState.setRolesData(myTeam);//update role data


  }


  Widget videoLinkView(String text, IconData image, Color color, int type) {
    return InkWell(
      onTap: () {
        addAwardBottomSheet(widget.projectId);
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 11.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              image,
              color: color,
              size: 21.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              text,
              style: new TextStyle(
                  color: color,
                  fontSize: 17,
                  fontFamily: AssetStrings.lotoRegularStyle),
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

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return
      Stack(
        children: <Widget>[
          new ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              new Container(
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                   sizeBox,
                    videoLinkView(
                        "Add an award", Icons.add_box, AppColors.kPrimaryBlue,
                        2),
                    sizeBox,
                    new AwardsTab(
                      list: listAwards,
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
                    CommonList(
                      widget.projectId,
                      widget.fullScreenCallBack,
                      isRole: widget.isRole,
                      key: _keyRoleList,
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

  //open add award bottom sheet
  void addAwardBottomSheet(String projectIDs) async
  {
    var response = await showModalBottomSheet<dynamic>(
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
                .height / 1.5,
            child: Padding(
              padding: MediaQuery
                  .of(context)
                  .viewInsets,
              child: AddAwardsBottomSheet(projectIDs),
            ),
          );
        }
    );
    if(response is Award)
      {
        listAwards.add(response);
        _projectResponse.awards.add(response);
        showInSnackBar("New award added");
        setState(() {

        });
      }
  }


  Widget getTextFieldBottomSheet(String labelText,
      TextEditingController controller,
      FocusNode focusNodeCurrent,
      FocusNode focusNodeNext,
      TextInputType textInputType,
      int max) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      child: new TextFormField(
        controller: controller,
        focusNode: focusNodeCurrent,
        textCapitalization: TextCapitalization.sentences,
        maxLines: max,
        style: AppCustomTheme.ediTextStyle,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(),
            contentPadding: new EdgeInsets.only(
                top: 14.0, bottom: 14.0, left: 14.0, right: 10.0),
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26, width: 1.0),
            ),
            focusColor: Colors.brown),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
