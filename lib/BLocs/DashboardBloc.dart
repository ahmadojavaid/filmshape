import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_flutter_mar/AbstractApi/DashboardApi.dart';
import 'package:new_flutter_mar/BLocs/BLoc.dart';
import 'package:new_flutter_mar/Model/AddAccount/AddAccountRequest.dart';
import 'package:new_flutter_mar/Model/UserDetail/UserDetailRequest.dart';
import 'package:new_flutter_mar/Model/cancelorder/CancelOrderRequest.dart';
import 'package:new_flutter_mar/Model/change_setting_password/ChangeSettingPasswordRequest.dart';
import 'package:new_flutter_mar/Model/chatuser/chat_user.dart';
import 'package:new_flutter_mar/Model/device_token_request/DeviceTokenRequest.dart';
import 'package:new_flutter_mar/Model/gameslist/GameSearchList.dart';
import 'package:new_flutter_mar/Model/my_selling/MySellingRequest.dart';
import 'package:new_flutter_mar/Model/report/ReportRequest.dart';
import 'package:new_flutter_mar/Model/user_profile/UserProfileRequest.dart';
//import 'package:rxdart/rxdart.dart';

class DashboardBloc extends BLoc {
  DashboardApi authAPI;

  //static BehaviorSubject<int> txtCount ;

  DashboardBloc({
    @required this.authAPI,
  });

  Stream<List<ChatUser>> getChatFriends({@required String userId}) {
    return authAPI.getChatFriends(userId: userId);
  }

  Future updateGroupMessage(
      {@required ChatUser user, @required String userId}) async {
    return await authAPI.updateGroupMessage(userId: userId, user: user);
  }

  Future createChatUser(
      {@required ChatUser user, @required String userId}) async {
    return await authAPI.createChatUser(user: user, userId: userId);
  }

  Future<bool> resetUnreadMessageCount(
      {@required String userId, @required String chatUserId}) async {
    return await authAPI.resetUnreadMessageCount(
        userId: userId, chatUserId: chatUserId);
  }

  Future<bool> updateDeviceToken(
      {@required String deviceToken,
      @required String userId,
      @required String deviceType}) async {
    return await authAPI.updateDeviceToken(
        deviceToken: deviceToken, deviceType: deviceType, userId: userId);
  }

  Future<dynamic> getcategoryList({@required BuildContext context}) async {
    return await authAPI.getCategoryList(
      context: context,
    );
  }

  Future<dynamic> getGameDetails(
      {@required BuildContext context,
      @required int ids,
      @required GameSearchListRequest gameListRequest,
      int page}) async {
    return await authAPI.getGameDetails(
        context: context,
        id: ids,
        page: page,
        gameListRequest: gameListRequest);
  }

  Future<dynamic> setDeviceToken(
      {@required BuildContext context,
      @required DeviceTokenRequest devicetokenRequest,
      int page}) async {
    return await authAPI.setDeviceToken(
        context: context, requestBody: devicetokenRequest);
  }

  Future<dynamic> getMySelling(
      {@required BuildContext context,
      @required MySellingRequest request,
      int page}) async {
    return await authAPI.getMySelling(
        context: context, request: request, page: page);
  }

  Future<dynamic> deleteMySelling(
      {@required BuildContext context, int id}) async {
    return await authAPI.deleteMySelling(context: context, id: id);
  }

  Future<dynamic> getmyOrderList(
      {@required BuildContext context, int page}) async {
    return await authAPI.getOrderList(context: context, page: page);
  }

  Future<dynamic> cancelOrder({
    @required BuildContext context,
    @required CancelOrderRequest request,
  }) async {
    return await authAPI.cancelOrder(context: context, request: request);
  }

  Future<dynamic> getMyFaq({@required BuildContext context, int page}) async {
    return await authAPI.getMyFaq(context: context, page: page);
  }

  Future<dynamic> getCMSPage(
      {@required BuildContext context, @required int page}) async {
    return await authAPI.getCMSPage(
      context: context,
      page: page,
    );
  }

  Future<dynamic> notificationOnOff({@required BuildContext context}) async {
    return await authAPI.notificationOnOff(
      context: context,
    );
  }

  Future<dynamic> reportUser({
    @required ReportRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.reportUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> getGameFullDetails({
    @required BuildContext context,
    @required int ids,
  }) async {
    return await authAPI.getGameFullDetails(
      context: context,
      id: ids,
    );
  }

  Future<dynamic> addAccount({
    @required AddAccountRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.addAccount(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> changeSettingPassword({
    @required ChangeSettingPasswordRequest request,
    @required BuildContext context,
  }) async {
    return await authAPI.changeSettingPasswordUser(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> changeLanguage({
    @required Map request,
    @required BuildContext context,
  }) async {
    return await authAPI.changeLanguage(
      requestBody: request,
      context: context,
    );
  }

  Future<dynamic> getGamesList(
      {@required BuildContext context,
      @required GameSearchListRequest gameListRequest,
      int page}) async {
    return await authAPI.getGamesList(
        context: context, gameListRequest: gameListRequest, page: page);
  }

  Future<dynamic> getNotificationList(
      {@required BuildContext context, int page}) async {
    return await authAPI.getNotificationList(context: context, page: page);
  }

  Future<dynamic> markNotification(
      {@required BuildContext context, @required int id}) async {
    return await authAPI.readNotification(context: context, id: id);
  }

  Future<dynamic> markAllNotification({@required BuildContext context}) async {
    return await authAPI.readAllNotification(context: context);
  }

  Future<dynamic> updateProfileList({
    @required BuildContext context,
    @required UserProfileRequest updateprofilerequest,
  }) async {
    return await authAPI.updateUserProfile(
        context: context, userDetailRequest: updateprofilerequest);
  }

//  uploadCompanyLogoUser
  Future<dynamic> companyLogo(
      {@required Map request, @required BuildContext context}) async {
    return await authAPI.companyLogoUser(
      requestBody: request,
      context: context,
    );
  }

  //  skip user profile
  Future<dynamic> skipProfile({
    @required Map request,
    @required BuildContext context,
  }) async {
    return await authAPI.skipUserProfile(
      requestBody: request,
      context: context,
    );
  }

  //  Check user profile is approved or not by admin.
  Future<dynamic> isUserApproved({
    @required BuildContext context,
  }) async {
    return await authAPI.isUserApproved(
      context: context,
    );
  }

  //  Returns user profile is approved or not by admin.
  Future<dynamic> getProfile({
    @required BuildContext context,
  }) async {
    return await authAPI.getProfile(
      context: context,
    );
  }

  //  Check categories.
  Future<dynamic> getCategories({
    @required BuildContext context,
  }) async {
    return await authAPI.getCategories(
      context: context,
    );
  }

  //  Update Farmer Profile
  Future<dynamic> updateProfile({
    @required BuildContext context,
    @required UserDetailRequest userDetailRequest,
  }) async {
    return await authAPI.updateProfile(
      context: context,
      userDetailRequest: userDetailRequest,
    );
  }

  @override
  void dispose() {
    // implement dispose
  }
}
