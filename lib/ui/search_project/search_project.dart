import 'package:Filmshape/Model/following_suggestion/suggestion_response.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Model/search/search_data_response.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SearchProject extends StatefulWidget {
  final ValueChanged<Widget> fullScreenCallBack;

  SearchProject(this.fullScreenCallBack);

  @override
  _SearchProjectState createState() => new _SearchProjectState();
}

class _SearchProjectState extends State<SearchProject> {
  List<ProjectData> listProject = new List();
  List<Users> listUsers = new List();

  Dio dio;
  CancelToken _requestToken;

  TextEditingController _SearchController = new TextEditingController();
  HomeListProvider provider;

  final GlobalKey<ScaffoldState> globalKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    dio = Dio();
  }

  getSearchedData(String query) async {
    //clear the data list first
    listProject.clear();
    listUsers.clear();

    print("query $query");
    provider.setLoading();
    Map<String, String> headers = {};
    headers["Authorization"] = "Token " + MemoryManagement.getAccessToken();

    try {
      if (_requestToken != null)
        _requestToken.cancel(); //cancel the previous on going request

      _requestToken = CancelToken(); //generate new token for new request

      print("url ${APIs.search + "$query"}");
      var response = await dio
          .get(APIs.search + "$query",
              cancelToken: _requestToken, options: Options(headers: headers))
          .timeout(timeoutDuration);

      provider.hideLoader();
      print("response ${response.data}");
      SearchListResponse searchListResponse =
          new SearchListResponse.fromJson(response.data);

      //check if user liked any of the project
      for(var project in searchListResponse.projects)
        {
          project.isLike=checkLikeUserId(project.likedBy);
          listProject.add(project);

        }
      listUsers.addAll(searchListResponse.users);

      //if users and projects found hide keyboard
      if(listUsers.length>0 ||listProject.length>0) {
        closeKeyboard();
        FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
      }
      setState(() {});
    } on DioError catch (e) {
      print("error:${e.message}");
    //  provider.hideLoader();

      //    showInSnackBar("Error: ${e.message}");
    } catch (e) {
      print("error:${e}");
      // provider.hideLoader();

      // showInSnackBar("Error: ${e.toString()}");
    }
  }

  Future<bool> likeUnlikeCommentApi(ProjectData data) async {
    var response = await provider.likeUnlikeProjectFeed(
        context, data.id, data.likeType, "Comment");

    if (response is LikesResponse) {
      data?.likedBy?.length = response.likes;
    }
  }

  void showInSnackBar(String value) {
    globalKey.currentState.showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget getAppBarNew(BuildContext context) {
    return PreferredSize(
        preferredSize: Size.fromHeight(220.0),
        child: Material(
          elevation: 2.0,
          child: Container(
            height: 60.0,
            margin: new EdgeInsets.only(left: 20.0, right: 20.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(Icons.arrow_back,)),

                new SizedBox(
                  width: 20.0,
                ),

                Expanded(
                  child: new TextFormField(
                    controller: _SearchController,
                    textCapitalization: TextCapitalization.sentences,
                    style: new TextStyle(
                        color: AppColors.kAppBlack,
                        fontFamily: AssetStrings.lotoBoldStyle,
                        fontSize: 17.0),

                    decoration: new InputDecoration(
                      fillColor: Colors.green,
                      border: InputBorder.none,

                      hintText: "Search",
                      hintStyle: new TextStyle(
                          color: AppColors.kAppBlack.withOpacity(0.7),
                          fontFamily: AssetStrings.lotoBoldStyle,
                          fontSize: 16.0),
                    ),

                    onChanged: (String value) {
                      getSearchedData(value);

                    },
                  ),
                ),


                Offstage(
                  offstage: _SearchController.text
                      .trim()
                      .length > 0 ? false : true,


                  child: InkWell(
                      onTap: () {
                        _SearchController.text = "";
                        setState(() {

                        });
                      },
                      child: new Icon(
                        Icons.clear, color: Colors.black, size: 21,)),
                ),


              ],
            ),
          ),
        ));
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            appBar: getAppBarNew(context),
            key: globalKey,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

              child: Container(
                margin: new EdgeInsets.only(left: 35.0, right: 35.0),

                child: Column(
                  children: <Widget>[

                    Offstage(
                        offstage: listUsers != null && listUsers.length > 0
                            ? false
                            : true,

                        child: getText("People")),


                    new Container(
                        margin: new EdgeInsets.only(top: 20.0),
                        child: new Wrap(
                          children: actorWidgets.toList(),
                        )),
                    new SizedBox(
                      height: 20.0,
                    ),
                    Offstage(
                        offstage: listProject != null && listProject.length > 0
                            ? false
                            : true,
                        child: getText("Projects")),

                    Container(
                        margin: new EdgeInsets.only(top: 10.0),
                        child: new Wrap(
                          children: projectWidgets.toList(),
                        ))
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
      ),
    );
  }

  Widget getText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(top: 20.0),
      child: new Text(
        text,
        style: new TextStyle(
            color: Colors.black,
            fontSize: 20.0,
            fontFamily: AssetStrings.lotoSemiboldStyle),
      ),
    );
  }

  Widget stackItem(int index) {
    return Positioned(
      child: new SvgPicture.asset(
        AssetStrings.imageProductionMarketing,
        width: 30.0,
        height: 30.0,
        fit: BoxFit.fill,
      ),
    );
  }

  /* buildStackList() {
    return Container(
      child: new ListView.builder(
        padding: new EdgeInsets.all(0.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return stackItem(index);
        },
        itemCount: 5,
      ),
    );
  }*/




  Iterable<Widget> get actorWidgets sync* {
    for (Users data in listUsers) {
      yield SearchUser(data);
    }
  }

  Iterable<Widget> get projectWidgets sync* {
    for (ProjectData data in listProject) {
      yield SearchProjectItem(data, likeCallBack, voidCallbackProjectDetails);
    }
  }

  ValueChanged<ProjectData> likeCallBack(ProjectData data) {
    likeUnlikeCommentApi(data);
  }

  //move to full project detail screen
  ValueChanged<int> voidCallbackProjectDetails(int postid) {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new JoinProjectDetails(
          postid,
          previousTabHeading: "Join a Project",
          fullScreenWidget: widget.fullScreenCallBack,
        );
      }),
    );
  }
}

