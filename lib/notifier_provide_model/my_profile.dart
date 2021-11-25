import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';

class MyProfileProvider with ChangeNotifier {
  MyProfileResponse profileResponse = new MyProfileResponse();

  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => profileResponse;

  Future<dynamic> getProfileData(String id, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
        await APIHandler.get(context: context, url: APIs.getmyProfile + "$id/");

    print(APIs.getmyProfile);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      MyProfileResponse loginResponseData =
          new MyProfileResponse.fromJson(response);
      profileResponse = loginResponseData;
      completer.complete(loginResponseData);
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
