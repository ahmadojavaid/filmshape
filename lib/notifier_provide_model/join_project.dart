import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/add_a_credit/search_project_response.dart';
import 'package:Filmshape/Model/browser_project/browse_all_project_filter_request.dart';
import 'package:Filmshape/Model/browser_project/browse_project.dart';
import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/create_profile/create_profile_request.dart';
import 'package:Filmshape/Model/create_profile/create_profile_response.dart';
import 'package:Filmshape/Model/create_project/create_project_request.dart';
import 'package:Filmshape/Model/create_project/create_project_response.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Model/join_project/join_product_data.dart';
import 'package:Filmshape/Model/join_project/join_project_details_response.dart';
import 'package:Filmshape/Model/myprojects/my_project_filter.dart';
import 'package:Filmshape/Model/myprojects/my_projects_response.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_request.dart';
import 'package:Filmshape/Model/searchtalent/search_talent_response.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/ui/browse_project/data_model.dart';
import 'package:flutter/material.dart';

class JoinProjectProvider with ChangeNotifier {
  CreateProfileResponse loginResponse = new CreateProfileResponse();
  JoinProjectDetailsResponses JoinProjectDetailsResponse;
  GetRolesResponseMain rolesResponse = new GetRolesResponseMain();
  JonProductData joinProductData = new JonProductData();
  JonProductData projectTypeDataResponse = new JonProductData();
  JonProductData projectStatusDataResponse = new JonProductData();
  JonProductData projectGenreDataResponse = new JonProductData();
  JonProductData ethicityDataResponse = new JonProductData();
  List<ProjectData> myProjectList = new List();

  //to cache the previous filter of
  DataModelFilter browseProjectFilter = new DataModelFilter();
  BrowseAllProjectFilterRequest browseAllProjectFilterRequest =
      new BrowseAllProjectFilterRequest();

  List<String> listAllRolesItem = new List();
  List<String> statusList = new List();
  List<String> projectTypeList = new List();
  List<String> ethicityList = new List();
  List<String> genreList = new List();
  List<int> roldIdList = new List();

  List<String> userListJoinSearch = new List();
  List<GetRolesResponse> rolesList = new List();

  List<String> list = new List();
  List<int> listId = new List();

  List<AddRoleModel> listModel = new List();

  LinkedHashSet<String> hashSet = new LinkedHashSet();

  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => loginResponse;
  getRolesList() => rolesList;

  getRolesIdList() => roldIdList;

  getAllRolesList() => listAllRolesItem;

