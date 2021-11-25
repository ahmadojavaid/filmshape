import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/IfincaColors.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/ui/my_profile/my_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'APIs.dart';
import 'app_loader.dart';

// Todo: actual

// Returns screen size
Size getScreenSize({@required BuildContext context}) {
  return MediaQuery.of(context).size;
}

// Returns status bar height
double getStatusBarHeight({@required BuildContext context}) {
  return MediaQuery.of(context).padding.top;
}

bool isAndroidPlatform({@required BuildContext context}) {
  if (Platform.isAndroid) {
    return true;
  } else {
    return false;
  }
}

// Returns bottom padding for round edge screens
double getSafeAreaBottomPadding({@required BuildContext context}) {
  return MediaQuery.of(context).padding.bottom;
}

// Returns Keyboard size
bool isKeyboardOpen({@required BuildContext context}) {
  return MediaQuery.of(context).viewInsets.bottom > 0.0;
}

// Returns spacer
Widget getSpacer({double height, double width}) {
  return new SizedBox(
    height: height ?? 0.0,
    width: width ?? 0.0,
  );
}

// Clears memory on logout success
void onLogoutSuccess({
  @required BuildContext context,
}) {
  MemoryManagement.clearMemory();

/*
  if (isAndroid()) {
    Fluttertoast.clearAllNotifications();
  }
  isUserSignedIn = false;*/
  customPushAndRemoveUntilSplash(
    context: context,
  );
}

// Custom Push And Remove Until Splash
void customPushAndRemoveUntilSplash({
  @required BuildContext context,
}) {
/*  Navigator.pushAndRemoveUntil(
    context,
    new CupertinoPageRoute(builder: (BuildContext context) {
      return new Splash();
    }),
    (route) => false,
  );*/

//  Navigator.popUntil(
//    context,
//        (route) {
//      return route.runtimeType == Splash();
//    },
//  );
//  Navigator.push(context, new CupertinoPageRoute(builder: (BuildContext context) {
//    return new Splash();
//  }));
}

// Logs out user

// Returns datetime parsing string of format "MM/dd/yy"
DateTime getDateFromString({
  @required String dateString,
}) {
  try {
    return DateTime.parse(dateString);
  } catch (e) {
    return DateTime.now();
  }
}

// CONVERTS DOUBLE INTO RADIANS
num getRadians({@required double value}) {
  return value * (3.14 / 180);
}

class ParentDashboard {}

// Checks target platform
bool isAndroid() {
  return defaultTargetPlatform == TargetPlatform.android;
}

// Asks for exit
Future<bool> askForExit() async {
//  if (canExitApp) {
//    exit(0);
//    return Future.value(true);
//  } else {
//    canExitApp = true;
//    Fluttertoast.showToast(
//      msg: "Please click BACK again to exit",
//      toastLength: Toast.LENGTH_LONG,
//      gravity: ToastGravity.BOTTOM,
//    );
//    new Future.delayed(
//        const Duration(
//          seconds: 2,
//        ), () {
//      canExitApp = false;
//    });
//    return Future.value(false);
//  }
}

