import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/ui/statelesswidgets/bottomsheet_top_header.dart';
import 'package:Filmshape/ui/statelesswidgets/youtube_vimeo_button.dart';
import 'package:Filmshape/ui/vimeoauth/vimeo_auth.dart';
import 'package:Filmshape/ui/youtubeauth/youtube_auth.dart';

class MediaBottomViewDemo extends StatefulWidget {
  final ValueChanged<int> callBack;
  final String media;

  MediaBottomViewDemo(this.callBack, this.media);

  @override
  _BottomViewDemoState createState() => _BottomViewDemoState();
}

class _BottomViewDemoState extends State<MediaBottomViewDemo> {
  String _youtubeToken;
  String _vimeoToken;
  FocusNode _InputField = new FocusNode();

  TextEditingController _InputUrlController = new TextEditingController();

  final StreamController<String> _streamControllerYoutubeConnected =
      StreamController<String>();

  final StreamController<String> _streamControllerVimeoConnected =
      StreamController<String>();

//authenticate the youtube user
  Future<void> youtubeAuth() async {
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

//when user update trailer link manullay than need to check
  VoidCallback saveTrailer() {
    if (_InputUrlController.text.length > 0) {
      //check if it's youtube or vimeo link
      if (_InputUrlController.text.contains("youtube") ||
          _InputUrlController.text.contains("vimeo")) {
        Navigator.pop(context, _InputUrlController.text);
      }
      //invalid video link
      else {
        showInSnackBar("Please link a Youtube or Vimeo video only");
      }
    } else {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _InputUrlController.text = widget.media;
    _youtubeToken = MemoryManagement.getYoutubeToken();
    _vimeoToken = MemoryManagement.getVimeoToken();

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
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      child: new Wrap(
        children: <Widget>[
          BottomSheetTopHeaderWidget(saveTrailer),
          Container(
            margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 60.0),
            child: new Text(
              "Quick access for video linking",
              style: AppCustomTheme.createAccountLink,
            ),
          ),
          new SizedBox(
            height: 30.0,
          ),
          Container(
            margin: new EdgeInsets.only(top: 10.0),
            child: videoLinkView(
                (_youtubeToken == null)
                    ? "Connect my Youtube account"
                    : "Browse my Youtube videos",
                AssetStrings.imageYoutube,
                1,
                true),
          ),
          Container(
            margin: new EdgeInsets.only(top: 20.0),
            child: videoLinkView(
                (_vimeoToken == null)
                    ? "Connect my Vimeo account"
                    : "Browse my Vimeo videos",
                AssetStrings.imageVimeo,
                2,
                true),
          ),
          getTextFieldBottomSheet(50, null, "Input a URL", _InputUrlController,
              _InputField, _InputField, false, TextInputType.text, Icons.link),
          new Container(
            height: 50.0,
            child: new Text("  "),
          )
        ],
      ),
    );
  }

  Widget videoLinkView(
      String text, String image, int from, bool fromBottomSheet) {
    return InkWell(
        onTap: () {
          //youtube button clicked and from bottom sheet
          if (from == 1 && fromBottomSheet) //form youtube
          {
            if (_youtubeToken == null) {
              youtubeAuth();
            } else {
              if (widget.callBack != null) {
                Navigator.pop(context);
                widget.callBack(1); //for youtube
              }
            }
          }
          //load vimeo video from bottom sheet
          else if (from == 2 && fromBottomSheet) //form vimeo
          {
            if (_vimeoToken == null) {
              vimeoAuth();
            } else {
              if (widget.callBack != null) {
                Navigator.pop(context);
                widget.callBack(2); //for vimeo video

              }
            }
          } else if (_youtubeToken == null && from == 1) {
            youtubeAuth();
          } else if (_vimeoToken == null && from == 2) {
            vimeoAuth();
          }
        },
        child: YoutubeVimeoVideoWidget(
            _youtubeToken, _vimeoToken, text, image, from));
  }
}
