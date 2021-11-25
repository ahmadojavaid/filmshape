import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_request.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/common_video_view/items/expendable_view.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:Filmshape/ui/statelesswidgets/user_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'my_profile/my_profile.dart';

class SearchForTalent extends StatefulWidget {
  String previousTabHeading;
  bool showBackButton;

  SearchForTalent({this.previousTabHeading, this.showBackButton = false});

  @override
  _SearchForTalentState createState() => _SearchForTalentState();
}

class _SearchForTalentState extends State<SearchForTalent> {
  String gender;
  String ethnicity;
  String location;

  List<String> _searchDataList;

  TextEditingController _SearchController = new TextEditingController();
  TextEditingController _LocationController = new TextEditingController();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  BehaviorSubject<String> _streamSearch = BehaviorSubject();

  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  int _pageNo = 1;
  ScrollController _scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  bool _loadMore = false;
  bool isPullToRefresh = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  var dateTime;
  int year;
  JoinProjectProvider providerJoinProject;
  CreateProfileProvider providerProfile;
  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String profile;
  Notifier _notifier;

  bool isVisible = false;

  TextEditingController _HeightController = new TextEditingController();
  TextEditingController _WeightController = new TextEditingController();
  FocusNode _HeightField = new FocusNode();
  FocusNode _WeightField = new FocusNode();

  List<UserData> _searchTalentList = new List<UserData>();
  bool _showRolesView=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchDataList = new List();

    Future.delayed(const Duration(milliseconds: 300), () {
      providerProfile?.list?.clear(); //clear previously selected roels data
      hitGenderApi();
      hitEthicsApi();
      hitRolesApi();
      _notifier?.notify('action', "Search for Talent"); //update title

    });

    _setScrollListener();
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


