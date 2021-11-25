import 'dart:async';

import 'package:Filmshape/Model/browser_project/browse_all_project_filter_request.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/browse_project/browse_project_bottom_sheet.dart';
import 'package:Filmshape/ui/my_profile/decprator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

import 'browse_project_tab_item.dart';
import 'data_model.dart';

class BrowseProjectScreen extends StatefulWidget {
  final ValueChanged<Widget> fullScreencallBack;
  String previousTabHeading;

  BrowseProjectScreen(this.fullScreencallBack, {this.previousTabHeading});

  @override
  BrowseProjectScreenState createState() => BrowseProjectScreenState();
}

class BrowseProjectScreenState extends State<BrowseProjectScreen>
    with TickerProviderStateMixin {
  TabController tabBarController;
  int _tabIndex = 0;
  Notifier _notifier;
  JoinProjectProvider provider;
  final StreamController<bool> _streamControllerFilterindicator =
      StreamController<bool>();

  final GlobalKey<BrowseProjectTabItemState> _allTabKey =
      new GlobalKey<BrowseProjectTabItemState>();

  final GlobalKey<BrowseProjectTabItemState> _topRatedTabKey =
      new GlobalKey<BrowseProjectTabItemState>();

  final GlobalKey<BrowseProjectTabItemState> _featuredRatedTabKey =
      new GlobalKey<BrowseProjectTabItemState>();

  final GlobalKey<BrowseProjectTabItemState> _mostViewedRatedTabKey =
      new GlobalKey<BrowseProjectTabItemState>();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  //to move to inner side  screen
  void moveToScreen(Widget screen) {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return screen;
      }),
    );
  }