// Returns no data view
Widget getNoDataView({
  @required String msg,
  TextStyle messageTextStyle,
  @required VoidCallback onRetry,
}) {
  return new Center(
    child: new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new Text(
          msg ?? "No data found",
          style: messageTextStyle ??
              const TextStyle(
                fontSize: 18.0,
              ),
        ),
        new InkWell(
          onTap: onRetry ?? () {},
          child: new Text(
            "REFRESH",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

// Returns platform specific back button icon
IconData getPlatformSpecificBackIcon() {
  return defaultTargetPlatform == TargetPlatform.iOS
      ? Icons.arrow_back_ios
      : Icons.arrow_back;
}

// Sets name fields
String setName({
  @required String firstName,
  @required String lastName,
}) {
  return (getFirstLetterCapitalized(source: (firstName ?? "")) +
          " " +
          getFirstLetterCapitalized(source: (lastName ?? "")))
      .trim();
}

// Returns first letter capitalized of the string
String getFirstLetterCapitalized({@required String source}) {
  if (source == null && (source?.isNotEmpty ?? true)) {
    return "";
  } else {
    print("source: $source");
    String result = source.toUpperCase().substring(0, 1);
    if (source.length > 1) {
      result = result + source.toLowerCase().substring(1, source.length);
    }
    return result;
  }
}

Widget getAppBar(String title, {StreamController<String> streamController}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70.0),
    child: Material(
      elevation: 0.5,
      child: Container(
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(left: 20.0),
              height: 90.0,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                AssetStrings.filmLogo,
                height: 40.0,
                width: 40.0,
              ),
            ),
            Expanded(
              child: (streamController != null)
                  ? StreamBuilder<String>(
                      stream: streamController.stream,
                      initialData: title,
                      builder: (context, snapshot) {
                        return getTitleWidget(snapshot.data);
                      })
                  : getTitleWidget(title),
            ),
            Container(
              child: InkWell(
                  onTap: () {},
                  child: new Icon(
                    Icons.search,
                    size: 23.0,
                    color: Colors.black,
                  )),
            ),
            Container(
              margin: new EdgeInsets.only(left: 10.0, right: 20),
              child: InkWell(
                  onTap: () {},
                  child: new Icon(
                    Icons.menu,
                    size: 23.0,
                    color: Colors.black,
                  )),
            ),
          ],
        ),
      ),
    ),
  );
  ;
}

