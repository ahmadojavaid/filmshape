import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/invite_send_received/accept_reject_request.dart';
import 'package:Filmshape/Model/invite_send_received/invite_send_received_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProjectSentRequestDetails extends StatefulWidget {
  final Sent sent;
  final int type;
  final ValueSetter<int> callbackCount;
  final ValueChanged<Widget> fullScreenWidget;

  ProjectSentRequestDetails(
      {Key key,
      this.sent,
      this.type,
      this.callbackCount,
      this.fullScreenWidget})
      : super(key: key);

  @override
  _ProjectSentRequestDetailsState createState() => _ProjectSentRequestDetailsState();
}

class _ProjectSentRequestDetailsState extends State<ProjectSentRequestDetails> {

  List<String> list = new List();

  String role = "";
  String roleMain = "";
  String title = '';
  String message = "";
  String date = "";
  String thumbnailUrl = "";
  String roleCallUrl = "";
  String projectTitle = "";
  String roleDecription = "No Description";
  String genderName = "";
  String ethicityName = "";
  String location = "";
  String name = "";
  String description = "";
  int projectId;

  HomeListProvider provider;

  bool _showRevoteButton = true;

  @override
  void initState() {
    super.initState();
    if (widget.sent != null) {
      var send = widget.sent;

      if (send.roleCall != null && send.roleCall.role != null) {
        projectId = send.roleCall.project.id; //set project id
        role = send.roleCall.role.name ?? "";
        roleMain = send.roleCall.role.category.name ?? "";
        roleDecription = send.roleCall.role.description ?? "No description";
        roleCallUrl = send.roleCall.role.iconUrl ?? "";
      }
      if (send.roleCall.gender != null) {
        genderName = send.roleCall.gender ?? "";
      }
      if (send.roleCall.ethnicity != null) {
        ethicityName = send.roleCall?.ethnicity?.name ?? "";
      }

      message = send?.message ?? "";

      date = formatDateStringMyProject(send?.created ?? "", "dd/MM/yyyy");



      if (widget.type == 1) {
        title = send?.titleReceived ?? "";
        description = send.receiver?.description ?? "";
        name = send.receiver?.fullName ?? "";
        location = send.receiver?.location ?? "";
        thumbnailUrl = send.receiver?.thumbnailUrl ?? "";
      } else {
        title = send?.titleSent ?? "";
        name = send.sender?.fullName ?? "";
        description = send.sender?.description ?? "";
        location = send.sender?.location ?? "";
        thumbnailUrl = send.sender?.thumbnailUrl ?? "";
      }

      //show hide accept reject button
      if (send.status.toLowerCase() == "pending") {
        _showRevoteButton = true;
      } else {
        _showRevoteButton = false;
      }
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }


  void hitApiacceptreject(String id) async {

    provider.setLoading();
    AcceptRejectInvitation acceptreject = new AcceptRejectInvitation(
        declined: false, accepted: false, revoked: true);

    var response = await provider.requestAcceptRemove(
        acceptreject, context, REQUESTTYPE.ACCEPT, id);

    provider.hideLoader();
    if (response != null && response is AcceptRejectInvitation) {
      /* if (widget.callbackCount != null) {
        widget.callbackCount(1);
      }*/
      Navigator.pop(context);

      setState(() {

      });
    }
    else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }


  Future<void> _showAlertDialog(String id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Revoke Request'),
          content: Text('Are you sure you want to revoke this request?'),
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
                hitApiacceptreject(id);
              },
            ),

          ],
        );
      },
    );
  }


  Widget getCornerButton(String text) {
    return new Container(
      alignment: Alignment.center,
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(color: AppColors.kPrimaryBlue, width: 1.0),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
      child: new Text(
        text,
        style: new TextStyle(color: AppColors.kPrimaryBlue,
            fontSize: 15.0,
            fontFamily: AssetStrings.lotoRegularStyle),
      ),
    );
  }

  Widget getAttributeItem(String title, String image, IconData data) {
    return Container(
      margin: new EdgeInsets.only(left: 35.0, right: 55.0, top: 25.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: new TextStyle(
                fontSize: 14.0,
                color: AppColors.introBodyColor,
                fontFamily: AssetStrings.lotoRegularStyle),
          ),
          new SizedBox(
            height: 5.0,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Icon(
                data,
                size: 16.0,
              ),
              new SizedBox(
                width: 7.0,
              ),
              Expanded(
                  child: new Text(
                    image,
                    style: new TextStyle(fontSize: 15.0,
                        color: Colors.black,
                        fontFamily: AssetStrings.lotoRegularStyle),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  VoidCallback revokeCallback() {
    _showAlertDialog(widget.sent.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery
        .of(context)
        .size;
    provider = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: Column(
              children: <Widget>[
                new SizedBox(
                  height: 10.0,
                ),
                TopBar(revokeCallback,_showRevoteButton),
                new SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: new SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[

                          new Container(
                            height: 1.0,
                            color: Colors.blueGrey.withOpacity(0.1),
                          ),

                          Container(
                            margin: new EdgeInsets.only(left: 30.0),
                            child: new Text(
                              title,
                              style: new TextStyle(
                                  color: AppColors.kBlack,
                                  fontSize: 20.0,
                                  fontFamily: AssetStrings.lotoRegularStyle),
                            ),
                          ),

                          Container(
                            margin: new EdgeInsets.only(
                                left: 30.0, top: 10.0, right: 30.0),
                            child: Row(
                              children: <Widget>[
                                new Container(
                                    width: 30.0,
                                    height: 30.0,
                                    decoration: new BoxDecoration(
                                      border: new Border.all(
                                          color: Colors.transparent, width: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: getCachedNetworkImageWithurl(
                                          url: thumbnailUrl,
                                          fit: BoxFit.cover),
                                    )),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Text(
                                  name,
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontFamily: AssetStrings.lotoBoldStyle,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.only(
                                left: 30.0, top: 15.0, right: 30.0),
                            child: Row(
                              children: <Widget>[


                                getSvgNetworkImage(url: roleCallUrl, size: 30.0),
                                new SizedBox(
                                  width: 10.0,
                                ),
                                new Text(
                                  role,
                                  style: new TextStyle(
                                      color: AppColors.introBodyColor,
                                      fontFamily: AssetStrings.lotoBoldStyle,
                                      fontSize: 14.0),
                                ),
                                new Text(
                                  roleMain != null ? " ($roleMain)" :
                                  "",
                                  style: new TextStyle(
                                      color: AppColors.introBodyColor,
                                      fontSize: 13.0,
                                      fontFamily: AssetStrings.lotoRegularStyle),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.only(left: 30.0, top: 15.0),
                            child: new Text(
                              "Role description",
                              style: new TextStyle(
                                  color: AppColors.introBodyColor,
                                  fontSize: 15.0,
                                  fontFamily: AssetStrings.lotoRegularStyle),
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.only(
                                left: 30.0, top: 13.0, right: 30.0),
                            alignment: Alignment.topLeft,
                            child: new Text(
                              roleDecription,
                              style: new TextStyle(
                                  color: Colors.black,
                                  height: 1.2,
                                  fontSize: 15.0,
                                  fontFamily: AssetStrings.lotoRegularStyle),
                            ),
                          ),
                          Container(
                            margin: new EdgeInsets.only(left: 30.0, top: 40.0),
                            child: new Text(
                              "Project details",
                              style: new TextStyle(
                                  color: AppColors.kBlack,
                                  fontSize: 20.0,
                                  fontFamily: AssetStrings.lotoRegularStyle),
                            ),
                          ),
                          getAttributeItem(
                              "Project title", "the one lake", Icons.edit),
                          getAttributeItem(
                              "Project type", "Feature film", Icons.backup),
                          getAttributeItem("Genre", "Comedy", Icons.color_lens),
                          getAttributeItem(
                              "Location", location, Icons.location_on),
                          getAttributeItem(
                              "Description",
                              description,
                              Icons.message),
                          getAttributeItem(
                              "Personal message",
                              message,
                              Icons.message),
                          new SizedBox(
                            height: 35.0,
                          ),
                          InkWell(
                            onTap: () {
                              moveToProjectDetailScreen();
                            },
                            child: Container(
                                width: screensize.width,
                                child: getCornerButton("View project")),
                          ),
                          new SizedBox(
                            height: 35.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
    );
  }

  void moveToProjectDetailScreen() {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new JoinProjectDetails(
          projectId,
          previousTabHeading: INVITENREQUEST,
          fullScreenWidget: widget.fullScreenWidget,
        );
      }),
    );
  }

}

class TopBar extends StatelessWidget {
  final VoidCallback revokeCallback;
  final bool showRevokeButton;
  TopBar(this.revokeCallback,this.showRevokeButton);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new SizedBox(
          width: 20.0,
        ),
        InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: new Icon(
                Icons.keyboard_arrow_down, size: 25.0)),
        new SizedBox(
          width: 2.0,
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            height: 50.0,
            width: 60.0,
            alignment: Alignment.centerLeft,
            child: new Text(
              "Close",
              style:
              new TextStyle(
                  color: Colors.black, fontSize: 16.0),
            ),
          ),
        ),
        Expanded(child: new Container()),


        InkWell(
          onTap: () {
            revokeCallback();
          },
          child: Offstage(
            offstage: !showRevokeButton,
            child: new Container(
              padding: new EdgeInsets.symmetric(
                  vertical: 5.0, horizontal: 10.0),
              decoration: new BoxDecoration(
                  border: new Border.all(
                      color: AppColors.delete_save_border,
                      width: 1.0),
                  borderRadius: new BorderRadius.circular(16.0),
                  color: AppColors.delete_save_background),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.reply,
                    color: Colors.red,
                  ),
                  new SizedBox(
                    width: 5.0,
                  ),
                  new Text(
                    "Revoke Request",
                    style: new TextStyle(
                        color: Colors.black, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          ),
        ),
        new SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

}
