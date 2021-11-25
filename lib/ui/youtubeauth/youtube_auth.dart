// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/youtubeauth/YoutubeAuthRequest.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeAuthWebView extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<YoutubeAuthWebView> {
  LoginProvider provider;

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  //got the client id from google console
/*  String CLIENT_ID =
      "133713896762-tlqi918vc9h7jpes9e6kagpa6ra51774.apps.googleusercontent.com";
  */
  String CLIENT_ID =
      "275810026068-b6mlh0j979q5tic19ph950b1ilqbccbs.apps.googleusercontent.com";
  String REDIRECT_URI =
  /*  "filmshape.com";*/ //user will be redirected to this link String REDIRECT_URI =
      "http://localhost"; //user will be redirected to this link
  String GRANT_TYPE = "authorization_code"; //to get final token
  String OAUTH_URL = "https://accounts.google.com/o/oauth2/auth";
  String OAUTH_SCOPE = "https://www.googleapis.com/auth/youtube";
  WebViewController _webViewController; //to reload the url later
  var baseUrl; //base url load by webview
  bool oneTime = true; //to avoid frequent call

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<LoginProvider>(context);
    baseUrl =
        "$OAUTH_URL?redirect_uri=$REDIRECT_URI&response_type=code&client_id=$CLIENT_ID&scope=$OAUTH_SCOPE";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Authentication'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            WebView(
              initialUrl: baseUrl,
              javascriptMode: JavascriptMode.unrestricted,
              userAgent:
                  "AppleWebKit/535.19 (KHTML, like Gecko) Chrome/56.0.0.0 Mobile Safari/535.19",
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                _webViewController = webViewController;
              },
              // TODO(iskakaushik): Remove this when collection literals makes it to stable.
              navigationDelegate: (NavigationRequest request) {
                //check if url contains code we need to fetch access token later
                if (request.url.contains("?code=")) {
                  Uri uri = Uri.dataFromString(request.url);
                  Map<String, String> data = uri.queryParameters;
                  print("code ${data["code"]}"); //get code from quer parameter
                  getToken(data["code"]); //get the token
                  return NavigationDecision.prevent;
                }
                //if got some error
                else if (request.url.contains("error=access_denied")) {
                  showInSnackBar("Something went wrong");
                }
               // print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                provider.setLoading();
                //print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                provider.hideLoader();
               // print('Page finish loading: $url');
                //if final url contains the code
                if (url.contains("?code=")) {
                  Uri uri = Uri.dataFromString(url);
                  Map<String, String> data = uri.queryParameters;
                  print("code ${data["code"]}"); //get query code
                  getToken(data["code"]); //get token
                } else if (url.contains("error=access_denied")) {
                  showInSnackBar("Something went wrong");
                }
                //this statement to check or redirect to allow permission screen
                //somehow it's not redirecting by itself so need to load baseurl
                //and set state call to ask user for final authorization
                else if (url.contains("&flowName=GeneralOAuthFlow") &&
                    url.contains(
                        "https://accounts.google.com/signin/oauth/delegation?authuser=0&part")) {
                 // print("grant access");
                  //to avoid frequent reload or url
                  var status = MemoryManagement.getAccessGrant()??false;
                  print("grant access $status)");
                  if (oneTime && (!status)) {
                    oneTime = false;
                    //setState(() {});
                    // _webViewController.loadUrl(baseUrl);
                    MemoryManagement.setAccessGrant();
                   // grantAccess();
                  }
                }
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

  Future<void> grantAccess() async
  {
    var response = await Navigator.push(
      context,
      new CupertinoPageRoute(
          builder: (BuildContext context) {
            return new YoutubeAuthWebView();
          }),
    );

    Navigator.pop(context, response);
  }

  //function to get access token from
  Future<void> getToken(String code) async {
    provider.setLoading();

    var request = YoutubeAuthRequest(
        code: code, //got by authorization the user in webview
        grantType: GRANT_TYPE,
        redirectUri: REDIRECT_URI, //where user finally redirected after success
        clientId: CLIENT_ID);
    provider.hideLoader();
    var response = await provider.getYoutubeAuthToken(request, context);
    //got access token successfully
    if (response is YoutubeAuthTokenResponse) {
      //print("response ${response.toJson()}");
      Navigator.pop(
          context, response); //send token back to calling end
    } else {
      APIError apiError = response;
      showInSnackBar("error ${apiError.toJson()}");
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(new SnackBar(content: new Text(value)));
  }
}