Widget getTitleWidget(String title) {
  return new Container(
    alignment: Alignment.center,
    child: Center(
      child: new Text(
        title,
        style: AppCustomTheme.headline20,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

Widget getCommonHeader(List<String> userRoleThumbnail, int type,
    {String name,
    String time,
    String rolemain,
    String subrole,
    int userId,
    BuildContext context}) {
  return Container(
    margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 10),
    padding: new EdgeInsets.symmetric(vertical: 15.0),
    child: IntrinsicHeight(
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: userRoleThumbnail.length > 0
                  ? getSvgNetworkCacheImage(userRoleThumbnail, 42,
                      userid: userId, context: context, name: name)
                  : Container()),
          new SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Container(
              padding: new EdgeInsets.symmetric(vertical: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          goToProfile(context, userId.toString(), name);
                        },
                        child: new Text(
                          name,
                          style: new TextStyle(
                              fontSize: 17,
                              color: AppColors.kHomeBlack,
                              fontFamily: AssetStrings.lotoBoldStyle),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      new Text(
                        time,
                        style: AppCustomTheme.projectDateLikeStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  new SizedBox(
                    height: 3.0,
                  ),
                  Row(
                    children: <Widget>[
                      new Text(
                        subrole,
                        style: new TextStyle(
                            color: AppColors.topNavColor,
                            fontSize: 13.0,
                            fontFamily: AssetStrings.lotoSemiboldStyle),
                      ),
                      new Text(
                        rolemain != null && rolemain.length > 0
                            ? " ($rolemain)"
                            : "",
                        style: new TextStyle(
                            color: AppColors.kPlaceHolberFontcolor,
                            fontSize: 13.0,
                            fontFamily: AssetStrings.lotoRegularStyle),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget getCachedNetworkImage({@required String url, BoxFit fit}) {
  return new CachedNetworkImage(
    width: double.infinity,
    height: double.infinity,
    imageUrl: "$url",
    matchTextDirection: true,
    fit: fit,
    placeholder: (context, String val) {
      return new Center(
        child: new CupertinoActivityIndicator(),
      );
    },
    errorWidget: (BuildContext context, String error, Object obj) {
      print("errro $error");
      return new Center(
        child: Container(
          width: 40,
          height: 40,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kPrimaryBlue,
          ),
        ),
//          child: new SvgPicture.asset(
//        AssetStrings.imageFirst,
//        fit: BoxFit.fill,
//      )
      );
    },
  );
}

shareData() {
  Share.share('check out my website https://example.com',
      subject: 'Look what I made!');
}

Widget getSvgNetworkImage({@required String url, double size}) {
  //print("url ${APIs.imageBaseUrl}$url");
  return new SvgPicture.network(
    "${APIs.imageBaseUrl}$url",
    fit: BoxFit.cover,
    width: size,
    height: size,
    placeholderBuilder: (context) {
      return new Container(
        width: size,
        height: size,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kPrimaryBlue.withOpacity(0.7),
        ),
      );
    },
  );
}

Widget getGenreProject(String genreProject, double margin, double marginTop) {
  return new Container(
    margin: new EdgeInsets.only(left: margin, top: marginTop),
    padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5, bottom: 5),
    decoration: new BoxDecoration(
        color: AppColors.kPrimaryBlue,
        borderRadius: new BorderRadius.circular(5.0)),
    child: new Text(
      genreProject,
      style: new TextStyle(
          fontFamily: AssetStrings.lotoSemiboldStyle,
          color: Colors.white,
          fontSize: 13.0),
    ),
  );
}

Color getStatusColor(String status) {
  Color color = Colors.black;
  switch (status) {
    case "Pending":
      {
        color = Colors.black;
        break;
      }
    case "Accepted":
      {
        color = AppColors.kPrimaryBlue;
        break;
      }
    case "Declined":
      {
        color = AppColors.heartColor;
        break;
      }
    case "Auditioning":
      {
        color = AppColors.twitter;
        break;
      }
  }
  return color;
}

String getStatusIcon(String status) {
  String icon = "";
  switch (status) {
    case "Pending":
      {
        icon = AssetStrings.access_time;
        break;
      }
    case "Accepted":
      {
        icon = AssetStrings.ic_tick;
        break;
      }
    case "Declined":
      {
        icon = AssetStrings.declined;
        break;
      }
    case "Auditioning":
      {
        icon = AssetStrings.personMyProfile;
        break;
      }
  }
  return icon;
}

Widget getCachedNetworkImageWithurl(
    {@required String url, BoxFit fit, double size}) {
  return new CachedNetworkImage(
    width: size,
    height: size,
    imageUrl: "${APIs.imageBaseUrl}$url",
    matchTextDirection: true,
    fit: fit != null ? fit : BoxFit.cover,
    placeholder: (context, String val) {
      return new Center(
        child: new CupertinoActivityIndicator(),
      );
    },
    errorWidget: (BuildContext context, String error, Object obj) {
      print("errro $error");
      return new Center(
        child: Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kGrey,
          ),
        ),
//          child: new SvgPicture.asset(
//        AssetStrings.imageFirst,
//        fit: BoxFit.fill,
//      )
      );
    },
  );
}

Widget getRowWidget(String text, String data, int type,
    {ValueSetter<int> callback, Color color}) {
  return Container(
    height: 50.0,
    child: InkWell(
      onTap: () {
        if (callback != null) {
          callback(type);
        }
      },
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new SvgPicture.asset(
            data,
            width: 16.0,
            height: 16.0,
            color: color != null ? color : Colors.black,
          ),
          new SizedBox(
            width: 5.0,
          ),
          new Text(
            text,
            style: new TextStyle(
                fontFamily: AssetStrings.lotoRegularStyle,
                fontSize: 15.0,
                color: color != null ? color : Colors.black),
          )
        ],
      ),
    ),
  );
}

Widget getStackItem(List<String> list, int type, double size) {
  return Container(
    alignment: Alignment.centerLeft,
    child: new Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[]
        // todo: make dynamic
        ..addAll(new List.generate(list.length, (index) {
          return new Padding(
            padding: new EdgeInsets.only(
              right: index *
                  (28.0), // give left and remove alignment for reverse type
            ),
            child: new Container(
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
                border: new Border.all(
                  width: 2.2,
                  color: Colors.white,
                ),
              ),
              child: ClipOval(
                  child: getSvgNetworkImage(url: list[index], size: size)
              ),
            ),
          );
        })),
    ),
  );
}


Widget getStackItemWithLength(List<String> list, double size) {
  return Container(
    alignment: Alignment.centerLeft,
    child: new Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[]
      // todo: make dynamic
        ..addAll(new List.generate(list.length, (index) {
          return new Padding(
            padding: new EdgeInsets.only(
              right: index *
                  (28.0), // give left and remove alignment for reverse type
            ),
            child: new Container(
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
                border: new Border.all(
                  width: 2.2,
                  color: Colors.white,
                ),
              ),
              child: ClipOval(
                  child: getSvgNetworkImage(url: list[index], size: size)
              ),
            ),
          );
        })),
    ),
  );
}

