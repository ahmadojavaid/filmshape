import 'dart:async';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:new_flutter_mar/Model/Network/APIError.dart';
import 'package:new_flutter_mar/Network/APIHandler.dart';
import 'package:new_flutter_mar/Utils/APIs.dart';
import 'package:new_flutter_mar/Utils/UniversalFunctions.dart';
import 'package:new_flutter_mar/Utils/UniversalProperties.dart';

class UniversalAPI {
  // Hits add assets
  static Future<dynamic> addAsset({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.addAssetsUrl,
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits add assets
  static Future<dynamic> addToMyAsset({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.addGlobalAssetsUrl,
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits all assets API
  static Future<dynamic> getAllAssets({
    @required BuildContext context,
    @required int assetTypeCode,
    @required int pageNumber,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.allAssetsUrl + "?vendor_type=$assetTypeCode",
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits notifications list API
  static Future<dynamic> getNotifications({
    @required BuildContext context,
    @required int pageNumber,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.notificationsListUrl + "?page=$pageNumber",
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits notifications count API
  static Future<dynamic> getNotificationsCount({
    @required BuildContext context,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.notificationsCountUrl,
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits mark notification as read API
  static Future<dynamic> markNotificationAsRead({
    @required BuildContext context,
    @required String notificationId,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.readNotificationUrl + "/$notificationId",
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits search assets API
  static Future<dynamic> getSearchedAssets({
    @required BuildContext context,
    @required int assetTypeCode,
    @required String keyword,
    @required int pageNumber,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.get(
      context: context,
      url: APIs.searchAssetsUrl +
          "?page=$pageNumber&vendor_type=$assetTypeCode&keyword=$keyword",
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits contact us
  static Future<dynamic> contactUsAdmin({
    @required BuildContext context,
    @required Map requestBody,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.post(
      context: context,
      requestBody: requestBody,
      url: APIs.contactUsUrl,
    );

    if (response is APIError) {
      completer.complete(response);
    } else {
      completer.complete(response);
    }
    return completer.future;
  }

  // Hits signup otp verify Otp api
  static Future<dynamic> updateDeviceToken({
    @required BuildContext context,
    @required Map request,
  }) async {
    Completer<dynamic> completer = new Completer<dynamic>();

    var response = await APIHandler.put(
      context: context,
      requestBody: request,
      url: APIs.updateDeviceTokenUrl,
    );

    if (response is APIError) {
      completer.complete(response);
      return completer.future;
    } else {
      completer.complete(response);
      return completer.future;
    }
  }

  // Hits logout API
  static void logout({
    @required BuildContext context,
    @required bool mounted,
    @required Map requestBody,
    @required Function onSuccess,
  }) async {
    // Showing loader
    OverlayState overlayState;
    overlayState = Overlay.of(context);
    OverlayEntry loader = new OverlayEntry(builder: (BuildContext context) {
      return new Positioned.fill(
        child: new Container(
          color: Colors.black.withOpacity(0.5),
          alignment: Alignment.center,
          // child: getAppThemedLoader(context: context),
        ),
      );
    });
    overlayState.insert(loader);

    bool gotInternetConnection = await hasInternetConnection(
      context: context,
      mounted: mounted,
      canShowAlert: true,
      onFail: () {
        loader.remove(); //hide loader
      },
      onSuccess: () {},
    );

    if (gotInternetConnection) {
      var response = await APIHandler.get(
        context: context,
        url: APIs.logoutUrl,
      );

      loader.remove(); //hide loader
      //logged in successfully
      if (response != null && !(response is APIError)) {
        if (onSuccess != null) {
          onSuccess();
        }
      } else {
        APIError apiError = response;
        onSuccess();
        /* showAlert(
          context: context,
          titleText: Localization.of(context).trans(LocalizationValues.error),
          message: apiError.error,
          actionCallbacks: {
            Localization.of(context).trans(LocalizationValues.ok): () {
              if (apiError.onAlertPop != null) {
                apiError.onAlertPop();
              }
            }
          },
        );*/
      }
    }
  }
}

// Universal API methods

// Gets notifications badge count
void getNotificationBadgeCount({
  @required BuildContext context,
  @required VoidCallback updateScreen,
  bool mounted,
}) async {
  bool gotInternetConnection = await hasInternetConnection(
    context: context,
    mounted: mounted,
    canShowAlert: false,
    onFail: () {},
    onSuccess: () {},
  );

  if (gotInternetConnection) {
    var response = await UniversalAPI.getNotificationsCount(
      context: context,
    );
    //logged in successfully
    if (response != null && !(response is APIError)) {
      unreadNotificationsCount = response["count"];
      /*  addBadge(unreadNotificationsCount);*/
      if (updateScreen != null) {
        updateScreen();
      }
    } else {
      APIError apiError = response;
      print(apiError.error);
    }
  }
}
