import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomViewDemo extends StatefulWidget {
  final Showreel showreel;
  final ValueChanged<int> callBack;

  BottomViewDemo(this.showreel, this.callBack);

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<BottomViewDemo> {
  String _youtubeToken;
  String _vimeoToken;
  FocusNode _InputField = new FocusNode();
  FocusNode _BioField = new FocusNode();
  FocusNode _TitleField = new FocusNode();

  TextEditingController _InputUrlController = new TextEditingController();
  TextEditingController _ShowReelController = new TextEditingController();
  TextEditingController _BioController = new TextEditingController();

  final StreamController<String> _streamControllerYoutubeConnected =
      StreamController<String>();

  final StreamController<String> _streamControllerVimeoConnected =
      StreamController<String>();

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

  //authenticate the videmo user
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
      _streamControllerVimeoConnected.add(_vimeoToken);
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

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget _bottomSheetTop() {
    return new Container(
      margin: new EdgeInsets.only(
          left: BOTTOMSHEET_MARGIN_LEFT_RIGHT,
          right: BOTTOMSHEET_MARGIN_LEFT_RIGHT,
          top: 10.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () {
                //reset fields to old link
                _InputUrlController.text = widget.showreel.mediaOldLink;
                widget.showreel.media = widget.showreel.mediaOldLink;
                ;

                Navigator.pop(context);
              },
              child: bottomSheetCloseButton()),
          InkWell(
              onTap: () {
                widget.showreel.media = _InputUrlController.text;
                widget.showreel.title = _ShowReelController.text;
                widget.showreel.description = _BioController.text;
                print("showreel ${widget.showreel.toJson()}");
                Navigator.pop(context, _InputUrlController.text);
              },
              child: bottomSheetSaveButton()),
        ],
      ),
    );
  }

  Widget _getSizeBox(double value) {
    return new SizedBox(
      height: value,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();
    _InputUrlController.text = widget.showreel.media;
    _ShowReelController.text = widget.showreel.title;
    _BioController.text = widget.showreel.description;

    print("bottom view called");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamControllerYoutubeConnected.close();
    _streamControllerVimeoConnected.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height - 50,
        child: Column(
          children: <Widget>[
            _bottomSheetTop(),
            divider(),
            Expanded(
              child: new ListView(
                children: <Widget>[
                  _getSizeBox(30),
                  Container(
                    margin: new EdgeInsets.only(left: 40.0, top: 40),
                    child: new Text(
                      "Quick access for video linking",
                      style: AppCustomTheme.createProfileSubTitle,
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(left: 40.0, top: 4.0),
                    child: new Text(
                      "Connect account for quick video linking",
                      style: AppCustomTheme.body15Regular,
                    ),
                  ),

                  new StreamBuilder<String>(
                      stream: _streamControllerYoutubeConnected.stream,
                      initialData: _youtubeToken,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        var token = snapshot.data;
                        return Container(
                          margin: new EdgeInsets.only(top: 30.0),
                          child: videoLinkView(
                              (token == null)
                                  ? "Connect my Youtube account"
                                  : "Browse my Youtube videos",
                              AssetStrings.imageYoutube,
                              1,
                              true),
                        );
                      }),

                  new StreamBuilder<String>(
                      stream: _streamControllerVimeoConnected.stream,
                      initialData: _vimeoToken,
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        var token = snapshot.data;
                        return Container(
                          margin: new EdgeInsets.only(top: 20.0),
                          child: videoLinkView(
                              (token == null)
                                  ? "Connect my Vimeo account"
                                  : "Browse my Vimeo videos",
                              AssetStrings.imageVimeo,
                              2,
                              true),
                        );
                      }),

                  getTextFieldBottomSheet(
                      30,
                      null,
                      "Input a URL",
                      _InputUrlController,
                      _InputField,
                      _InputField,
                      false,
                      TextInputType.text,
                      Icons.link),

                  getTextFieldBottomSheet(
                      40,
                      null,
                      "Showreel title",
                      _ShowReelController,
                      _TitleField,
                      _BioField,
                      false,
                      TextInputType.text,
                      Icons.mode_edit),
//            Container(
//              margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 40),
//              child: new TextFormField(
//                validator: validatorTitle,
//                controller: _ShowReelController,
//                textInputAction: TextInputAction.next,
//                focusNode: _TitleField,
//                style: AppCustomTheme.ediTextStyle,
//                onFieldSubmitted: (value) {
//                  _TitleField.unfocus();
//                  FocusScope.of(context).autofocus(_BioField);
//                },
//                decoration: new InputDecoration(
//                    border: new OutlineInputBorder(),
//                    labelText: "Showreel title",
//                    contentPadding: new EdgeInsets.symmetric(
//                        vertical: 18.0, horizontal: 16.0),
//                    prefix: Padding(
//                      padding: const EdgeInsets.only(
//                          left: 8.0, right: 8.0, top: 0.0),
//                      child: new Icon(
//                        Icons.mode_edit,
//                        color: Colors.black,
//                        size: 16.0,
//                      ),
//                    ),
//                    labelStyle: AppCustomTheme.labelEdiTextRegular,
//                    focusedBorder: OutlineInputBorder(
//                      borderSide: BorderSide(
//                          color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
//                    ),
//                    enabledBorder: OutlineInputBorder(
//                      borderSide: BorderSide(
//                          color: AppColors.kbordercolor,
//                          width: INPUT_BOX_BORDER_WIDTH),
//                    ),
//                    focusColor: Colors.brown),
//              ),
//            ),
                  getTextFieldBottomSheet(
                      20,
                      validatorBio,
                      "Description",
                      _BioController,
                      _BioField,
                      _BioField,
                      false,
                      TextInputType.text,
                      Icons.message,
                      maxLines: 6),
//            Container(
//              margin: new EdgeInsets.only(
//                  left: 40.0, right: 40.0, top: 20, bottom: 40),
//              child: new TextFormField(
//                validator: validatorBio,
//                controller: _BioController,
//                focusNode: _BioField,
//                textInputAction: TextInputAction.next,
//                maxLines: 6,
//                style: AppCustomTheme.ediTextStyle,
//                onFieldSubmitted: (value) {
//                  _BioField.unfocus();
//                },
//                decoration: new InputDecoration(
//                  border: new OutlineInputBorder(),
//                  labelText: "Description",
//                  labelStyle: AppCustomTheme.labelEdiTextRegular,
//                  focusedBorder: OutlineInputBorder(
//                    borderSide: BorderSide(
//                        color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
//                  ),
//                  enabledBorder: OutlineInputBorder(
//                    borderSide: BorderSide(
//                        color: AppColors.kbordercolor,
//                        width: INPUT_BOX_BORDER_WIDTH),
//                  ),
//                  focusColor: Colors.brown,
//                  prefix: Padding(
//                    padding:
//                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 0.0),
//                    child: new Icon(
//                      Icons.message,
//                      color: Colors.black,
//                      size: 16.0,
//                    ),
//                  ),
//                ),
//              ),
//            ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget videoLinkView(
      String text, String image, int from, bool fromBottomSheet) {
    return InkWell(
      onTap: () {
        //if connectivity
//        if (fromBottomSheet) {
//          Navigator.pop(context);
//        }
        //youtube button clicked and from bottom sheet
        if (from == 1 && fromBottomSheet) //form youtube
        {
          if (_youtubeToken == null) {
            youtubeAuth();
          }
          //else if (_channel != null)
          // {
          // showAllVideosBottomSheet(1); //list already loaded
          // }
          else {
            if (widget.callBack != null) {
              Navigator.pop(context);
              widget.callBack(1); //for youtube
            }
            //getChannelIdApi(_youtubeToken);
          }
        }
        //load vimeo video from bottom sheet
        else if (from == 2 && fromBottomSheet) //form vimeo
        {
          if (_vimeoToken == null) {
            vimeoAuth();
          }
          //else if (_vimeoVideosListResponse != null) {
          // showAllVideosBottomSheet(2); //list already loaded show vimeo
          // }
          else {
            //getVimeoVideosList();
            if (widget.callBack != null) {
              Navigator.pop(context);
              widget.callBack(2); //for vimeo

            }
          }
        } else if (_youtubeToken == null && from == 1) {
          youtubeAuth();
        } else if (_vimeoToken == null && from == 2) {
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
}
