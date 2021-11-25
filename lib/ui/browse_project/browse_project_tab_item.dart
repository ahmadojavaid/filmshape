import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/browser_project/browse_project.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:Filmshape/ui/project_details/create_project_final_screen.dart';
import 'package:Filmshape/ui/statelesswidgets/VideoThumbnailWidget.dart';
import 'package:Filmshape/ui/statelesswidgets/genere_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class BrowseProjectTabItem extends StatefulWidget {
  final ValueChanged<Widget> fullScreencallBack;
  final PROJECTTYPE projectType;

  BrowseProjectTabItem(this.fullScreencallBack, this.projectType, {Key key})
      : super(key: key);

  @override
  BrowseProjectTabItemState createState() => BrowseProjectTabItemState();
}

class BrowseProjectTabItemState extends State<BrowseProjectTabItem>
    with AutomaticKeepAliveClientMixin<BrowseProjectTabItem> {
  List<AllFTMProject> dataList = new List();

  JoinProjectProvider provider;
  HomeListProvider providers;

  int _page = 1;
  int dataStatus = 0;
  int position = 0;

  ScrollController scrollController = new ScrollController();
  bool _loadMore = false;
  bool isPullToRefresh = false;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300), () {
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
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

    var response = await provider.browseProjects(
        _page, context, provider.browseAllProjectFilterRequest);

    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is BrowseProjectResponse) {
      if (_page == 1) {
        dataList.clear();
      }

      //for different screen type
      switch (widget.projectType) {
        case PROJECTTYPE.ALL:
          {
            //check if more data is available
            if (response.all != null && response.all.length < PAGINATION_SIZE) {
              _loadMore = false;
            } else {
              _loadMore = true;
            }
            dataList.addAll(response.all);
            break;
          }
        case PROJECTTYPE.FEATURED:
          {
            //check if more data is available
            if (response.featured != null &&
                response.featured.length < PAGINATION_SIZE) {
              _loadMore = false;
            } else {
              _loadMore = true;
            }
            dataList.addAll(response.featured);
            break;
          }
        case PROJECTTYPE.MOSTVIEWED:
          {
            //check if more data is available
            if (response.mostViewed != null &&
                response.mostViewed.length < PAGINATION_SIZE) {
              _loadMore = false;
            } else {
              _loadMore = true;
            }
            dataList.addAll(response.mostViewed);
            break;
          }
        case PROJECTTYPE.TOPRATED:
          {
            //check if more data is available
            if (response.topRated != null &&
                response.topRated.length < PAGINATION_SIZE) {
              _loadMore = false;
            } else {
              _loadMore = true;
            }
            dataList.addAll(response.topRated);
            break;
          }
      }

      //check data
      if (dataList.length == 0) {
        dataStatus = 1;
      } else {
        dataStatus = 0;
      }
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
    scaffoldKey.currentState
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
            var projectData = dataList[index];
            return InkWell(
                onTap: () {
                  position = index;
//                  Navigator.push(
//                    context,
//                    new CupertinoPageRoute(builder: (BuildContext context) {
//                      return new CreateProjectFinalScreen(
//                        projectData.id.toString(),
//                        widget.fullScreencallBack,
//                        null,
//                        previousTabHeading: "My projects",
//                        isRole: true,
//                      );
//                    }),
//                  );
                  _moveToDetailScreen(projectData.id);
                },
                child: buildItem(projectData, index));
          },
          itemCount: dataList.length,
        ),
      ),
    );
  }

  Future<void> _moveToDetailScreen(int projectId) async {
    //project detail screen
    await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new JoinProjectDetails(
          projectId,
          previousTabHeading: browseAllProjects,
          fullScreenWidget: widget.fullScreencallBack,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    providers = Provider.of<HomeListProvider>(context);
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
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
              (dataStatus == 1)
                  ? getEmptyView("No projects found")
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> likeUnlikeApi(int id, int type, int index) async {
    /*  provider.setLoading();*/
    var response =
        await providers.likeUnlikeProjectFeed(context, id, type, "Project");

    if (response != null && (response is LikesResponse)) {
      dataList[index].likedBy.length = response.likes;

      if (dataList[index].isLike == null) {
        dataList[index].isLike = false;
      }

      dataList[index].isLike = !dataList[index].isLike;

      /*  if (type == 1) {
        dataList[index].isLike = true;
      } else {
        dataList[index].isLike = false;
      }*/
    }

    provider.hideLoader();
    setState(() {});
  }

  void moveToOwnProjectDetailScreen(AllFTMProject projectData, int index) {
    position = index;
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new CreateProjectFinalScreen(
          projectData.id.toString(),
          widget.fullScreencallBack,
          null,
          previousTabHeading: "My projects",
          isRole: true,
        );
      }),
    );
  }

  void moveToOtherProjectDetailScreen(AllFTMProject projectData, int index) {
    position = index;
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new CreateProjectFinalScreen(
          projectData.id.toString(),
          widget.fullScreencallBack,
          null,
          previousTabHeading: "My projects",
          isRole: true,
        );
      }),
    );
  }

  Widget buildItem(AllFTMProject projectData, int index) {
    String date = "";

    var genere =
        "${projectData?.genre?.name ?? ""}${(projectData?.projectType?.name ?? "").length > 0 ? "/" : ""}${projectData?.projectType?.name ?? ""}";


    if (projectData.created != null) {
      date = "${formatDateStringMyProject(projectData.created, "dd")}th " +
          "${formatDateStringMyProject(projectData.created, "MMMM yyyy")}";
    }
    //add team members here
    List<String> teamList = new List();
    if (projectData.team != null)
      for (var data in projectData.team) {
        teamList.add(data.thumbnailUrl); //add team users
      }

    return Container(
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
//              Container(
//                height: LIST_PLAYER_HEIGHT,
//                child: Container(
//                  child: (_mediaUrl != null && _mediaUrl.length > 0)
//                      ? YoutubeVimeoInappBrowser(_mediaUrl ?? "")
//                      : Container(),
//                  decoration: new BoxDecoration(
//                    color: Colors.black.withOpacity(0.8),
//                  ),
//                ),
//              ),
              MediaThumbnailWidget(mediaUrl: projectData.media),
              InkWell(
                onTap: () {
                  moveToOwnProjectDetailScreen(projectData, index);
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
                  moveToOtherProjectDetailScreen(projectData, index);
                },
                child: Offstage(
                  offstage: projectData.description != null &&
                          projectData.description.length > 0
                      ? false
                      : true,
                  child: Container(
                      margin: new EdgeInsets.only(
                          left: 20.0, top: 15.0, right: 10.0),
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
              ),
              InkWell(
                onTap: () {
                  moveToOwnProjectDetailScreen(projectData, index);
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
                      Expanded(child: getNetworkStackItem(teamList, 0, 36.0)),
                      InkWell(
                        onTap: () {
                          int type = 1;

                          if (projectData != null) {
                            int type =
                                projectData.isLike != null && projectData.isLike
                                    ? 0
                                    : 1;

                            likeUnlikeApi(projectData.id, type, index);
                          }
                        },
                        child: new SvgPicture.asset(
                          AssetStrings.like,
                          width: 20,
                          height: 20,
                          color:
                              projectData.isLike != null && projectData.isLike
                                  ? AppColors.kPrimaryBlue
                                  : AppColors.kHomeBlack,
                        ),
                      ),
                      new SizedBox(
                        width: 3.0,
                      ),
                      new Text(
                        projectData.likedBy != null &&
                                projectData.likedBy.length > 0
                            ? " ${projectData.likedBy.length.toString()}"
                            : "0",
                        style: TextStyle(
                            fontSize: 15.0,
                            color:
                                projectData.isLike != null && projectData.isLike
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
                    top: BorderSide(width: 0.6, color: AppColors.dividerColor),
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

  //reset the filter
  void resetFilter() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
