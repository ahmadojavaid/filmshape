import 'dart:async';

import 'package:Filmshape/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:Filmshape/Model/ForgotPassword/ForgotPasswordResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/hide_profile_reques_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/ui/forgot_password/change_password.dart';
import 'package:flutter/cupertino.dart';

class ForgotProvider with ChangeNotifier {
  ForgotPasswordResponse loginResponse = new ForgotPasswordResponse();

  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => loginResponse;

  String id;

  Future<dynamic> getData(
      ForgotPasswordRequest request, BuildContext context) async {
    print("request model ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.forgotUrl, requestBody: request.toJson());

    print(APIs.forgotUrl);
    print(request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse loginResponseData =
          new ForgotPasswordResponse.fromJson(response);
      loginResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> changePassword(ChangePasswordRequest request,
      BuildContext context) async {
    print("request model ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.changePassword,
        requestBody: request.toJson());

    print(APIs.forgotUrl);
    print(request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse loginResponseData =
      new ForgotPasswordResponse.fromJson(response);
      loginResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> hideProfile(HideProfileRequestResponse request,
      BuildContext context) async {

    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.hideProfile,
        requestBody: request.toJson());


    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      HideProfileRequestResponse hideProfileRequestResponse =
      new HideProfileRequestResponse.fromJson(response);

      completer.complete(hideProfileRequestResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> deleteProfile(String userId,
      BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.deleteProfile+userId);


    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {

     completer.complete(response);
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
