import 'dart:async';
import 'dart:io';

import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/SignUp/suggested_location.dart';
import 'package:Filmshape/Model/youtubeauth/youtube_auth_token_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/UniversalProperties.dart';
import 'package:Filmshape/Utils/autocomplete_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifier/main_notifier.dart';

import 'APIs.dart';
import 'AppColors.dart';
import 'AssetStrings.dart';
import 'Constants/AppCustomTheme.dart';
import 'Constants/Const.dart';
import 'memory_management.dart';



Widget getItemDivider() {
  return Padding(
      padding: const EdgeInsets.only(left: 40, top: 3, bottom: 3),
      child: new Container(
        height: ITEM_DIVIDER,
        color: AppColors.kGrey,
      ));
}

Widget getEmptyRefreshWidget(BuildContext context, String message,
    VoidCallback onPressed, bool isEnabled) {
  var screenSize = MediaQuery.of(context).size;
  return new Container(
    height: screenSize.height,
    width: screenSize.width,
    child: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Icon(
              Icons.youtube_searched_for,
              size: 50,
              color: AppColors.kAppBlack,
            ),
            SizedBox(
              height: 8,
            ),
            new Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppColors.kAppBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            new FlatButton(
                onPressed: isEnabled ? onPressed : null,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(
                      Icons.refresh,
                      color: AppColors.kAppBlack,
                    ),
                    new Text(
                      "Refresh",
                      style:
                      new TextStyle(fontSize: 18.0, color: AppColors.kAppBlack),
                    ),
                  ],
                ))
          ],
        )),
  );
}

