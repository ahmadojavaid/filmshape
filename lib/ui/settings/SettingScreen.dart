import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/ui/payment_screen/PaymentScreen.dart';
import 'package:Filmshape/ui/settings/AccountsAndSecurityScreen.dart';
import 'package:Filmshape/ui/settings/ContactSupportScreen.dart';
import 'package:Filmshape/ui/settings/PushNotificationScreen.dart';
import 'package:Filmshape/ui/settings/ReportViolationScreen.dart';
import 'package:Filmshape/ui/settings/settings_connect_account.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  final ValueChanged<Widget> fullScreenCallBack;
  String previousTabHeading;

  SettingScreen(this.fullScreenCallBack, {this.previousTabHeading});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Notifier _notifier;
  String version;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      _notifier?.notify('action', "Settings"); //update title
      getVersionDetails();
    });
  }

  void getVersionDetails() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //update previous heading
    if (widget.previousTabHeading != null)
      _notifier?.notify('action', widget.previousTabHeading);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifier = NotifierProvider.of(context); // to update home screen header

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new SizedBox(
                  height: 30.0,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SettingHeader(
                        text: "Account",
                        iconPath: AssetStrings.account_person)),
                SizedBox(
                  height: 15.0,
                ),
                InkWell(
                    onTap: () {
                      widget
                          .fullScreenCallBack(new AccountsANdSecurityScreen());
                    },
                    child: _getTextView("Account and Security")),
                _getView(),
                InkWell(
                    onTap: () {
                      //if current user is not pro user
                      if(!isProUser())
                      widget.fullScreenCallBack(PaymentScreen());
                    },
                    child: Notifier.of(context).register<String>(ACCOUNT_UPGRADED_NOTIFIER,
                            (data) {

                          return getTwoSidedTxtView("Membership", isProUser()?"Pro":"Free");
                        })),

                _getView(),
                InkWell(
                    onTap: () {
                      widget.fullScreenCallBack(new PushNotificationScreen());
                    },
                    child: _getTextView("Push notifications")),
                _getView(),
                InkWell(
                    onTap: () {
                      widget.fullScreenCallBack(new SettingsConnectAccount());
                    },
                    child: _getTextView("Connected accounts")),
                _getView(),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SettingHeader(
                        text: "Support", iconPath: AssetStrings.liveHelp)),
                SizedBox(
                  height: 15.0,
                ),
                InkWell(
                    onTap: () {
                      widget.fullScreenCallBack(new ContactSupportScreen());
                    },
                    child: _getTextView("Contact Support")),
                _getView(),
                InkWell(
                    onTap: () {
                      widget.fullScreenCallBack(new ReportViolationScreen());
                    },
                    child: _getTextView("Report a violation")),
                _getView(),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: SettingHeader(
                        text: "Terms and policies",
                        iconPath: AssetStrings.files)),
                SizedBox(
                  height: 15.0,
                ),
                InkWell(
                    onTap: _launchURL,
                    child: _getTextView("Terms and conditions")),
                _getView(),
                InkWell(
                    onTap: _launchURL, child: _getTextView("Privacy policy")),
                _getView(),
                InkWell(
                    onTap: _launchURL, child: _getTextView("Cookie policy")),
                _getView(),
                _getTextView("Disclaimer"),
                _getView(),
                SizedBox(
                  height: 10.0,
                ),
                getTwoSidedTxtView("App version", version ?? "0.0"),
                SizedBox(
                  height: 40.0,
                ),
              ]),
        ),
      ),
    );
  }

  Widget _getTextView(String txt) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 18.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            txt,
            style: TextStyle(
                color: AppColors.settingBlackText,
                fontSize: 16.0,
                fontFamily: AssetStrings.lotoRegularStyle),
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
      ],
    );
  }

  Widget getTwoSidedTxtView(String txt1, String txt2) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 18.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Text(
                  txt1,
                  style: TextStyle(
                      color: AppColors.settingBlackText,
                      fontSize: 16.0,
                      fontFamily: AssetStrings.lotoRegularStyle),
                ),
              ),
              Spacer(),
              Text(
                txt2,
                style: TextStyle(
                    color: AppColors.settingBlackText,
                    fontSize: 16.0,
                    fontFamily: AssetStrings.lotoRegularStyle),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 18.0,
        ),
      ],
    );
  }

  Widget _getView() {
    return new Container(
      height: 1.0,
      color: AppColors.dividerColorsSettings,
    );
  }

  _launchURL() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class SettingHeader extends StatelessWidget {
  final String text;
  final String iconPath;

  SettingHeader({@required this.text, @required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        new SvgPicture.asset(
          iconPath,
          width: 24.0,
          height: 24.0,
          fit: BoxFit.cover,
          color: AppColors.payment_background,
        ),
        new SizedBox(
          width: 10.0,
        ),
        new Text(
          text,
          style: new TextStyle(
              color: Colors.black,
              fontFamily: AssetStrings.lotoRegularStyle,
              fontSize: 20.0),
        ),
      ],
    );
  }
}
