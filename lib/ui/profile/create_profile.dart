import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/create_profile_request.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/ethicity/ethicity_response.dart';
import 'package:Filmshape/Model/gender/gender_response.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/ui/common_video_view/items/expendable_view.dart';
import 'package:Filmshape/ui/connect_account/connect_account.dart';
import 'package:Filmshape/ui/profile/custom_search.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';


class CreateProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<CreateProfile> {

  String gender;

  String ethinics;

  List<String> _searchDataList;
  TextEditingController _BioController = new TextEditingController();
  TextEditingController _HeightController = new TextEditingController();
  TextEditingController _WeightController = new TextEditingController();
  TextEditingController _SearchController = new TextEditingController();
  TextEditingController _DateofBirthController = new TextEditingController();

  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _HeightField = new FocusNode();
  FocusNode _WeightField = new FocusNode();
  FocusNode _BioField = new FocusNode();
  FocusNode _SearchField = new FocusNode();
  FocusNode _DateofbirthField = new FocusNode();


  BehaviorSubject<String> _streamSearch = BehaviorSubject();

  var dateTime;
  int year;
  CreateProfileProvider provider;

  DateTime selectedDate = DateTime.now();

  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image; //to store profile image
  String profile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    year = selectedDate.year;
    dateTime = new DateTime(selectedDate.year - 18);
    //show tutorial on home screen
    MemoryManagement.setToolTipState(state:TUTORIALSTATE.HOME.index);

    Future.delayed(const Duration(milliseconds: 500), () {
      _searchDataList = new List();
      hitGenderApi();
      hitEthicsApi();
      hitRolesApi();
    });


