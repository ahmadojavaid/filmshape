import 'dart:io';

import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:Filmshape/ui/profile/custom_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';

class YoutubeVimeoInappBrowser extends StatefulWidget {
  final String videoUrl;

  YoutubeVimeoInappBrowser(this.videoUrl, {Key key}) : super(key: key);

  @override
  YoutubeVimeoInappBrowserState createState() =>
      new YoutubeVimeoInappBrowserState();
}

class YoutubeVimeoInappBrowserState extends State<YoutubeVimeoInappBrowser>
    with AutomaticKeepAliveClientMixin<YoutubeVimeoInappBrowser>, WidgetsBindingObserver {
  InAppWebViewController _controller;

  String iframeUrl = " https://player.vimeo.com/video/410052574";

  LoginProvider provider;
  Notifier _notifier;
  bool _once=true;
  bool _isVideoLoaded=false;
  bool _resumeOnce=false;
  @override
  void initState() {
    super.initState();
    iframeUrl = widget.videoUrl;
    print("playing url $iframeUrl");
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    print("current state ${state.toString()}");
//    if(_controller!=null)
//      {
//        if(state==AppLifecycleState.paused)
//          {
//            _controller.pauseTimers();
//            if(Platform.isAndroid)
//              {
//                print("video paused");
//                _controller.android.pause();
//              }
//          }
//        else
//          {
//            _controller.pauseTimers();
//            if(Platform.isAndroid)
//            {
//              print("video resumed");
//              _controller.android.resume();
//            }
//          }
//      }
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    _notifier = NotifierProvider.of(context); // to update home screen header
    String player = """
<!DOCTYPE html>
<html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Flutter InAppWebView</title>
    </head>
    <body style="margin: 0; padding: 0">
      <iframe src="$iframeUrl" width="100%" height="${LIST_PLAYER_HEIGHT}px" class="player" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
    </body>
</html>""";
    return Scaffold(
        body: Container(
            child: Stack(children: <Widget>[
              Notifier.of(context).register<String>('pausevideo', (data) {
                print("pausevideo_data $data");
                //to pause if any video is running
                //check if has data and _once flag to avoid frequent call of
                if(Platform.isAndroid) {
                  if (data.hasData && _once) {
                    // _controller?.reload();
                    //check if video is loaded
                    if (_isVideoLoaded) {
                      //pause all timers
                      _controller?.pauseTimers();
                      //if platform is android pause it
                      if (Platform.isAndroid)
                        _controller?.android?.pause();
                    }
                    _resumeOnce = true;
                    _once =
                    false; //to make sure functionality executes once for multiple calls
                  }
                  else if (_resumeOnce) {
                    print("resume videos");
                    //no data or not allowed once performed
                    _controller?.resumeTimers(); //resume the timer
                    //resume video as well
                    if (Platform.isAndroid)
                      _controller?.android?.resume();
                    _resumeOnce = false;
                    _once = true; //and enable for execution for above if block
                  }
                }
                return Container();
              }),
      Container(
        color: Colors.black,
        child: InAppWebView(
          initialOptions:
              InAppWebViewGroupOptions(android: AndroidInAppWebViewOptions()),
          initialData: InAppWebViewInitialData(data: player),
          initialHeaders: {},


          onWebViewCreated: (InAppWebViewController controller) {
            _controller = controller;
          },
          onLoadStart: (InAppWebViewController controller, String url) {
            provider.setLoading();
            _isVideoLoaded=false;
          },
          onLoadStop: (InAppWebViewController controller, String url) {
            provider.hideLoader();
            _isVideoLoaded=true;
          },
        ),
      ),
      Center(
        child: Offstage(
         offstage: !provider.getLoading(),
          child:CircularProgressIndicator(
           backgroundColor: AppColors.kPrimaryBlue,
          ),

        ),
      ),
    ])));
  }

  //load new url
  void reloadNewUrl(String url) {
    _controller.loadUrl(url: url);
  }

  //pause the video
  void pauseVideo() async
  {
    if(Platform.isAndroid)
    await _controller.reload();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