// Returns app bar
Widget getAppbar(String title) {
  return new AppBar(
    centerTitle: true,
    title: new Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}

getProfileAndCoverPicWidget(String url, File localImage) {
  if (url != null && url.isNotEmpty && localImage == null) {
//    return CachedNetworkImageProvider(
//        (url.contains(FB_IMAGE_URL_PREFIX))
//            ? "$url?width=$FB_G_PHOTO_SIZE&heigth=$FB_G_PHOTO_SIZE"
//            : (url.contains(
//            G_IMAGE_URL_PREFIX)) ? "$url?sz=$FB_G_PHOTO_SIZE" : url
//
//    );
  } else {
    return (localImage == null)
        ? AssetImage(NO_COVER_IMAGE_FOUND)
        : new FileImage(
      localImage,
    );
  }
}

getChatWidget({@required int count, @required Function onClick}) {
  return Stack(
    children: <Widget>[
      Center(
          child: InkWell(
            onTap: () {
              onClick();
            },
            child: new Icon(Icons.chat, size: 25.0, color: Colors.black87),
          )),
      Align(
        alignment: Alignment.topRight,
        child: getNotificationCount(count),
      )
    ],
  );
}

getNotificationCount(int count) {
  return (count > 0)
      ? ClipOval(
    child: Container(
      color: Colors.red,
      height: 22.0, // height of the button
      width: 22.0, // width of the button
      child: Center(
        child: Text(
          (count < 10) ? "$count" : "9+",
          style: TextStyle(fontSize: 10),
        ),
      ),
    ),
  )
      : Container();
}

Widget appLogo()
{
  return  new  SvgPicture.asset(
    AssetStrings.filmLogo,
    height: 100,
    width: 100,
  );
}


Widget getContinueProfileSetupButtonLight(VoidCallback callback, String text,) {
  return
    Container(
      height: 50.0,

      margin: new EdgeInsets.only(
          left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [

          BoxShadow(
            color: AppColors.blueButtonColorCode.withOpacity(
                0.2),
            blurRadius: 2.0,
            // has the effect of softening the shadow
            spreadRadius: 2.0,
            // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Material(
        borderRadius: new BorderRadius.circular(5.0),
        child: Ink(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),

              color: AppColors.blueButtonColorCode),
          child: InkWell(
            borderRadius: new BorderRadius.circular(5.0),
            splashColor: AppColors.blueButtonColorCode.withOpacity(
                0.8),
            onTap: () {
              callback();
            },
            child: new Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new SizedBox(
                    width: 40.0,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: new EdgeInsets.symmetric(
                          vertical: 5.0),
                      child: Text(
                        text,
                        style: AppCustomTheme.button,
                      ),
                    ),
                  ),
                  new Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  new SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}


Widget getContinueProfileSetupButtonLightWithoutIcon(VoidCallback callback,
    String text,) {
  return
    Container(
      height: 50.0,

      margin: new EdgeInsets.only(
          left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [

          BoxShadow(
            color: AppColors.blueButtonColorCode.withOpacity(
                0.2),
            blurRadius: 2.0,
            // has the effect of softening the shadow
            spreadRadius: 2.0,
            // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Material(
        borderRadius: new BorderRadius.circular(5.0),
        child: Ink(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),

              color: AppColors.blueButtonColorCode),
          child: InkWell(
            borderRadius: new BorderRadius.circular(5.0),
            splashColor: AppColors.blueButtonColorCode.withOpacity(
                0.8),
            onTap: () {
              callback();
            },
            child: new Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[

                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: new EdgeInsets.symmetric(
                          vertical: 5.0),
                      child: Text(
                        text,
                        style: AppCustomTheme.button,
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
}


Widget getContinueProfileSetupDarkBlueButton(VoidCallback callback,
    String text) {
  return
    Container(
      height: 50.0,

      margin: new EdgeInsets.only(
          left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(28.0),
      ),
      child: Material(
        borderRadius: new BorderRadius.circular(28.0),
        child: Ink(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(28.0),

              color: AppColors.blues),
          child: InkWell(
            borderRadius: new BorderRadius.circular(25.0),
            splashColor: AppColors.blues.withOpacity(
                0.8),
            onTap: () {
              callback();
            },
            child: new Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new SizedBox(
                    width: 40.0,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: new EdgeInsets.symmetric(
                          vertical: 5.0),
                      child: Text(
                        text,
                        style: AppCustomTheme.button,
                      ),
                    ),
                  ),
                  new Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20.0,
                  ),
                  new SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}



Widget getContinueProfileSetupButton(VoidCallback callback,String text) {
  return
    Container(
      height: 50.0,

      margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: [

          BoxShadow(
            color: Colors.deepPurpleAccent.withOpacity(
                0.2),
            blurRadius: 2.0,
            // has the effect of softening the shadow
            spreadRadius: 2.0,
            // has the effect of extending the shadow
            offset: Offset(
              0.0, // horizontal, move right 10
              2.0, // vertical, move down 10
            ),
          )
        ],
      ),
      child: Material(
        borderRadius: new BorderRadius.circular(5.0),
        child: Ink(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.circular(5.0),

              color: AppColors.kPrimaryBlue),
          child: InkWell(
            borderRadius: new BorderRadius.circular(5.0),
            splashColor: AppColors.kPrimaryBlue.withOpacity(
                0.8),
            onTap: () {
              callback();
            },
            child: new Container(
              alignment: Alignment.center,
              child: Row(
                children: <Widget>[
                  new SizedBox(
                    width: 40.0,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      padding: new EdgeInsets.symmetric(
                          vertical: 5.0),
                      child: Text(
                        text,
                        style: AppCustomTheme.button,
                      ),
                    ),
                  ),
                  new Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18.0,
                  ),
                  new SizedBox(
                    width: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
}


Widget _loader(StreamController<bool> _streamControllerShowLoader) {
  return new StreamBuilder<bool>(
      stream: _streamControllerShowLoader.stream,
      initialData: false,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        bool status = snapshot.data;
        return status
            ? Center(child: CupertinoActivityIndicator(radius: 10))
            : new Container();
      });
}

Future<List<String>> getLocationSuggestionsList(String locationText) async {
  Dio dio = Dio();
  CancelToken _requestToken;

  //if search text length is greater than 0 than return blank array
  if (locationText.length == 0)
    return List();

  List<String> suggestionList = List();

  try {
    if (_requestToken != null)
      _requestToken.cancel(); //cancel the previous on going request
    _requestToken = CancelToken(); //generate new token for new request
    //call the apoi
    var response = await dio
        .get(
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$locationText&key=AIzaSyDZ-dGhsAHzvrFfdpFkk5cpJpZfJ6mbR9I",
        cancelToken: _requestToken
    )
        .timeout(timeoutDuration);
    //get the suggestion list
    var locationList = SuggestedLocation.fromJson(response.data);
    print("ress $response");

    //get description list and add to string list
    for (var data in locationList.predictions) {
      suggestionList.add(data.description);
    }
  } on DioError catch (e) {}
  catch (e) {}

  return suggestionList;
}

Widget getLocation(TextEditingController controller, BuildContext context,
    StreamController<bool> _streamControllerShowLoader,{IconData iconData,double iconPadding=0}) {
  return Container(
    margin: new EdgeInsets.only(
        left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
    child: Stack(
      children: <Widget>[
        AutoCompleteTextView(

          isLocation:true,
          defaultPadding: iconPadding,
          icon: iconData,
          hintText: "Location",
          suggestionsApiFetchDelay: 100,
          focusGained: () {},
          onTapCallback: (String text) async {
            // addData(text);
            print(text);

          },
          focusLost: () {
            print("focust lost");
          },
          onValueChanged: (String text) {
            print("called $text");
          },
          controller: controller,
          suggestionStyle: Theme
              .of(context)
              .textTheme
              .body1,
          getSuggestionsMethod: getLocationSuggestionsList,

          tfTextAlign: TextAlign.left,
          tfTextDecoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Location",

          ),
        ),
        Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: _loader(_streamControllerShowLoader))
      ],
    ),
  );
}

Widget getNoData(String message) {
  return new Text(message,
    style:  AppCustomTheme.backButtonThemeStyle);
}

Widget getSetupButton(VoidCallback callback, String text, double margin,
    {Color newColor})
{
  return Container(
    height: 50.0,

    margin: new EdgeInsets.only(left: margin, right: margin),
    decoration: new BoxDecoration(
      borderRadius: new BorderRadius.circular(8.0),
      boxShadow: [

        BoxShadow(
          color: (newColor == null) ? AppColors.kPrimaryBlue.withOpacity(
              0.2) : AppColors.searchTalentColor.withOpacity(
              0.2),
          blurRadius: 2.0,
          // has the effect of softening the shadow
          spreadRadius: 2.0,
          // has the effect of extending the shadow
          offset: Offset(
            0.0, // horizontal, move right 10
            2.0, // vertical, move down 10
          ),
        )
      ],
    ),
    child: Material(
      borderRadius: new BorderRadius.circular(5.0),
      child: Ink(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),

            color: (newColor == null) ? AppColors.kPrimaryBlue : AppColors
                .searchTalentColor),

        child: InkWell(
          borderRadius: new BorderRadius.circular(5.0),
          splashColor: (newColor == null) ? AppColors.kPrimaryBlue : AppColors
              .searchTalentColor,
          onTap: () {
            callback();
          },
          child: new Container(
            alignment: Alignment.center,
            child: new Text(
              text,
              style: AppCustomTheme.button,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget getProfileWidget(String url)
{
  print("url ${APIs.imageBaseUrl}$url");
  return Container(
      height: PROFILE_IMAGE_W_H,
      width: PROFILE_IMAGE_W_H,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          border: new Border.all(
              color: Colors.grey.withOpacity(0.5),
              width: 1.0),
          color: Colors.grey.withOpacity(0.2)),
      child: ClipOval(
        child: getCachedNetworkImage(
            url:
            "${APIs.imageBaseUrl}$url",
            fit: BoxFit.cover),
      ));
}


Widget getSetupDecoratorButton(VoidCallback callback, String text,
    double margin,
    {Color newColor}) {
  return Container(
    height: 50.0,

    margin: new EdgeInsets.only(left: margin, right: margin),
    decoration: new BoxDecoration(
      borderRadius: new BorderRadius.circular(8.0),

    ),
    child: Material(
      borderRadius: new BorderRadius.circular(5.0),
      child: Ink(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),

            border: new Border.all(
                width: 1.0,
                color: AppColors.borderWhiteButton
            ),

            color: Colors.white

        ),

        child: InkWell(
          borderRadius: new BorderRadius.circular(5.0),

          onTap: () {
            callback();
          },
          child: new Container(
            alignment: Alignment.center,
            child: new Text(
              text,
              style: AppCustomTheme.buttonWhite,
            ),
          ),
        ),
      ),
    ),
  );
}
Widget getTextFieldBottomSheet(double marginTop,
    Function validators,
    String labelText,
    TextEditingController controller,
    FocusNode focusNodeCurrent,
    FocusNode focusNodeNext,
    bool obsectextType,
    TextInputType textInputType,
    IconData data,
    {int maxLines = 1}) {
  return Container(
    margin: new EdgeInsets.only(
        left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT, top: marginTop),
    child: new TextFormField(
      validator: validators,
      controller: controller,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      maxLines: maxLines,
      style: AppCustomTheme.ediTextStyle,
      textAlignVertical: TextAlignVertical.top,
      textCapitalization: TextCapitalization.sentences,
      decoration: new InputDecoration(
          border: new OutlineInputBorder(),
          contentPadding: new EdgeInsets.only(
              top: 14.0, bottom: 14.0, left: 14.0, right: 10.0),
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          prefix: Padding(
            padding: const EdgeInsets.only(
                right: 8.0),
            child: new Icon(
              data,
              color: Colors.black,
              size: 18.0,
            ),
          ),
          focusColor: Colors.brown),
    ),
  );
}

Widget bottomSheetSaveButton() {
  return new Container(
    padding: new EdgeInsets.symmetric(
        vertical: 6.0, horizontal: 13.0),
    decoration: new BoxDecoration(
        border: new Border.all(
            color: AppColors.delete_save_border,
            width: 1.0),
        borderRadius: new BorderRadius.circular(16.0),
        color: AppColors.delete_save_background),
    child: new Row(
      children: <Widget>[
        new Icon(
          Icons.save,
          color: Colors.black45,
          size: 17.0,
        ),
        new SizedBox(
          width: 5.0,
        ),
        new Text(
          "Save",
          style: new TextStyle(
              color: Colors.black, fontSize: 15.0),
        ),
      ],
    ),
  );
}

Widget bottomSheetCloseButton() {
  return new Row(
    children: <Widget>[
      new Icon(Icons.keyboard_arrow_down, size: 29.0),
      new SizedBox(
        width: 4.0,
      ),
      new Text(
        "Close",
        style: new TextStyle(
            color: Colors.black, fontSize: 16.0),
      ),
    ],
  );
}

Widget divider() {
  return Container(
    margin: new EdgeInsets.only(top: 20),
    color: AppColors.dividerColor,
    height: 0.9,
  );
}

Widget getUserProfileImageView(File image, VoidCallback callback,
    String thumbUrl) {
  return Container(
    width: 150.0,
    height: 150.0,
    margin: new EdgeInsets.only(left: 40.0, right: 20.0),
    child: new Row(
      children: <Widget>[
        Stack(
          children: <Widget>[
            new Container(
              width: 132.0,
              height: 132.0,
            ),
            InkWell(
              onTap: () {
                callback();
              },
              child: Container(
                child: new Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                        border:
                        new Border.all(color: Colors.black12, width: 0.3),
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.1)),
                    child: getImage(image, thumbUrl)
                ),
              ),
            ),
            new Positioned(
                top: 0.0,
                right: 0.0,
                child: Container(
                  padding: new EdgeInsets.symmetric(
                      vertical: 2.0, horizontal: 5.0),
                  margin: new EdgeInsets.only(top: 40.0),
                  decoration: new BoxDecoration(
                      border:
                      new Border.all(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: new BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: new InkWell(
                      onTap: () {
                        callback();
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Icon(
                            Icons.camera_alt,
                            size: 14.0,
                          ),
                          new SizedBox(
                            width: 3.0,
                          ),
                          new Text(
                            "Edit",
                            style: AppCustomTheme.body13Bold,
                          )
                        ],
                      )),
                ))
          ],
        ),
        new SizedBox(
          width: 15.0,
        ),
      ],
    ),
  );
}

Widget getImage(File _image, String _profileThumbImage) {
  return new CircleAvatar(
      backgroundColor: Colors.white24,
      child: (_image != null) ? new Container(
          width: 100.0,
          height: 100.0,
          child: ClipOval(
            child: new Image.file(
              _image,
              fit: BoxFit.cover,
            ),
          )) :
      (_profileThumbImage != null && _profileThumbImage.length > 0) ? ClipOval(
        child: getCachedNetworkImage(
            url:
            "${APIs.imageBaseUrl}${_profileThumbImage ?? ""}",
            fit: BoxFit.cover),
      ) :
      new Image.asset(
        AssetStrings.logoImage,
        width: 100.0,
        height: 100.0,
      )

  );
}

Widget getTextField(Function validators,
    String labelText,
    TextEditingController controller,
    FocusNode focusNodeCurrent,
    FocusNode focusNodeNext,
    bool obsectextType,
    TextInputType textInputType,
    {IconData prefixIcon, int maxlines = 1, Notifier notifier, bool enable}) {
  return Container(
    margin: new EdgeInsets.only(
        left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),

    child: new TextFormField(
      validator: validators,
      controller: controller,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      keyboardType: textInputType,
      style: AppCustomTheme.ediTextStyle,
      textCapitalization: TextCapitalization.sentences,
      maxLines: maxlines,
      autofocus: false,
      enabled: enable != null ? enable : true,
      decoration: new InputDecoration(
        border: new OutlineInputBorder(),
        contentPadding: new EdgeInsets.symmetric(
            vertical: TextFormField_Veritical_Margin,
            horizontal:
            TextFormField_Horizontal_Margin),
        labelText: labelText,
        labelStyle: AppCustomTheme.labelEdiTextRegular,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.creatreProfileBordercolor, width: INPUT_BOX_BORDER_WIDTH),
        ),
        prefixIcon: (prefixIcon != null&&maxlines==1) ? Padding(
          padding: const EdgeInsets.only(right: 16.0,left: ICON_LEFT_PADDING),
          child: new Icon(
            prefixIcon,
            color: Colors.black,
            size: 16.0,
          ),
        ) : null,
        prefix: (prefixIcon != null&&maxlines>1) ? Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: new Icon(
            prefixIcon,
            color: Colors.black,
            size: 16.0,
          ),
        ) : null,
      ),
      onChanged: (value){
        notifier?.notify('action', value);
      },
        textAlign: TextAlign.start,
        onFieldSubmitted: (value) {
     //   focusNodeCurrent.unfocus();
       // FocusScope.of(context).autofocus(focusNodeNext);
      },

    ),
  );
}

Widget getHeightWeightTextField(bool fullWidth,
    Function validators,
    String labelText,
    TextEditingController controller,
    FocusNode focusNodeCurrent,
    FocusNode focusNodeNext,
    bool obsectextType,
    String hint,
    TextInputType textInputType, {bool enable}) {
  return Container(
    margin: new EdgeInsets.only(
        left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
    width: 150,
    child: new TextFormField(
      validator: validators,
      controller: controller,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      keyboardType: TextInputType.number,
      enabled: enable != null ? enable : true,
      textInputAction: TextInputAction.next,
      style: AppCustomTheme.ediTextStyle,

      onFieldSubmitted: (value) {
        focusNodeCurrent.unfocus();

//        if (focusNodeCurrent == _WeightField) {} else {
//          FocusScope.of(context).autofocus(focusNodeNext);
//        }
      },

      onChanged: (String value) {

      },

      decoration: new InputDecoration(
        border: new OutlineInputBorder(),
        contentPadding: new EdgeInsets.symmetric(
            vertical: TextFormField_Veritical_Margin,
            horizontal: TextFormField_Horizontal_Margin),
        labelText: labelText,
        suffixText: hint,
        prefixStyle: TextStyle(color: Colors.blue),
        labelStyle: AppCustomTheme.labelEdiTextRegular,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.creatreProfileBordercolor,
              width: INPUT_BOX_BORDER_WIDTH),
        ),),
    ),
  );
}


Widget getDateofBirthTextField(bool fullWidth,
    Function validators,
    String labelText,
    TextEditingController controller,
    FocusNode focusNodeCurrent,
    FocusNode focusNodeNext,
    bool obsectextType,
    String hint,
    TextInputType textInputType, {bool enable}) {
  return Container(
    margin: new EdgeInsets.only(
        left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
    width: 150,
    child: new TextFormField(
      validator: validators,
      controller: controller,
      obscureText: obsectextType,
      focusNode: focusNodeCurrent,
      keyboardType: TextInputType.number,
      enabled: enable != null ? enable : true,
      textInputAction: TextInputAction.next,
      style: AppCustomTheme.ediTextStyle,
      textCapitalization: TextCapitalization.sentences,

      onFieldSubmitted: (value) {
        focusNodeCurrent.unfocus();

//        if (focusNodeCurrent == _WeightField) {} else {
//          FocusScope.of(context).autofocus(focusNodeNext);
//        }
      },

      onChanged: (String value) {

      },

      decoration: new InputDecoration(
        border: new OutlineInputBorder(),
        contentPadding: new EdgeInsets.symmetric(
            vertical: TextFormField_Veritical_Margin,
            horizontal: TextFormField_Horizontal_Margin),
        labelText: labelText,
        suffixText: hint,
        prefixStyle: TextStyle(color: Colors.blue),
        labelStyle: AppCustomTheme.labelEdiTextRegular,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: AppColors.creatreProfileBordercolor,
              width: INPUT_BOX_BORDER_WIDTH),
        ),),
    ),
  );
}


Widget saveButton(Color color)
{
  return new Container(
    padding: new EdgeInsets.symmetric(
        vertical: 6.0, horizontal: 10.0),
    decoration: new BoxDecoration(
        border: new Border.all(
            color: AppColors.delete_save_border,
            width: 1.0),
        borderRadius:
        new BorderRadius.circular(20.0),
        color: color.withOpacity(0.03)),
    child: new Row(
      children: <Widget>[
        new Icon(
          Icons.save,
          color: AppColors.topNavColor,
          size: 18.0,
        ),
        new SizedBox(
          width: 5.0,
        ),
        new Text(
          "Save",
          style: new TextStyle(
              fontFamily: AssetStrings.lotoRegularStyle,
              color: AppColors.topNavColor,
              fontSize: 15.0),
        ),
      ],
    ),
  );
}

Widget paidUnPaidWidget(String title,bool isPaid)
{
  return new Container(
    padding: new EdgeInsets.symmetric(vertical: 12.0, horizontal: 23.0),
    alignment: Alignment.center,
    decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: AppColors.creatreProfileBordercolor,
            width: INPUT_BOX_BORDER_WIDTH),
        color: isPaid
            ? AppColors.kPrimaryBlue
            : Colors.transparent),
    child: new Text(
      title,
      style: new TextStyle(
          color: isPaid
              ? Colors.white
              : AppColors.kPlaceHolberFontcolor,
          fontFamily: AssetStrings.lotoRegularStyle,
          fontSize: 17.0),
    ),
  );
}

Widget backButton(String title, VoidCallback callback) {
  return PreferredSize(
    preferredSize: Size.fromHeight(70.0),
    child: Material(
      elevation: 1.0,
      color: AppColors.white,
      child: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(width: 35,),
            InkWell(
              onTap: () {
                callback();
              },
              child: Row(children: <Widget>[
                new Icon(
                  Icons.keyboard_backspace,
                  size: 25.0,
                  color: Colors.black,
                ),
                new SizedBox(
                  width: 8.0,
                ),
                new Text(
                  title,
                  style: new TextStyle(
                      fontFamily: AssetStrings.lotoSemiboldStyle,
                      fontSize: 16.0),
                ),
              ],),
            ),
            Expanded(child: SizedBox(height: 70,),)
          ],
        ),
      ),
    ),
  );
}

Widget editData(VoidCallback callBack) {
  return new Positioned(
      top: 0.0,
      right: 0.0,
      child: InkWell(
        onTap: () {
          callBack();
        },
        child: new Container(
          decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.circular(16.0)),
          margin: new EdgeInsets.only(right: 30.0, top: 22.0),
          padding: new EdgeInsets.symmetric(
              vertical: 5.0, horizontal: 16.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.link,
                color: Colors.black87,
                size: 17.0,
              ),
              new SizedBox(
                width: 5.0,
              ),
              new Container(
                child: new Text(
                  "Edit",
                  style: AppCustomTheme.editSaveButtonStyle,
                ),
              )
            ],
          ),
        ),
      ));
}
Widget attributeHeading(String text, String image, Color images, Color border,
    int type) {
  return new Container(
    margin: new EdgeInsets.only(left: 40.0, right: 40.0),
    decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: border,
            width: INPUT_BOX_BORDER_WIDTH),
        color: Colors.white),
    padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        type == 3 ? new Image.asset(
          image,
          width: 19.0,
          height: 19.0,
          color: images,
        ) : new Image.asset(
          image,
          width: 19.0,
          height: 19.0,
        ),
        new SizedBox(
          width: 11.0,
        ),

        new Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AssetStrings.lotoRegularStyle,
              fontSize: 15),
        ),
      ],
    ),
  );
}

