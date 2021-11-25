import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginRequest.dart';
import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:Filmshape/ui/bottom_nav/bottom_nav.dart';
import 'package:Filmshape/ui/forgot_password/forgot_password.dart';
import 'package:Filmshape/ui/profile/create_profile.dart';
import 'package:Filmshape/ui/screens/getting_started_screen.dart';
import 'package:Filmshape/ui/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _EmailController = new TextEditingController();
  TextEditingController _PasswordController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _EmailField = new FocusNode();
  FocusNode _PasswordField = new FocusNode();
  String _status;

  LoginProvider provider;
  FirebaseProvider firebaseProvider;

  //for calling native call

  @override
  void initState() {
    MemoryManagement.init();
    super.initState();
  }

  String validatorPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    }
  }

  static String validatorEmail(String value) {
    return emailValidator(email: value);
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  hitApi() async {
    provider.setLoading();
    LoginRequest loginRequest = new LoginRequest(
        username: _EmailController.text, password: _PasswordController.text);
    var response = await provider.login(loginRequest, context);

    if (response is LoginResponse) {
      try {
        //firebase login
        var firebaseId = await firebaseProvider.signIn(
            _EmailController.text, FIREBASE_USER_PASSWORD);
        //update user info to fire store user collection
        await firebaseProvider
            .updateFirebaseUser(getUser(response, firebaseId));
      } catch (ex) {
        print("error ${ex.toString()}");
        //for old filmshape users
        //firebase signup for later use in chat
        var firebaseId = await firebaseProvider.signUp(
            _EmailController.text, FIREBASE_USER_PASSWORD);
        //save user info to fire store user collection
        var user = getUser(response, firebaseId);
        user.created = DateTime.now()
            .toIso8601String(); //if user is not registered with firebase
        await firebaseProvider.createFirebaseUser(user);
      }

      provider.hideLoader();
      MemoryManagement.setAccessToken(accessToken: response.token);
      MemoryManagement.setuserId(id: response.user.id.toString());
      MemoryManagement.setUpgradedAccount(response.user.isFeatured); //to mark as user if featured or not
      MemoryManagement.setShowReelId(id: response.user.showreel.id.toString());
      var userData = jsonEncode(response.toJson());
      MemoryManagement.setUserData(data: userData);
      MemoryManagement.setVerifyMail(verify: response.user.isVerified);

      Navigator.pushAndRemoveUntil(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return new BottomNavigation();
        }),
        (route) => false,
      );
    } else {
      provider.hideLoader();
      APIError apiError = response;
      print(apiError.error);
      /*  showAlert(
        context: context,
        titleText: "ERROR",
        message: "",
        actionCallbacks: {"OK": () {}},
      );*/
      showInSnackBar("Authentication Failed");
    }
  }

  //create user model for firebase
  FilmShapeFirebaseUser getUser(
      LoginResponse loginResponse, String firebaseId) {
    var listRoles=List<String>();
    for(var data in loginResponse.user.roles)
      {
        listRoles.add(data.iconUrl);
      }
    return new FilmShapeFirebaseUser(
        fullName: loginResponse.user?.fullName,
        email: loginResponse.user?.username,
        location: loginResponse.user?.location,
        updated: DateTime.now().toIso8601String(),
        filmShapeId: loginResponse.user?.id,
        firebaseId: firebaseId,
        isOnline: true,
        bio:loginResponse.user?.bio??"",
        thumbnailUrl: loginResponse.user?.thumbnailUrl??"",
        gender: loginResponse.user?.gender?.name??"",
        roles: listRoles

    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeys,
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: <Widget>[
              Form(
                key: _fieldKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: new Column(
                        children: <Widget>[
                          new SizedBox(height: 90),
                          Container(
                            alignment: Alignment.center,
                            child: appLogo(),
                          ),
                          new SizedBox(
                            height: MARGIN_FROM_LOGO_TOP,
                          ),
                          new Text(
                            "Log in to Filmshape",
                            style: AppCustomTheme.headline26,
                          ),
                          (_status != null) ? _emailSuccess() : Container(),
                          new SizedBox(
                            height: MARGIN_FOR_INPUT_FIELD,
                          ),
                          getTextField(
                              validatorEmail,
                              "Email address",
                              _EmailController,
                              _EmailField,
                              _PasswordField,
                              false,
                              TextInputType.emailAddress),
                          new SizedBox(
                            height: 15.0,
                          ),
                          getTextField(
                              validatorPassword,
                              "Password",
                              _PasswordController,
                              _PasswordField,
                              _PasswordField,
                              true,
                              TextInputType.text),
                          new SizedBox(
                            height: 20.0,
                          ),
                          new Container(
                            margin:
                                new EdgeInsets.only(right: MARGIN_LEFT_RIGHT),
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () async {
                                _status = await Navigator.push(
                                  context,
                                  new CupertinoPageRoute(
                                      builder: (BuildContext context) {
                                    return new ForgotScreen();
                                  }),
                                );
                                setState(() {});
                              },
                              child: new Text(
                                "Forgotten account?",
                                style: AppCustomTheme.labelTextBlack17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new SizedBox(
                      height: BUTTON_TOP_MARGIN,
                    ),
                    Container(
                        child: getSetupButton(
                            callback, "Log in", MARGIN_LEFT_RIGHT)),
                    new SizedBox(
                      height: 25.0,
                    ),
                    InkWell(
                        onTap: () {
                          moveToScreen();
                        },
                        child: new Text(
                          "Sign up",
                          style: AppCustomTheme.labelTextPrimary19,
                        )),
                    new SizedBox(
                      height: 30.0,
                    )
                  ],
                ),
              ),
              new Center(
                child: getFullScreenProviderLoader(
                  status: provider.getLoading(),
                  context: context,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void moveToScreen() {
    var screen = MemoryManagement.getScreen();
    print("screen $screen");
    switch (screen) {
      case 1:
        {
          Navigator.push(
            context,
            new CupertinoPageRoute(builder: (BuildContext context) {
              return new GettingStartedScreen();
            }),
          );
        }
        break;
      case 2:
        {
          Navigator.push(
            context,
            new CupertinoPageRoute(builder: (BuildContext context) {
              return new CreateProfile();
            }),
          );
        }
        break;
      default:
        {
          Navigator.push(
            context,
            new CupertinoPageRoute(builder: (BuildContext context) {
              return new SignupScreen();
            }),
          );
        }
    }
  }

  Widget _emailSuccess() {
    return new Column(
      children: <Widget>[
        new SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              AssetStrings.statusOk,
              width: 20,
              height: 20,
            ),
            new SizedBox(
              width: 10,
            ),
            new Text(
              "Reset password email sent!",
              style: AppCustomTheme.createAccountLink,
            ),
          ],
        ),
      ],
    );
  }

  VoidCallback callback() {
    if (_fieldKey.currentState.validate()) {
      hitApi();
    }
  }
}
