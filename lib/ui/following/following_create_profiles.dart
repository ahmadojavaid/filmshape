import 'dart:collection';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/following_suggestion/follow_response.dart';
import 'package:Filmshape/Model/following_suggestion/header.dart';
import 'package:Filmshape/Model/following_suggestion/suggestion_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/suggestion_notifier.dart';
import 'package:Filmshape/ui/profile_create_sucess/ProfileCreateSucess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FollowingCreateProfile extends StatefulWidget {
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<FollowingCreateProfile> {
  SuggestionProvider provider;
 // List<String> list = new List();
  bool isLike = false;
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    // TODO: implement initState

   // list.add(AssetStrings.imageMusic);
    //list.add(AssetStrings.imageLighting);

    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      hitApi();
    });
  }

  _buildContestList() {
    return Expanded(
      child: Container(
        margin: new EdgeInsets.only(left: 15.0, right: 15.0, top: 2.0),
        child: new ListView.builder(
          padding: new EdgeInsets.all(0.0),
          itemBuilder: (BuildContext context, int index) {
            if (provider.list[index] is Projects) {
              return buildItemProjects(provider.list[index], index);
            }
            else if (provider.list[index] is Users) {
              return buildItem(index, provider.list[index]);
            }
            else if (provider.list[index] is Header) {
              return _topHeading(provider.list[index]);
            }
            else {
              return provider.list[index]; //for extra space
            }
          },
          itemCount: provider.list.length,
        ),
      ),
    );
  }

  VoidCallback backCallBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    provider = Provider.of<SuggestionProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            appBar: appBarBackButton(onTap: backCallBack),
            key: _scaffoldKeys,
            body: new Container(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new SizedBox(
                    height: 25.0,
                  ),
//                  InkWell(
//                    onTap: () {
//                      Navigator.pop(context);
//                    },
//                    child: Container(
//                      margin: new EdgeInsets.only(left: 25.0),
//                      child: new Row(
//                        crossAxisAlignment: CrossAxisAlignment.start,
//                        children: <Widget>[
//                          new Icon(Icons.arrow_back),
//                          new SizedBox(
//                            width: 5.0,
//                          ),
//                          new Text(
//                            "Back",
//                            style: AppCustomTheme.backButtonStyle,
//                          )
//                        ],
//                      ),
//                    ),
//                  ),

                  new SizedBox(
                    height: 30.0,
                  ),
                  _buildContestList(),
                  new SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0,bottom: 16.0),
                      child: getContinueProfileSetupButton(
                          callback, "Complete profile setup"),
                    ),
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                        ]
                    ),
                  )
                ],
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
      ),
    );
  }

  Widget _topHeading(Header header) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 16),
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              child: new Text(
                header.heading,
                style: AppCustomTheme.createProfileSubTitle,
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 4.0),
              child: new Text(
                header.subHeading,
                style: AppCustomTheme.body15Regular,
              ),
            )
          ]),
    );
  }


  VoidCallback callback() {
    Navigator.pushAndRemoveUntil(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new ProfileCreateSuccess();
      }),
          (route) => false,
    );
  }

  hitApi() async {
    provider.setLoading();
    var response = await provider.getData(context);

    if (response != null && (response is SuggestionResponse)) {} else {
      APIError apiError = response;
      print(apiError.error);
      /*  showAlert(
        context: context,
        titleText: "ERROR",
        message: "Failed! Try Again.",
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar("Failed! Try Again.");
    }
  }


  Future<bool> likeUnlikeApi(int id, int type, int index) async {
    var response = await provider.likeUnlikeProject(context, id, type);

    if (response != null && (response is LikesResponse)) {
      print(response);
    }
    else {
      Projects project = provider.list[index];
      if (type == 0) {
        project.count = project.count + 1;
        project.isLike = true;
      }
      else {
        project.count = project.count - 1;
        project.isLike = false;
      }
      setState(() {

      });
    }
    }



  hitFollowUnfollowApi(int id, int type, int index) async {
    provider.setLoading();
    var response = await provider.followUser(context, id, type);

    if (response != null && (response is FollowResponse)) {
      if (provider.list[index] is Users) {
        Users user = provider.list[index];
        if (type == 1) {
          user.isFollow = true;
        }
        else {
          user.isFollow = false;
        }
      }

      setState(() {

      });
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

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }


  Widget buildItemProjects(Projects project, int pos) {

    List<String> listUsers = new List();

    if (project.team != null && project.team.length > 0) {
      for (int i = 0; i < project.team.length; i++) {
        var data = project.team[i];
        listUsers.add(data.thumbnailUrl);
      }
      print("list $listUsers");
    }

    return Container(
      margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: Card(
        elevation: 3.0,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
               ]..add(Expanded(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: getNetworkStackItem(listUsers, 0, 40.0)
                    ),
                  ))..add(
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        int type = 1;
                        if (project.isLike != null) {
                          if (project.isLike) {
                            type = 0;
                            project.count = project.count - 1;
                            print("unlike$type");
                          }
                          else {
                            project.count = project.count + 1;
                            print("like$type");
                          }
                        }
                        project.isLike = !project.isLike;

                        likeUnlikeApi(project.id, type, pos);

                        setState(() {

                        });
                      },
                      child: Container(
                        padding: new EdgeInsets.only(bottom: 5.0),
                        margin: new EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: <Widget>[
                            (project.isLike != null && project.isLike) ?
                            new Icon(
                              Icons.thumb_up,
                              size: 18.0,
                              color: AppColors.kPrimaryBlue,
                            ) :
                            new Icon(
                              Icons.thumb_up,
                              size: 18.0,
                            ),
                            new SizedBox(
                              width: 5.0,
                            ),
                            new Text(
                              project.count != null
                                  ? project.count.toString()
                                  : "0",
                              style: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              new SizedBox(
                height: 13.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "${project.title}",
                  style: AppCustomTheme
                      .suggestedFriendNameStyle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              new SizedBox(
                height: 5.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "${project.location}",
                  style: new TextStyle(color: Colors.black87,
                      fontSize: 14.0,
                      fontFamily: AssetStrings.lotoRegularStyle),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Container(
                  margin:
                  new EdgeInsets.only(top: 5.0, right: 20.0),
                  alignment: Alignment.topLeft,
                  child: new Text(
                    "${project.description}",
                    style: AppCustomTheme.descriptionIntro,
                  )),

              new SizedBox(
                height:
                10.0,
              ),


              new Container(
                alignment: Alignment.center,
                width: 120.0,
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5, bottom: 5),
                decoration: new BoxDecoration(
                    color: AppColors.kPrimaryBlue,
                    borderRadius: new BorderRadius.circular(5.0)
                ),
                child: new Text(project.genre != null ? project.genre.name : "",
                  style: new TextStyle(
                    fontFamily: AssetStrings.lotoSemiboldStyle,
                    color: Colors.white,
                    fontSize: 13.0),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index, Users user) {
    List<String> roles=List();
    LinkedHashSet<String> listLocal = new LinkedHashSet<String>();
    for(var data in user.roles)
      {
        listLocal.add(data.iconUrl);
      }
    roles.addAll(listLocal);
    return Container(
      margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
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
                                url:
                                "${APIs.imageBaseUrl}${user.thumbnailUrl??""}",
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
                                user.fullName,
                                style: AppCustomTheme
                                    .suggestedFriendNameStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              new SizedBox(
                                height: 2.0,
                              ),
                              Expanded(
                                child: Container(
                                  padding: new EdgeInsets.only(right: 35.0),
                                  child: new Text(
                                    user.username,
                                    style: AppCustomTheme
                                        .suggestedFriendMyReelStyle,
                                    maxLines: 1,
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
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    new CupertinoPageRoute(
                        builder: (BuildContext context) {
                          return new ProfileCreateSuccess();
                        }),
                  );
                },
                child: Container(
                  margin: new EdgeInsets.only(top: 10.0),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      (roles.length>0)
                      ?Container(
                          height: 36,
                          child: getStackItem(roles, 0, 36)):Container(),
                      Expanded(
                        child: new SizedBox(
                          width: 5.0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          int type = 1;
                          if (user.isFollow != null && user.isFollow) {
                            type = 2;
                          }
                          hitFollowUnfollowApi(user.id, type, index);
                        },
                        child: Container(
                          padding: new EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                color: user.isFollow != null && user.isFollow
                                    ? AppColors.kPrimaryBlue
                                    : AppColors.kPlaceHolberFontcolor,
                                width: INPUT_BOX_BORDER_WIDTH,
                              ),
                              borderRadius: new BorderRadius.circular(16.0)),
                          child: new Text(
                            user.isFollow != null && user.isFollow
                                ? "Following"
                                : "Follow",
                            style: new TextStyle(
                                fontFamily: AssetStrings.lotoRegularStyle,
                                fontSize: 13.0,
                                color: user.isFollow != null && user.isFollow
                                    ? AppColors.kPrimaryBlue
                                    : AppColors.kPlaceHolberFontcolor
                            ),
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
    );
  }
}