Widget inviteUserAttributeHeading(String text, IconData icon, Color border) {
  return new Container(
    margin: new EdgeInsets.only(left: 40.0, right: 40.0),
    decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: border,
            width: INPUT_BOX_BORDER_WIDTH),
        color: Colors.white),
    padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
    child: new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        Icon(
          icon,
          color: Colors.black,
          size: 20.0,
        ),
        new SizedBox(
          width: 11.0,
        ),

        new Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: Colors.black,
              fontFamily: AssetStrings.lotoRegularStyle,
              fontSize: 15),
        ),
      ],
    ),
  );
}

bool isCurrentUser(String userId) {
  var currentUserId = MemoryManagement.getuserId();
  return (currentUserId == userId);
}


Widget getBackButton(String userId,BuildContext context,bool showit) {
  return (!isCurrentUser(userId)&&showit) ? Positioned(
    top: 6, left: 15, child: InkWell(
      onTap: (){
        Navigator.pop(context);
      },
      child: Icon(
      Icons.arrow_back,
      color: Colors.black,
  ),
    ),) : Container();
}


//for youtube auth in native
TargetPlatform platform;
const platformType = const MethodChannel('flutter.native/helper');

//get response from android
Future<dynamic> androidYoutubeLogin() async {
  try {
    var data = await platformType.invokeMethod('helloFromNativeCode');
    if (data is Map) {
      print("data ${data.toString()}");
      if (data.containsKey("result")) {
        bool isKey = data["result"];
        //success
        if (isKey) {
          String token = data["token"];
          print("youtube toke $token");
          YoutubeAuthTokenResponse authTokenResponse = new YoutubeAuthTokenResponse(
              accessToken: token);
          return authTokenResponse;
        }
        //no key found
        else {
          APIError apiError = new APIError(
              error: "flutter get result failed", status: 400);
          return apiError;
        }
      }
    }
  } on PlatformException catch (e) {
    APIError apiError = new APIError(error: "Not implemented for IOS", status: 400);
    return apiError;
  }
}
