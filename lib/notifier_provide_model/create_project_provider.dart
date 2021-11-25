import 'dart:async';
import 'dart:convert';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/addrole/add_role_request.dart';
import 'package:Filmshape/Model/apply_project_role/ApplyForProjectRole.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Model/invite_send_received/invite_request.dart';
import 'package:Filmshape/Network/APIHandler.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:flutter/material.dart';

class CreateProjectProvider with ChangeNotifier {
  AddRoleTabResponse addRoleResponse = new AddRoleTabResponse();
  List<AddRoleDetails> addRoleDetails = new List();

  var _isLoading = false;

  getLoading() => _isLoading;

  getResponse() => addRoleResponse;

  getAddRolesResponse() => addRoleDetails;

  Future<dynamic> addTab(BuildContext context, AddRoleRequest addRoleRequest,
      {bool status=false}) async {
    print("addtab ${jsonEncode(addRoleRequest.toJson())}");

    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
    await APIHandler.post(context: context,
        url: APIs.addRoleTab,
        requestBody: addRoleRequest.toJson());
    //if true becausing api being called in loop and avoid show hide loader everytime
    if (!status) {
      hideLoader();
    }

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddRoleTabResponse searchResponseData =
      new AddRoleTabResponse.fromJson(response);

      addRoleResponse = searchResponseData;

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> assignMySelf(BuildContext context, String roleId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    print("add roel ${APIs.addRoleTab + "$roleId/assign/self/"}");
    var response =
    await APIHandler.post(
        context: context, url: APIs.addRoleTab + "$roleId/assign/self/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddRoleTabResponse searchResponseData =
      new AddRoleTabResponse.fromJson(response);

      addRoleResponse = searchResponseData;

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> getProfileRoles(BuildContext context,
      String filter) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var finalUrl = "${APIs.addRoleTab}?filters=$filter";
    print("final url $finalUrl");
    var response =
    await APIHandler.get(
        context: context, url: finalUrl);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("response ${response}");
      GetRolesMainsDetails searchResponseData =
      new GetRolesMainsDetails.fromJson(response);

      addRoleDetails = searchResponseData.data;
      print("addRoleDetails ${ searchResponseData.data.length}");
      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> removeTab(BuildContext context, String tabId) async {

    print("url ${APIs.removeRoleTab}$tabId");

    var response =
    await APIHandler.delete(
        context: context, url: "${APIs.removeRoleTab}$tabId/");

    hideLoader();
    if (response is APIError) {
      return response;
    } else {
      return "Deleted";
    }
  }

  Future<dynamic> unassignToSelf(BuildContext context, String roleId) async {
    print("url ${APIs.unassignToSelf}$roleId/unassign");

    var response =
    await APIHandler.post(
        context: context, url: "${APIs.unassignToSelf}$roleId/unassign/");

    hideLoader();
    if (response is APIError) {
      return response;
    } else {
      return "Unassigned";
    }
  }

  Future<dynamic> updateRoleInformation(BuildContext context,
      SaveRoleCallRequest saveRoleData,
      String roleId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
        context: context,
        url: APIs.addRoleTab + "$roleId/",
        requestBody: saveRoleData.toJson());

    print(APIs.addRoleTab+ "$roleId/");
    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddRoleTabResponse searchResponseData =
          new AddRoleTabResponse.fromJson(response);

      addRoleResponse = searchResponseData;

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }


  Future<dynamic> sendInviteRequest(BuildContext context,
      SendInviteRequest request,
      String id,
      String userId) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
        context: context,
        url: APIs.inviteSend + "$id/invite/User/$userId/",
        requestBody: request.toJson());

    print(APIs.inviteSend + "$id/invite/User/$userId/");

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddRoleTabResponse searchResponseData =
          new AddRoleTabResponse.fromJson(response);

      completer.complete(searchResponseData);
      notifyListeners();
      return completer.future;
    }
  }

  Future<dynamic> applyForRoleCall(
      BuildContext context, ApplyRoleRequest request) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response =
        await APIHandler.get(context: context, url: APIs.applyForRole);

    hideLoader();
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("response ${response}");
      completer.complete(response);
      notifyListeners();
      return completer.future;
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
