import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/create_profile_request.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/ui/profile/custom_search.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final VoidCallback callback;
  final ValueChanged<CreateProfileResponse> callBackValued;
  final MyProfileResponse responseProfile;

  EditProfile(this.callback, this.callBackValued, this.responseProfile);

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<EditProfile> {
  String gender;
  String ethinics;


  var dateTime;
  DateTime selectedDate = DateTime.now();

  TextEditingController _BioController = new TextEditingController();
  TextEditingController _HeightController = new TextEditingController();
  TextEditingController _WeightController = new TextEditingController();
  TextEditingController _FullNameController = new TextEditingController();
  TextEditingController _LocationController = new TextEditingController();
  TextEditingController _DateofBirthController = new TextEditingController();

  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _HeightField = new FocusNode();
  FocusNode _WeightField = new FocusNode();
  FocusNode _BioField = new FocusNode();
  FocusNode _SearchField = new FocusNode();
  FocusNode _LocationField = new FocusNode();
  FocusNode _NameField = new FocusNode();

  final StreamController<bool> _streamControllerShowLoader =
  StreamController<bool>();

  final StreamController<bool> _streamControllerSaveButton =
  StreamController<bool>();


  int year;
  CreateProfileProvider provider;

  Color color = Colors.grey.withOpacity(0.7);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  File _image; //to store profile image
  String _profileThumbImage;

  @override
  void initState() {
    year = selectedDate.year;
    dateTime = new DateTime(selectedDate.year - 18);
    // TODO: implement initState
    super.initState();
    //if profile data is not loaded
    if (widget.responseProfile == null) {
      Future.delayed(const Duration(milliseconds: 300), () {
        hitGetMyProfileApi();

      });
    }
    //data pre loaded show it
    else {
      setProfileData(widget.responseProfile);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      hitGenderApi();
      hitEthicsApi();
    });

  }


  @override
  void dispose() {
    _streamControllerShowLoader.close(); //close the stream on disponsse
    _streamControllerSaveButton.close(); //save button controller
    super.dispose();
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


  Widget getDob(BuildContext context) {
    return Container(
      margin: new EdgeInsets.only(
          left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      width: 200,
      child: new TextFormField(
        validator: null,
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



  hitGetMyProfileApi() async {
    provider.setLoading();
    var id = MemoryManagement.getuserId();
    var response = await provider.getProfileData(id, context);

    if (response is MyProfileResponse) {
      setProfileData(response);
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
  }

  //set user profile data
  void setProfileData(MyProfileResponse profileResponse) {
    _FullNameController.text = profileResponse?.fullName;
    _LocationController.text = profileResponse?.location;
    _HeightController.text = profileResponse?.height?.toString();
    _WeightController.text = profileResponse?.weight?.toString();
    _BioController.text = profileResponse?.bio ?? "";

    if(profileResponse.gender!=null)
    gender = profileResponse?.gender?.name ?? "";
    if(profileResponse.ethnicity!=null)
    ethinics = profileResponse?.ethnicity?.name ?? "";

    _profileThumbImage = profileResponse?.thumbnailUrl ?? "";

    _DateofBirthController.text = profileResponse?.date_of_birth ?? "";
    setState(() {});
    setTextChangeListener();
  }

  void setTextChangeListener() {
    _FullNameController.addListener(_printLatestValue);
    _LocationController.addListener(_printLatestValue);
    _HeightController.addListener(_printLatestValue);
    _WeightController.addListener(_printLatestValue);
    _BioController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print("Second text field:");
    _streamControllerSaveButton.add(true);
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  hitGenderApi() async {
    var response = await provider.getGender(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  hitEthicsApi() async {
    var response = await provider.getEthicity(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  hitApi() async {
    if (_image != null)
      await uploadPhoto(); //update profile pic

    var id = MemoryManagement.getuserId();
    provider.setLoading();
    //create request body
    CreateProfileRequest createProfileRequest1 = new CreateProfileRequest();

    if (provider.genderResponse != null &&
        provider.genderResponse.data.length > 0) {
      for (int i = 0; i < provider.genderResponse.data.length; i++) {
        var data = provider.genderResponse.data[i];

        if (data.name == gender) {
          createProfileRequest1.gender =
              RolesCreateProfile(type: "Gender", id: data.id);
          break;
        }
      }
    }

    if (provider.ethicityResponse != null &&
        provider.ethicityResponse.data.length > 0) {
      for (int i = 0; i < provider.ethicityResponse.data.length; i++) {
        var data = provider.ethicityResponse.data[i];

        if (data.name == ethinics) {
          createProfileRequest1.ethnicity =
              RolesCreateProfile(type: "Ethnicity", id: data.id);
          break;
        }
      }
    }

    if (_DateofBirthController.text != null &&
        _DateofBirthController.text.length > 0) {
      createProfileRequest1.date_of_birth = _DateofBirthController.text;
    }

    createProfileRequest1.bio = _BioController.text;


    if (_HeightController.text.length > 0) {
      createProfileRequest1.height =
          int.tryParse(_HeightController.text.toString()) ?? 0;
    }

    if (_WeightController.text.length > 0) {
      createProfileRequest1.weight =
          int.tryParse(_WeightController.text.toString()) ?? 0;
    }
    createProfileRequest1.full_name = _FullNameController.text;

    createProfileRequest1.location = _LocationController.text;

     print("request data ${json.encode(createProfileRequest1.toJson())}");

    var response = await provider.saveData(createProfileRequest1, context, id);

    if (response != null && (response is CreateProfileResponse)) {
      //if not null update data in previous screen
      if (widget.callback != null) {
        widget.callback();
      }
      if (widget.callBackValued != null) {
        print("called");
        widget.callBackValued(response);
      }
      showInSnackBar("Profile Updated Successfully.");
    } else {
      APIError apiError = response;
      print(apiError.error);
      /* showAlert(
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
          provider.setRoleList(provider.listId);
          print(provider.list);
          print(provider.listId);
          break;
        }
      }
      setState(() {});
    }
  }

  String validatorLocation(String value) {
    if (value.isEmpty) {
      return 'Please enter your location';
    }
  }

  String validatorName(String value) {
    if (value.isEmpty) {
      return 'Please enter your name';
    }
  }

  _buildMaterialSearchPage(BuildContext context) {
    return new MaterialPageRoute<String>(
        settings: new RouteSettings(
          name: 'material_search',
        ),
        builder: (BuildContext context) {
          return new Material(
            child: new MaterialSearch<String>(
              placeholder: 'Search',
              results: provider.listAllRolesItem
                  .map((String v) => new MaterialSearchResult(
                        value: v,
                        text: v,
                      ))
                  .toList(),
              filter: (dynamic value, String criteria) {
                return value.toLowerCase().trim().contains(
                    new RegExp(r'' + criteria.toLowerCase().trim() + ''));
              },
              onSelect: (dynamic value) => Navigator.of(context).pop(value),
              onSubmit: (String value) => Navigator.of(context).pop(value),
            ),
          );
        });
  }

  Future<void> uploadPhoto() async {
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

  String validatorWeight(String value) {
    if (value.isEmpty) {
      return 'Please enter weight';
    }
  }

//  Widget getTextField(
//    bool fullWidth,
//    Function validators,
//    String labelText,
//    TextEditingController controller,
//    FocusNode focusNodeCurrent,
//    FocusNode focusNodeNext,
//    bool obsectextType,
//    String hint,
//    TextInputType textInputType,
//  ) {
//    return Container(
//      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
//      width: (fullWidth) ? MediaQuery.of(context).size.width : 150.0,
//      child: new TextFormField(
//        validator: validators,
//        controller: controller,
//        obscureText: obsectextType,
//        focusNode: focusNodeCurrent,
//        keyboardType: TextInputType.number,
//        textInputAction: TextInputAction.next,
//        style: AppCustomTheme.ediTextStyle,
//        onFieldSubmitted: (value) {
//          focusNodeCurrent.unfocus();
//
//          if (focusNodeCurrent == _WeightField) {
//          } else {
//            FocusScope.of(context).autofocus(focusNodeNext);
//          }
//        },
//        onChanged: (String value) {},
//        decoration: new InputDecoration(
//          border: new OutlineInputBorder(),
//          contentPadding:
//              new EdgeInsets.symmetric(vertical: TextFormField_Veritical_Margin, horizontal: TextFormField_Horizontal_Margin),
//          labelText: labelText,
//          suffixText: hint,
//          prefixStyle: TextStyle(color: Colors.blue),
//          labelStyle: AppCustomTheme.labelEdiTextRegular,
//          focusedBorder: OutlineInputBorder(
//            borderSide:
//                BorderSide(color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
//          ),
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(
//                color: AppColors.creatreProfileBordercolor,
//                width: INPUT_BOX_BORDER_WIDTH),
//          ),
//        ),
//      ),
//    );
//  }

//  Widget getPrefixTextField(
//    Function validators,
//    String labelText,
//    TextEditingController controller,
//    FocusNode focusNodeCurrent,
//    FocusNode focusNodeNext,
//    bool obsectextType,
//    String hint,
//    TextInputType textInputType,
//  ) {
//    return Container(
//      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
//      child: new TextFormField(
//        validator: validators,
//        controller: controller,
//        obscureText: obsectextType,
//        focusNode: focusNodeCurrent,
//        keyboardType: TextInputType.number,
//        textInputAction: TextInputAction.next,
//        style: AppCustomTheme.ediTextStyle,
//        onFieldSubmitted: (value) {
//          focusNodeCurrent.unfocus();
//
//          if (focusNodeCurrent == _WeightField) {
//          } else {
//            FocusScope.of(context).autofocus(focusNodeNext);
//          }
//        },
//        onChanged: (String value) {},
//        decoration: new InputDecoration(
//          border: new OutlineInputBorder(),
//          contentPadding:
//              new EdgeInsets.symmetric(vertical: TextFormField_Veritical_Margin, horizontal: TextFormField_Horizontal_Margin),
//          labelText: labelText,
//          suffixText: hint,
//          prefix: Padding(
//            padding: const EdgeInsets.only(right: 10.0),
//            child: new SvgPicture.asset(
//              AssetStrings.account_person,
//              width: 20.0,
//              height: 20.0,
//            ),
//          ),
//          prefixStyle: TextStyle(color: Colors.blue),
//          labelStyle: AppCustomTheme.labelEdiTextRegular,
//          focusedBorder: OutlineInputBorder(
//            borderSide:
//                BorderSide(color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
//          ),
//          enabledBorder: OutlineInputBorder(
//            borderSide: BorderSide(
//                color: AppColors.creatreProfileBordercolor,
//                width: INPUT_BOX_BORDER_WIDTH),
//          ),
//        ),
//      ),
//    );
//  }

  Widget getDropdownItem(String title, List<String> list, int type, String hint,
      ValueChanged<String> valueChanged) {

    return InkWell(
      onTap: () {
        if (type == 1) {
          if (provider.genderList.length == 0) {
            provider.setLoading();
            hitGenderApi();
          }
        } else if (type == 2) {
          if (provider.ethicityList.length == 0) {
            provider.setLoading();
            hitEthicsApi();
          }
        }
      },
        child: DropDownButtonWidget(
          title: title,
          list: list,
          hint: hint,
          callBack: valueChanged,)
    );
  }

  ValueChanged<String> genderCallBack(String value) {
    gender = value;
  }

  ValueChanged<String> enthincsCallBack(String value) {
    ethinics = value;
  }




  get appBar =>

      PreferredSize(
        preferredSize: Size.fromHeight(71.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            Container(
              padding: new EdgeInsets.only(left: 20.0, right: 20.0),
              height: 70.0,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(
                      Icons.keyboard_backspace,
                      size: 24.0,

                    ),
                  ),
                  new SizedBox(
                    width: 8.0,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "Back",
                      style: new TextStyle(
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 16.0),
                    ),
                  ),
                  Expanded(child: Container()),
                  InkWell(
                    onTap: () {
                      hitApi();
                    },
                      child: new StreamBuilder<bool>(
                          stream: _streamControllerSaveButton.stream,
                          initialData: false,
                          builder: (BuildContext context,
                              AsyncSnapshot<bool> snapshot) {
                            bool status = snapshot.data;
                            return status
                                ? saveButton(Colors.white)
                                : saveButton(AppColors.delete_save_background);
                          })
                  ),
                  new SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
            ),
            new Container(
              height: 1.0,
              color: Colors.grey.withOpacity(0.4),
            ),
          ],
        ),
      );


  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);

    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            key: _scaffoldKey,
            appBar: appBar,
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
                            "Edit profile",
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
                            _image, callback, _profileThumbImage),
                        new SizedBox(
                          height: 15.0,
                        ),
                        getTextField(
                            validatorName,
                            "Full Name",
                            _FullNameController,
                            _NameField,
                            _LocationField,
                            false,
                            TextInputType.text,
                            prefixIcon: FontAwesomeIcons.solidUserCircle
                        ),
                        sizeBox,
                        getLocation(_LocationController, context,
                            _streamControllerShowLoader,iconData: Icons.location_on),
                        sizeBox,

                        getDob(context),

                        sizeBox,

                        getTextField(
                            validatorBio,
                            "Bio",
                            _BioController,
                            _BioField,
                            _HeightField,
                            false,
                            TextInputType.text,
                            prefixIcon: Icons.message,
                            maxlines: 6
                        ),
                  sizeBox,
                        getDropdownItem(
                            gender, provider.genderList, 1, "Gender",
                            genderCallBack),
                        sizeBox,
                        getDropdownItem(
                            ethinics, provider.ethicityList, 2, "Ethnicity",
                            enthincsCallBack),
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
                          height: 30.0,
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

  //when user image is clicked
  VoidCallback callback() {
    _crupitinoActionSheet();
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
