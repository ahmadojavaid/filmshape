import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:new_flutter_mar/AbstractApi/DashboardApi.dart';
import 'package:new_flutter_mar/Model/AddAccount/AddAccountRequest.dart';
import 'package:new_flutter_mar/Model/AddAccount/AddAccountResponse.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordRequest.dart';
import 'package:new_flutter_mar/Model/ForgotPassword/ForgotPasswordResponse.dart';
import 'package:new_flutter_mar/Model/Login/LoginResponse.dart';
import 'package:new_flutter_mar/Model/Network/APIError.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpRequest.dart';
import 'package:new_flutter_mar/Model/SignUp/registration_otp/RegistrationOtpResponse.dart';
import 'package:new_flutter_mar/Model/UserDetail/UserDetailRequest.dart';
import 'package:new_flutter_mar/Model/cancelorder/CancelOrderRequest.dart';
import 'package:new_flutter_mar/Model/change_password/ChangePasswordResponse.dart';
import 'package:new_flutter_mar/Model/change_setting_password/ChangeSettingPasswordRequest.dart';
import 'package:new_flutter_mar/Model/chatuser/chat_user.dart';
import 'package:new_flutter_mar/Model/device_token_request/DeviceTokenRequest.dart';
import 'package:new_flutter_mar/Model/gameslist/GameSearchList.dart';
import 'package:new_flutter_mar/Model/my_selling/MySellingRequest.dart';
import 'package:new_flutter_mar/Model/report/ReportRequest.dart';
import 'package:new_flutter_mar/Model/user_profile/UserProfileRequest.dart';
import 'package:new_flutter_mar/Model/user_profile/UserProfileResponse.dart';
import 'package:new_flutter_mar/Network/APIHandler.dart';
import 'package:new_flutter_mar/Utils/APIs.dart';
import 'package:new_flutter_mar/Utils/memory_management.dart';

class DashboardServiceAPi extends DashboardApi {
  @override
  Stream<List<ChatUser>> getChatFriends({@required String userId}) {
    /*var firestore = Firestore.instance
        .collection("chatfriends")
        .document(userId)
        .collection("friends")
        .orderBy('lastMessageTime', descending: true)
        .snapshots();

    StreamController<List<ChatUser>> controller =
    new StreamController<List<ChatUser>>();

    //get the data and convert to list
    firestore.listen((QuerySnapshot snapshot) {
      final List<ChatUser> productList =
      snapshot.documents.map((documentSnapshot) {
        return ChatUser.fromMap(documentSnapshot.data);
      }).toList();

      //remove if any item is null
      productList.removeWhere((product) => product == null);
      controller.add(productList);
    });*/

    return null;
  }

  @override
  Future updateGroupMessage(
      {@required ChatUser user, @required String userId}) {
    /* var document =
    Firestore.instance.collection("groups").document(user.userId);

    var dataMap = new Map<String, dynamic>();
    dataMap["lastMessage"] = user.lastMessage;
    dataMap["lastMessageTime"] = user.lastMessageTime;
    document.updateData(dataMap);*/
  }

  @override
  Future createChatUser({@required ChatUser user, @required String userId}) {
    //var loginResponse = _getUserResponse();
    //  var userId = "0"; //add this current user friend list
    var userName = "";
    var profilePic = "";

    try {
      if (MemoryManagement.getUserInfo() != null) {
        var infoData = jsonDecode(MemoryManagement.getUserInfo());
        var userinfo = LoginResponse.fromJson(infoData);
        userName = userinfo.data.user.name;
        profilePic = MemoryManagement.getImage() ?? "";
      }
    } catch (ex) {
      print("error ${ex.toString()}");
      return null;
    }

    //storing current user as friend to other user chat friend list

    var chatUser = new ChatUser();
    chatUser.username = userName;
    chatUser.userId = userId.toString();
    chatUser.profilePic = profilePic;
    chatUser.lastMessage = user.lastMessage;
    chatUser.lastMessageTime = user.lastMessageTime;
    chatUser.unreadMessageCount = user.unreadMessageCount;
    chatUser.isGroup = false;
  }

  @override
  Future<bool> resetUnreadMessageCount(
      {@required String userId, @required String chatUserId}) async {
    return true;
  }

  @override
  Future<bool> updateDeviceToken(
      {String deviceToken, String userId, @required String deviceType}) async {
    return true;
  }

  @override
  Future<dynamic> getCMSPage(
      {@required BuildContext context, int page}) async {}

  Future<dynamic> getMyFaq({@required BuildContext context, int page}) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
      context: context,
      url: APIs.getfaq,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits forgotPassword api
  Future<dynamic> addAccount({
    @required BuildContext context,
    @required AddAccountRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.addAccount,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      AddAccountResponse responseAccount =
          new AddAccountResponse.fromJson(response);
      completer.complete(responseAccount);
      return completer.future;
    }
  }

