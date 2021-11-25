import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/create_profile/create_profile_request.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_profile/media/create_profile_media_request.dart';
import 'package:Filmshape/Model/ethicity/ethicity_response.dart';
import 'package:Filmshape/Model/gender/gender_response.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/my_profile/MyProfileResponse.dart';
import 'package:Filmshape/Model/user_channelid/ChannelId.dart';
import 'package:Filmshape/Model/vimeoauth/vimeo_videos_list_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Messages.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CreateProfileProvider with ChangeNotifier {
  CreateProfileResponse loginResponse = new CreateProfileResponse();
  MyProfileResponse myResponse = new MyProfileResponse();
  GetRolesResponseMain rolesResponse = new GetRolesResponseMain();
  MyProfileResponse myProfileResponse = new MyProfileResponse();

  GenderResponse genderResponse = new GenderResponse();
  EthicityResponse ethicityResponse = new EthicityResponse();
  List<String> listAllRolesItem = new List();
  List<String> genderList = new List();
  List<String> ethicityList = new List();
  List<int> roldIdList = new List();
  List<GetRolesResponse> rolesList = new List();

  List<String> list = new List();
  LinkedHashSet<int> listId = new LinkedHashSet<int>();

  List<AddRoleModel> listModel = new List();
  LinkedHashSet<String> hashSet = new LinkedHashSet();



  var _isLoading = false;

  getLoading() => _isLoading;


  ChannelIdResponse channelResponse = new ChannelIdResponse();

  getChannelsId() => id;

  String id;




  Future<dynamic> saveData(
      CreateProfileRequest request, BuildContext context, String userid) async {
    //("request model ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: APIs.createProfileUrl + userid + "/",
        requestBody: request.toJson());

     //(request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
          new CreateProfileResponse.fromJson(response);
      ("profile updated ${loginResponseData.toJson()}");
      loginResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> updateUserShowReel(UserShowReelRequest request,
      BuildContext context, String userid) async {
     Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: APIs.updateUserShowReelUrl + userid + "/",
        requestBody: request.toJson());

    //("url ${APIs.updateUserShowReelUrl + userid + "/"}");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProfileResponse loginResponseData =
      new CreateProfileResponse.fromJson(response);
      loginResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }



  Future<dynamic> getProfileData(String id, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
    await APIHandler.get(context: context, url: APIs.getmyProfile + "$id/");

    //(APIs.getmyProfile);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      MyProfileResponse loginResponseData =
      new MyProfileResponse.fromJson(response);
      myProfileResponse = loginResponseData;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getGender(BuildContext context) async {
    //(APIs.genderUrl);

    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(context: context, url: APIs.genderUrl);


    hideLoader();
    if (response is APIError) {
      //("response ${response.error}");
      completer.complete(response);
      return completer.future;
    } else {
      //("genderres $response");
      GenderResponse finalResponseData = new GenderResponse.fromJson(response);
      genderResponse = finalResponseData;
      genderList.clear(); //to avoid duplicate data
      for (int i = 0; i < finalResponseData.data.length; i++) {
        var data = finalResponseData.data[i];
        genderList.add(data.name);
      }
      completer.complete(finalResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> getRoles(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(context: context, url: APIs.rolesUrl);
    hideLoader();
    if (response is APIError) {
      //("response ${response.error}");
      completer.complete(response);
      return completer.future;
    } else {
      GetRolesResponseMain finalResponseData =
          new GetRolesResponseMain.fromJson(response);
      rolesResponse = finalResponseData;
      listAllRolesItem.clear();
      roldIdList.clear();
      rolesList.clear();
      list.clear();
      listId.clear();

      for (var roleTile in finalResponseData.data) {
        rolesList.add(roleTile);
        for (var subRole in roleTile.roles) {
          listAllRolesItem.add(subRole.name);
        }
      }
      completer.complete(finalResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> getEthicity(BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(context: context, url: APIs.ehicityUrl);

    //(APIs.ehicityUrl);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      EthicityResponse loginResponseData =
      new EthicityResponse.fromJson(response);
      ethicityResponse = loginResponseData;
      ethicityList.clear(); //avoid duplicate data
      for (int i = 0; i < loginResponseData.data.length; i++) {
        var data = loginResponseData.data[i];
        ethicityList.add(data.name);
      }
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  void hideLoader() {
    //(_isLoading);
    _isLoading = false;
    notifyListeners();
  }

  void setLoading() {
    //(_isLoading);
    _isLoading = true;
    notifyListeners();
  }


  void addRoleBottomData(AddRoleModel model) {
    listModel.add(model);
    if (!hashSet.add(model.title)) {
      hashSet.add(model.title);
      //(hashSet);
    }
  }

  void removeRoleBottomData(AddRoleModel model) {
    for (AddRoleModel models in listModel) {
      if (models.title == model.title) {
        listModel.remove(models);
        break;
      }
    }
  }


  void setRoleList(LinkedHashSet<int> list) {
    roldIdList.clear();
    List<int> result = LinkedHashSet<int>.from(list).toList();
    roldIdList.addAll(result);
    //(roldIdList);
    notifyListeners();
  }

  Future<dynamic> getChannelId(String request, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.getChannelId + request);
    //(request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChannelIdResponse loginResponseData = new ChannelIdResponse.fromJson(
          response);

      //(loginResponseData.items[0].id);
      channelResponse = loginResponseData;
      id = loginResponseData.items[0].id;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> getVimeoVideoList(String accessToken,) async {
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
      //("respoonee ${response}") ;
      final Map parsed = json.decode(response.data);
      VimeoVideosListResponse videosListResponse = new VimeoVideosListResponse
          .fromJson(parsed);
      //("videolist ${videosListResponse.total}");
      return videosListResponse;
    } on DioError catch (e) {
      //("error ${e.response}");
      return new APIError(
        error: e.response.data["developer_message"],
        status: 400,
        onAlertPop: () {},
      );
    }
    catch (e) {
      //("exception ${e.toString()}");
      return new APIError(error: Messages.genericError);
    }
  }

  Future<dynamic> uploadPicture(File _image) async
  {
    try {
      Dio dio = new Dio();
      Map<String, String> headers = {
        //header
        "Accept": "application/json",
        "Authorization": "Token ${MemoryManagement.getAccessToken()}"
      };

      dio.options.headers = headers;
      String fileName = _image.path
          .split('/')
          .last;
      FormData formData = FormData.fromMap({
        "thumbnail": await MultipartFile.fromFile(_image.path,
            filename: fileName),
      });
      var response = await dio.post(APIs.baseUrl + "/entity/User/thumbnail/",
          data: formData);
      return response;
    } on DioError catch (e) {
      print("error ${e.response}");
      APIError error = APIError(error: e.message);
      return error;
    }
  }

  Future<dynamic> getVimeoImages(String videoUrl, BuildContext context) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: videoUrl);
    //(request);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("response vimeo $response");
      ChannelIdResponse loginResponseData = new ChannelIdResponse.fromJson(
          response);

      //(loginResponseData.items[0].id);
      channelResponse = loginResponseData;
      id = loginResponseData.items[0].id;
      completer.complete(loginResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  }



