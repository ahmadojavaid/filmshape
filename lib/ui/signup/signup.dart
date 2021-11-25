import 'dart:async';
import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/SignUp/SignUpRequest.dart';
import 'package:Filmshape/Model/SignUp/SignupResponse.dart';
import 'package:Filmshape/Model/filmshape_firebase_user.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/firebase_provider.dart';
import 'package:Filmshape/notifier_provide_model/signup_provider.dart';
import 'package:Filmshape/ui/screens/getting_started_screen.dart';
import 'package:Filmshape/ui/settings/Webview.dart';
import 'package:Filmshape/ui/signup/recaptchav2.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignupScreen> {
  RecaptchaV2Controller recaptchaV2Controller = RecaptchaV2Controller();

  TextEditingController _EmailController = new TextEditingController();
  TextEditingController _FullNameController = new TextEditingController();
  TextEditingController _LocationController = new TextEditingController();
  TextEditingController _PasswordController = new TextEditingController();

  final StreamController<bool> _streamControllerShowLoader =
      StreamController<bool>();

  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _EmailField = new FocusNode();
  FocusNode _PasswordField = new FocusNode();
  FocusNode _LocationField = new FocusNode();
  FocusNode _NameField = new FocusNode();
  SingupProvider provider;
  FirebaseProvider firebaseProvider;

  String validatorPassword(String value) {
    if (value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 8) {
      return 'Password length must be 8';
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

  static String validatorEmail(String value) {
    return emailValidator(email: value);
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _streamControllerShowLoader.close(); //close the stream on disponsse
    super.dispose();
  }

  hitApi() async {
    provider.setLoading();
    SignUpRequest signupRequest = new SignUpRequest(
        fullName: _FullNameController.text,
        password: _PasswordController.text,
        email: _EmailController.text,
        location: _LocationController.text);
    var response = await provider.signUp(signupRequest, context);

    if (response is SignupResponse) {
      //firebase signup for later use in chat
      var firebaseId = await firebaseProvider.signUp(
          _EmailController.text, FIREBASE_USER_PASSWORD);
      //save user info to fire store user collection
      await firebaseProvider.createFirebaseUser(getUser(response, firebaseId));

      provider.hideLoader();
      MemoryManagement.setAccessToken(accessToken: response.token);
      MemoryManagement.setuserId(id: response.user.id.toString());
      MemoryManagement.setShowReelId(id: response.user.showreel.id.toString());
      //save user info for later use
      var userData = jsonEncode(response.toJson());
      MemoryManagement.setUserData(data: userData);

      MemoryManagement.setScreen(screen: 1);

      Route route =
          CupertinoPageRoute(builder: (context) => GettingStartedScreen());
      Navigator.pushReplacement(context, route);
    } else {
      provider.hideLoader();
      APIError apiError = response;
      print(apiError.error);
      showInSnackBar(apiError.error);
    }
  }

  FilmShapeFirebaseUser getUser(
      SignupResponse signupResponse, String firebaseId) {
    return new FilmShapeFirebaseUser(
        fullName: signupResponse.user.fullName,
        email: signupResponse.user.username,
        location: signupResponse.user.location,
        updated: DateTime.now().toIso8601String(),
        created: DateTime.now().toIso8601String(),
        filmShapeId: signupResponse.user.id,
        firebaseId: firebaseId,
        isOnline: true
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<SingupProvider>(context);
    firebaseProvider = Provider.of<FirebaseProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKeys,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: <Widget>[
                Form(
                  key: _fieldKey,
                  child: new SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: new Column(
                      children: <Widget>[
                        new SizedBox(height: 90),
                        Container(
                            alignment: Alignment.center, child: appLogo()),
                        new SizedBox(
                          height: MARGIN_FROM_LOGO_TOP,
                        ),
                        new Text(
                          "Sign up to Filmshape",
                          style: AppCustomTheme.headline26,
                        ),
                        new SizedBox(
                          height: MARGIN_FOR_INPUT_FIELD,
                        ),
                        getTextField(
                            validatorName,
                            "Full Name",
                            _FullNameController,
                            _NameField,
                            _EmailField,
                            false,
                            TextInputType.text),
                        new SizedBox(
                          height: 15.0,
                        ),
                        getTextField(
                          validatorEmail,
                          "Email address",
                          _EmailController,
                          _EmailField,
                          _LocationField,
                          false,
                          TextInputType.emailAddress,
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        getLocation(_LocationController, context,
                            _streamControllerShowLoader),
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
                          TextInputType.text,
                        ),
                        new SizedBox(
                          height: 15.0,
                        ),
                        Container(
                          margin: new EdgeInsets.only(
                              left: MARGIN_LEFT_RIGHT,
                              right: MARGIN_LEFT_RIGHT),
                          child: new Text(
                            "Users must be at least 18 years of age to use Filmshape and by signing up you agree to our",
                            style: AppCustomTheme.labelSingup,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              new CupertinoPageRoute(
                                  builder: (BuildContext context) {
                                return new Webview(
                                  title: "Terms and Policies",
                                  url:
                                      "http://35.226.88.58/terms-and-conditions/",
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: new EdgeInsets.only(
                                left: MARGIN_LEFT_RIGHT,
                                right: MARGIN_LEFT_RIGHT),
                            child: new Text(
                              "Terms and policies.",
                              style: new TextStyle(
                                  color: AppColors.kPrimaryBlue,
                                  fontFamily: AssetStrings.lotoSemiboldStyle),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        new SizedBox(
                          height: 60,
                        ),
                      ],
                    ),
                  ),
                ),
                getSetupButton(callback, "Sign up now", MARGIN_LEFT_RIGHT),
                new SizedBox(
                  height: 25.0,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Text(
                      "Log in",
                      style: AppCustomTheme.labelTextPrimary19,
                    )),
                new SizedBox(
                  height: 20.0,
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
          Padding(
            padding: EdgeInsets.only(left: 0, right: 0, top: 0),
            child: reCapcha(),
          )
        ],
      ),
    );
  }

  Widget reCapcha() {
    return RecaptchaV2(
      apiKey: "6LdN-ukUAAAAAGCsjlY2OpKFz1KRYl2DhSTzApmV",
      // for enabling the reCaptcha
      apiSecret: "6LdN-ukUAAAAADEUzR7IICMzPuimHdTCQ-YBAw9o",
      // for verifying the responded token
      controller: recaptchaV2Controller,
      onVerifiedError: (err) {
        print(err);
      },
      onVerifiedSuccessfully: (success) {
        if (success) {
          recaptchaV2Controller.hide(); //show recapcha
          hitApi();
        } else {
          recaptchaV2Controller.hide(); //show recapcha
          /*showAlert(
              context: context,
              titleText: "ERROR",
              message: "Verification failed",
              actionCallbacks: {"OK": () {}},
            );*/

          showInSnackBar("Verification Failed");
        }
      },
    );
  }

  VoidCallback callback() {
    if (_fieldKey.currentState.validate()) {
      //recaptchaV2Controller.show(); //show recapcha
      hitApi();
    }
  }
}
