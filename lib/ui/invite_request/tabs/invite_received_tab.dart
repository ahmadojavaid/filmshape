import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Model/invite_send_received/accept_reject_request.dart';
import 'package:Filmshape/Model/invite_send_received/invite_send_received_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/invite_request/project_received_request_details.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class InvitiesReceivedTabs extends StatefulWidget {
  final ValueSetter<InviteSendReceivedResponse> callback;
  final ValueSetter<DataModel> callbackCount;

  InvitiesReceivedTabs({Key key, this.callback, this.callbackCount})
      : super(key: key);

  @override
  ReceivedTabsState createState() => ReceivedTabsState();
}

class ReceivedTabsState extends State<InvitiesReceivedTabs>
    with AutomaticKeepAliveClientMixin<InvitiesReceivedTabs> {
  List<Sent> listReceived = new List();
  List<Sent> listLocal = new List();
  List<String> listOption = ["Accept", "Decline", "Delete"];
  List<String> listStatus = ["All", 'Pending', "Accepted", "Declined"];
  List<String> listInvite = [
    "All invites and requests",
    "Invites for me to join projects",
    "Requests to join my projects"
  ];
  String statusfilter;
  String invitefilter;
  HomeListProvider provider;
  int indexs;
  var _showLoader=false;
  //for pull to refresh
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  Future<ValueSetter> removedata(int count) async {
    print("accepet reeject $count");
    print("accepet index $indexs");

    if (count == 0) {
      listLocal[indexs].status = "Declined";
    } else {
      listLocal[indexs].status = "Accepted";
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    statusfilter = listStatus[0];
    invitefilter = listInvite[0];
    Future.delayed(const Duration(milliseconds: 300), () {
      if (provider.inviteSendReceivedResponse.received?.length == null ||
          provider.inviteSendReceivedResponse.received?.length == 0) {
        //if data is not found hit api again
        _refreshIndicatorKey.currentState?.show();
      } else
        setData(); // data already loaded show list
      _refreshIndicatorKey.currentState?.show();
    });
  }

  void callApi()
  {
    _refreshIndicatorKey.currentState?.show();
  }
  void _showPopupMenu(Offset offset, String id, int index) async {
    double left = offset.dx;
    double top = offset.dy;
    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top - 80, 0, 0),
      items: listOption.map((String popupRoute) {
        return new PopupMenuItem<String>(
          child: new Text(popupRoute),
          value: popupRoute,
        );
      }).toList(),
      elevation: 3.0,
    );

    if (selected == "Accept") {
      hitApiacceptreject(id, index, REQUESTTYPE.ACCEPT);
    } else if (selected == "Decline") {
      hitApiacceptreject(id, index, REQUESTTYPE.REJECT);
    } else {
      _showAlertDialog(id, index);
    }
  }

  void hitApi() async {
    provider.setLoading();
    var response = await provider.getDataSendInvite(context);

    if (response is InviteSendReceivedResponse) {
      setData();
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }

  //update data list if already loaded
  void setData() {
    widget.callback(provider.inviteSendReceivedResponse);
    if (provider.inviteSendReceivedResponse.received != null) {
      listLocal.clear();
      listReceived.clear();
      listReceived.addAll(provider.inviteSendReceivedResponse.received);
      listLocal.addAll(provider.inviteSendReceivedResponse.received);
    }
  }

  Future<void> _showAlertDialog(String id, int index) async {
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
                hitApiacceptreject(id, index, REQUESTTYPE.DELETE);
              },
            ),
          ],
        );
      },
    );
  }

  void hitApiacceptreject(String id, int index, REQUESTTYPE requesttype) async {
    provider.setLoading();
    _showLoader=true;
    AcceptRejectInvitation acceptreject;

    if (requesttype == REQUESTTYPE.ACCEPT) {
      acceptreject = new AcceptRejectInvitation(
          accepted: true, declined: false, revoked: false);
    } else if (requesttype == REQUESTTYPE.REJECT) {
      acceptreject = new AcceptRejectInvitation(
          declined: true, accepted: false, revoked: false);
    }


    var response = await provider.requestAcceptRemove(
        acceptreject, context, requesttype, id);

    _showLoader=false;
    if (response is AcceptRejectInvitation) {
      if (requesttype == REQUESTTYPE.ACCEPT) {
        listLocal[index].status = "Accepted";
        var receivedData=listReceived[index];

        showInSnackBar("Request Accepted");
      } else if (requesttype == REQUESTTYPE.REJECT) {
        listLocal[index].status = "Declined";
        showInSnackBar("Request Declined");
      } else {
        listLocal.removeAt(index);
        //remove from main list as well
        provider.inviteSendReceivedResponse?.received?.removeAt(index);

        if (widget.callbackCount != null) {
          DataModel model = new DataModel(count: listLocal.length, roleId: 1);
          widget.callbackCount(model);
        }
      //  setState(() {});


        showInSnackBar("Request Removed");
      }
    } else {
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget getDropdownItem(String title, List<String> list, int type, String hint,
      ValueChanged<String> valueChanged) {
    return InkWell(
        onTap: () {},
        child: DropDownButtonWidget(
          title: title,
          list: list,
          hint: hint,
          callBack: valueChanged,
          paddingContent: true,
        ));
  }

  _buildContestList() {
    return Expanded(
      child: Container(
        color: Colors.white,
        margin: new EdgeInsets.only(top: 20.0),
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            await hitApi();
          },
          child: new ListView.builder(
            padding: new EdgeInsets.all(0.0),
            itemBuilder: (BuildContext context, int index) {
              return buildItem(index, listLocal[index]);
            },
            itemCount: listLocal.length,
          ),
        ),
      ),
    );
  }

  ValueChanged<String> statusCallBack(String value) {
    statusfilter = value;
    filterData();
  }

  void filterData() {
    listLocal.clear();

    if (statusfilter == "All") {
      listLocal.addAll(listReceived);
    } else {
      for (var data in listReceived) {
        if (data.status == statusfilter) {
          listLocal.add(data);
        }
      }
    }
    if (listLocal != null && listLocal.length > 0) {
      List<Sent> listTemp = new List();
      if (invitefilter != "All invites and requests") {
        if (invitefilter == "My requests to join projects") {
          for (var data in listLocal) {
            if (!data.invite) {
              listTemp.add(data);
            }
          }
        } else {
          for (var data in listLocal) {
            if (data.invite) {
              listTemp.add(data);
            }
          }
        }

        listLocal.clear();
        listLocal.addAll(listTemp);
      }
    }

    print(listLocal.length);
    print(listLocal);
    setState(() {});
    setState(() {});
  }

  ValueChanged<String> inviteCallBack(String value) {
    invitefilter = value;
    filterData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    provider = Provider.of<HomeListProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Container(
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 15.0,
                ),
                getDropdownItem(invitefilter, listInvite, 2, "Invites filter",
                    inviteCallBack),
                new SizedBox(
                  height: 15.0,
                ),
                getDropdownItem(statusfilter, listStatus, 1, "Status filter",
                    statusCallBack),
                _buildContestList(),
                new SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
//            new Center(
//              child: getHalfScreenProviderLoader(
//                status: provider.getLoading(),
//                context: context,
//              ),
//            ),

          (listLocal.length == 0)
              ? new Center(
                  child: Container(
                      margin: new EdgeInsets.only(top: 100.0),
                      child: getNoData("No Request Found")))
              : Container(),

          new Center(
            child: getHalfScreenProviderLoader(
              status: _showLoader,
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget videoLinkViewBottomSheet(String text) {
    return InkWell(
      onTap: () {},
      child: new Container(
        margin: new EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border:
              new Border.all(color: Colors.grey.withOpacity(0.3), width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              text,
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
            new Icon(
              Icons.arrow_drop_down,
              size: 24.0,
            )
          ],
        ),
      ),
    );
  }

  void goToView(Sent send) {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new ProjectReceivedRequestDetails(
            type: 2, sent: send, callbackCount: removedata);
      }),
    );
  }

  Widget buildItem(int index, Sent received) {
    List<String> list = new List();

    String role;
    String roleMain;
    String title;
    String message;
    String date;
    String icon = getStatusIcon(received.status);
    Color color = getStatusColor(received.status);

    if (received.roleCall != null && received.roleCall.role != null) {
      role = received.roleCall.role.name ?? "";
      roleMain = received.roleCall.role.category.name ?? "";

      list.add(received.roleCall.role.iconUrl);
    }

    title = received.titleReceived != null ? received.titleReceived : "";
    message = received.message != null ? received.message : "";
    date = formatDateStringMyProject(
        received.created != null ? received.created : "", "dd/MM/yyyy");

    if (received.sender != null && received.sender.thumbnailUrl != null) {
      list.add(received.sender.thumbnailUrl);
    }

    return InkWell(
      onTap: () {
        indexs = index;
        goToView(received);
      },
      child: Container(
        color: received.status == "Declined"
            ? AppColors.redDeclined
            : Colors.white,
        child: Column(
          children: <Widget>[
            new Container(
              height: 0.7,
              color: AppColors.dividerColor,
            ),
            new SizedBox(
              height: 20.0,
            ),
            Container(
              margin: new EdgeInsets.only(right: 33.0, left: 33.0),
              child: Row(
                children: <Widget>[
                  Container(
                      child: getSvgNetworkCacheImage(list, 36.0,
                          context: context,
                          userid: received.sender.id,
                          name: received.sender.fullName)),
                  new SizedBox(
                    width: 8.0,
                  ),
                  new Text(
                    role,
                    style: new TextStyle(
                        color: AppColors.introBodyColor,
                        fontFamily: AssetStrings.lotoBoldStyle,
                        fontSize: 14.0),
                  ),
                  Expanded(
                    child: new Text(
                      " ($roleMain)",
                      style: new TextStyle(
                          color: AppColors.introBodyColor,
                          fontSize: 13.0,
                          fontFamily: AssetStrings.lotoRegularStyle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  new SizedBox(
                    width: 5.0,
                  ),
                  Offstage(
                    offstage: received.status.toLowerCase() != "pending",
                    child: new GestureDetector(
                      onTapDown: (TapDownDetails details) {
                        _showPopupMenu(details.globalPosition,
                            received.id.toString(), index);
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: new Icon(
                          Icons.more_vert,
                          size: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Offstage(
              offstage: title != null && title.length > 0 ? false : true,
              child: Container(
                alignment: Alignment.topLeft,
                margin: new EdgeInsets.only(top: 13.0, left: 33.0, right: 33.0),
                child: new Text(
                  title,
                  style: new TextStyle(
                    color: Colors.black,
                    fontSize: 15.0,
                    fontFamily: AssetStrings.lotoBoldStyle,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
            Offstage(
              offstage: message != null && message.length > 0 ? false : true,
              child: Container(
                alignment: Alignment.topLeft,
                margin: new EdgeInsets.only(top: 7.0, left: 33.0, right: 33.0),
                child: new Text(
                  message,
                  style: new TextStyle(
                      color: AppColors.introBodyColor, fontSize: 14.0),
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            new SizedBox(
              height: 15.0,
            ),
            Container(
              margin: new EdgeInsets.only(top: 7.0, left: 33.0, right: 33.0),
              child: Row(
                children: <Widget>[
                  new Container(
                    padding: new EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 13.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: received.status == "Pending" ||
                                    received.status == "Declined"
                                ? color.withOpacity(0.2)
                                : color,
                            width: 1.2),
                        borderRadius: new BorderRadius.circular(3.0),
                        color: Colors.white.withOpacity(0.2)),
                    child: new Row(
                      children: <Widget>[
                        new SvgPicture.asset(
                          icon,
                          color: color,
                          width: 15.0,
                          height: 15.0,
                        ),
                        new SizedBox(
                          width: 5.0,
                        ),
                        new Text(
                          received.status ?? "",
                          style: new TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                              fontFamily: AssetStrings.lotoRegularStyle),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: new Text(
                        date,
                        style: new TextStyle(
                            color: AppColors.introBodyColor,
                            fontSize: 15.0,
                            fontFamily: AssetStrings.lotoRegularStyle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            new SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