  Future<dynamic> getData(
      CreateProfileRequest request, BuildContext context, String userid) async {
    print("request model ${request.toJson()}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: APIs.createProfileUrl + userid + "/",
        requestBody: request.toJson());

    print(APIs.createProfileUrl + userid + "/");
    print(request);
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

  Future<dynamic> searchProject(JoinRequest request, BuildContext context,
      int pageNo) async {
    print("request model ${json.encode(request.toJson())}");
    var finalApi = "${APIs
        .searchProjects}?page=$pageNo&per_page=$RESULT_PER_PAGE&filters=${json.encode(request
        .toJson())}";
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context,
        url: finalApi,

    );
   print(finalApi);
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {

      SearchMainREsponse searchResponseData =
      new SearchMainREsponse.fromJson(response);

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> searchForTalent(SearchTalentRequest request, BuildContext context,
      int pageNo) async {
    print("request model ${json.encode(request.toJson())}");

    Completer<dynamic> completer = new Completer<dynamic>();
    var finalApi="${APIs.searchTalent}?page=$pageNo&per_page=$RESULT_PER_PAGE&filters=${json.encode(request.toJson())}";


    var response = await APIHandler.get(
        context: context,
        url: finalApi,
        requestBody: request.toJson()
    );

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      var mSearchTalentResponse = new SearchTalentResponse.fromJson(response);

      completer.complete(mSearchTalentResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> searchForMyProjects(MyProjectFilters filters,
      BuildContext context,
      int pageNo) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var finalApi = "${APIs
        .myProjects}?page=$pageNo&per_page=$RESULT_PER_PAGE&filters=${json.encode(filters
        .toJson())}";


    var response = await APIHandler.get(
      context: context,
      url: finalApi,
    );

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      MyProjectResponse myProjectResponse = new MyProjectResponse.fromJson(
          response);
     if(pageNo==1)
       {
         myProjectList.clear();
       }
      myProjectList.addAll(myProjectResponse.listData);
      completer.complete(myProjectResponse);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> browseProjects(int pageNo, BuildContext context,
      BrowseAllProjectFilterRequest request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var finalUrl =
        "${APIs
        .browseProjects}?page=$pageNo&per_page=$PAGINATION_SIZE&filters=${json
        .encode(request.toJson())}";
    print("browseall $finalUrl");

    var response = await APIHandler.get(
      context: context,
      url: finalUrl,
    );

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      BrowseProjectResponse  browseProjectResponse = new BrowseProjectResponse.fromJson(
          response);
      completer.complete(browseProjectResponse);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> projectDetails(BuildContext context,
      int projectId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
      context: context,
      url: APIs.likeUnlikeProject + "$projectId/",

    );

    print(APIs.likeUnlikeProject + "$projectId/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      //clear previous data
      JoinProjectDetailsResponses searchResponseData =
      new JoinProjectDetailsResponses.fromJson(response);

      JoinProjectDetailsResponse = searchResponseData;

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }




  Future<dynamic> getCommonData(BuildContext context, int type,
      String urls, {bool isCreating}) async {

    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
        context: context, url: APIs.commonDataJoin + urls);

    if (response is APIError) {
      print("response ${response.error}");
      completer.complete(response);
      return completer.future;
    } else {
      print("commondata $response");
      JonProductData finalResponseData = new JonProductData.fromJson(response);
      joinProductData = finalResponseData;
      if (type == 1) {
        projectTypeList.clear();
        if (isCreating == null || isCreating == false) {
          projectTypeList.add("Any");
        }

        projectTypeDataResponse = finalResponseData;
      }
      else if (type == 2) {
        genreList.clear();
        if (isCreating == null || isCreating == false) {
          genreList.add("Any");
        }

        projectGenreDataResponse = finalResponseData;
      }
      else if (type == 4) {
        ethicityList.clear();
        if (isCreating == null || isCreating == false) {
          ethicityList.add("Any");
        }

        ethicityDataResponse = finalResponseData;
      }
      else {
        statusList.clear();
        if (isCreating == null || isCreating == false) {
          statusList.add("Any");
        }

        projectStatusDataResponse = finalResponseData;
      }


      //to avoid duplicate data
      for (int i = 0; i < finalResponseData.data.length; i++) {
        var data = finalResponseData.data[i];
        if (type == 1) {
          projectTypeList.add(data.name);
        }
        else if (type == 2) {
          genreList.add(data.name);
        } else if (type == 4) {
          ethicityList.add(data.name);
        }
        else {
          statusList.add(data.name);
        }
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
      print("response ${response.error}");
      completer.complete(response);
      return completer.future;
    } else {
      print("getRoles $response");
      GetRolesResponseMain finalResponseData =
          new GetRolesResponseMain.fromJson(response);
      rolesResponse = finalResponseData;
      listAllRolesItem.clear();
      roldIdList.clear();
      rolesList.clear();
      list.clear();
      listId.clear();

      for (int i = 0; i < finalResponseData.data.length; i++) {
        var data = finalResponseData.data[i];
        rolesList.add(data);
        for (int j = 0; j < data.roles.length; j++) {
          var childData = data.roles[j];
          listAllRolesItem.add(childData.name);
          print(listAllRolesItem);
        }
      }
      completer.complete(finalResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> createProject(CreateProjectRequest request,
      BuildContext context
     ) async {
    print("request model ${json.encode(request.toJson())}");
   print("api ${APIs.createProjectUrl}");
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.createProjectUrl,
        requestBody: request.toJson()
    );

     hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      CreateProjectResponse searchResponseData =
      new CreateProjectResponse.fromJson(response);


      completer.complete(searchResponseData);
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

  void addRoleBottomData(AddRoleModel model) {
    listModel.add(model);
    if (!hashSet.add(model.title)) {
      hashSet.add(model.title);
      print(hashSet);
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

  void setRoleList(List<int> list) {
    roldIdList.clear();
    roldIdList.addAll(list);
    notifyListeners();
  }
}