    MemoryManagement.init();

  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }


  hitGenderApi() async {
    var response = await provider.getGender(context);

    if (response != null && (response is GenderResponse)) {
      print("suvccess");
    } else {
      print("error");
    }
  }

  hitRolesApi() async {
    provider.setLoading();
    var response = await provider.getRoles(context);

    if (response != null && (response is GetRolesResponseMain)) {
      print(" rolesuvccess");
      _searchDataList.addAll(provider.listAllRolesItem);
    } else {
      print(" role error");
    }
  }


  hitEthicsApi() async {
    var response = await provider.getEthicity(context);

    if (response != null && (response is EthicityResponse)) {
      print("suvccess");
    } else {
      print("error");
    }
  }


  hitApi() async {
    provider.setLoading();
    if (_image != null) {
      uploadPhoto(); //upload profile pic
    }
    //create request body
    CreateProfileRequest createProfileRequest1 = new CreateProfileRequest();


    if (provider.genderResponse != null) {
      for (var data in provider.genderResponse.data) {
        if (data.name == gender) {
          createProfileRequest1.gender = RolesCreateProfile(type: "Gender",
              id: data.id);
          break;
        }
      }
    }

    if (provider.ethicityResponse != null) {
      for (var data in provider.ethicityResponse.data) {
        if (data.name == ethinics) {
          createProfileRequest1.ethnicity =
              RolesCreateProfile(type: "Ethnicity",
                  id: data.id);
          break;
        }
      }
    }


    var roleList = provider.listId;
    List<RolesCreateProfile> rolesSelected = List();
    if (roleList != null) {
      for (var roleId in roleList) {
        var role = RolesCreateProfile(type: "Role", id: roleId);
        rolesSelected.add(role);
      }
    }

    if (rolesSelected.length > 0) {
      createProfileRequest1.roles = rolesSelected;
    }

    if (_BioController.text.length > 0) {
      createProfileRequest1.bio = _BioController.text;
    }

    createProfileRequest1.date_of_birth =
        _DateofBirthController.text.toString();

    if (_HeightController.text.length > 0) {
      createProfileRequest1.height = int.tryParse(
          _HeightController.text.toString()) ?? 0;
    }
    else
      {
        createProfileRequest1.height=0;
      }

    if (_WeightController.text.length > 0) {
      createProfileRequest1.weight = int.tryParse(
          _WeightController.text.toString()) ?? 0;
    }
    else
      {
        createProfileRequest1.weight=0;
      }

    var id = MemoryManagement.getuserId();

    var response = await provider.saveData(createProfileRequest1, context, id);

    if (response is CreateProfileResponse) {
      //update user thumbnail user cache data
      updateUserInfo(2, response?.user?.thumbnailUrl ?? "");
      //update user roles in user cache data
      updateUserInfo(4, response?.user?.roles??List<Roles>());

      MemoryManagement.setVerifyMail(verify: response?.user?.isVerified);

      Navigator.push(
        context,
        new CupertinoPageRoute(
            builder: (BuildContext context) {
              return new ConnectAccount();
            }),
      );
    } else {
      APIError apiError = response;
      print(apiError.error);
      /*  showAlert(
        context: context,
        titleText: "ERROR",
        message: apiError.error,
        actionCallbacks: {"OK": () {}},
      );*/

      showInSnackBar(apiError.error);
    }
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
          //   List<int> result = LinkedHashSet<int>.from( provider.listId).toList();
          provider.setRoleList(provider.listId);
          print(provider.list);
          print(provider.listId);
          break;
        }
      }
      setState(() {

      });
    }
  }


  _showMaterialSearch(BuildContext context) {
    Navigator.of(context)
        .push(_buildMaterialSearchPage(context))
        .then((dynamic value) {
      print(value);
      addData(value.toString());
    });
  }


  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
          //isInitialRoute: false,
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              placeholder: 'Search',
              results: provider.listAllRolesItem.map((String v) =>
              new MaterialSearchResult(
                value: v,
                text: v,
              )).toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim()
                    .contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => Navigator.of(context).pop(value),
              onSubmit: (String value) => Navigator.of(context).pop(value),
            ),
          );
        }
    );
  }


  uploadPhoto() async {
    provider.setLoading();

    var response = await provider.uploadPicture(_image);
    if (response is APIError) {
      showInSnackBar("Image upload failed ${response.error}");
    }
    else {
      showInSnackBar("Profile image uploaded successfully.");
    }

    provider.hideLoader();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  String validatorBio(String value) {
    if (value.isEmpty) {
      return 'Please enter your bio';
    }
  }

  String validatorHeight(String value) {
    if (value.isEmpty) {
      return 'Please enter height';
    }
  }

  String validatorDob(String value) {
    if (value.isEmpty) {
      return 'Please enter dob';
    }
  }

  String validatorWeight(String value) {
    if (value.isEmpty) {
      return 'Please enter weight';
    }
  }


  Widget getDropdownItem(String title, List<String> list, int type) {
    return InkWell(
      onTap: () {
         if (type == 1) {
          if (provider.genderList.length == 0) {
            provider.setLoading();
            hitGenderApi();
          }
        }
        else if (type == 2) {
          if (provider.ethicityList.length == 0) {
            provider.setLoading();
            hitEthicsApi();
          }
        }
      },
      child: Container(
        margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: AppColors.creatreProfileBordercolor, width:INPUT_BOX_BORDER_WIDTH),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration.collapsed(hintText: ""),
              isEmpty: title == '',
              child: Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: title,
                    isDense: true,
                    isExpanded: true,
                    hint: new Text(type == 1 ? "Gender" : "Ethnicity"),
                    onChanged: (String newValue) {
                      print(newValue);
                      title = newValue;
                      state.didChange(newValue);
                      if (type == 1) {
                        gender = newValue;
                      }
                      else {
                        ethinics = newValue;
                      }
                      setState(() {

                      });
                    },
                    items: list.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppCustomTheme.ediTextStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //when user image is clicked
  VoidCallback callbackProfilePic() {
    _crupitinoActionSheet();
  }

  VoidCallback backCallBack() {
    Navigator.pop(context);
  }


  Widget getDob(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(
          left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      width: 200,
      child: new TextFormField(
        validator: validatorDob,
        controller: _DateofBirthController,
        keyboardType: TextInputType.number,
        enabled: true,
        showCursor: false,
        readOnly: true,
        textCapitalization: TextCapitalization.sentences,
        textInputAction: TextInputAction.next,
        style: AppCustomTheme.ediTextStyle,

        onTap: () {
          _selectDate(context);
        },


        decoration: new InputDecoration(
          border: new OutlineInputBorder(),
          contentPadding: new EdgeInsets.symmetric(
              vertical: TextFormField_Veritical_Margin,
              horizontal: TextFormField_Horizontal_Margin),
          labelText: "Date of birth*",

          prefixStyle: TextStyle(color: Colors.blue),

          /*  prefix: Padding(
            padding: const EdgeInsets.only(
                left: 4.0, right: 8.0, top: 0.0),
            child: new Icon(
              Icons.date_range,
              color: Colors.black,
              size: 18.0,
            ),
          ),*/

          prefixIcon: new Icon(
            Icons.date_range,
            color: Colors.black,
            size: 18.0,
          ),


          labelStyle: AppCustomTheme.labelEdiTextRegular,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: AppColors.creatreProfileBordercolor,
                width: INPUT_BOX_BORDER_WIDTH),
          ),),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {

    provider = Provider.of<CreateProfileProvider>(context);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            /*   appBar: appBarBackButton(onTap: backCallBack),*/
            body: Container(

              color: Colors.white,
              child: Form(
                key: _fieldKey,
                child: new SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
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
                            "Create profile",
                            style: AppCustomTheme.createProfileSubTitle,
                          ),
                        ),
                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, top: 4.0),
                          child: new Text(
                            "Fill out your personal details",
                            style: AppCustomTheme.body15Regular,
                          ),
                        ),
                        new SizedBox(
                          height: 30.0,
                        ),
                        getUserProfileImageView(
                            _image, callbackProfilePic, null),
                        new SizedBox(
                          height: 15.0,
                        ),
                        getDob(context),
                        new SizedBox(
                          height: 15.0,
                        ),

                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
                          child: new TextFormField(
                            validator: validatorBio,
                            controller: _BioController,
                            textInputAction: TextInputAction.next,
                            maxLines: 6,
                            focusNode: _BioField,
                            style: AppCustomTheme.ediTextStyle,
                            onFieldSubmitted: (value) {
                              _BioField.unfocus();
                              FocusScope.of(context).autofocus(_HeightField);
                            },
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(),
                              labelText: "Bio",
                              labelStyle: AppCustomTheme.labelEdiTextRegular,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: AppColors.creatreProfileBordercolor,
                                    width: INPUT_BOX_BORDER_WIDTH),
                              ),
                              focusColor: Colors.brown,
                              prefix: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8.0, top: 0.0),
                                child: new Icon(
                                  Icons.message,
                                  color: Colors.black,
                                  size: 18.0,
                                ),
                              ),
                            ),

                          ),
                        ),

                        sizeBox,
                        sizeBox,

                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, top: 4.0),
                          child: new Text(
                            "Actor specific details (Optional)",
                            style: new TextStyle(
                                fontFamily: AssetStrings.lotoRegularStyle,
                                color: AppColors.kPlaceHolberFontcolor
                            ),
                          ),
                        ),
                        sizeBox,
                        getDropdownItem(gender, provider.genderList, 1),
                        sizeBox,
                        getDropdownItem(ethinics, provider.ethicityList, 2),
                        sizeBox,
                        getHeightWeightTextField(
                            false,
                            validatorHeight,
                            "Height",
                            _HeightController,
                            _HeightField,
                            _WeightField,
                            false,
                            "cm",
                            TextInputType.text),
                        sizeBox,
                        getHeightWeightTextField(
                            false,
                            validatorWeight,
                            "Weight",
                            _WeightController,
                            _WeightField,
                            _SearchField,
                            false,
                            "kg",
                            TextInputType.text),
                        new SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                          child: new Text(
                            "Select your roles",
                            style: AppCustomTheme.createProfileSubTitle,
                          ),
                        ),
                        new SizedBox(
                          height: 25.0,
                        ),