Widget getSvgNetworkCacheImage(List<String> list, double size,
    {int userid, BuildContext context, String name, int noOfShowing}) {
  return Container(
    alignment: Alignment.centerLeft,
    child: new Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[]
        // todo: make dynamic
        ..addAll(new List.generate(
            noOfShowing != null && noOfShowing < list.length
                ? noOfShowing
                : list.length, (index) {
          return new Padding(
            padding: new EdgeInsets.only(
              right: index *
                  (28.0), // give left and remove alignment for reverse type
            ),
            child: new Container(
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: Colors.grey[400],
                shape: BoxShape.circle,
                border: new Border.all(
                  width: 2.2,
                  color: Colors.white,
                ),
              ),
              child: ClipOval(
                child: noOfShowing != null && noOfShowing < list.length &&
                    index == 0 ? new Container(
                  color: Colors.black.withOpacity(0.3),
                  alignment: Alignment.center,

                  child: new Text(" +${list.length - noOfShowing + 1}",
                    style: new TextStyle(color: Colors.white, fontSize: 16.0),),


                ) : noOfShowing != null && noOfShowing < list.length &&
                    index == noOfShowing - 1 ? new Container(


                  child: list[list.length - 1].contains("svg")
                      ? getSvgNetworkImage(
                      url: list[list.length - 1], size: size)
                      : InkWell(
                    onTap: () {
                      if (userid != null) {
                        goToProfile(context, userid.toString(), name);
                      }
                    },
                    child: getCachedNetworkImageWithurl(
                        url: list[list.length - 1],
                        fit: BoxFit.cover,
                        size: size),
                  ),
                )

                    : list[index].contains("svg")
                    ? getSvgNetworkImage(url: list[index], size: size)
                    : InkWell(
                        onTap: () {
                          if (userid != null) {
                            goToProfile(context, userid.toString(), name);
                          }
                        },
                        child: getCachedNetworkImageWithurl(
                            url: list[index], fit: BoxFit.cover, size: size),
                      ),
              ),
            ),
          );
        })),
    ),
  );
}

goToProfile(BuildContext context, String userId, String name,
    {bool fromComments, bool fromSearchScreen = false}) {
  Navigator.push(
    context,
    new CupertinoPageRoute(builder: (BuildContext context) {
      return MyProfile(
        null,
        null,
        null,
        userId,
        previousTabHeading: name,
        fromComment: fromComments != null ? fromComments : null,
        fromSearchScreen: fromSearchScreen,
      );
    }),
  );
}

Widget getNetworkStackItem(List<String> list, int type, double size) {
  return Container(
    alignment: Alignment.centerLeft,
    child: new Stack(
      alignment: Alignment.centerRight,
      children: <Widget>[]
        // todo: make dynamic
        ..addAll(new List.generate(list.length, (index) {
          return new Padding(
            padding: new EdgeInsets.only(
              right: index *
                  (28.0), // give left and remove alignment for reverse type
            ),
            child: new Container(
              width: size,
              height: size,
              decoration: new BoxDecoration(
                color: Colors.green[400],
                shape: BoxShape.circle,
                border: new Border.all(
                  width: 2.2,
                  color: Colors.white,
                ),
              ),
              child: ClipOval(
                child: type == 0
                    ? getCachedNetworkImage(
                        url: "${APIs.imageBaseUrl}${list[index]}",
                        fit: BoxFit.cover)
                    : new SvgPicture.asset(
                        list[index],
                        fit: BoxFit.cover,
                        width: size,
                        height: size,
                      ),
              ),
            ),
          );
        })),
    ),
  );
}

