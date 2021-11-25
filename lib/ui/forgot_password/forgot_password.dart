import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:Filmshape/Model/ForgotPassword/ForgotPasswordResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/notifier_provide_model/forgot_provider.dart';
import 'package:provider/provider.dart';

class ForgotScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotScreen> {
  TextEditingController _EmailController = new TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKeys = new GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _EmailField = new FocusNode();
  ForgotProvider provider;



  static String validatorEmail(String value) {
    return emailValidator(email: value);
  }

  void showInSnackBar(String value) {
    _scaffoldKeys.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  hitApi() async {
    provider.setLoading();
    ForgotPasswordRequest loginRequest = new ForgotPasswordRequest(
        email: _EmailController.text);
    var response = await provider.getData(loginRequest, context);

    if (response != null && (response is ForgotPasswordResponse)) {
//      showAlert(
//        context: context,
//        titleText: "SUCCESS",
//        message: response.message,
//        actionCallbacks: {"OK": () {}},
//      );
      Navigator.pop(context, "succeess");//send result back
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


  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    provider = Provider.of<ForgotProvider>(context);
    return Scaffold(
      key: _scaffoldKeys,
      body: Stack(
        children: <Widget>[
          new SingleChildScrollView(
      physics: BouncingScrollPhysics(),
            child: Form(
              key: _fieldKey,
              child: Container(
                height: screensize.height,
                width: screensize.width,
                child: new Column(
                  children: <Widget>[
                    new SizedBox(
                        height: 90
                    ),

                    Container(
                      alignment: Alignment.center,
                      child: appLogo(),
                    ),

                    new SizedBox(
                      height: 50,
                    ),
                    new Text(
                      "Forgotten account",
                      style: AppCustomTheme.headline26,
                    ),
                    Container(
                        margin:
                        new EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
                        child: new Text(
                          "Enter your email address below\nand we will send you an email to\nreset your password.",
                          style: AppCustomTheme.descriptionIntro,
                          textAlign: TextAlign.center,
                        )),
                    new SizedBox(
                      height: 30,
                    ),
                    getTextField(
                        validatorEmail,
                        "Email address",
                        _EmailController,
                        _EmailField,
                        _EmailField,
                        false,
                        TextInputType.emailAddress),
                    new SizedBox(
                      height: BUTTON_TOP_MARGIN,
                    ),
                    getSetupButton(callback, "Reset password", MARGIN_LEFT_RIGHT),
                    new SizedBox(
                      height: 25.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Text(
                          "Back",
                          style: AppCustomTheme.backButtonThemeStyle,
                        )),
                    new SizedBox(
                      height: 20.0,
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
  VoidCallback callback()
  {
    if (_fieldKey.currentState.validate()) {
      hitApi();
    }
  }
}
