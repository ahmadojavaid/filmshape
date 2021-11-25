// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeViemoFullVideoPlayer extends StatefulWidget {
  final Widget playerWidget;

  YoutubeViemoFullVideoPlayer(this.playerWidget);

  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<YoutubeViemoFullVideoPlayer>
{

   LoginProvider provider;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init called");
  }

  @override
  Widget build(BuildContext context) {
    //  print("embeded url webview ${widget.embededUrl}");
    provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: Container(
        child: widget.playerWidget,
      ),
    );
  }





}