Widget getHalfScreenProviderLoader({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? AppLoader(
          size: 30.0,
        )
      : new Container();
}

Widget getFullScreenProviderLoader({
  @required bool status,
  @required BuildContext context,
}) {
  return status
      ? getAppThemedLoader(
          context: context,
        )
      : new Container();
}

Widget getFullScreenLoader({
  @required Stream<bool> stream,
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new StreamBuilder<bool>(
    stream: stream,
    initialData: false,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      bool status = snapshot.data;
      return status
          ? getAppThemedLoader(
              context: context,
            )
          : new Container();
    },
  );
}

Widget getHalfScreenLoader({
  @required Stream<bool> stream,
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new StreamBuilder<bool>(
    stream: stream,
    initialData: false,
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      bool status = snapshot.data;
      return status
          ? getHalfAppThemedLoader(
              context: context,
            )
          : new Container();
    },
  );
}

Widget getHalfAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    // color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: 50,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? IfincaColors.kAppYellow,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed loader
Widget getAppThemedLoader({
  @required BuildContext context,
  Color bgColor,
  Color color,
  double strokeWidth,
}) {
  return new Container(
    color: bgColor ?? const Color.fromRGBO(1, 1, 1, 0.6),
    height: getScreenSize(context: context).height,
    width: getScreenSize(context: context).width,
    child: getChildLoader(
      color: color ?? IfincaColors.kAppYellow,
      strokeWidth: strokeWidth,
    ),
  );
}

// Returns app themed list view loader
Widget getChildLoader({
  Color color,
  double strokeWidth,
}) {
  return new Center(
    child: new CircularProgressIndicator(
      backgroundColor: Colors.transparent,
      valueColor: new AlwaysStoppedAnimation<Color>(
        color ?? Colors.white,
      ),
      strokeWidth: strokeWidth ?? 6.0,
    ),
  );
}

// Checks Internet connection
Future<bool> hasInternetConnection({
  @required BuildContext context,
  bool mounted,
  @required Function onSuccess,
  @required Function onFail,
  bool canShowAlert = true,
}) async {
  try {
    final result = await InternetAddress.lookup('google.com')
        .timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      onSuccess();
      return true;
    } else {
      if (canShowAlert) {
        onFail();
        /* showAlert(
          context: context,
          titleText: Localization.of(context).trans(LocalizationValues.error),
          message: Messages.noInternetError,
          actionCallbacks: {
            Localization.of(context).trans(LocalizationValues.ok): () {
              return false;
            }
          },
        );*/
      }
    }
  } catch (_) {
    onFail();
    /*  showAlert(
        context: context,
        titleText: Localization.of(context).trans(LocalizationValues.error),
        message: Messages.noInternetError,
        actionCallbacks: {
          Localization.of(context).trans(LocalizationValues.ok): () {
            return false;
          }
        });*/
  }
  return false;
}