//  TabController _tabController;

  @override
  void initState() {
    tabBarController =
    new TabController(initialIndex: _tabIndex, length: 4, vsync: this);
    tabBarController.addListener(_handleTabSelection);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);


    Future.delayed(const Duration(milliseconds: 300), () {
      _notifier?.notify('action', browseAllProjects); //update title
    });
    super.initState();
  }

  @override
  void dispose() {
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);
    //remove rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    //reset all filter in destory
    provider.browseAllProjectFilterRequest =
    new BrowseAllProjectFilterRequest();
    //reset local cache drop down values
    provider.browseProjectFilter = new DataModelFilter();
    _streamControllerFilterindicator.close(); //clear stream
    super.dispose();
  }

  void showInSnackBar(String value) {
    scaffoldKey.currentState.showSnackBar(
        new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    var screensize = MediaQuery
        .of(context)
        .size;
    _notifier = NotifierProvider.of(context); // to update home screen header
    return SafeArea(
      child: new Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Material(
                  elevation: 3.0,

                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white
                    ),
                    padding: new EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            width: screensize.width,
                            height: 40.0,
                            margin: new EdgeInsets.only(left: 10.0, right: 5.0),
                            child: DecoratedTabBar(
                              decoration: BoxDecoration(
                                  border: Border(
                                    bottom:
                                    BorderSide(
                                        width: 1.0, color: Colors.transparent),
                                  ),
                                  color: Colors.transparent),
                              tabBar: new TabBar(
                                  indicatorColor: Colors.black,
                                  labelStyle: new TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: AssetStrings.lotoBoldStyle),
                                  indicatorWeight: 2.4,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  isScrollable: true,
                                  unselectedLabelStyle: new TextStyle(
                                      fontSize: 14.0,
                                      fontFamily: AssetStrings
                                          .lotoRegularStyle),
                                  unselectedLabelColor: Colors.black87,
                                  labelColor: Colors.black,
                                  labelPadding: new EdgeInsets.only(left: 15.0),
                                  indicatorPadding: new EdgeInsets.only(
                                      left: 15.0),
                                  controller: tabBarController,
                                  tabs: <Widget>[
                                    new Tab(
                                      text: "All",
                                    ),
                                    new Tab(
                                      text: "Top Rated",
                                    ),
                                    new Tab(
                                      text: "Featured",
                                    ),

                                    new Tab(
                                      text: "Most Viewed",
                                    ),

                                  ]),
                            ),
                          ),
                        ),

                        new SizedBox(
                          width: 5.0,
                        ),

                        InkWell(
                            onTap: () {
                              filterProjectsBottomSheet();
                            },
                            child: new StreamBuilder<bool>(
                                stream: _streamControllerFilterindicator.stream,
                                initialData: false,
                                builder: (BuildContext context,
                                    AsyncSnapshot<bool> snapshot) {
                                  bool status = snapshot.data;
                                  return FilterButton(status);
                                })
                        ),
                        new SizedBox(
                          width: 15.0,
                        )
                      ],
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        BrowseProjectTabItem(
                          widget.fullScreencallBack, PROJECTTYPE.ALL,
                          key: _allTabKey,),
                        BrowseProjectTabItem(
                            widget.fullScreencallBack, PROJECTTYPE.TOPRATED,
                            key: _topRatedTabKey),
                        BrowseProjectTabItem(
                            widget.fullScreencallBack, PROJECTTYPE.FEATURED,
                            key: _featuredRatedTabKey),
                        BrowseProjectTabItem(
                            widget.fullScreencallBack, PROJECTTYPE.MOSTVIEWED,
                            key: _mostViewedRatedTabKey),
                      ],
                      controller: tabBarController,),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }


  void _handleTabSelection() {
    if (tabBarController.index != _tabIndex) {
      _tabIndex = tabBarController.index;
      print("index $_tabIndex");
    }
  }


  void filterProjectsBottomSheet() async
  {
    var result = await showModalBottomSheet<int>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height / 1.7,
                padding: EdgeInsets.only(
                    bottom: MediaQuery
                        .of(context)
                        .viewInsets
                        .bottom),
                child: BrowseProjectBottomSheet(),
              ));
        });
    //check if any filter is applied
    if (result != null && result == 1) {
      //apply the filter
      print("filter ${provider.browseAllProjectFilterRequest.toJson()}");
      _streamControllerFilterindicator.add(true); //filter applied
      switch (tabBarController.index) {
        case 0:
          {
            _allTabKey.currentState?.resetFilter();
            break;
          }
        case 1:
          {
            _topRatedTabKey.currentState?.resetFilter();
            break;
          }
        case 2:
          {
            _featuredRatedTabKey.currentState?.resetFilter();
            break;
          }
        case 3:
          {
            _mostViewedRatedTabKey.currentState?.resetFilter();
            break;
          }
      }
    }
    else if (result != null && result == 2) {
      //clear  the filter
      print("filter ${provider.browseAllProjectFilterRequest.toJson()}");
      refreshAllLoadedTab();
      _streamControllerFilterindicator.add(false); //filter removed

    }
  }

  void refreshAllLoadedTab() {
    _allTabKey.currentState?.resetFilter();
    _topRatedTabKey.currentState?.resetFilter();
    _featuredRatedTabKey.currentState?.resetFilter();
    _mostViewedRatedTabKey.currentState?.resetFilter();
  }


}

class FilterButton extends StatelessWidget {
  final bool showIndicator;

  FilterButton(this.showIndicator);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: <Widget>[
        new Container(
          padding: new EdgeInsets.symmetric(
              vertical: 6.0, horizontal: 8.0),
          decoration: new BoxDecoration(
              border: new Border.all(
                  color: AppColors.delete_save_border,
                  width: 1.0),
              borderRadius:
              new BorderRadius.circular(5.0),
              color: AppColors.white),
          child: new Row(
            children: <Widget>[
              new SizedBox(
                width: 5.0,
              ),
              new Text(
                "Filter",
                style: new TextStyle(
                    color: Colors.black, fontSize: 15.0),
              ),

              new Icon(
                Icons.arrow_drop_down,
                color: Colors.black45,
                size: 17.0,
              ),
            ],
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: (showIndicator) ? Container(width: 10,
            height: 10,

            decoration: new BoxDecoration(
              color: AppColors.kPrimaryBlue,
              shape: BoxShape.circle,
            ),
          ) : Container(),)
      ],
    );
  }

}

