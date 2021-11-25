import 'dart:collection';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/followfollowing/followingfollowersresponse.dart';
import 'package:Filmshape/Model/following_suggestion/follow_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/suggestion_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class FollowingUsers extends StatefulWidget {

  final int type;
  final String userId;
  final String currentHeader;

  const FollowingUsers(this.currentHeader,
      {Key key, @required this.type, @required this.userId})
      : super(key: key);

  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<FollowingUsers> {
  SuggestionProvider provider;
  List<String> list = new List();
  List<FollowFollowingUser> dataList;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  Notifier _notifier;

  int _page = 1;
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();



  @override
  void initState() {
    dataList = new List();
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitApi();
      //update header
      _notifier?.notify(
          'action', (widget.type == 1) ? "Followers" : "Following");
    });

    _setScrollListener();
  }


  void _setScrollListener() {
    scrollController = new ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        if (dataList.length >= (PAGINATION_SIZE * _page) && _loadMore) {
          isPullToRefresh = true;
          hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }


  hitFollowUnfollowApi(int id, int types, int index) async {
    provider.setLoading();

    print("types $types");
    var response = await provider.followUser(context, id, types);

    provider.hideLoader();

    if (response != null && (response is FollowResponse)) {
      dataList[index].isFollowing = !dataList[index].isFollowing;
    }
    else {
      APIError apiError = response;
      print(apiError.error);
      /* showAlert(
        context: context,
        titleText: "ERROR",
        message: "Failed! Try Again.",
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar("Failed! Try Again.");
    }
  }

  hitApi() async {
    if (!isPullToRefresh) {
      provider.setLoading();
    }

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }


    var response = await provider.followerFollowing(
        context, widget.userId, widget.type, _page);

    if (response is FollowersFollowingReponse) {
      if (_page == 1) {
        dataList.clear();
      }

      if (response.followingFollowers != null &&
          response.followingFollowers.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }

      if (response.followingFollowers != null &&
          response.followingFollowers.length > 0) {
        for (FollowFollowingUser data in response.followingFollowers) {
          if (data.isFollowing == null) {
            data.isFollowing = false;
          }
        }
      }

      dataList.addAll(response.followingFollowers);

      setState(() {

      });


    }
    else {
      APIError apiError = response;
      print(apiError.error);

      showInSnackBar(apiError.error);
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  VoidCallback callBackAppBar() {
    //update header back to previous
    _notifier?.notify(
        'action', widget.currentHeader);

    Navigator.pop(context,"update");
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SuggestionProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.followFollowingBackgroundColor,
        key: _scaffoldKeys,
        // appBar: getAppBar(widget.type == 0 ? "Folllowing" : "Followers"),
        appBar: backButton("Back to profile",callBackAppBar),
        body: new Stack(
          children: <Widget>[
            new Column(
              children: <Widget>[
                _buildContestList(),
              ],
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            (dataList.length == 0)
                ? new Center(
                child: getNoData(
                    (widget.type == 1) ? "No Followers" : "No Followings")
            ) : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildItem(String name, String bio, List<String> roles, String url,
      bool isBool, int id, int index) {
    return Container(
      margin: new EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
      child: Card(
        elevation: 3.0,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            children: <Widget>[
              Container(
                child: IntrinsicHeight(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: getCachedNetworkImage(
                                url:"${APIs.imageBaseUrl}$url",
                                fit: BoxFit.cover),
                          )),
                      new SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 3.0, horizontal: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                name ?? "",
                                style: AppCustomTheme
                                    .suggestedFriendNameStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              new SizedBox(
                                height: 5.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: new EdgeInsets.only(right: 38.0),
                                  child: new Text(
                                    bio ?? "",
                                    style: AppCustomTheme
                                        .followingTextStyle,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                margin: new EdgeInsets.only(top: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    (roles.length>0)
                        ?Container(
                        height:35,
                        child: getStackItem(roles, 0, 35)):Container(),
                    Expanded(
                      child: new SizedBox(
                        width: 5.0,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        int types = 1;
                        if (isBool == null || !isBool) {
                          types = 0;
                        }

                        hitFollowUnfollowApi(id, types, index);
                      },
                      child: Container(
                        padding: new EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        decoration: new BoxDecoration(
                            border: new Border.all(
                              color: AppColors.kPrimaryBlue,
                              width: 1.0,
                            ),
                            borderRadius: new BorderRadius.circular(16.0)),
                        child: new Text(
                          isBool != null && isBool ? "Follow" : "Following",
                          style: new TextStyle(
                              color: AppColors.kPrimaryBlue,
                              fontSize: 13.5,
                              fontFamily: AssetStrings.lotoRegularStyle),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildContestList() {
    return Expanded(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,


        onRefresh: () async {
          isPullToRefresh = true;
          _loadMore = false;
          await hitApi();
        },
        child: Container(
          color: AppColors.backgroundColorsGrey,
          child: Container(
            margin: new EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
            child: new ListView.builder(
              padding: new EdgeInsets.all(0.0),
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),

              itemBuilder: (BuildContext context, int index) {
                String name = "";
                String bio = "";
                String url = "";
                List<String> roles = List();
                LinkedHashSet<String> listLocal = new LinkedHashSet<String>();

                var data = dataList[index];

                for (var role in data.roles) {
                  listLocal.add(role.iconUrl);
                }

                roles.addAll(listLocal);

                return InkWell(
                  onTap: () {
                    goToProfile(context, data.id.toString(), data.fullName);
                  },
                  child: buildItem(data.fullName, data.bio, roles,
                      data.thumbnailUrl, data.isFollowing, data.id, index),
                );
              },
              itemCount: dataList.length,
            ),
          ),
        ),
      ),
    );
  }
}