// Show alert dialog
void showAlert(
    {@required BuildContext context,
    String titleText,
    Widget title,
    String message,
    Widget content,
    Map<String, VoidCallback> actionCallbacks}) {
  Widget titleWidget = titleText == null
      ? title
      : new Text(
          titleText.toUpperCase(),
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: dialogContentColor,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        );
  Widget contentWidget = message == null
      ? content != null ? content : new Container()
      : new Text(
          message,
          textAlign: TextAlign.center,
          style: new TextStyle(
            color: dialogContentColor,
            fontWeight: FontWeight.w400,
//            fontFamily: Constants.contentFontFamily,
          ),
        );

  OverlayEntry alertDialog;
  // Returns alert actions
  List<Widget> _getAlertActions(Map<String, VoidCallback> actionCallbacks) {
    List<Widget> actions = [];
    actionCallbacks.forEach((String title, VoidCallback action) {
      actions.add(
        new ButtonTheme(
          minWidth: 0.0,
          child: new CupertinoDialogAction(
            child: new Text(title,
                style: new TextStyle(
                  color: dialogContentColor,
                  fontSize: 16.0,
//                        fontFamily: Constants.contentFontFamily,
                )),
            onPressed: () {
              action();
              alertDialog?.remove();
              alertAlreadyActive = false;
            },
          ),
//          child: defaultTargetPlatform != TargetPlatform.iOS
//              ? new FlatButton(
//                  child: new Text(
//                    title,
//                    style: new TextStyle(
//                      color: IfincaColors.kPrimaryBlue,
////                      fontFamily: Constants.contentFontFamily,
//                    ),
//                    maxLines: 2,
//                  ),
//                  onPressed: () {
//                    action();
//                  },
//                )
//              :
// new CupertinoDialogAction(
//                  child: new Text(title,
//                      style: new TextStyle(
//                        color: IfincaColors.kPrimaryBlue,
//                        fontSize: 16.0,
////                        fontFamily: Constants.contentFontFamily,
//                      )),
//                  onPressed: () {
//                    action();
//                  },
//                ),
        ),
      );
    });
    return actions;
  }

  List<Widget> actions =
      actionCallbacks != null ? _getAlertActions(actionCallbacks) : [];

  OverlayState overlayState;
  overlayState = Overlay.of(context);

  alertDialog = new OverlayEntry(builder: (BuildContext context) {
    return new Positioned.fill(
      child: new Container(
        color: Colors.black.withOpacity(0.7),
        alignment: Alignment.center,
        child: new WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: new Dialog(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(10.0),
            ),
            child: new Material(
              borderRadius: new BorderRadius.circular(10.0),
              color: IfincaColors.kWhite,
              child: new Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
                child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                            ),
                            child: titleWidget,
                          ),
                          contentWidget,
                        ],
                      ),
                    ),
                    new Container(
                      height: 0.6,
                      margin: new EdgeInsets.only(
                        top: 24.0,
                      ),
                      color: dialogContentColor,
                    ),
                    new Row(
                      children: <Widget>[]..addAll(
                          new List.generate(
                            actions.length +
                                (actions.length > 1 ? (actions.length - 1) : 0),
                            (int index) {
                              return index.isOdd
                                  ? new Container(
                                      width: 0.6,
                                      height: 30.0,
                                      color: dialogContentColor,
                                    )
                                  : new Expanded(
                                      child: actions[index ~/ 2],
                                    );
                            },
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  });

  if (!alertAlreadyActive) {
    alertAlreadyActive = true;
    overlayState.insert(alertDialog);
  }
}

// Closes keyboard by clicking any where on screen
void closeKeyboard() {
  SystemChannels.textInput.invokeMethod('TextInput.hide');
}

void launchUrl(String url) async {
//
  print("launch url $url");
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Could not launch $url');
  }
}

String readTimestamp(String timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('hh:mm a');
  var date =
      new DateTime.fromMicrosecondsSinceEpoch(int.parse(timestamp) * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}

String readTimestampGroupChatTop(num timestamp, String formatRequired) {
  var format = new DateFormat(formatRequired);
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);

  return format.format(date);
}

String formatDateString(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    return DateFormat('d MMMM').format(dateTime);
  } catch (e) {
    print("date error ${e.toString()}");
    return "";
  }
}

String getProjectGroupId(String projectId) {
  return "filmshapegroup$projectId";
}

