// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_request.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VimeoAuthWebView extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<VimeoAuthWebView> {
  LoginProvider provider;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  var _redirectionUrl = "https://www.logicbolts.app";
  var _client_id = "c08a7d2eab616124670cc5d5cb21f56c7fd566bd";
  var _state_code = "123filmshape";

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vimeo Authentication'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            WebView(
              initialUrl:
                  "https://api.vimeo.com/oauth/authorize?response_type=code&client_id=$_client_id&redirect_uri=$_redirectionUrl&state=$_state_code",
              javascriptMode: JavascriptMode.unrestricted,
              userAgent:
                  "AppleWebKit/535.19 (KHTML, like Gecko) Chrome/56.0.0.0 Mobile Safari/535.19",
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              // ignore: prefer_collection_literals
//              javascriptChannels: <JavascriptChannel>[
//                _toasterJavascriptChannel(context),
//              ].toSet(),
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(_redirectionUrl)) {
                  print('blocking navigation to ${request.url}');
                  var finalUrl = request.url;
                  var code =
                      finalUrl.substring((finalUrl.indexOf("code=") + 5));
                  print("final code $code");
                  // return NavigationDecision.prevent;
                  getToken(code.trim());
                }
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
            ),
            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> getToken(String code) async {
    provider.setLoading();
    var request = VimeoAuthRequest(
        code: code,
        grantType: "authorization_code",
        redirectUri: _redirectionUrl);
    provider.hideLoader();
    var response = await provider.getVimeoAuthToken(request, context);
   Navigator.pop(context, response); //response back to calling end
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }


}
