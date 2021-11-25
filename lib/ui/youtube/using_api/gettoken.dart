import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_appauth/flutter_appauth.dart';

class MyAppToen extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppToen> {
  final authorizationEndpoint =
      Uri.parse("http://example.com/oauth2/authorization");
  final tokenEndpoint = Uri.parse("http://example.com/oauth2/token");

  final identifier =
      "133713896762-tlqi918vc9h7jpes9e6kagpa6ra51774.apps.googleusercontent.com";
  final secret = "xjejQ4c-N5RAwvJonwMocj07";
  final redirectUrl = Uri.parse("http://my-site.com/oauth2-redirect");
  final credentialsFile = new File("");

  @override
  void initState() {
    super.initState();
  }

  getToken() async {
    FlutterAppAuth appAuth = FlutterAppAuth();

    final AuthorizationTokenResponse result =
        await appAuth.authorizeAndExchangeCode(
          AuthorizationTokenRequest(
              '133713896762-tlqi918vc9h7jpes9e6kagpa6ra51774.apps.googleusercontent.com',
              'filmshape.com',
          serviceConfiguration: AuthorizationServiceConfiguration(
              'https://accounts.google.com/o/oauth2/auth',
              'https://oauth2.googleapis.com/token'),
          scopes: ['profile', 'email']),
    );

    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 100,
                child: InkWell(
                    child: new Text("OauthToekn"),
                    onTap: () {
                      getToken();
                      /*   FlutterAppAuthWrapper.startAuth(
                      AuthConfig(
                        clientId: "17231235286-5tb3lnnl5h684i2nja8spnsd32ks807a.apps.googleusercontent.com",
                        clientSecret: "ZA9I66f_H8U3FcdHOwG4dSpn",
                        redirectUrl: "http://localhost/singup",
                        endpoint: AuthEndpoint(
                            auth: "https://accounts.google.com/o/oauth2/auth",
                            token: "https://oauth2.googleapis.com/token"),
                        scopes: [
                          "profile",
                          'email'
                        ],
                      ),
                    );*/

/*
                    createImplicitBrowserFlow(id, _scopes).then((BrowserOAuth2Flow flow) {
                      flow.obtainAccessCredentialsViaUserConsent()
                          .then((AccessCredentials credentials) {
                            print(credentials.accessToken);

                        flow.close();
                      });
                    });
                  },*/
                    }),
              ),
              /* StreamBuilder(
                initialData: "init state",
                stream: FlutterAppAuthWrapper.eventStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.data);
                    var error = snapshot.error as PlatformException;
                    return Text("[Error] ${error.message}: ${error.details}");
                  } else {
                    return Text(snapshot.data.toString());
                  }
                },
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