//                        getTextField(
//                            true,
//                            validatorWeight,
//                            "Search for a role",
//                            _SearchController,
//                            _SearchField,
//                            _SearchField,
//                            false,
//                            "",
//                            TextInputType.text),

                        Container(
                          margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
                          child: AutoCompleteTextView(
                            defaultPadding: 0,
                            isLocation: false,
                            hintText: "Search for a role",
                            suggestionsApiFetchDelay: 100,
                            focusGained: () {},
                            onTapCallback: (String text) async {
                               addData(text);
                              print(text);
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

//                        InkWell(
//                          onTap: () {
//                            showAllRolesBottomSheet();
//                          },
//
//                          child: new Container(
//                            margin: new EdgeInsets.only(
//                                left: 40.0, right: 40.0),
//                            decoration: new BoxDecoration(
//                              borderRadius: new BorderRadius.circular(5.0),
//                              border:
//                              new Border.all(
//                                  color: AppColors.creatreProfileBordercolor,
//                                  width: INPUT_BOX_BORDER_WIDTH),
//                            ),
//                            padding: new EdgeInsets.symmetric(
//                                horizontal: 7.0, vertical: 16.0),
//                            child: getTextField(
//                                validatorWeight,
//                                "Search for a role",
//                                _SearchController,
//                                _SearchField,
//                                _SearchField,
//                                false,
//                                "",
//                                TextInputType.text),
//                            new Row(
//                              children: <Widget>[
//                                new SizedBox(
//                                  width: 5.0,
//                                ),
//                                new Icon(
//                                  Icons.search,
//                                  color: Colors.black,
//                                  size: 20.0,
//                                ),
//                                new SizedBox(
//                                  width: 5.0,
//                                ),
//                                new Text(
//                                  "Search for a role",
//                                  style: AppCustomTheme.body15Regular,
//                                ),
//                              ],
//                            ),
                        //    ),
                        //),
                        new SizedBox(
                          height: 15.0,
                        ),
                        new Container(
                          color: Colors.grey.withOpacity(0.5),
                          height: 1.0,
                        ),


                        SampleExpendable(),



                        new SizedBox(
                          height: 25.0,
                        ),


                        getContinueProfileSetupButton(callback,  "Continue"),
                        new SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
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


  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1940, 8),
        lastDate: DateTime(year - 18));
    if (picked != null && picked != dateTime)
      setState(() {
        dateTime = picked;
        _DateofBirthController.text = DateOfBirthformat.format(dateTime);
      });
  }


  VoidCallback callback()
  {
    if (_DateofBirthController.text != null &&
        _DateofBirthController.text.length > 0) {
      hitApi();
    }
    else {
      showInSnackBar("Please enter dob");
    }
  }

  Future<List<String>> getLocationSuggestionsList(String locationText) async {

    List<String> suggestionList=provider.listAllRolesItem.where((f) =>
        f.toLowerCase().startsWith(
            locationText.toLowerCase())).toList();

      return suggestionList;

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

  _crupitinoActionSheet() {
    return containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
          actions: <Widget>[
            //to show delete image option
            _image != null
                ? CupertinoActionSheetAction(
              child: const Text(
                DELETE_PHOTO,
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                _image = null;
                Navigator.pop(context);
                setState(() {});
              },
            )
                : Container(),

            CupertinoActionSheetAction(
              child: const Text(CAMERA),
              onPressed: () {
                _getCameraImage();
                Navigator.pop(context);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text(GALLARY),
              onPressed: () {
                _getGalleryImage();
                Navigator.pop(context);
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            child: const Text(CANCEL),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(
                context,
              );
            },
          )),
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  Future _getCameraImage() async {
    var imageFileSelect = await ImagePicker.pickImage(
        source: ImageSource.camera, maxWidth: maxWidth, maxHeight: maxHeight);

    var imageFile = await ImageCropper.cropImage(
        sourcePath: imageFileSelect.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    _image = null;

    _image = imageFile;

    setState(() {});
  }


  void showAllRolesBottomSheet() {
     showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0),
              topRight: Radius.circular(7.0)),
        ),

        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery
                .of(context)
                .viewInsets,
            child: Container(
              color: Colors.white,
              child: new Wrap(

                children: <Widget>[

                  new Container(
                    height: 45.0,
                    margin: new EdgeInsets.only(
                        left: 20.0, right: 20.0, top: 30.0),
                    child: new Container(
                      padding: new EdgeInsets.only(left: 10.0),
                      decoration: new BoxDecoration(
                          color: AppColors.chipColors.withOpacity(0.3),
                          borderRadius: new BorderRadius.circular(25.0)),
                      child: new TextField(

                        controller: _SearchController,
                        onSubmitted: (value) {

                        },
                        onChanged: (value) {

                        _streamSearch.add(value);


                        },
                        decoration: new InputDecoration(
                          fillColor: Colors.green,
                          border: InputBorder.none,
                          hintText: "Search by name...",
                          hintStyle: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                      ),
                    ),
                  ),
                  StreamBuilder<String>(
                      stream: _streamSearch.stream,
                      initialData: "",
                      builder: (context, snapshot) {
                        if (snapshot.data.length>0) {
                           print("snapshot data ${snapshot.data}");
                           _searchDataList.clear();
                           _searchDataList.addAll(provider.listAllRolesItem);
                          _searchDataList=_searchDataList.where((f) =>
                              f.toLowerCase().startsWith(
                                  snapshot.data.toLowerCase())).toList();

                          print("searchlisttsize ${_searchDataList.length}");
                        }
                        else
                          {
                            print("else ${snapshot.data}");
                            _searchDataList.clear();
                            _searchDataList.addAll(provider.listAllRolesItem);
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
                              itemCount: _searchDataList.length
                          ),
                        );
                      }),



                ],
              ),
            ),
          );
        }
    );
  }

  Future _getGalleryImage() async {
    var imageFileSelect = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: maxWidth, maxHeight: maxHeight);
    var imageFile = await ImageCropper.cropImage(
        sourcePath: imageFileSelect.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    _image = imageFile;
    setState(() {});
  }

  showMessage(String msg) async {
    await Future.delayed(Duration(milliseconds: 100));

    showAlert(
      context: context,
      titleText: "ALERT",
      message: msg,
      actionCallbacks: {"OK": () {}},
    );
  }


}