  @override
  void dispose() {
    _streamControllerShowLoader.close(); //close the stream on disponsse
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify(
          'action', widget.previousTabHeading);

    super.dispose();
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  hitApi() async {
    if (!isPullToRefresh) {
      providerJoinProject.setLoading();
    }

    if (_loadMore) {
      _pageNo++;
    } else {
      _pageNo = 1;
    }

    //create request body
    SearchTalentRequest request = new SearchTalentRequest();

    //for gender
    if (providerProfile.genderResponse.data != null) {
      for (var data in providerProfile.genderResponse.data) {
        if (data.name == gender) {
          request.gender =
              RolesCreateProfile(type: "Gender", id: data.id);
          break;
        }
      }
    }
    // ethencity
    if (providerProfile.ethicityResponse.data != null) {
      for (var data in providerProfile.ethicityResponse.data) {
        if (data.name == ethnicity) {
          request.ethnicity =
              RolesCreateProfile(type: "Ethnicity", id: data.id);
          break;
        }
      }
    }

    //for roles
    var roleList = providerProfile.listId.toList();
    List<RolesCreateProfile> rolesSelected = List();
    if (roleList != null && roleList.length > 0) {
      for (int i = 0; i < roleList.length; i++) {
        var role = RolesCreateProfile(type: "Role", id: roleList[i]);
        rolesSelected.add(role);
      }
    }

    if (rolesSelected.length > 0) {
      request.roles = rolesSelected;
    }


    if (_LocationController.text.length > 0) {
      request.location = _LocationController.text;
    }
    //for height
    if (_HeightController.text.length > 0) {
      request.height = int.parse(_HeightController.text);
    }
    if (_WeightController.text.length > 0) {
      request.weight = int.parse(_WeightController.text);
    }

    var response =
    await providerJoinProject.searchForTalent(request, context, _pageNo);


    if (response is APIError) {
      showInSnackBar(response.error);
    }
    else {
//      _LocationController.text = "";
//      _HeightController.text = "";
//      _WeightController.text = "";
//      gender = null;
//      ethnicity = null;

      if (response is SearchTalentResponse) {
        if (response.listData != null &&
            response.listData.length < PAGINATION_SIZE) {
          _loadMore = false;
        } else {
          _loadMore = true;
        }

        //clear previous data
        if (_pageNo == 1) {
          _searchTalentList.clear();
        }

        _searchTalentList.addAll(response.listData ?? List());

        //if it's first time result
        if (_pageNo == 1) {
          var currentPos = _scrollController.position.pixels;
          _scrollController.jumpTo(currentPos + 300);
        }
      }
    }
  }




  hitGenderApi() async {
    var response = await providerProfile.getGender(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  hitEthicsApi() async {
    var response = await providerProfile.getEthicity(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  hitRolesApi() async {
    providerProfile.setLoading();
    var response = await providerProfile.getRoles(context);

    if (response != null && (response is GetRolesResponseMain)) {
      _searchDataList.addAll(providerProfile.listAllRolesItem);
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
    _showRolesView=true; //show the roles list now
  }

  void addData(String data) async {
    for (GetRolesResponse list in providerProfile.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data && !providerProfile.list.contains(data)) {
          childItem.isChecked = true;
          list.category.isExpend = true;
          providerProfile.listId.add(childItem.id);
          providerProfile.list.add(childItem.name);
          providerProfile.setRoleList(providerProfile.listId);

          break;
        }
      }
      checkVisible();

      setState(() {});
    }
  }


  void checkVisible() {
    if (providerProfile.list.contains("Actor") ||
        providerProfile.list.contains("Actor (Extra)")) {
      isVisible = false;
    }
    else {
      isVisible = false;
    }
  }




  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    //FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
     return InkWell(
        onTap: () {

          if (type == 1) {
            if (providerProfile.genderList.length == 0) {
              providerProfile.setLoading();
              hitGenderApi();
            }
          } else if (type == 2) {
            if (providerProfile.ethicityList.length == 0) {
              providerProfile.setLoading();
              hitEthicsApi();
            }
          }
        },
        child: DropDownButtonWidget(
            title: title,
            list: list,
            image: image,
            hint: hint,
            callBack: valueChanged));
  }


  ValueChanged<List<String>> voiCallBack(List<String> value) {
    checkVisible();
  }

  ValueChanged<String> genderCallBack(String value) {
    gender = value;
  }

  ValueChanged<String> ethicityCallBack(String value) {
    ethnicity = value;
  }

  @override
  Widget build(BuildContext context) {
    providerJoinProject = Provider.of<JoinProjectProvider>(context);
    providerProfile = Provider.of<CreateProfileProvider>(context);
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
                  /*  physics: BouncingScrollPhysics(),*/
                  controller: _scrollController,
                  child: Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        (widget.showBackButton) ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: new EdgeInsets.only(
                                left: 10, top: 5),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,

                            ),
                          ),
                        ) : Container(),
                        new SizedBox(
                          height: 40.0,
                        ),

                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                          child: new Text(
                            "Select roles to search for",
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
                              closeKeyboard();
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
                          offstage:!_showRolesView,
                          child: SampleExpendable(voidcallback: voiCallBack,
                            type: 3,
                            maxLimit: true,),
                        ),

                        new SizedBox(height: 15),


                        new Offstage(
                          offstage: isVisible,
                          child: sizeBox,
                        ),

                        Offstage(
                          offstage: isVisible,
                          child: getDropdownItem(
                              gender,
                              providerProfile.genderList,
                              1,
                              AssetStrings.ploject_type,
                              "Gender",
                              genderCallBack),
                        ),

                        new Offstage(
                          offstage: isVisible,
                          child: sizeBox,
                        ),

                        Offstage(
                          offstage: isVisible,
                          child: getDropdownItem(
                              ethnicity,
                              providerProfile.ethicityList,
                              2,
                              AssetStrings.paint,
                              "Ethnicity",
                              ethicityCallBack),
                        ),

                        new Offstage(
                          offstage: isVisible,
                          child: sizeBox,
                        ),

                        Offstage(
                          offstage: isVisible,
                          child: getHeightWeightTextField(
                              false,
                              validatorHeight,
                              "Height",
                              _HeightController,
                              _HeightField,
                              _WeightField,
                              false,
                              "cm",
                              TextInputType.text),
                        ),
                        sizeBox,

                        Offstage(
                          offstage: isVisible,
                          child: getHeightWeightTextField(
                              false,
                              validatorWeight,
                              "Weight",
                              _WeightController,
                              _WeightField,
                              _WeightField,
                              false,
                              "kg",
                              TextInputType.text),
                        ),

                        new Offstage(
                          offstage: isVisible,
                          child: sizeBox,
                        ),
                        getLocation(_LocationController, context,
                            _streamControllerShowLoader,
                            iconData: Icons.location_on,
                            iconPadding: ICON_LEFT_PADDING),
                        sizeBox,
                        getSetupButton(callback, "Search talent", 40,
                            newColor: AppColors.searchTalentColor),
                        new SizedBox(
                          height: 30.0,
                        ),
                        Offstage(
                          offstage: _searchTalentList.length >
                              0
                              ? false
                              : true,
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
                                    "${_searchTalentList.length} Results",
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
                                  var data = _searchTalentList[index];
                                  return InkWell(
                                    onTap: () {
                                      moveToProfileScreen(data);
                                    },
                                    child: UserWidget(data),
                                  ); //for extra space
                                },
                                itemCount: _searchTalentList.length),
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
              status: (providerProfile.getLoading() ||
                  providerJoinProject.getLoading()),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  void moveToProfileScreen(UserData userData)
  {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return MyProfile( null,
          null,
          null,
          userData.id.toString(),
          previousTabHeading: "Search of Talent",
          userData: userData,
          );
      }),
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
    List<String> suggestionList = providerProfile.listAllRolesItem
        .where((f) => f.toLowerCase().startsWith(locationText.toLowerCase()))
        .toList();

    return suggestionList;
  }

  Widget buildSearchItem(int pos) {
    return InkWell(
      onTap: () {
        addData(_searchDataList[pos]);
        _searchDataList.clear();
        _searchDataList.addAll(providerProfile.listAllRolesItem);
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
                          _searchDataList
                              .addAll(providerProfile.listAllRolesItem);
                          _searchDataList = _searchDataList
                              .where((f) => f
                                  .toLowerCase()
                                  .startsWith(snapshot.data.toLowerCase()))
                              .toList();

                          //("searchlisttsize ${_searchDataList.length}");
                        } else {
                          //("else ${snapshot.data}");
                          _searchDataList.clear();
                          _searchDataList
                              .addAll(providerProfile.listAllRolesItem);
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
