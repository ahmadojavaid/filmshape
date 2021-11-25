import 'package:Filmshape/Utils/AppColors.dart';
import 'package:flutter/material.dart';

import '../AssetStrings.dart';

class AppCustomTheme {
  AppCustomTheme._();

  static var headline26 = TextStyle(
      fontSize: 24,
      fontFamily: AssetStrings.lotoBoldStyle,
      letterSpacing: 0.5);


  static var headline24 = TextStyle(
      color: AppColors.topTitleColor,
      fontSize: 23,
      fontFamily: AssetStrings.lotoSemiboldStyle,
      letterSpacing: 0.5);

  static var headlineBold24 = TextStyle(
      color: AppColors.topTitleColor,
      fontSize: 21,
      fontFamily: AssetStrings.lotoBoldStyle,
      letterSpacing: 0.5);


  static var headline20 =  TextStyle(
    color: AppColors.topNavColor,
    fontSize: 18,
    fontFamily: AssetStrings.lotoBoldStyle,
  );


  static var headline21 = TextStyle(
    color: AppColors.seacrhBackground,
    fontSize: 16.5,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var descriptionIntro = TextStyle(
    color: AppColors.introBodyColor,
    fontSize: 15,
    height: 1.5,
     fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var descriptionDetailTab = TextStyle(
    color: AppColors.introBodyColor,
    fontSize: 14,
    height: 1.2,
    letterSpacing: 0.4,
    fontFamily: AssetStrings.lotoRegularStyle,
  );


  static var descriptionIntro13 = TextStyle(
    color: AppColors.introBodyColor,
    fontSize: 13.0,
    height: 1.5,
    letterSpacing: 0.4,
    fontFamily: AssetStrings.lotoRegularStyle,
  );


  static var black16 = TextStyle(
    color: AppColors.topTitleColor,
    fontSize: 16,
    height: 1.3,
    letterSpacing: 0.4,
    fontFamily: AssetStrings.lotoRegularStyle,
  );


  static var labelTextBlack17 =  TextStyle(
    fontSize: 16,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var labelTextPrimary19 =  TextStyle(
    fontSize: 18,
    color: AppColors.kPrimaryBlue,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var body1 =  TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var body13Bold =  TextStyle(
    color: Colors.black,
    fontSize: 13,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );



  static var body14Regular = TextStyle(
    color: Colors.black.withOpacity(0.8),
    fontSize: 14,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var body14SemiBold = TextStyle(
    color: Colors.black.withOpacity(0.8),
    fontSize: 14,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );

  static var body16 = TextStyle(
      fontFamily: AssetStrings.lotoLightStyle,
      fontSize: 15,
      color: Colors.black.withOpacity(0.9));

  static var button =  TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );
  static var buttonWhite = TextStyle(
    fontSize: 16,
    color: AppColors.splashBlack,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );


  static var button16 =  TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );

  static var subhead =  TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );


  //create profile screen
  static const  ediTextStyle = TextStyle(
    color: Colors.black,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static const labelEdiTextRegular = const TextStyle(
    fontFamily: AssetStrings.lotoRegularStyle,
  );


  static const labelEdiTextRegularCustom = const TextStyle(
      fontFamily: AssetStrings.lotoRegularStyle,
      color: AppColors.kActiveFontcolor
  );


  static const labelSingup = const TextStyle(
      fontFamily: AssetStrings.lotoRegularStyle,
      color: AppColors.introBodyColor,
      height: 1.2
  );



  static var roleHeadingStyle = TextStyle(
      fontSize: 16,
      fontFamily: AssetStrings.lotoBoldStyle,
      letterSpacing: 0.5);

  static var roleSubHeadingSelectedStyle = TextStyle(
      fontSize: 15,
      fontFamily: AssetStrings.lotoBoldStyle,
      letterSpacing: 0.5);

  static var roleSubHeadingNoteSelectedStyle = TextStyle(
      fontSize: 15,
      fontFamily: AssetStrings.lotoLightStyle,
      letterSpacing: 0.5);

  static var body15Regular = TextStyle(
    color: Colors.black.withOpacity(0.7),
    fontSize: 14,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var createProfileSubTitle = TextStyle(
    fontSize: 20,
    fontFamily: AssetStrings.lotoRegularStyle,
  );


  static var createProfileSubTitleBottomSheet = TextStyle(
    fontSize: 16,
    fontFamily: AssetStrings.lotoRegularStyle,
  );
  static var selectRolesTitle = TextStyle(
      fontSize: 18,
      fontFamily: AssetStrings.lotoRegularStyle,
      color: Colors.black87
  );

  static var backButtonStyle = TextStyle(
    fontSize: 16,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var backButtonWhiteStyle = TextStyle(
      fontSize: 16,
      fontFamily: AssetStrings.lotoRegularStyle,
      color: Colors.white
  );

  static var backButtonThemeStyle = TextStyle(
    fontSize: 17,
    color:Colors.deepPurpleAccent,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var createAccountLink = TextStyle(
    fontSize: 15,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  //suggested friend list

  static var suggestedFriendNameStyle = TextStyle(
    fontSize: 15,
    fontFamily: AssetStrings.lotoBoldStyle,
  );


  static var detailTabNameStyle = TextStyle(
    fontSize: 18,
    fontFamily: AssetStrings.lotoBoldStyle,
  );


  static var suggestedFriendMyReelStyle = TextStyle(
    fontSize: 12,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var followingTextStyle = TextStyle(
    fontSize: 13.5,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  static var suggestedFriendFollowButtonStyle = TextStyle(
    fontSize: 13,
    fontFamily: AssetStrings.lotoLightStyle,
  );


  static var tabSelectedVideoTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: AssetStrings.lotoBoldStyle,

  );


  static var tabUnSelectedVideoTextStyle = TextStyle(
    fontSize: 15.5,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  //profile final screen button
  static var profileCreatedButtonStyle = TextStyle(
    color: AppColors.kPrimaryBlue, fontSize: 16,
    fontFamily: AssetStrings.lotoRegularStyle,
  );

  //video list
  static var videoItemTitleStyle =  TextStyle(
    fontSize: 15,
    fontFamily: AssetStrings.lotoSemiboldStyle,
  );
  
  
  //myprofile
  static var myProfileAttributeHeadingStyle = TextStyle(
    fontSize: 17,
      fontFamily: AssetStrings.lotoLightStyle,
      );


  static var myProfileAttributeHeadingJoinProject = TextStyle(
    fontSize: 15,
    fontFamily: AssetStrings.lotoLightStyle,
  );


  static var myProfileAttributeStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontFamily: AssetStrings.lotoBoldStyle,
      );

  //user project item
  static var projectHeadingStyle=  TextStyle(
   fontSize: 18.0,
  fontFamily: AssetStrings.lotoSemiboldStyle);

  static var projectDateLikeStyle=  TextStyle(
      fontSize: 15.0,
      fontFamily: AssetStrings.lotoRegularStyle);

  static var editSaveButtonStyle=  TextStyle(
      fontSize: 14.0,
      fontFamily: AssetStrings.lotoRegularStyle);

  static var profileUserStyle= TextStyle(
  fontFamily: AssetStrings.lotoBoldStyle,
  fontSize: 18.0);

  static var profileUserLocationStyle=  new TextStyle(
      fontSize: 15.0,
      fontFamily: AssetStrings.lotoRegularStyle);

  static var bottomNavigationBar=  new TextStyle(
      fontFamily: AssetStrings.lotoBoldStyle);


  static var notDataTextStyle=  new TextStyle(
      fontSize: 15.0,
      fontFamily: AssetStrings.lotoSemiboldStyle);

  static var chatUserNameStyle=new TextStyle(
      color: AppColors.kHomeBlack,
  fontSize: 14.0,
  fontFamily: AssetStrings.lotoBoldStyle);

}


