import 'package:Filmshape/Model/badge_count.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Model/invite_send_received/invite_send_received_response.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/ui/invite_request/tabs/invite_received_tab.dart';
import 'package:Filmshape/ui/invite_request/tabs/invities_sent_tab.dart';
import 'package:Filmshape/ui/my_profile/decprator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InviteRequest extends StatefulWidget {
  final ValueChanged<BadgeCount> badeCountCallback;
  final ValueChanged<Widget> fullScreenWidget;

  InviteRequest({Key key, this.badeCountCallback, this.fullScreenWidget})
      : super(key: key);

  @override
  InviteRequestState createState() => InviteRequestState();
}

class InviteRequestState extends State<InviteRequest>
    with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  String image;

  GlobalKey<SendTabsState> _projectKeySend = new GlobalKey<SendTabsState>();
  GlobalKey<ReceivedTabsState> _projectKeyReceived =
      new GlobalKey<ReceivedTabsState>();

  double currentIndexPage = 0.0;
  String sendNumber = "0";
  String receiveNumber = "0";
  bool isFirstTmeDataLoaded=false;

//to move to inner side  screen
  void moveToScreen(Widget screen,ValueSetter<BadgeCount> updateProjectCount) async {
    var status=await Navigator.push<String>(
      context,
      new CupertinoPageRoute(
          builder: (BuildContext context) {
            return screen;
          }),
    );

    if(status!=null)
    {
      updateProjectCount(BadgeCount(type: 2));// project deleted
    }
  }


  Future<ValueSetter> voidCallBackComments(
      InviteSendReceivedResponse response) async {
    {
      if (response.sent != null) {
        sendNumber = response.sent.length.toString();
        print("receibed ${response.sent.length}");
      }

      if (response.received != null) {
        print("receibed ${response.received.length}");
        receiveNumber = response.received.length.toString();
        //update the counter of unseen data in icon
        widget.badeCountCallback(
            BadgeCount(count: response.received.length, type: 1));
      }

      setState(() {

      });
    }
  }


  Future<ValueSetter> changeCount(DataModel count) async {
    {
      if (count.roleId == 1) {
        receiveNumber = count.count.toString();
      }
      else {
        sendNumber = count.count.toString();
      }
      setState(() {

      });
    }
  }



  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }


  @override
  void initState() {
    super.initState();
    tabBarController =
    new TabController(initialIndex: _tabIndex, length: 2, vsync: this);
    tabBarController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    _tabIndex = tabBarController.index;
    if (_tabIndex == 0) {
     _projectKeySend.currentState?.callApi();
    } else  {
    _projectKeyReceived.currentState?.callApi();
    }


  }
  @override
  Widget build(BuildContext context) {

    var screensize = MediaQuery.of(context).size;
    return SafeArea(
      child: new Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  new SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    width: screensize.width,
                    height: 40.0,
                    margin: new EdgeInsets.only(left: 18.0, right: 18.0),
                    child: DecoratedTabBar(
                      decoration: BoxDecoration(
                          border: Border(
                            bottom:
                            BorderSide(width: 1.0, color: Colors.transparent),
                          ),
                          color: Colors.transparent),
                      tabBar: new TabBar(
                          indicatorColor: Colors.black,
                          labelStyle: new TextStyle(
                              fontSize: 16.0,
                              fontFamily: AssetStrings.lotoBoldStyle),
                          indicatorWeight: 2.4,
                          indicatorSize: TabBarIndicatorSize.tab,
                          isScrollable: true,
                          unselectedLabelStyle: new TextStyle(fontSize: 16.0,
                              fontFamily: AssetStrings.lotoRegularStyle),
                          unselectedLabelColor: Colors.black87,
                          labelColor: Colors.black,
                          labelPadding: new EdgeInsets.only(left: 15.0),
                          indicatorPadding: new EdgeInsets.only(left: 15.0),
                          controller: tabBarController,
                          tabs: <Widget>[
                            new Tab(
                              text: sendNumber != "0"
                                  ? "Sent ($sendNumber)"
                                  : "Sent",
                            ),
                            new Tab(
                              text: receiveNumber != "0"
                                  ? "Received ($receiveNumber)"
                                  : "Received",
                            )
                          ]),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: new TabBarView(
                        controller: tabBarController,
                        children: <Widget>[
                          new InvitiesSentTabs(
                            callback: voidCallBackComments,
                            callbackCount: changeCount,
                            fullScreenWidget: widget.fullScreenWidget,
                            key: _projectKeySend,
                          ),
                          new InvitiesReceivedTabs(
                            callback: voidCallBackComments,
                            callbackCount: changeCount,
                            key: _projectKeyReceived,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),


          ],
        ),
      ),
    );
  }

  void callBothTabApis()
  {
    _projectKeySend.currentState?.callApi();
    _projectKeyReceived.currentState?.callApi();
  }
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
