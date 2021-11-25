import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile_second_provider.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsConnectAccount extends StatefulWidget {
  @override
  _SettingsConnectAccountState createState() => _SettingsConnectAccountState();
}

class _SettingsConnectAccountState extends State<SettingsConnectAccount> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  CreateProfileSecondProvider provider;

  String _youtubeToken;
  String _vimeoToken;

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

  //authenticate the vimeo user
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

  Widget videoLinkView(String text, String image, int from) {
    return InkWell(
      onTap: () {
        //youtube button clicked
        if (from == 1 && _youtubeToken == null) //from youtube
        {
          youtubeAuth();
        }
        //load vimeo video
        else if (from == 2 && _vimeoToken == null) //form vimeo
        {
          vimeoAuth();
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: (from == 1 && _youtubeToken != null)
                  ? Colors.red.withOpacity(0.6)
                  : (from == 2 && _vimeoToken != null)
                      ? Colors.blue.withOpacity(0.6)
                      : Colors.grey.withOpacity(0.6),
              width: INPUT_BOX_BORDER_WIDTH),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 16.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Image.asset(
              image,
              width: 20.0,
              height: 20.0,
              color: (from == 1 && _youtubeToken != null)
                  ? Colors.red.withOpacity(0.6)
                  : (from == 2 && _vimeoToken != null)
                      ? Colors.blue.withOpacity(0.6)
                      : Colors.black.withOpacity(0.6),
            ),
            new SizedBox(
              width: 12.0,
            ),
            new Text(
              text,
              style: AppCustomTheme.createAccountLink,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

    super.initState();
  }

  Widget getListTileItem(String title, String image) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      child: ListTile(
        leading: new Image.asset(image),
        title: Align(
          child: Text(title),
          alignment: Alignment(-1.2, 0),
        ),
        trailing: Icon(
          Icons.arrow_right,
          color: Colors.black,
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  String validatorBio(String value) {
    if (value.isEmpty) {
      return 'Please enter your bio';
    }
  }

  String validatorTitle(String value) {
    if (value.isEmpty) {
      return 'Please enter your title';
    }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileSecondProvider>(context);
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: appBarBackButton(onTap: () {
              Navigator.pop(context);
            }),
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            body: Form(
              key: _fieldKey,
              child: new SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                        child: new Text(
                          "Connect my account",
                          style: AppCustomTheme.createProfileSubTitle,
                        ),
                      ),
                      Container(
                        margin: new EdgeInsets.only(
                            left: MARGIN_LEFT_RIGHT, top: 4.0),
                        child: new Text(
                          "Connect account for quick video linking",
                          style: AppCustomTheme.body15Regular,
                        ),
                      ),
                      new SizedBox(
                        height: 30.0,
                      ),
                      videoLinkView(
                        (_youtubeToken == null)
                            ? "Connect my Youtube account"
                            : "Youtube connected",
                        AssetStrings.imageYoutube,
                        1,
                      ),
                      new SizedBox(
                        height: 20.0,
                      ),
                      videoLinkView(
                          (_vimeoToken == null)
                              ? "Connect my Vimeo account"
                              : "Vimeo connected",
                          AssetStrings.imageVimeo,
                          2),
                    ],
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
}
