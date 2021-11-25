import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/ui/login/login.dart';
import 'package:Filmshape/ui/signup/signup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SplashIntroScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FadeIn();
}

class FadeIn extends State<SplashIntroScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Stack(
            children: <Widget>[
              BackgroundImage(),
             LogoWithNameWidget(),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: new Column(
                  children: <Widget>[
                    Container(
                        child: getSetupButton(
                            callback, "Log in", MARGIN_LEFT_RIGHT)),
                    new SizedBox(
                      height: 20.0,
                    ),
                    Container(
                        child: getSetupDecoratorButton(
                            callbackSignin, "Sign up", MARGIN_LEFT_RIGHT)),
                    new SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void callback() {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new LoginScreen();
      }),
    );
  }

  void callbackSignin() {
    Navigator.push(
      context,
      new CupertinoPageRoute(builder: (BuildContext context) {
        return new SignupScreen();
      }),
    );
  }
}

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      height: double.infinity,
      child: new SvgPicture.asset(
        AssetStrings.background_bg,
        fit: BoxFit.cover,

        width: double.infinity,
        height: double.infinity,

      ),
    );
  }
}

class LogoWithNameWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SvgPicture.asset(
              AssetStrings.filmLogo,
              height: 50,
              width: 50,

            ),
            SizedBox(
              width: 10,
            ),
            new Text(
              "Filmshape",
              style: new TextStyle(
                  color: AppColors.splashBlack,
                  fontFamily: AssetStrings.muliBoldStyle,
                  fontWeight: FontWeight.w800,
                  fontSize: 35.0),
            )
          ]),
    );
  }
}
