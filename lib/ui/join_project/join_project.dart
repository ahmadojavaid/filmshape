import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/add_a_credit/search_project_response.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/like_unlike/like_unlike_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/common_video_view/items/expendable_view.dart';
import 'package:Filmshape/ui/otherprojectdetails/join_project_details.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:Filmshape/ui/statelesswidgets/genere_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class JoinProject extends StatefulWidget {
  final int type;
  String previousTabHeading;
  final ValueChanged<Widget> fullScreenWidget;

  JoinProject(this.fullScreenWidget, {this.type, this.previousTabHeading});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<JoinProject> {
  String projectType;
  String genre;
  String location;
  String payment;
  String projectStatus;

  List<String> _searchDataList;
  List<SearchProjectResponse> projectList;

  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  TextEditingController _SearchController = new TextEditingController();
  TextEditingController _LocationController = new TextEditingController();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  BehaviorSubject<String> _streamSearch = BehaviorSubject();

  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  var dateTime;
  int year;
  JoinProjectProvider provider;
  CreateProfileProvider providers;
  HomeListProvider providerHome;
  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String profile;
  Notifier _notifier;
  int _pageNo = 1;

  bool _loadMore = false;
  bool isPullToRefresh = false;

  bool _showRolesView = false;

  @override
  void initState() {
    super.initState();
    _searchDataList = new List();
    projectList = new List();

    Future.delayed(const Duration(milliseconds: 300), () {
      provider.list.clear();
      hitCommonApi(0);
      hitRolesApi();
      _notifier?.notify('action', "Join a Project"); //update title
    });

    _setScrollListener();
  }

  @override
  void dispose() {
    _streamControllerShowLoader.close(); //close the stream on disponsse
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);

    super.dispose();
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  hitApi() async {
    if (!isPullToRefresh) {
      provider.setLoading();
    }

    //check if is loadmore
    if (_loadMore) {
      _pageNo++;
    } else {
      _pageNo = 1;
    }
    //create request body
    JoinRequest joinrequest = new JoinRequest();

    if (provider.projectTypeDataResponse.data != null) {
      for (var data in provider.projectTypeDataResponse.data) {
        if (data.name == projectType) {
          joinrequest.project_type =
              RolesCreateProfile(type: "ProjectType", id: data.id);
          break;
        }
      }
    }

    if (provider.projectGenreDataResponse.data != null) {
      for (var data in provider.projectGenreDataResponse.data) {
        if (data.name == genre) {
          joinrequest.genre =
              RolesCreateProfile(type: "ProjectGenre", id: data.id);
          break;
        }
      }
    }

    if (provider.projectStatusDataResponse.data != null) {
      for (var data in provider.projectStatusDataResponse.data) {
        if (data.name == projectStatus) {
          joinrequest.status =
              RolesCreateProfile(type: "ProjectStatus", id: data.id);
          break;
        }
      }
    }

    var roleList = providers.listId.toList();
    List<RolesCreateProfile> rolesSelected = List();
    if (roleList != null && roleList.length > 0) {
      for (int i = 0; i < roleList.length; i++) {
        var role = RolesCreateProfile(type: "Role", id: roleList[i]);
        rolesSelected.add(role);
      }
    }

    if (rolesSelected.length > 0) {
      joinrequest.roles = rolesSelected;
    }

    if (_LocationController.text.length > 0) {
      joinrequest.location = _LocationController.text;
    }

    var response = await provider.searchProject(joinrequest, context, _pageNo);

    if (response is APIError) {
      showInSnackBar(response.error);
    } else if (response is SearchMainREsponse) {
      //clear previous data
      if (_pageNo == 1) {
        projectList.clear();
      }

      if (response.data != null && response.data.length < PAGINATION_SIZE) {
        _loadMore = false;
      } else {
        _loadMore = true;
      }

      //check if project liked by
      if (response.data != null) {
        for (var data in response.data) {
          if (data.likedBy != null) {
            var like = checkLikeUserId(data.likedBy);
            data?.isLike = like;
          }
        }
      }

      projectList.addAll(response.data ?? List());

      //reset the fields
//      _LocationController.text = "";
//      projectStatus = null;
//      projectType = null;
//      genre = null;

      //if it's first time result
      if (_pageNo == 1) {
        var currentPos = _scrollController.position.pixels;
        _scrollController.jumpTo(currentPos + 300);
      }

      setState(() {});
    }
  }

  hitCommonApi(int type) async {
    var response;

    switch (type) {
      case 0:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        response = await provider.getCommonData(context, 2, "ProjectGenre/");
        var responseProjectStatus =
            await provider.getCommonData(context, 3, "ProjectStatus/");
//        if(responseProjectStatus is JonProductData)
//          {
//            if (widget.type != null && widget.type == 1) {
//              projectStatus = responseProjectStatus.data.last.name;
//            }
//
//
//          }
        break;
      case 1:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        break;
      case 2:
        response = await provider.getCommonData(context, 2, "ProjectGenre/");
        break;
      case 3:
        response = await provider.getCommonData(context, 3, "ProjectStatus/");
        break;
    }
  }

  hitRolesApi() async {
    providers.setLoading();
    var response = await providers.getRoles(context);

    if (response != null && (response is GetRolesResponseMain)) {
      _searchDataList.addAll(providers.listAllRolesItem);
      provider.hideLoader();
    } else {
      //(" role error");
    }
    _showRolesView = true; //show the roles list now
  }

  void addData(String data) async {
    for (GetRolesResponse list in providers.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data && !providers.list.contains(data)) {
          childItem.isChecked = true;
          list.category.isExpend = true;
          providers.listId.add(childItem.id);
          providers.list.add(childItem.name);
          providers.setRoleList(providers.listId);
          //(providers.list);
          //(providers.listId);
          break;
        }
      }
      setState(() {});
    }
  }

  void _setScrollListener() {
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (_searchDataList.length >= (PAGINATION_SIZE * _pageNo) &&
            _loadMore) {
          isPullToRefresh = true;
          hitApi();
          showInSnackBar("Loading data...");
        }
      }
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    return InkWell(
        onTap: () {
          if (type == 1) {
            if (provider.projectTypeList.length == 0) {
              provider.setLoading();
              hitCommonApi(1);
            }
          } else if (type == 2) {
            if (provider.genreList.length == 0) {
              provider.setLoading();
              hitCommonApi(2);
            }
          } else if (type == 3) {
            if (provider.statusList.length == 0) {
              provider.setLoading();
              hitCommonApi(3);
            }
          }
          // FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
        },
        child: DropDownButtonWidget(
            title: title,
            list: list,
            image: image,
            hint: hint,
            callBack: valueChanged));
  }

  ValueChanged<String> projectTypeCallBack(String value) {
    projectType = value;
  }

  ValueChanged<String> projectGenreCallBack(String value) {
    genre = value;
  }

  ValueChanged<String> projectStatusCallBack(String value) {
    projectStatus = value;
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    providers = Provider.of<CreateProfileProvider>(context);
    providerHome = Provider.of<HomeListProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            body: Container(
              color: Colors.white,
              child: Form(
                key: _fieldKey,
                child: new SingleChildScrollView(
                  controller: _scrollController,
                  /*  physics: BouncingScrollPhysics(),*/
                  child: Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new SizedBox(
                          height: 45.0,
                        ),
                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                          child: new Text(
                            "Select roles to apply for",
                            style: AppCustomTheme.selectRolesTitle,
                          ),
                        ),
                        new SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          margin: new EdgeInsets.only(
                              left: MARGIN_LEFT_RIGHT,
                              right: MARGIN_LEFT_RIGHT),
                          child: AutoCompleteTextView(
                            defaultPadding: 9.0,
                            isLocation: false,
                            icon: Icons.search,
                            hintText: "Search for a role",
                            suggestionsApiFetchDelay: 100,
                            focusGained: () {},
                            onTapCallback: (String text) async {
                              addData(text);
                              //closeKeyboard();
                              //(text);
                            },
                            focusLost: () {
                              //("focust lost");
                            },
                            onValueChanged: (String text) {
                              //("called $text");
                            },
                            controller: _SearchController,
                            suggestionStyle: Theme.of(context).textTheme.body1,
                            getSuggestionsMethod: getLocationSuggestionsList,
                            tfTextAlign: TextAlign.left,
                            tfStyle: TextStyle(
                              fontSize: 16,
                              color: Theme.of(context).textTheme.body1.color,
                            ),
                            tfTextDecoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Search for a role",
                            ),
                          ),
                        ),
                        new SizedBox(
                          height: 25.0,
                        ),
                        new Container(
                          color: Colors.grey.withOpacity(0.5),
                          height: 1.0,
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        Offstage(
                          offstage: !_showRolesView,
                          child: SampleExpendable(
                            maxLimit: true,
                          ),
                        ),
                        new SizedBox(height: 15),
                        sizeBox,
                        getDropdownItem(
                            projectType,
                            provider.projectTypeList,
                            1,
                            AssetStrings.ploject_type,
                            "Project type",
                            projectTypeCallBack),
                        sizeBox,
                        getDropdownItem(genre, provider.genreList, 2,
                            AssetStrings.paint, "Genre", projectGenreCallBack),
                        sizeBox,
                        getLocation(_LocationController, context,
                            _streamControllerShowLoader,
                            iconData: Icons.location_on,
                            iconPadding: ICON_LEFT_PADDING),
                        sizeBox,
                        getDropdownItem(
                            projectStatus,
                            provider.statusList,
                            3,
                            AssetStrings.ic_tick,
                            "Project status",
                            projectStatusCallBack),
                        new SizedBox(
                          height: 35.0,
                        ),
                        getSetupButton(callback, "Search projects", 40),
                        new SizedBox(
                          height: 30.0,
                        ),
                        Offstage(
                          offstage: projectList.length > 0 ? false : true,
                          child: Container(
                            color: AppColors.kBackfroundSearch,
                            child: new Container(
                              margin: new EdgeInsets.only(
                                  left: 55.0, right: 45.0, top: 30),
                              child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Text(
                                    "${projectList.length} Results",
                                    style: new TextStyle(
                                        fontFamily:
                                            AssetStrings.lotoRegularStyle,
                                        color: AppColors.introBodyColor,
                                        fontSize: 18),
                                  ),
                                  new Container(
                                    padding: new EdgeInsets.all(7.0),
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.backgroundSearch),
                                    child: new Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: AppColors.kBackfroundSearch,
                          child: Container(
                            margin: new EdgeInsets.only(
                                left: 15.0, right: 15.0, top: 2.0),
                            child: new ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              padding: new EdgeInsets.all(0.0),
                              itemBuilder: (BuildContext context, int index) {
                                return buildItemProjects(
                                    index); //for extra space
                              },
                              itemCount: projectList.length,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: (provider.getLoading() || providers.getLoading()),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> likeUnlikeApi(int id, int type, int index) async {
    provider.setLoading();
    var response =
        await providerHome.likeUnlikeProjectFeed(context, id, type, "Project");

    provider.hideLoader();

    if (response is LikesResponse) {
      projectList[index].likedBy.length = response.likes;
      projectList[index].isLike = !projectList[index].isLike;
    }

    setState(() {});
  }

  Widget buildItemProjects(int pos) {
    var projectData = projectList[pos];
    List<String> list = new List();
    String genreProject;
    String role ;
    String roleMain ;
    String iconUrl ;

    if (projectData.projectRoleCalls.length > 0) {
      ProjectRoleCallss data = projectList[pos].projectRoleCalls[0];

      if (data.role != null) {
        role = data.role.name;
        roleMain = data.role.category.name;
        iconUrl = data.role.iconUrl;
      }
    }

    genreProject =
        "${projectData?.genre?.name ?? ""}${(projectData?.projectType?.name ?? "").length > 0 ? "/" : ""}${projectData?.projectType?.name ?? ""}";

    if (projectData.team != null)
      for (var data in projectData.team) {
        list.add(data.thumbnailUrl);
      }
    //("list $list");

    return Container(
      margin: new EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            new CupertinoPageRoute(builder: (BuildContext context) {
              return new JoinProjectDetails(
                projectList[pos].id,
                previousTabHeading: "Join a Project",
                fullScreenWidget: widget.fullScreenWidget,
              );
            }),
          );
        },
        child: Card(
          elevation: 1.5,
          shape: RoundedRectangleBorder(
            side: new BorderSide(
                color: AppColors.projectCardbordercolor, width: 1),
            borderRadius: BorderRadius.circular(5),
          ),
          color: Colors.white,
          child: Container(
            padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
/*
                      Expanded(
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          child:  buildStackList(),
                        ),
                      ),*/
                    ]
                      ..add(Expanded(
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: getNetworkStackItem(list, 0, 40.0)),
                      ))
                      ..add(
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            padding: new EdgeInsets.only(bottom: 5.0),
                            margin: new EdgeInsets.only(left: 25.0),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    int type = projectList[pos].isLike ? 0 : 1;

                                    likeUnlikeApi(
                                        projectList[pos].id, type, pos);
                                  },
                                  child: new Icon(
                                    Icons.thumb_up,
                                    size: 17.0,
                                    color: projectList[pos].isLike
                                        ? AppColors.kPrimaryBlue
                                        : Colors.black,
                                  ),
                                ),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  projectList[pos].likedBy.length.toString(),
                                  style: new TextStyle(
                                      color: projectList[pos].isLike
                                          ? AppColors.kPrimaryBlue
                                          : Colors.black,
                                      fontSize: 15.0,
                                      fontFamily:
                                          AssetStrings.lotoRegularStyle),
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
                    projectList[pos].title ?? "",
                    style: AppCustomTheme.suggestedFriendNameStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                new SizedBox(
                  height: 5.0,
                ),
                Offstage(
                  offstage: projectList[pos].location != null ? false : true,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: new Text(
                      projectList[pos].location ?? "",
                      style: new TextStyle(
                          color: Colors.black87,
                          fontSize: 14.0,
                          fontFamily: AssetStrings.lotoRegularStyle),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Offstage(
                  offstage: projectList[pos].description != null ? false : true,
                  child: Container(
                      margin: new EdgeInsets.only(top: 5.0, right: 20.0),
                      alignment: Alignment.topLeft,
                      child: new Text(
                        projectList[pos].description ?? "",
                        style: AppCustomTheme.descriptionIntro,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )),
                ),
                Offstage(
                  offstage: genreProject.length > 0 ? false : true,
                  child: new SizedBox(
                    height: 14.0,
                  ),
                ),
                Offstage(
                    offstage: genreProject != null && genreProject.length > 0
                        ? false
                        : true,
                    child: Container(
                        margin: new EdgeInsets.only(left: 0, top:  5),
                        child: GenereWidget(
                          genere: genreProject,
                        ))),
                new SizedBox(
                  height: 14.0,
                ),
                Container(
                  margin: new EdgeInsets.only(right: 5.0),
                  child: Row(
                    children: <Widget>[
                      Offstage(
                          offstage: iconUrl != null ? false : true,
                          child: getSvgNetworkImage(url: iconUrl, size: 20.0)),
                      new SizedBox(
                        width: 5.0,
                      ),
                      Offstage(
                        offstage: role != null ? false : true,
                        child: new Text(
                          role != null ? role : "",
                          style: new TextStyle(
                              color: AppColors.introBodyColor,
                              fontFamily: AssetStrings.lotoBoldStyle,
                              fontSize: 14.0),
                        ),
                      ),
                      Expanded(
                        child: Offstage(
                          offstage: roleMain != null ? false : true,
                          child: new Text(
                            roleMain != null ? " ($roleMain)" : "",
                            style: new TextStyle(
                                color: AppColors.introBodyColor,
                                fontSize: 13.0,
                                fontFamily: AssetStrings.lotoRegularStyle),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
      ),
    );
  }

  VoidCallback callback() {
    // FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    //(_LocationController.text);
    isPullToRefresh = false;
    _loadMore = false;
    hitApi();
  }

  Future<List<String>> getLocationSuggestionsList(String locationText) async {
    List<String> suggestionList = providers.listAllRolesItem
        .where((f) => f.toLowerCase().startsWith(locationText.toLowerCase()))
        .toList();

    return suggestionList;
  }

  Widget buildSearchItem(int pos) {
    return InkWell(
      onTap: () {
        addData(_searchDataList[pos]);
        _searchDataList.clear();
        _searchDataList.addAll(providers.listAllRolesItem);
        Navigator.pop(context);
      },
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: new EdgeInsets.only(left: 15.0, right: 15.0),
            padding: new EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Container(
                margin: new EdgeInsets.only(left: 10.0, right: 10.0),
                child: new Text(
                  _searchDataList[pos],
                  style: new TextStyle(
                      color: Colors.black,
                      fontFamily: "LatoSemiBold",
                      fontSize: 15.0),
                )),
          ),
        ],
      ),
    );
  }

  void showAllRolesBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              color: Colors.white,
              child: new Wrap(
                children: <Widget>[
                  new Container(
                    height: 45.0,
                    margin: new EdgeInsets.only(top: 30.0),
                    child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      decoration: new BoxDecoration(
                          color: AppColors.chipColors.withOpacity(0.3),
                          borderRadius: new BorderRadius.circular(25.0)),
                      child: new TextField(
                        controller: _SearchController,
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          _streamSearch.add(value);
                        },
                        decoration: new InputDecoration(
                          fillColor: Colors.green,
                          border: InputBorder.none,
                          hintText: "Search by name...",
                          hintStyle: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: _streamSearch.stream,
                      initialData: "",
                      builder: (context, snapshot) {
                        if (snapshot.data.length > 0) {
                          //("snapshot data ${snapshot.data}");
                          _searchDataList.clear();
                          _searchDataList.addAll(providers.listAllRolesItem);
                          _searchDataList = _searchDataList
                              .where((f) => f
                                  .toLowerCase()
                                  .startsWith(snapshot.data.toLowerCase()))
                              .toList();

                          //("searchlisttsize ${_searchDataList.length}");
                        } else {
                          //("else ${snapshot.data}");
                          _searchDataList.clear();
                          _searchDataList.addAll(providers.listAllRolesItem);
                        }

                        return Container(
                          color: Colors.white,
                          margin: new EdgeInsets.only(top: 30.0),
                          height: getScreenSize(context: context).height / 3,
                          child: new ListView.builder(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return buildSearchItem(index);
                              },
                              itemCount: _searchDataList.length),
                        );
                      }),
                ],
              ),
            ),
          );
        });
  }
}
