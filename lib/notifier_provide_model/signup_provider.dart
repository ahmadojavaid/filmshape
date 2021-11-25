import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/SignUp/SignUpRequest.dart';
import 'package:Filmshape/Model/SignUp/SignupResponse.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';

class SingupProvider with ChangeNotifier {
  SignupResponse signUpResponse = new SignupResponse();
  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => signUpResponse;


  Future<dynamic> signUp(SignUpRequest request, BuildContext context) async {
    print("request model ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.signUpUrl, requestBody: request.toJson());

    print(APIs.signUpUrl);
    print(request);
    //hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      SignupResponse loginResponse = new SignupResponse.fromJson(response);
      completer.complete(loginResponse);
      signUpResponse = loginResponse;
      notifyListeners();
      return completer.future;
    }
  }

  void hideLoader() {
    print(_isLoading);
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    print(_isLoading);
    _isLoading = true;
    notifyListeners();
  }
}
