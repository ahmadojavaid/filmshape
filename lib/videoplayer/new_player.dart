// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeViemoFullVideoPlayer2 extends StatefulWidget {
  final String embededUrl;

  YoutubeViemoFullVideoPlayer2(this.embededUrl);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<YoutubeViemoFullVideoPlayer2> {
  LoginProvider provider;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  String urlToLoad;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft,
//    ]);
  //  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  urlToLoad="""
<!DOCTYPE html>
<html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
      <meta http-equiv="X-UA-Compatible" content="ie=edge">
      <title>Flutter InAppWebView</title>
    </head>
    <body>
      <iframe src="${widget.embededUrl}" width="100%" height="${LIST_PLAYER_HEIGHT}px" class="player" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
    </body>
</html>""";
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    SystemChrome.setPreferredOrientations([
       DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);


   }

  @override
  Widget build(BuildContext context) {
    //  print("embeded url webview ${widget.embededUrl}");
    provider = Provider.of<LoginProvider>(context);
    //  var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
//    return Scaffold(
////      body: Stack(
////        children: <Widget>[
////          Container(
////            child: WebView(
////              initialUrl: widget.embededUrl,
////              javascriptMode: JavascriptMode.unrestricted,
////              userAgent:
////              "AppleWebKit/535.19 (KHTML, like Gecko) Chrome/56.0.0.0 Mobile Safari/535.19",
////              onWebViewCreated: (WebViewController webViewController) {
////                _controller.complete(webViewController);
////                _webViewController = webViewController;
////              },
////              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
////              // ignore: prefer_collection_literals
//////              javascriptChannels: <JavascriptChannel>[
//////                _toasterJavascriptChannel(context),
//////              ].toSet(),
////              navigationDelegate: (NavigationRequest request) {
////                print('allowing navigation to $request');
////                return NavigationDecision.navigate;
////              },
////              onPageStarted: (String url) {
////                provider.setLoading();
////                print('Page started loading: $url');
////              },
////              onPageFinished: (String url) {
////                provider.hideLoader();
////                print('Page finished loading: $url');
////              },
////              gestureNavigationEnabled: true,
////            ),
////          ),
////          new Center(
////            child: getHalfScreenProviderLoader(
////              status: provider.getLoading(),
////              context: context,
////            ),
////          ),
////
////        ],
////      ),
////    );

    return SafeArea(
      child: Scaffold(
//          appBar: AppBar(
//            title: const Text('Video Player'),
//            actions: <Widget>[
//              Icon(Icons.fullscreen),
//            ],
//
//          ),
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: new WebviewScaffold(
              userAgent:
              "AppleWebKit/535.19 (KHTML, like Gecko) Chrome/56.0.0.0 Mobile Safari/535.19",
              url: Uri.dataFromString('$urlToLoad', mimeType: 'text/html').toString(),
              withJavascript: true,
              withZoom: true,
              withLocalStorage: true,
              hidden: true,
              mediaPlaybackRequiresUserGesture: true,
              initialChild: Container(
                color: Colors.white,
                child: const Center(
                  child: Text(
                    'Waiting.....',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
