import 'dart:async';
import 'dart:convert';

import 'package:Filmshape/Model/Login/add_manager_request.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_profile/media/create_profile_media_request.dart';
import 'package:Filmshape/Model/create_profile/media/create_profile_media_response.dart';
import 'package:Filmshape/Model/create_project/create_project_request.dart';
import 'package:Filmshape/Model/create_project/create_project_response.dart';
import 'package:Filmshape/Model/projectresponse/project_response.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class CreateProfileSecondProvider with ChangeNotifier {
  ProjectResponse projectResponse=new ProjectResponse();
   var _isLoading = false;

  getLoading() => _isLoading;


  ChannelIdResponse channelResponse = new ChannelIdResponse();

  getChannelsId() => id;

  String id;


  Future<dynamic> updateUserShowReel(UserShowReelRequest request,
      BuildContext context, String showreelid) async {

      Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: APIs.updateUserShowReelUrl + showreelid + "/",
        requestBody: request.toJson());

    print("showreel api ${APIs.updateUserShowReelUrl + showreelid + "/"}");
     hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
      new CreateProfileResponse.fromJson(response);
       completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> addManagers(BuildContext context, AddManagerRequest request,
      String projectId) async {
    String url = APIs.createProjectUrl + "$projectId/";


    print("final url $url");
    print("final url ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: url,
        requestBody: request.toJson());

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
      new CreateProfileResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> hideSalary(BuildContext context, bool isBoolean,
      String projectId) async {
    String url = APIs.createProjectUrl + "$projectId/private/";

    if (!isBoolean) {
      url = APIs.createProjectUrl + "$projectId/public/";
    }


    print("final url $url");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: url);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
      new CreateProfileResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> deleteProject(BuildContext context,
      String projectId) async {
    String url = APIs.createProjectUrl + "$projectId/";


    print("final url $url");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.delete(
        context: context,
      url: url,);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
      new CreateProfileResponse.fromJson(response);
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> getChannelId(String request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.getChannelId + request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChannelIdResponse loginResponseData = new ChannelIdResponse.fromJson(
          response);

      print(loginResponseData.items[0].id);
      channelResponse = loginResponseData;
      id = loginResponseData.items[0].id;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getProjectDetails(String projectId, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.getProjectUrl + projectId);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      projectResponse = new ProjectResponse.fromJson(
          response);
      completer.complete(projectResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getVimeoVideoList(String accessToken,
     ) async {
    final Map<String, String> header = new Map<String, String>();
    header['Authorization'] =
    "Bearer $accessToken";
    header['Content-Type'] = "application/json";

    try {
      Dio dio = Dio();
      var response = await dio
          .get(
        APIs.getVimeoVideosList,
        options: Options(
          headers: header,
        ),
      ).timeout(timeoutDuration);
       print("respoonee ${response}") ;
      final Map parsed = json.decode(response.data);
      VimeoVideosListResponse videosListResponse = new VimeoVideosListResponse
          .fromJson(parsed);
      print("videolist ${videosListResponse.total}");
      return videosListResponse;

    } on DioError catch (e) {
      print("error ${e.response}");
      return new APIError(
        error: e.response.data["developer_message"],
        status: 400,
        onAlertPop: () {},
      );
    }
    catch (e) {
      print("exception ${e.toString()}");
      return new APIError(error: Messages.genericError);
    }
  }

  Future<dynamic> updateProject(CreateProjectRequest request,
      BuildContext context,
      String projectId) async {
    print("request model ${json.encode(request.toJson())}");
    Completer<dynamic> completer = new Completer<dynamic>();
    print("${APIs.createProjectUrl}$projectId/");
    var response = await APIHandler.put(
        context: context,
        url: APIs.createProjectUrl+"$projectId/",
        requestBody: request.toJson()
    );

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProjectResponse createProjectResponse =
      new CreateProjectResponse.fromJson(response);

      completer.complete(createProjectResponse);
      //notifyListeners();
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
