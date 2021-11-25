import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/create_profile/create_profile_request.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/ui/common_video_view/items/expendable_view.dart';
import 'package:Filmshape/ui/edit_profile/edit_profile.dart';
import 'package:Filmshape/ui/my_profile/first_tab/video_my_profile.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

class FirstTabProfile extends StatefulWidget {
  final ValueChanged<List<String>> callback;
  final ValueChanged<Widget> callBack;
  final String userId;

  FirstTabProfile(this.callback, this.callBack, this.userId, {Key key})
      : super(key: key);

  @override
  UserProfileFirstTabState createState() => UserProfileFirstTabState();
}

class UserProfileFirstTabState extends State<FirstTabProfile>
    with AutomaticKeepAliveClientMixin<FirstTabProfile> {
  CreateProfileProvider provider;
  List<String> _searchDataList;

  String _gender = "";
  String _ethnicity = "";
  int _height = 0;
  int _wight = 0;

  final chipsList = new BehaviorSubject<List<String>>();
  List<AddRoleModelBottom> listRoles = new List();

  TextEditingController _InputUrlController = new TextEditingController();
  TextEditingController _ShowReelController = new TextEditingController();
  TextEditingController _BioController = new TextEditingController();

  String _youtubeToken;
  String _vimeoToken;
  Showreel _showreel;

//authenticate the youtube user
  youtubeAuth() async {
    var response;
    if (Platform.isIOS) {
      response = await Navigator.push(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return new YoutubeAuthWebView();
        }),
      );
    } else {
      response = await androidYoutubeLogin();
    }
    //success response from
    if (response is YoutubeAuthTokenResponse) {
      _youtubeToken = response.accessToken;
      print("access token $_youtubeToken");
      MemoryManagement.setYoutubeToken(token: _youtubeToken);

      setState(() {});
    }
    //failure
    else if (response is APIError) {
      showInSnackBar(response.error);
    }
    //unknown failure
    else {
      showInSnackBar(Messages.genericError);
    }
  }

  //authenticate the videmo user
  Future<void> vimeoAuth() async {
    var response = await Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new VimeoAuthWebView();
      }),
    );
    //success
    if (response is ViemoAuthTokenResponse) {
      _vimeoToken = response.accessToken;
      print("access token $_vimeoToken");
      MemoryManagement.setVimeoToken(token: _vimeoToken);

      setState(() {});
    }
    //failure
    else if (response is APIError) {
      showInSnackBar(response.error);
    }
    //unknown failure
    else {
      showInSnackBar(Messages.genericError);
    }
  }

  @override
  void initState() {
    super.initState();
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget attributeHeading(String text, IconData image, int from) {
    return InkWell(
      onTap: () {
        if (from == 1) //edit attributes weigth,height, gender enthencity
        {
          widget.callBack(EditProfile(
              null, updateAttributeData, provider.myProfileResponse));
//        Navigator.push(
//          context,
//          new CupertinoPageRoute(
//              builder: (BuildContext context) {
//                return new EditProfile(
//                    null, updateAttributeData, provider.myProfileResponse);
//              }),
//        );
        } else //add new roles
        {
          //if roles are not load
//        if (provider.rolesList.length == 0) {
//          showInSnackBar("wait loading roles");
//          hitRolesApi();
//        }
//        else {
//          showSelectRoleBottomSheet();
//        }
          hitRolesApi();
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(color: AppColors.kPrimaryBlue, width: 1.0),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 10.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Icon(
              image,
              color: AppColors.kPrimaryBlue,
              size: 18.0,
            ),
            new SizedBox(
              width: 12.0,
            ),

            new Text(
              text,
              style: new TextStyle(
                  color: AppColors.kPrimaryBlue,
                  fontSize: 15.5,
                  fontFamily: AssetStrings.lotoRegularStyle),
            ),
          ],
        ),
      ),
    );
  }

  //if attributes updated in edit profile
  ValueChanged updateAttributeData(CreateProfileResponse data) {
    print("got reponsse");
    _gender = (data.gender != null) ? data.gender.name : "";
    _wight = data.weight ?? 0;
    _height = data.height ?? 0;
    _ethnicity = (data.ethnicity != null) ? data.ethnicity.name : "";
    setState(() {});
  }

  Future<ValueSetter> voidCallBack(List<String> list) async {
    chipsList.add(list);
  }

  hitRolesApi() async {
    provider.setLoading();
    var response = (provider.rolesResponse.data == null)
        ? await provider.getRoles(context)
        : provider.rolesResponse;
    provider.hideLoader();

    if (response is GetRolesResponseMain) {
      _searchDataList = new List();
      _searchDataList.addAll(provider.listAllRolesItem);
      //this loop to set selected roles for bottom tab

      provider.list.clear(); //clear previous list if any

      for (var datas in provider.rolesList) {
        datas.category.isExpend = false; //set default to falsee

      }

      for (var userRole in listRoles) {
        var list = List<String>();
        for (var localData in userRole.list) {
          list.add(localData.name);
        }
        provider.list.addAll(list);
        print("roles ${listRoles.length}");

        //add select role to list

        print("roles ${userRole.list.length}");
        for (var datas in provider.rolesList) {
          print(
              "categoryname1=${datas.category.name} category2=${userRole.title}");
          //for main category
          if (datas.category.name == userRole.title) {
            print("expanded yes");
            datas.category.isExpend = true;
          }
          //for subcategory
          for (var selectedUserRole in userRole.list) {
            for (var childData in datas.roles) {
              /*  childData.isChecked = false; //set default to false*/
              if (selectedUserRole.name == childData.name) {
                print("child checked");
                childData.isChecked = true;
                provider.listId.add(childData.id);
                // break;
              }
            }
          }
        }

        provider.hideLoader();
      }

      showSelectRoleBottomSheet(); //role loaded show bottom sheet

      Future.delayed(const Duration(milliseconds: 1000), () {
        print("datalenght ${provider.list}");
        chipsList.add(provider.list);
      });
    } else {
      APIError error = response;
      showInSnackBar(error.error);
    }
  }

  void setData(MyProfileResponse responseProfile) {
    provider.myProfileResponse =
        responseProfile; //set data to pass in edit profile
    listRoles.clear();
    provider.list.clear();
    List<String> list = List();

    for (int i = 0; i < responseProfile.roles.length; i++) {
      Roles data = responseProfile.roles[i];
      if (!list.contains(data.category.name)) {
        list.add(data.category.name);
      }
    }

    for (int i = 0; i < list.length; i++) {
      List<DataModel> dataList = List();

      String title = list[i];
      String icons = "";

      for (int j = 0; j < responseProfile.roles.length; j++) {
        Roles data = responseProfile.roles[j];

        if (title == data.category.name) {
          var dataModel = DataModel(name: data.name, count: 0);
          dataList.add(dataModel);
          provider.list.add(data.name);
          icons = data.iconUrl;
        }
      }

      AddRoleModelBottom model =
          new AddRoleModelBottom(title: title, iconurl: icons, list: dataList);
      listRoles.add(model);
    }
    //for gender
    if (responseProfile.gender != null) {
      _gender = responseProfile.gender.name != null
          ? responseProfile.gender.name
          : "";
    }
    //for enthenticity
    if (responseProfile.ethnicity != null) {
      _ethnicity = responseProfile.ethnicity.name;
    }
    _wight = responseProfile.weight ?? 0;
    _height = responseProfile.height ?? 0;
    _showreel = responseProfile.showreel;
    provider.hideLoader();

    _InputUrlController.text = responseProfile?.showreel?.media ?? "";
    _ShowReelController.text = responseProfile?.showreel?.title ?? "";
    _BioController.text = responseProfile?.showreel?.description ?? "";

    setState(() {});
  }

  Widget buildSearchItem(int pos) {
    return InkWell(
      onTap: () {
        addData(_searchDataList[pos]);
        _searchDataList.clear();
        _searchDataList.addAll(provider.listAllRolesItem);
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

  void addData(String data) async {
    for (GetRolesResponse list in provider.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data && !provider.list.contains(data)) {
          childItem.isChecked = true;
          list.category.isExpend = true;
          provider.listId.add(childItem.id);
          provider.list.add(childItem.name);
          provider.setRoleList(provider.listId);
          print(provider.list);
          print(provider.listId);
          AddRoleModel addmodel = new AddRoleModel(
              title: childItem.category.name,
              iconurl: childItem.iconUrl,
              list: childItem.name);
          provider.addRoleBottomData(addmodel);
          break;
        }
      }
      setState(() {});
    }
  }

  Future<List<String>> selectedRoles() async {
    listRoles.clear();

    var roleList = provider.listId;
    var rolesIcon = List<String>();

    for (var roleId in roleList) {
      RolesData roleData;
      List<DataModel> dataList = List();
      var title;
      for (var mainData in provider.rolesList) {
        roleData = mainData.roles
            .singleWhere((user) => user.id == roleId, orElse: () => null);

        if (roleData != null) {
          rolesIcon.add(mainData.category.iconUrl);
          title = mainData.category.name;
          break;
        }
      }

      if (roleData != null) {
        var userRole = listRoles.singleWhere((user) => user.title == title,
            orElse: () => null);
        if (userRole == null) {
          var datamodel = DataModel(name: roleData.name, count: 0);
          dataList.add(datamodel);
          AddRoleModelBottom model = new AddRoleModelBottom(
              title: title, iconurl: roleData.category.iconUrl, list: dataList);
          listRoles.add(model);
        } else {
          var datamodel = DataModel(name: roleData.name, count: 0);
          userRole.list.add(datamodel);
        }
      }
    }

    setState(() {});

    return rolesIcon;
  }

  hitApi() async {
    var listRolesIcons = await selectedRoles();

    provider.setLoading();

    //create request body
    CreateProfileRequest createProfileRequest1 = new CreateProfileRequest();

    var roleList = provider.listId;

    print("selected roles ${roleList.length}");

    List<RolesCreateProfile> rolesSelected = List();

    if (roleList != null && roleList.length > 0) {
      for (var roleId in roleList) {
        var role = RolesCreateProfile(type: "Role", id: roleId);
        rolesSelected.add(role);
      }
    }

    if (rolesSelected.length > 0) {
      createProfileRequest1.roles = rolesSelected;
    }

    var id = MemoryManagement.getuserId();

    var response = await provider.saveData(createProfileRequest1, context, id);

    print("role update res ${response.toString()}");

    if (response is APIError) {
      showInSnackBar(response.error);
    }
    //update role in previous screen
    if (widget.callback != null) {
      print("roles icon ${listRolesIcons.length}");
      widget.callback(listRolesIcons);
    }
  }

  void removeData(String data) {
    for (GetRolesResponse list in provider.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data) {
          childItem.isChecked = false;
          provider.listId.remove(childItem.id);
          provider.setRoleList(provider.listId);
          print(provider.listId);
          AddRoleModel addmodel = new AddRoleModel(
              title: childItem.category.name,
              iconurl: childItem.iconUrl,
              list: childItem.name);
          removedRoleData(addmodel);
          print(list);
          break;
        }
      }
    }
  }

  void removedRoleData(AddRoleModel model) {
    provider.removeRoleBottomData(model);
  }

  void showSelectRoleBottomSheet() {
    TextEditingController _SearchController = new TextEditingController();
    showModalBottomSheet<void>(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: getScreenSize(context: context).height - 50,
                color: Colors.white,
                child: new Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: new EdgeInsets.only(
                          left: 30.0, right: 30.0, top: 20.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: new Icon(Icons.keyboard_arrow_down,
                                  size: 29.0)),
                          new SizedBox(
                            width: 4.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Text(
                              "Close",
                              style: new TextStyle(
                                  color: Colors.black, fontSize: 16.0),
                            ),
                          ),
                          Expanded(
                            child: new SizedBox(
                              width: 55.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              hitApi();
                              Navigator.pop(context);
                            },
                            child: new Container(
                              padding: new EdgeInsets.symmetric(
                                  vertical: 6.0, horizontal: 13.0),
                              decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: AppColors.delete_save_border,
                                      width: 1.0),
                                  borderRadius: new BorderRadius.circular(16.0),
                                  color: AppColors.delete_save_background),
                              child: new Row(
                                children: <Widget>[
                                  new Icon(
                                    Icons.save,
                                    color: Colors.black45,
                                    size: 17.0,
                                  ),
                                  new SizedBox(
                                    width: 5.0,
                                  ),
                                  new Text(
                                    "Save",
                                    style: new TextStyle(
                                        color: Colors.black, fontSize: 15.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Container(
                      height: 0.6,
                      margin: new EdgeInsets.only(top: 20.0),
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: 40.0, top: 30.0),
                      child: new Text(
                        "Select your roles",
                        style: AppCustomTheme.createProfileSubTitle,
                      ),
                    ),
                    Container(
                      margin: new EdgeInsets.only(
                          left: MARGIN_LEFT_RIGHT,
                          right: MARGIN_LEFT_RIGHT,
                          top: 30.0),
                      child: AutoCompleteTextView(
                        defaultPadding: 0,
                        isLocation: false,
                        hintText: "Search for a role",
                        suggestionsApiFetchDelay: 100,
                        focusGained: () {},
                        onTapCallback: (String text) async {
                          addData(text);
                          closeKeyboard();
                        },
                        focusLost: () {
                          print("focust lost");
                        },
                        onValueChanged: (String text) {
                          print("called $text");
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
                      height: 15.0,
                    ),
                    Expanded(
                      child: Container(
                          child: SampleExpendable(
                        type: 1,
                        voidcallback: voidCallBack,
                      )),
                    ),
                    StreamBuilder<List<String>>(
                        stream: chipsList.stream,
                        builder: (context, snapshot) {
                          print("actorlist ${snapshot.data?.length}");
                          if (actorWidgets.length == 0)
                            return Container();
                          else
                            return Container(
                                decoration: new BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ]),
                                width: MediaQuery.of(context).size.width,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new Wrap(
                                    runSpacing: 5.0,
                                    spacing: 5.0,
                                    children: actorWidgets.toList(),
                                  ),
                                ));
                        })
                  ],
                ),
              ),
            ),
          );
        });
  }

  Iterable<Widget> get actorWidgets sync* {
    for (String data in provider.list) {
      yield Container(
        height: 35.0,
        margin: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: AppColors.dividerColor, width: 1.0),
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Chip(
          backgroundColor: Colors.white,
          label: Text(
            data,
            style: new TextStyle(color: AppColors.topNavColor),
          ),
          deleteIcon: Icon(
            Icons.clear,
            size: 15.0,
            color: AppColors.topNavColor,
          ),
          onDeleted: () {
            provider.list.remove(data);
            removeData(data);
            voidCallBack(provider.list);
          },
        ),
      );
    }
  }

  Future<List<String>> getLocationSuggestionsList(String locationText) async {
    List<String> suggestionList = provider.listAllRolesItem
        .where((f) => f.toLowerCase().startsWith(locationText.toLowerCase()))
        .toList();

    return suggestionList;
  }

  Widget getDivider() {
    return new Container(
      height: 20.0,
      decoration: new BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: AppColors.dividerColor),
          left: BorderSide(width: 1.0, color: Color(0xFFFFDFDFDF)),
          right: BorderSide(width: 1.0, color: Color(0xFFFF7F7F7F)),
          bottom: BorderSide(width: 1.0, color: AppColors.dividerColor),
        ),
        color: Colors.grey.withOpacity(0.1),
      ),
    );
  }

  Widget getRowItem(String title, String image) {
    return Container(
      color: Colors.white,
      child: new Row(
        children: <Widget>[
          getSvgNetworkImage(url: image, size: 16),
          new SizedBox(
            width: 8.0,
          ),
          new Text(
            title,
            style: new TextStyle(
                fontSize: 14.0,
                color: AppColors.kPrimaryBlue,
                fontFamily: AssetStrings.lotoRegularStyle),
          ),
        ],
      ),
    );
  }

  Widget getAttributeItem(String title, String value) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 30.0, top: 20.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            title,
            style: AppCustomTheme.myProfileAttributeHeadingStyle,
          ),
          new SizedBox(
            height: 5.0,
          ),
          new Text(
            value,
            style: new TextStyle(fontSize: 16.0),
            //style: AppCustomTheme.myProfileAttributeStyle,
          ),
        ],
      ),
    );
  }

  Widget getBoxDataItem(List<DataModel> model, int index) {
    return Container(
      child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding:
                    new EdgeInsets.symmetric(vertical: 11.0, horizontal: 17.0),
                child: new Text(
                  model[index].name,
                  style: new TextStyle(
                      color: AppColors.introBodyColor,
                      fontSize: 15,
                      fontFamily: AssetStrings.lotoRegularStyle),
                )),
            index != model.length - 1
                ? new Container(
                    height: 1.5,
                    color: Colors.grey.withOpacity(0.2),
                  )
                : Container(),
          ]),
    );
  }

  Widget getBoxItem(AddRoleModelBottom model) {
    return Container(
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getRowItem(model.title, model.iconurl),
            new SizedBox(
              height: 8.0,
            ),
          ]
            ..add(new Container(
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                    border: new Border.all(
                        color: Colors.grey.withOpacity(0.2), width: 1.5)),
                child: new ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: new EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context, int index) {
                    return getBoxDataItem(model.list, index); //for extra space
                  },
                  itemCount: model.list.length,
                )))
            ..add(new SizedBox(
              height: 20,
            )),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            new ListView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                new SizedBox(
                  height: 20.0,
                ),
                Container(
                  margin: new EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "Roles",
                    style: new TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontFamily: AssetStrings.lotoRegularStyle),
                  ),
                ),
                (isCurrentUser(widget.userId))
                    ? new SizedBox(
                        height: 20.0,
                      )
                    : Container(),
                (isCurrentUser(widget.userId))
                    ? attributeHeading("Add a role", Icons.add_box, 2)
                    : Container(),
                Container(
                  margin: new EdgeInsets.only(top: 30.0),
                  child: new ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    padding: new EdgeInsets.all(0.0),
                    itemBuilder: (BuildContext context, int index) {
                      return getBoxItem(listRoles[index]); //for extra space
                    },
                    itemCount: listRoles.length,
                  ),
                ),
                new SizedBox(
                  height: 30.0,
                ),
                getDivider(),
                new SizedBox(
                  height: 50.0,
                ),
                Container(
                  margin: new EdgeInsets.only(left: 40.0),
                  child: new Text(
                    "Attributes",
                    style: new TextStyle(
                        color: Colors.black87,
                        fontSize: 20.0,
                        fontFamily: AssetStrings.lotoRegularStyle),
                  ),
                ),
                (isCurrentUser(widget.userId))
                    ? new SizedBox(
                        height: 20.0,
                      )
                    : Container(),
                (isCurrentUser(widget.userId))
                    ? attributeHeading("Edit attributes", Icons.edit, 1)
                    : Container(),
                Offstage(
                  offstage: _gender.isEmpty,
                  child: getAttributeItem("Gender", _gender),
                ),
                Offstage(
                  offstage: _ethnicity.isEmpty,
                  child: getAttributeItem("Ethnicity", _ethnicity),
                ),
                Offstage(
                    offstage: _height == 0,
                    child:
                        getAttributeItem("Height", _height.toString() + " cm")),
                Offstage(
                  offstage: _wight == 0,
                  child: getAttributeItem("Weight", _wight.toString() + " kg"),
                ),
                new SizedBox(
                  height: 50.0,
                ),
                getDivider(),
                new SizedBox(
                  height: 30.0,
                ),
                VideoMyProfileView(
                    callback, _showreel, widget.userId, widget.callBack),
                new SizedBox(
                  height: 15.0,
                ),
              ],
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
          ],
        ),
      ),
    );
  }

  VoidCallback callback() {
//    quickAccessVideoLinkBottomSheet();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
