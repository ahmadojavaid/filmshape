import 'dart:convert';

import 'package:Filmshape/Model/ForgotPassword/ForgotPasswordResponse.dart';
import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/hide_profile_reques_response.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/forgot_provider.dart';
import 'package:Filmshape/ui/forgot_password/change_password.dart';
import 'package:Filmshape/ui/login/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountsANdSecurityScreen extends StatefulWidget {
  @override
  _AccountsANdSecurityScreenState createState() =>
      _AccountsANdSecurityScreenState();
}

class _AccountsANdSecurityScreenState extends State<AccountsANdSecurityScreen> {
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
  TextEditingController _EmailController = new TextEditingController();
  TextEditingController CurrentPasswordController = new TextEditingController();
  TextEditingController NewPasswordController = new TextEditingController();
  TextEditingController COnfirmPasswordController = new TextEditingController();

  FocusNode _EmailField = new FocusNode();
  FocusNode _CurrentPasswordField = new FocusNode();
  FocusNode _NewPasswordField = new FocusNode();
  FocusNode _ConfirmPasswordField = new FocusNode();
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();

  ForgotProvider provider;
  bool _hideProfile = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  void setData() {
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      _EmailController.text = userResponse.user.username ?? "";
    }
    _hideProfile = MemoryManagement.getHideProfile()??false; //get hide profile status
  }

  void _onRememberMeChanged(bool newValue) => setState(() {
        _hideProfile = newValue;
        _hitHideProfileApi(newValue);
      });

  Future<void> hitApi() async {
    provider.setLoading();
    ChangePasswordRequest loginRequest = new ChangePasswordRequest(
        password: COnfirmPasswordController.text,
        oldPassword: CurrentPasswordController.text);
    var response = await provider.changePassword(loginRequest, context);

    if (response is ForgotPasswordResponse) {
      CurrentPasswordController.text = "";
      NewPasswordController.text = "";
      COnfirmPasswordController.text = "";

      showInSnackBar(response.message);

      /// Navigator.pop(context, "succeess");//send result back
    } else {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    }
  }

  String validatorConfirmPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your confirm password';
    } else if (value.length < 8) {
      return 'Please minimum 8 character';
    } else if (NewPasswordController.text != COnfirmPasswordController.text) {
      return 'New Password and Confirm Password not match';
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ForgotProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKeys,
            appBar: appBarBackButton(onTap: () {
              Navigator.pop(context);
            }),
            body: Form(
              key: _fieldKey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Text(
                        "Accounts and security",
                        style: AppCustomTheme.createProfileSubTitle,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Text(
                        "Email address",
                        style: AppCustomTheme.createProfileSubTitleBottomSheet,
                      ),
                    ),
                    new SizedBox(
                      height: 20,
                    ),
                    getTextField(
                        null,
                        "Email address",
                        _EmailController,
                        _EmailField,
                        _CurrentPasswordField,
                        false,
                        TextInputType.emailAddress,
                        enable: false),
                    new SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Text(
                        "Set new password",
                        style: AppCustomTheme.createProfileSubTitleBottomSheet,
                      ),
                    ),
                    new SizedBox(
                      height: 20,
                    ),
                    getTextField(
                        validatorPassword,
                        "Current password",
                        CurrentPasswordController,
                        _CurrentPasswordField,
                        _NewPasswordField,
                        true,
                        TextInputType.emailAddress),
                    new SizedBox(
                      height: 20,
                    ),
                    getTextField(
                        validatorPassword,
                        "New password",
                        NewPasswordController,
                        _NewPasswordField,
                        _ConfirmPasswordField,
                        true,
                        TextInputType.text),
                    new SizedBox(
                      height: 20,
                    ),
                    getTextField(
                        validatorConfirmPassword,
                        "Confirm password",
                        COnfirmPasswordController,
                        _ConfirmPasswordField,
                        _ConfirmPasswordField,
                        true,
                        TextInputType.text),
                    new SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: getSetupButton(callback, "Confirm new password",
                            MARGIN_LEFT_RIGHT)),
                    new SizedBox(
                      height: 40,
                    ),
                    Container(
                      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                      child: new Text(
                        "Profile status",
                        style: AppCustomTheme.createProfileSubTitleBottomSheet,
                      ),
                    ),
                    new SizedBox(
                      height: 20,
                    ),
                    _hideProfileWidget(),
                    new SizedBox(
                      height: 20,
                    ),
                    _deleteAccount(),
                    SizedBox(
                      height: 20,
                    )
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

  Widget _hideProfileWidget() {
    return new Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: Colors.grey.withOpacity(0.6), width: INPUT_BOX_BORDER_WIDTH),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Text(
              "Hide my profile",
              style: AppCustomTheme.createAccountLink,
            ),
            new SizedBox(
              width: 4.0,
            ),
            new Checkbox(value: _hideProfile, onChanged: _onRememberMeChanged)
          ],
        ),
      ),
    );
  }

  Widget _deleteAccount() {
    return InkWell(
      onTap: () {
        _showAlertDialog();
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: Colors.red.withOpacity(0.6),
              width: INPUT_BOX_BORDER_WIDTH),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Delete my account",
                style: AppCustomTheme.createAccountLink,
              ),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback callback() {
    if (_fieldKey.currentState.validate()) {
      hitApi();
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Future<void> _hitdeleteProfileApi() async {
    provider.setLoading();
    var userId = MemoryManagement.getuserId();
    var response = await provider.deleteProfile(userId, context);

    if (response is APIError) {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    } else {
      _moveToLoginScreen();
    }
  }

  Future<void> _hitHideProfileApi(bool status) async {
    provider.setLoading();
    var request = HideProfileRequestResponse(hidden: status);
    var response = await provider.hideProfile(request, context);
    if (response is APIError) {
      APIError apiError = response;
      showInSnackBar(apiError.error);
    } else {
      MemoryManagement.setHideProfile(
          response.hidden ?? false); //save hide profile status for later user
      setState(() {});
    }
  }

  void _moveToLoginScreen() {
    Navigator.of(context).pop();
    MemoryManagement.clearMemory(); //remove all cached data
    Navigator.pushAndRemoveUntil(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new LoginScreen();
      }),
      (route) => false,
    );
  }

  Future<void> _showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Are you sure you want to delete your profile?'),
          actions: <Widget>[
            FlatButton(
              child: Text('NO'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('YES'),
              onPressed: () {
                 _hitdeleteProfileApi();//call the delete profile api
                Navigator.of(context).pop();//pop back the alert dialog
               // _moveToLoginScreen();
              },
            ),
          ],
        );
      },
    );
  }
}
