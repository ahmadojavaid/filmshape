import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:Filmshape/Model/Login/LoginRequest.dart';
import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_request.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_auth_token_response.dart';
import 'package:Filmshape/Model/youtubeauth/YoutubeAuthRequest.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';

class LoginProvider with ChangeNotifier {
  LoginResponse loginResponse = new LoginResponse();
  ChannelIdResponse channelResponse = new ChannelIdResponse();


  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => loginResponse;


  getChannelsId() => id;

  String id;

  Future<dynamic> login(LoginRequest request, BuildContext context) async {
    print("request model ${request.toJson()}");
    print(APIs.loginUrl);
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context, url: APIs.loginUrl, requestBody: request.toJson());

    print(APIs.loginUrl);
    print(request);
    //hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponseData = new LoginResponse.fromJson(response);
      loginResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getVimeoAuthToken(VimeoAuthRequest request,
      BuildContext context) async {
     final Map<String, String> header = new Map<String, String>();
    header['Authorization'] =
    "basic YzA4YTdkMmVhYjYxNjEyNDY3MGNjNWQ1Y2IyMWY1NmM3ZmQ1NjZiZDordHd1cmhiVmM0dUFIWnA4d1hINzBEdGtYbmFsTDR3QlZNc3R1WW1Mc0t4WVBibVJZWGVyMHkxallFNC95aDUvL21hUEZHWXk1eEQzZHhXVEhIK3B1c1RDY1h5alJhcUl0V0Q2eW1UT1g0MXFjUHVIMUtOdzRnK1VmOVlWdkVQRg==";
    header['Accept'] = "application/vnd.vimeo.*+json;version=3.4";
    header['Content-Type'] = "application/json";

    try {
      Dio dio = Dio();
      var response = await dio
          .post(
        APIs.getVimeoToken,
        options: Options(
          headers: header,
        ),
        data: request.toJson(),
      )
          .timeout(timeoutDuration);

      print("auth data ${response.data}");
      ViemoAuthTokenResponse authTokenResponse = new ViemoAuthTokenResponse
          .fromJson(response.data);

      return authTokenResponse;

    } on DioError catch (e) {
      print("error ${e.response}");
      return new APIError(
        error: e.response.data["error_description"],
        status: 400,
        onAlertPop: () {},
      );
    }
    catch (e) {
      return new APIError(error: Messages.genericError);
    }
  }

  Future<dynamic> getYoutubeAuthToken(YoutubeAuthRequest request,
      BuildContext context) async {
    final Map<String, String> header = new Map<String, String>();
      header['Content-Type'] = "application/x-www-form-urlencoded";

    try {
      Dio dio = Dio();
      var response = await dio
          .post(
        APIs.youtubeTokenUrl,
        options: Options(
          headers: header,
        ),
        data: request.toJson(),
      )
          .timeout(timeoutDuration);

      print("auth data ${response.data}");
      YoutubeAuthTokenResponse authTokenResponse = new YoutubeAuthTokenResponse
          .fromJson(response.data);

      return authTokenResponse;

    } on DioError catch (e) {
      print("error ${e.response}");
      return new APIError(
        error: e.response.data["error_description"],
        status: 400,
        onAlertPop: () {},
      );
    }
    catch (e) {
      return new APIError(error: Messages.genericError);
    }
  }

  void hideLoader() {
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }
}