  Future<dynamic> getGameDetails(
      {@required BuildContext context,
      int id,
      @required GameSearchListRequest gameListRequest,
      int page}) async {
    String uri;
    Completer<dynamic> completer = new Completer<dynamic>();

    if (gameListRequest.minPrice == null && gameListRequest.minPrice == null) {
      uri = APIs.getGameDetails +
          "$id" +
          "?page=$page" +
          "&search=${gameListRequest.search}" +
          "&min_price=${""}" +
          "&max_price=${""}";
    } else {
      uri = APIs.getGameDetails +
          "$id" +
          "?page=$page" +
          "&search=${gameListRequest.search}" +
          "&min_price=${gameListRequest.minPrice}" +
          "&max_price=${gameListRequest.maxPrice}";
    }

    var response = await APIHandler.get(
      context: context,
      requestBody: gameListRequest,
      // url: APIs.getGameDetails + "$id"+ "?page=$page"+ "&search=${gameListRequest.search}"+"&min_price=${gameListRequest.minPrice}"+ "&max_price=${gameListRequest.maxPrice}",
      url: uri,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> notificationOnOff({@required BuildContext context}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      url: APIs.notificationonoff,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> getMySelling(
      {@required BuildContext context,
      MySellingRequest request,
      int page}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
        context: context,
        url: APIs.getMySelling + "?page=$page",
        requestBody: request);

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> getOrderList(
      {@required BuildContext context, int page}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
        context: context, url: APIs.getOrderList + "?page=$page");

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> getGameFullDetails(
      {@required BuildContext context, int id}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.getFullGameDetails + "$id",
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("full response ${response.toString()}");
    }
  }

  @override
  Future getProfile({
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      url: APIs.getProfileUrl,
      context: context,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      print("LoginResponse---->$response");
      UserProfileRespose userProfileRespose =
          new UserProfileRespose.fromJson(response);
      completer.complete(userProfileRespose);
      return completer.future;
    }
  }

  // Hits signup otp verify Otp api
  Future<dynamic> signUpOTPVerifyUser({
    @required BuildContext context,
    @required RegistrationOtpRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.verifyOTPUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      RegistrationOtpResponse loginResponse =
          new RegistrationOtpResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  // Hits change phone email otp verify Otp api
  Future<dynamic> changePhoneEmailOTPVerifyUser({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.verifyChangePhoneEmailOTPUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  // Hits forgotPassword api
  Future<dynamic> forgotPasswordUser({
    @required BuildContext context,
    @required ForgotPasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.forgotPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ForgotPasswordResponse forgotPasswordResponse =
          new ForgotPasswordResponse.fromJson(response);
      completer.complete(forgotPasswordResponse);
      return completer.future;
    }
  }

  // Hits forgotPassword api
  Future<dynamic> deleteMySelling(
      {@required BuildContext context, int id}) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.delete(
      context: context,
      url: APIs.deleteSelling + "/$id",
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits forgotPassword Otp verify api
  Future<dynamic> reportUser({
    @required BuildContext context,
    @required ReportRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.supportEmail,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits change Password api
  Future<dynamic> changeSettingPasswordUser({
    @required BuildContext context,
    @required ChangeSettingPasswordRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.changeSettingPasswordUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChangePasswordResponse changePasswordResponse =
          new ChangePasswordResponse.fromJson(response);
      completer.complete(changePasswordResponse);
      return completer.future;
    }
  }

  // Hits change language api
  Future<dynamic> setDeviceToken({
    @required BuildContext context,
    @required DeviceTokenRequest requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.devicToken,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      ChangePasswordResponse changePasswordResponse =
          new ChangePasswordResponse.fromJson(response);
      completer.complete(changePasswordResponse);
      return completer.future;
    }
  }

  // Hits change language api
  Future<dynamic> changeLanguage({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.changeLanguageUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  // Hits push notification toggle api
  Future<dynamic> getGamesList(
      {@required BuildContext context,
      @required GameSearchListRequest gameListRequest,
      int page}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: gameListRequest,
      url: APIs.getGamesListUrl + "?page=$page",
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits push notification toggle api
  Future<dynamic> cancelOrder({
    @required BuildContext context,
    CancelOrderRequest request,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      context: context,
      requestBody: request,
      url: APIs.cancelOrder,
    );
    print("aviiii");
    print(response);
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> readNotification(
      {@required BuildContext context, @required int id}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      url: APIs.readNotification + "$id" + "?",
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  Future<dynamic> readAllNotification({@required BuildContext context}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      url: APIs.readAllNotification,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits push notification toggle api
  Future<dynamic> getNotificationList(
      {@required BuildContext context, int page}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.getNotificationList + "?page=$page",
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits push notification toggle api
  Future<dynamic> getCategoryList({@required BuildContext context}) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.getCategoryList,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  // Hits upload Company logo api
  Future<dynamic> companyLogoUser({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.profilePicUrl,
    );
    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits skip profile
  Future<dynamic> skipUserProfile({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      context: context,
      requestBody: requestBody,
      url: APIs.skipProfileURL,
    );
    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  @override
  Future isUserApproved({
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();
    var response = await APIHandler.get(
      url: APIs.isUserApproved,
      context: context,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      LoginResponse loginResponse = new LoginResponse.fromJson(response);
      completer.complete(loginResponse);
      return completer.future;
    }
  }

  @override
  Future getCategories({
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      url: APIs.getCategoryUrl,
      context: context,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {}
  }

  @override
  Future updateProfile({
    @required UserDetailRequest userDetailRequest,
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      url: APIs.updateProfileUrl,
      context: context,
      requestBody: userDetailRequest,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  @override
  Future updateUserProfile({
    @required UserProfileRequest userDetailRequest,
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      url: APIs.updateProfileUrl,
      context: context,
      requestBody: userDetailRequest,
    );
    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      UserProfileRespose updateprofile =
          new UserProfileRespose.fromJson(response);
      completer.complete(updateprofile);
      return completer.future;
    }
  }
}
