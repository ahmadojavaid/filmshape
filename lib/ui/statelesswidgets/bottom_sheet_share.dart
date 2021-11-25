import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareBottomSheet extends StatelessWidget {
  ShareBottomSheet();

  // ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        child: new Wrap(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 17.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.keyboard_arrow_down, size: 29.0),
                        new SizedBox(
                          width: 4.0,
                        ),
                        new Text(
                          "Close",
                          style: new TextStyle(
                              color: Colors.black, fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: new SizedBox(
                      width: 55.0,
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              height: 1,
              color: AppColors.dividerColor,
              margin: new EdgeInsets.only(top: 17.0),
            ),
            Container(
              margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
              child: new Text(
                "Share project",
                style: new TextStyle(
                    color: Colors.black,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    fontSize: 20.0),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
              child: new Text(
                "Invite people outside the app to create an account and view or join your project.",
                style: new TextStyle(
                    color: AppColors.introBodyColor,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    fontSize: 16.0),
              ),
            ),
            Container(
                margin: new EdgeInsets.only(top: 30.0),
                child: InkWell(
                  onTap: () async {
                    print("clicked");
//                    await screenshotController.capture().then((image) async {
//                      //facebook appId is mandatory for andorid or else share won't work
//                      Platform.isAndroid
//                          ? SocialShare.shareFacebookStory(image.path,
//                          "#ffffff", "#000000", "https://google.com",
//                          appId: "xxxxxxxxxxxxx")
//                          .then((data) {
//                        print(data);
//                      })
//                          : SocialShare.shareFacebookStory(image.path,
//                          "#ffffff", "#000000", "https://google.com")
//                          .then((data) {
//                        print(data);
//                      });
//                    });
                  },
                  child: attributeHeading(
                      "Share to Facebook",
                      AssetStrings.shareFacebook,
                      AppColors.faceBook,
                      AppColors.faceBook,
                      1),
                )),
            Container(
              margin: new EdgeInsets.only(top: 15.0),
              child: InkWell(
                onTap: () {
                  //without hashtags
                  SocialShare.shareTwitter("Filmshape project",
                          hashtags: ["Filmshape", "Actor", "PhototGrapher"],
                          url: "https://google.com/#/hello",
                          trailingText: "\nFilmshape")
                      .then((data) {
                    print(data);
                  });
                },
                child: attributeHeading(
                    "Share to Twitter",
                    AssetStrings.shareTwitter,
                    AppColors.twitter,
                    AppColors.twitter,
                    2),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 15.0),
              child: InkWell(
                onTap: (){
                 _launchLinkedInShare();
                },
                child: attributeHeading(
                    "Share to Linkedin",
                    AssetStrings.shareLinked,
                    AppColors.linkedIn,
                    AppColors.linkedIn,
                    3),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 15.0),
              child: InkWell(
                onTap: () {
                  _launchEmail();
                },
                child: attributeHeading(
                    "Share via email",
                    AssetStrings.shareEmail,
                    Colors.black,
                    AppColors.creatreProfileBordercolor,
                    4),
              ),
            ),
            Container(
              margin: new EdgeInsets.only(top: 15.0),
              child: attributeHeading(
                  "Get shareable link",
                  AssetStrings.shareLink,
                  Colors.black,
                  AppColors.creatreProfileBordercolor,
                  5),
            ),
            new Container(
              height: 50.0,
              child: new Text("  "),
            )
          ],
        ),
      ),
    );
  }

  _launchEmail() async {
    // ios specification
    final String subject = "Subject:";
    final String stringText = "Your message goes here:";
    String uri =
        'mailto:administrator@gmail.com?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(stringText)}';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("No email client found");
    }
  }

  _launchLinkedInShare() async {
    // ios specification

    String uri =
        'https://www.linkedin.com/sharing/share-offsite/?url=http://35.226.88.58';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("No email client found");
    }
  }
}