String formatDateStringMyProject(String dateString, String formate) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    return DateFormat(formate).format(dateTime);
  } catch (e) {
    print("date error ${e.toString()}");
    return "";
  }
}

bool checkLikeUserId(List<int> likedBy) {
  bool isLike = false;
  var id = MemoryManagement.getuserId();
  for (var userId in likedBy) {
    if (userId.toString() == id) {
      isLike = true;
      break;
    }
  }
  return isLike;
}

String formatDateTimeString(String dateString) {
  try {
    DateTime dateTime = DateTime.parse(dateString);

    var currenttime = DateFormat('d MMM').format(DateTime.now());
    var time = DateFormat('d MMM').format(dateTime);

    if (currenttime == time) {
      DateTime dateToday = DateTime.now();
      var diffDt = dateToday.difference(dateTime);

      var hour = diffDt.inHours;
      var min = diffDt.inMinutes;
      var sec = diffDt.inSeconds;
      var miliseconnd = diffDt.inMilliseconds;

      if (hour > 0) {
        return "${hour}h";
      } else if (min > 0) {
        return "${min}m";
      } else if (sec > 0) {
        return "${sec}s";
      } else if (miliseconnd > 0) {
        return "1s";
      }
      return "1s";
    }

    return DateFormat('d MMM').format(dateTime);
  } catch (e) {
    print("date error ${e.toString()}");
    return "";
  }
}

String formatCurrentDateString() {
  try {
    return DateFormat('d MMMM').format(DateTime.now());
  } catch (e) {
    print("date error ${e.toString()}");
    return "";
  }
}

void updateUserInfo(int type, dynamic data) {
  try {
    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      switch (type) {
        //name
        case 1:
          userResponse.user.fullName = data as String;
          break;
        //profile
        case 2:
          userResponse.user.thumbnailUrl = data as String;
          break;
        //location
        case 3:
          userResponse.user.location = data as String;
          break;
        //roles
        case 4:
          userResponse.user.roles = data as List<Roles>;
          break;
      }

      //save it after update
      var userFinalData = jsonEncode(userResponse.toJson());
      MemoryManagement.setUserData(data: userFinalData);
    }
  } catch (ex) {
    print("erro ${ex.toString()}");
  }
}

Widget appBarBackButton({onTap}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70.0),
    child: Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 20,
              ),
              InkWell(onTap: onTap, child: new Icon(Icons.arrow_back)),
              new SizedBox(
                width: 5.0,
              ),
              InkWell(
                onTap: onTap,
                child: new Text(
                  "Back",
                  style: AppCustomTheme.backButtonStyle,
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 2,
            color: AppColors.gray_tab.withOpacity(0.2),
          )
        ],
      ),
    ),
  );
}

Widget getEmptyView(String message) {
  return Center(
      child: Text(
    message,
    style: AppCustomTheme.notDataTextStyle,
  ));
}

// protocol and www neutral
String getVideoId(String url, List<String> prefixes) {
  var cleaned = url.replaceAll("/^(https?:)?\\/\\/(www\.)?/", '');
  for (var i = 0; i < prefixes.length; i++) {
    print("cleaned code $cleaned");
    if (cleaned.indexOf(prefixes[i]) == 0)
      return cleaned.substring(prefixes[i].length);
  }
  return "";
}

String getYouTubeId(url) {
  return getVideoId(url, [
    'youtube.com/watch?v=',
    'youtu.be/',
    'youtube.com/embed/',
    'youtube.googleapis.com/v/',
    'https://www.youtube.com/watch?v=',
    'https://youtu.be/',
    'https://youtube.com/embed/',
    'https://youtube.googleapis.com/v/'
  ]);
}

String getVimeoId(url) {
  return getVideoId(url, [
    'vimeo.com/',
    'player.vimeo.com/',
    'https://vimeo.com/',
    'https://player.vimeo.com/'
  ]);
}

bool isProUser() {
  return MemoryManagement?.getUpgradedAccount() ?? false;
}
