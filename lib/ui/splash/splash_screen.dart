import 'dart:async';

import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/ui/bottom_nav/bottom_nav.dart';
import 'package:Filmshape/ui/splash/splash_intro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FadeIn();
}

class FadeIn extends State<SplashScreen> {
  @override
  void initState() {

    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    moveToScreen();

  }

  @override
  Widget build(BuildContext context) {
//    var width = MediaQuery
//        .of(context)
//        .size
//        .width;
//    var height = MediaQuery
//        .of(context)
//        .size
//        .height;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new SvgPicture.asset(
                    AssetStrings.filmLogo,
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  new Text(
                    "Filmshape",
                    style: AppCustomTheme.headline26,
                  )
                ]),
          ),
        ),
      ),
    );
  }

  void moveToScreen()async {

    //ebale firebase store local caceh
//    await Firestore.instance.settings(
//           persistenceEnabled: true,
//    );
    await MemoryManagement.init();
    //show tutorial on home screen
   // MemoryManagement.setToolTipState(state:TUTORIALSTATE.HOME.index);

    Timer _timer = new Timer(const Duration(seconds: 2), () {
      var token = MemoryManagement.getAccessToken();
      Navigator.pushAndRemoveUntil(
        context,
        new CupertinoPageRoute(builder: (BuildContext context) {
          return (token == null)
              ? new SplashIntroScreen()
              : new BottomNavigation();
        }),
        (route) => false,
      );
    });
  }
}
