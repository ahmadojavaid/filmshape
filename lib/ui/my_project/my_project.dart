import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Model/myprojects/my_project_filter.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/project_details/create_project_final_screen.dart';
import 'package:Filmshape/ui/statelesswidgets/VideoThumbnailWidget.dart';
import 'package:Filmshape/ui/statelesswidgets/genere_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class MyProject extends StatefulWidget {
  final ValueChanged<Widget> fullScreencallBack;
  String previousTabHeading;

  MyProject(this.fullScreencallBack,{this.previousTabHeading});
  @override
  _MenuHomeState createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MyProject> {

  List<ProjectData> dataList = new List();
  Notifier _notifier;
  JoinProjectProvider provider;
  HomeListProvider providers;
  int _page = 1;
  int dataStatus=0;
  int position = 0;

  bool offstagenodata = true;
  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _notifier?.notify('action', "My projects"); //update heading
      hitApi();

    });
    _setScrollListener();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    super.initState();
  }
  @override
  void dispose() {
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify(
          'action', widget.previousTabHeading);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      ]);
    super.dispose();
  }


  hitApi() async {
    if (!isPullToRefresh) {
      provider.setLoading();
    }

    var userId = MemoryManagement.getuserId();
    var filter = new MyProjectFilters(
        creator: CreatorInfo(type: "User", id: userId));

    if (_loadMore) {
      _page++;
    } else {
      _page = 1;
    }

    var response =
    await provider.searchForMyProjects(filter, context, _page);

    if (response is APIError) {
      showInSnackBar(response.error);
      dataStatus=1;
    }
    else if (response is MyProjectResponse) {
      print("my_project${response.listData.length}");

      if (_page == 1) {
        dataList.clear();
      }

      if (response.listData != null &&
          response.listData.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }

      dataList.addAll(response.listData);

      //check if user liked the post
      for (var item in dataList) {
        if (item.likedBy != null && item.likedBy?.length > 0) {
          var like = checkLikeUserId(item.likedBy);
          item?.isLike = like;
        }
      }
      _checkEmptyScreen();
    }
  }

  void _checkEmptyScreen() {
    //check data
    if (dataList.length == 0) {
      dataStatus = 1;
    } else {
      dataStatus = 0;
    }
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




  void showInSnackBar(String value) {
    Scaffold.of(context)
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  _buildContestList() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: () async {
        isPullToRefresh = true;
        _loadMore = false;
        await hitApi();
      },
      child: Container(
        color: Colors.white,
        child: new ListView.builder(
          padding: new EdgeInsets.all(0.0),
          controller: scrollController,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
           var projectData=dataList[index];
             return InkWell(
                onTap: (){
                  position=index;
                  _moveToProjectDetailScreen(projectData);
                },
                child: buildItem(projectData, index));
          },
          itemCount: dataList.length,
        ),
      ),
    );
  }

  Future<void> _moveToProjectDetailScreen(ProjectData projectData) async {
    var value = await Navigator.push<String>(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new CreateProjectFinalScreen(
          projectData.id.toString(),
          widget.fullScreencallBack,
          projectData,
          previousTabHeading: "My projects",
          isRole: true,
          fromMyProject: true,
        );
      }),
    );
   //check if project deleted or not
    if(value!=null)
      {
        dataList.removeAt(position);
        _checkEmptyScreen(); //check for empty screen
        setState(() {

        });
      }
  }


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    providers = Provider.of<HomeListProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: new Stack(
            children: <Widget>[
              _buildContestList(),
              new Center(
                child: getHalfScreenProviderLoader(
                  status: provider.getLoading(),
                  context: context,
                ),
              ),

              (dataStatus==1)?getEmptyView("No projects found"):Container(),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> likeUnlikeApi(int id, int type, int index) async {
    /*  provider.setLoading();*/
    var response = await providers.likeUnlikeProjectFeed(
        context, id, type, "Project");

    if (response is LikesResponse) {
      dataList[index].likedBy.length = response.likes;
      dataList[index].isLike = !dataList[index].isLike;
    }

    provider.hideLoader();
    setState(() {

    });
  }




  Widget buildItem(ProjectData projectData, int index) {
    String date = "";

    if (projectData.created != null) {
      date = "${formatDateStringMyProject(projectData.created, "dd")}th " +
          "${formatDateStringMyProject(projectData.created, "MMMM yyyy")}";
    }
    //add team members here
    List<String> teamList = new List();
    if (projectData.team != null)
      for (var data in projectData.team) {
      //  print("team_memeber project ${projectData.title} ${data.thumbnailUrl}");
        teamList.add(data.thumbnailUrl); //add team users
      }
    var genere =
        "${projectData?.genre?.name ?? ""}${(projectData?.projectType?.name ?? "").length > 0 ? "/" : ""}${projectData?.projectType?.name ?? ""}";

    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Container(
//                height: LIST_PLAYER_HEIGHT,
//                child: Container(
//                  child: (_mediaUrl != null &&
//                      _mediaUrl.length > 0)
//                      ? YoutubeVimeoInappBrowser(
//                      _mediaUrl ?? "")
//                      : Container(),
//                  decoration: new BoxDecoration(
//                    color: Colors.black.withOpacity(0.8),
//                  )
//                  ,
//                ),
//              ),
              MediaThumbnailWidget(mediaUrl: projectData.media),
              InkWell(
                onTap: () {
                  _moveToProjectDetailScreen(projectData);
                },
                child: Container(
                    margin: new EdgeInsets.only(left: 20.0, top: 20.0),
                    child: new Text(
                      "${projectData.title ?? ""}",
                      style: new TextStyle(
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 18.0,
                          color: AppColors.kBlack),
                    )),
              ),

              Offstage(
                  offstage: genere.length > 1 ? false : true,
                  child: Container(
                      margin: new EdgeInsets.only(left: 20, top: 15),
                      child: GenereWidget(
                        genere: genere,
                      ))),
              InkWell(
                onTap: () {
                  _moveToProjectDetailScreen(projectData);

                },
                child: Container(
                    margin:
                    new EdgeInsets.only(left: 20.0, top: 15.0, right: 10.0),
                    child: new Text(
                      "${projectData.description ?? ""}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontFamily: AssetStrings.lotoRegularStyle,
                        fontSize: 14.0,
                        color: AppColors.kAppBlack,
                      ),
                    )),
              ),
              InkWell(
                onTap: () {
                  _moveToProjectDetailScreen(projectData);
                },
                child: Container(
                    margin: new EdgeInsets.only(left: 20.0, top: 15.0),
                    child: new Text(
                      date,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontFamily: AssetStrings.lotoRegularStyle,
                        fontSize: 15.0,
                        color: AppColors.kPlaceHolberFontcolor,
                      ),
                    )),
              ),
              new SizedBox(
                height: 20.0,
              ),
              Container(
                margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                child: IntrinsicHeight(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      teamList != null && teamList.length > 0 ? Expanded(
                          child: Container(child: getSvgNetworkCacheImage(
                              teamList, 36, noOfShowing: 8))) : Expanded(
                          child: new Container()),
                      InkWell(
                        onTap: () {

                          if (projectData != null) {
                            int type = projectData.isLike != null &&
                                projectData.isLike ? 0 : 1;
                            likeUnlikeApi(projectData.id, type, index);
                          }

                        },
                        child: new SvgPicture.asset(
                          AssetStrings.like,
                          width: 20,
                          height: 20,
                          color: projectData.isLike != null &&
                              projectData.isLike
                              ? AppColors.kPrimaryBlue
                              : AppColors.kHomeBlack,
                        ),
                      ),
                      new SizedBox(
                        width: 3.0,
                      ),
                      new Text(
                        projectData.likedBy != null &&
                            projectData.likedBy.length > 0 ? " ${projectData
                            .likedBy
                            .length
                            .toString()}" : "0",
                        style: TextStyle(
                            fontSize: 15.0,
                            color: projectData.isLike != null &&
                                projectData.isLike
                                ? AppColors.kPrimaryBlue
                                : AppColors.kHomeBlack,
                            fontFamily: AssetStrings.lotoRegularStyle),
                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              new SizedBox(
                height: 25.0,
              ),
              new Container(
                height: 20,
                decoration: new BoxDecoration(
                  color: AppColors.tabBackground,
                  border: Border(
                    top:
                    BorderSide(width: 0.6, color: AppColors.dividerColor),
                    bottom:
                    BorderSide(width: 0.6, color: AppColors.dividerColor),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }


}
