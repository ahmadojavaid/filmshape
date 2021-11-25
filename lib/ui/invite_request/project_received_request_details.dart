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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProjectReceivedRequestDetails extends StatefulWidget {
  final Sent sent;
  final int type;
  final ValueSetter<int> callbackCount;
  final ValueChanged<Widget> fullScreenWidget;

  ProjectReceivedRequestDetails(
      {Key key,
      this.sent,
      this.type,
      this.callbackCount,
      this.fullScreenWidget})
      : super(key: key);

  @override
  _ProjectReceivedRequestDetailsState createState() =>
      _ProjectReceivedRequestDetailsState();
}

class _ProjectReceivedRequestDetailsState
    extends State<ProjectReceivedRequestDetails> {
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
  bool _showAcceptRejectButton = true;

  @override
  void initState() {
    super.initState();
    if (widget.sent != null) {
      var send = widget.sent;

      print("status ${send.status}");
      //show hide accept reject button
      if (send.status.toLowerCase() == "pending") {
        _showAcceptRejectButton = true;
      } else {
        _showAcceptRejectButton = false;
      }
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
    }
    Future.delayed(const Duration(milliseconds: 500), () {
      provider.hideLoader();
    });
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to reject this request?'),
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
                hitApiacceptreject(REQUESTTYPE.REJECT);
              },
            ),
          ],
        );
      },
    );
  }

  void hitApiacceptreject(REQUESTTYPE requesttype) async {
    provider.setLoading();
    AcceptRejectInvitation acceptreject;

    //accept section
    if (requesttype == REQUESTTYPE.ACCEPT) {
      acceptreject = new AcceptRejectInvitation(
          accepted: true, declined: false, revoked: false);
    }
    //reject section
    else if (requesttype == REQUESTTYPE.REJECT) {
      acceptreject = new AcceptRejectInvitation(
          declined: true, accepted: false, revoked: false);
    }

    var response = await provider.requestAcceptRemove(
        acceptreject, context, requesttype, widget.sent.id.toString());

    if (response is AcceptRejectInvitation) {
      if (requesttype == REQUESTTYPE.ACCEPT) {
        widget.callbackCount(1);
        showInSnackBar("Request Accepted");
      } else if (requesttype == REQUESTTYPE.REJECT) {
        widget.callbackCount(0);
        showInSnackBar("Request Declined");
      }
      Navigator.pop(context);
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
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
        style: new TextStyle(
            color: AppColors.kPrimaryBlue,
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
                style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                    fontFamily: AssetStrings.lotoRegularStyle),
              )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    provider = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: AppColors.white,
            body: Column(
              children: <Widget>[
                new SizedBox(
                  height: 10.0,
                ),
                TopBar(
                  acceptCallBack: acceptCallBack,
                  rejectCallBack: rejectCallBack,
                  btnStatus: _showAcceptRejectButton,
                ),
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
                                          color: Colors.transparent,
                                          width: 0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: getCachedNetworkImageWithurl(
                                          url: thumbnailUrl, fit: BoxFit.cover),
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
                                getSvgNetworkImage(
                                    url: roleCallUrl, size: 30.0),
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
                                  roleMain != null ? " ($roleMain)" : "",
                                  style: new TextStyle(
                                      color: AppColors.introBodyColor,
                                      fontSize: 13.0,
                                      fontFamily:
                                          AssetStrings.lotoRegularStyle),
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
                              "Description", description, Icons.message),
                          getAttributeItem(
                              "Personal message", message, Icons.message),
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

  VoidCallback acceptCallBack() {
    hitApiacceptreject(REQUESTTYPE.ACCEPT); //accept the request
  }

  VoidCallback rejectCallBack() {
    _showAlertDialog(); //show alert dialog before rejection
  }
}

class TopBar extends StatelessWidget {
  final VoidCallback acceptCallBack;
  final VoidCallback rejectCallBack;
  final bool btnStatus;

  TopBar({this.acceptCallBack, this.rejectCallBack, this.btnStatus});

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
            child: new Icon(Icons.keyboard_arrow_down, size: 25.0)),
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
              style: new TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ),
        ),
        Expanded(child: new Container()),
        Offstage(
          offstage: !btnStatus,
          child: Row(
            children: <Widget>[
              Button(
                  new Icon(
                    FontAwesomeIcons.solidTrashAlt,
                    color: Colors.red,
                    size: 16,
                  ),
                  "Decline",
                  rejectCallBack),
              SizedBox(
                width: 10,
              ),
              Button(
                  new Icon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: AppColors.kPrimaryBlue,
                    size: 16,
                  ),
                  "Accept",
                  acceptCallBack),
            ],
          ),
        ),
        new SizedBox(
          width: 10.0,
        ),
      ],
    );
  }
}

class Button extends StatelessWidget {
  final Icon icon;
  final String title;
  final VoidCallback callback;

  Button(this.icon, this.title, this.callback);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        callback();
      },
      child: new Container(
        padding: new EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
        decoration: new BoxDecoration(
            border:
                new Border.all(color: AppColors.delete_save_border, width: 1.0),
            borderRadius: new BorderRadius.circular(16.0),
            color: AppColors.delete_save_background),
        child: new Row(
          children: <Widget>[
            icon,
            new SizedBox(
              width: 5.0,
            ),
            new Text(
              title,
              style: new TextStyle(color: Colors.black, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }
}