class SearchUser extends StatelessWidget {
  Users user;

  SearchUser(this.user);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
      onTap: () {
        goToProfile(context, user.id.toString(), user.fullName ?? "",
            fromComments: true, fromSearchScreen: true);
      },
      child: Container(
        child: Container(
          margin: new EdgeInsets.only(top: 10.0),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    child: IntrinsicHeight(
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
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
                                    child: getCachedNetworkImageWithurl(
                                        url: user.thumbnailUrl ?? "",
                                        fit: BoxFit.cover),
                                  )),
                              Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                child: new Container(
                                  width: 13.0,
                                  height: 13.0,
                                  decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (user.isOnline)?Colors.greenAccent:Colors.grey,
                                      border: new Border.all(
                                          color: Colors.white, width: 1.3)),
                                ),
                              )
                            ],
                          ),
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
                                    user.fullName ?? "",
                                    style: new TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                        fontFamily: AssetStrings
                                            .lotoSemiboldStyle),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  new SizedBox(
                                    height: 5.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: new EdgeInsets.only(right: 35.0),
                                      child: new Text(
                                        user.bio ?? "",
                                        style: new TextStyle(
                                            color: Colors.black54,
                                            fontFamily: AssetStrings
                                                .lotoRegularStyle,
                                            fontSize: 14.0),
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchProjectItem extends StatelessWidget {
  ProjectData data;
  ValueChanged<ProjectData> likeCallBack;
  ValueChanged<int> projectDetailCallBack;

  List<String> list = new List();

  SearchProjectItem(this.data, this.likeCallBack, this.projectDetailCallBack);

  @override
  Widget build(BuildContext context) {
    bool isLiked = data.isLike ?? false;
    String likedByCount = data?.likedBy?.length?.toString() ?? "0";

    for (var item in data.team) {
      if (item != null && item.thumbnailUrl != null) {
        list.add(item.thumbnailUrl);
      }
    }

    if (list.length == 0) {
      if (data.creator.thumbnailUrl != null) {
        list.add(data.creator.thumbnailUrl);
      }
    }

    return InkWell(
      onTap: () {
        projectDetailCallBack(data.id);
      },
      child: Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: Card(
          elevation: 2.0,
          child: Container(
            padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            child: Column(
              children: <Widget>[
                Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[]
                      ..add(Expanded(
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: new Stack(
                            alignment: Alignment.centerRight,
                            children: <Widget>[]
                              // todo: make dynamic
                              ..addAll(new List.generate(list.length, (index) {
                                return new Padding(
                                  padding: new EdgeInsets.only(
                                    right: index *
                                        (28.0), // give left and remove alignment for reverse type
                                  ),
                                  child: new Container(
                                    width: 40,
                                    height: 40,
                                    decoration: new BoxDecoration(
                                      color: Colors.black,
                                      shape: BoxShape.circle,
                                      border: new Border.all(
                                        width: 1.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ClipOval(
                                      child: getCachedNetworkImageWithurl(
                                          url: list[index] ?? "",
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                );
                              })),
                          ),
                        ),
                      ))
                      ..add(
                        Container(
                          padding: new EdgeInsets.only(bottom: 5.0),
                          margin: new EdgeInsets.only(left: 25.0),
                          child: Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  data.isLike = !isLiked;
                                  data.likeType = isLiked ? 0 : 1;
                                  likeCallBack(data);
                                },
                                child: new Icon(
                                  Icons.favorite,
                                  size: 18.0,
                                  color: data.isLike != null && data.isLike
                                      ? AppColors.heartColor
                                      : AppColors.heartGrey,
                                ),
                              ),
                              new SizedBox(
                                width: 5.0,
                              ),
                              new Text(
                                likedByCount,
                                style: new TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14.5,
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
                new SizedBox(
                  height: 13.0,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: new Text(
                    data.title ?? "",
                    style: new TextStyle(
                        color: AppColors.kprojectTitle,
                        fontSize: 16.0,
                        fontFamily: AssetStrings.lotoSemiboldStyle),
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
                    data.location ?? "",
                    style: new TextStyle(color: Colors.black54,
                        fontSize: 14.0,
                        fontFamily: AssetStrings.lotoRegularStyle),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}