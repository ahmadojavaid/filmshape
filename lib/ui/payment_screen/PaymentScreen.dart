import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifier/main_notifier.dart';
import 'package:notifier/notifier_provider.dart';

class PaymentScreen extends StatefulWidget {

  final ValueChanged<bool> callback;

  PaymentScreen({this.callback});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Notifier _notifier;

  Widget getItem(String icon, String text) {
    return Container(
      margin: new EdgeInsets.only(left: 25.0, top: 25.0),
      alignment: Alignment.center,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SvgPicture.asset(
            icon,
            color: AppColors.kPrimaryBlue,
            width: 20.0,
            height: 20.0,
          ),
          new SizedBox(
            width: 15.0,
          ),
          Expanded(
            child: new Text(
              text,
              style: new TextStyle(
                  fontFamily: AssetStrings.lotoRegularStyle, fontSize: 16.0),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _notifier = NotifierProvider.of(context); // to update home screen header
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: new Stack(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    new Container(
                      width: size.width,
                      height: size.height / 3.2,
                      color: AppColors.payment_background,
                    ),

                    Positioned(
                      bottom: -(size.width / 2) / 2 - 10,
                      left: 0,
                      right: 0,
                      child: Container(
                        child: new SvgPicture.asset(
                          AssetStrings.payment_image_bottom_view,
                          width: size.width / 2,
                          height: size.width / 2,

                        ),
                      ),
                    ),
                  ],
                ),

                Positioned(
                  right: -35.0,
                  top: -35.0,
                  child: Container(
                    alignment: Alignment.topRight,
                    child: new SvgPicture.asset(
                      AssetStrings.payment_image_top_new,
                      width: 80,
                      height: 80.0,
                    ),
                  ),
                ),


                new Column(
                  children: <Widget>[

                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },


                      child: Container(
                        margin: new EdgeInsets.only(left: 25.0, top: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            new SizedBox(
                              width: 5.0,
                            ),
                            new Text(
                              "Back",
                              style: AppCustomTheme.backButtonWhiteStyle,
                            )
                          ],
                        ),
                      ),
                    ),
                    new Container(
                      width: 40,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(5.0)),
                      child: new Text(
                        "Pro",
                        style: new TextStyle(
                            fontFamily: AssetStrings.lotoBoldStyle,
                            color: AppColors.kPrimaryBlue),
                      ),
                    ),
                    new Container(
                      margin: new EdgeInsets.only(top: 15.0),
                      alignment: Alignment.center,
                      child: new Text(
                        "New features with Filmshape",
                        style: new TextStyle(
                            fontFamily: AssetStrings.lotoSemiboldStyle,
                            color: Colors.white,
                            fontSize: 23),
                      ),
                    ),
                    new SizedBox(
                        height: 7
                    ),
                    new Text(
                      "2.99/month",
                      style: new TextStyle(
                          fontFamily: AssetStrings.lotoBoldStyle,
                          color: Colors.white,
                          fontSize: 14),
                    ),

                    /*   Container(
                        width: 100,
                        height: 100,
                        child: new Image.asset(AssetStrings.propayment)),
*/

                    new SizedBox(
                      height: size.height / 6.5,
                    ),

                    new SizedBox(
                      height: 5.0,
                    ),
                    getItem(AssetStrings.joinProjectDrawer,
                        "Create projects with unlimited members."),
                    getItem(AssetStrings.share, "Get your profile featured."),
                    getItem(AssetStrings.imgStar, "Add awards to projects."),
                    getItem(
                        AssetStrings.imageVisiOff, "Set projects to private."),
                    getItem(
                        AssetStrings.addProjectItem,
                        "Add project managers to your projects."),
                    new SizedBox(
                      height: 60,
                    ),

                    Container(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            new TextSpan(
                              text: "We're a small team and every membership\n makes a difference. ",
                              style: new TextStyle(
                                  fontFamily: AssetStrings.lotoRegularStyle,
                                  fontSize: 16.0,
                                  color: AppColors.kBlack
                              ),
                            ),
                            WidgetSpan(
                              child: Icon(Icons.favorite, size: 14,
                                color: AppColors.heartColor,),
                            ),
                          ],
                        ),
                      ),
                    ),


                    new SizedBox(
                      height: 30.0,
                    ),
                    getContinueProfileSetupDarkBlueButton(
                        callback, "Upgrade"),
                    new SizedBox(
                      height: 20.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context); //close screen
                      },
                      child: new Text(
                        "No thanks",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    new SizedBox(
                      height: 10.0,
                    ),

                  ],
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }

  VoidCallback callback() {
    MemoryManagement.setUpgradedAccount(true); //mark account purchased
    _notifier?.notify(
        ACCOUNT_UPGRADED_NOTIFIER, "pro"); //update heading
    if (widget.callback != null) {
      widget.callback(true);
    }
    Navigator.pop(context);

  }
}
