// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:Filmshape/videoplayer/youtube_vimeo_full_web_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeViemoVideoPlayer extends StatefulWidget {
  final String embededUrl;
  final ValueChanged<String> fullVideCallBack;

  YoutubeViemoVideoPlayer(this.embededUrl, this.fullVideCallBack, {Key key})
      :super(key: key);

  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<YoutubeViemoVideoPlayer>
    with AutomaticKeepAliveClientMixin<YoutubeViemoVideoPlayer> {

  LoginProvider provider;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;
  Notifier _notifier;
  WebView _webView;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webView = WebView(
      initialUrl: widget.embededUrl ?? "",
      javascriptMode: JavascriptMode.unrestricted,
      userAgent:
      "AppleWebKit/535.19 (KHTML, like Gecko) Chrome/56.0.0.0 Mobile Safari/535.19",
      onWebViewCreated: (WebViewController webViewController) {
        _controller.complete(webViewController);
        _webViewController = webViewController;
      },
      // TODO(iskakaushik): Remove this when collection literals makes it to stable.
      // ignore: prefer_collection_literals
//              javascriptChannels: <JavascriptChannel>[
//                _toasterJavascriptChannel(context),
//              ].toSet(),
      navigationDelegate: (NavigationRequest request) {
        print('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        provider.setLoading();
        print('Page started loading: $url');
      },
      onPageFinished: (String url) {
        provider.hideLoader();
        print('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _notifier = NotifierProvider.of(context);// to update home screen header
    provider = Provider.of<LoginProvider>(context);
    reload();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _webView,
          new Center(
            child: getHalfScreenProviderLoader(
              status: provider.getLoading(),
              context: context,
            ),
          ),


            (Platform.isAndroid)?Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                fullViewPlayer();
              },
              child: Container(
                width: 30,
                height: 30,
                color: Colors.grey.withOpacity(0.5),
                child: Icon(
                  Icons.fullscreen,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ):Container()
        ],
      ),
    );
  }

  void fullViewPlayer() {
     if(widget.fullVideCallBack!=null)
    widget.fullVideCallBack(widget.embededUrl);

  }

  void reload() async {
    try {
      print("url ${widget.embededUrl}");
      var currentUrl = await _webViewController.currentUrl();
      print("current url $currentUrl");
      if (widget.embededUrl != currentUrl &&
          ((widget.embededUrl.contains("embed")) ||
              (widget.embededUrl.contains("player.vimeo.com")))) {
        _webViewController.loadUrl(widget.embededUrl);
      }
    } catch (e) {}
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
