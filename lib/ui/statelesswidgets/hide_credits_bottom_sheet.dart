import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/hide_credits/hide_credit_request.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';

class HideCreditBottomSheetWidget extends StatelessWidget {

  final String projectId;

  HideCreditBottomSheetWidget({@required this.projectId});

  BehaviorSubject<bool> checkBox = new BehaviorSubject();
  HomeListProvider provider;
  BuildContext context;

  void hideCredit() async {
    provider.setLoading();
    var request = HideCreditRequest(hideCredit: checkBox.value);
    var response = await provider.hideCredits(context, request, projectId);
    if (response is APIError) {
     // Navigator.pop(context, false);
      showAlert(
        context: context,
        titleText: "Error",
        message: response.error??"",
        actionCallbacks: {"OK": () {}},
      );
    }
    else {
      Navigator.pop(context, true); //credit updated
    }
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    provider = Provider.of<HomeListProvider>(context);
    return Padding(
      padding: MediaQuery
          .of(context)
          .viewInsets,
      child: Container(

        child: new Wrap(

          children: <Widget>[

            Container(
              margin: new EdgeInsets.only(
                  left: 30.0, right: 20.0, top: 15.0),
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  InkWell(
                    onTap: () {
                     Navigator.pop(context);
                    },
                    child: new Row(children: <Widget>[
                      new Icon(Icons.keyboard_arrow_down, size: 29.0),
                      new SizedBox(
                        width: 4.0,
                      ),
                      new Text(
                        "Close",
                        style: new TextStyle(
                            color: Colors.black,
                            fontSize: 16.0),
                      ),
                    ],),
                  ),

                  Expanded(
                    child: new SizedBox(
                      width: 55.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if(isProUser())
                      hideCredit();
                      else
                        {
                          showAlert(
                            context: context,
                            titleText: "Error",
                            message: "Only Pro user can hide the credits.",
                            actionCallbacks: {"OK": () {}},
                          );
                        }
                    },
                    child: new Container(
                      padding: new EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 10.0),
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
                    ),
                  ),
                ],
              ),
            ),


            new Container(
              margin: new EdgeInsets.only(top: 15.0),
              height: 0.5,
              color: Colors.grey.withOpacity(0.4),
            ),

            new Center(
              child: getHalfScreenProviderLoader(
                status: provider.getLoading(),
                context: context,
              ),
            ),
            Container(
              margin: new EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 40.0),
              child: new Text(
                "Edit credit",
                style: new TextStyle(
                    color: Colors.black,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    fontSize: 21.0
                ),
              ),
            ),

            Container(
              margin: new EdgeInsets.only(
                  left: 40.0, right: 40.0, top: 10.0),
              child: new Text(
                "For more project settings, open the project and select 'Project settings'.",
                style: new TextStyle(
                    color: AppColors.introBodyColor,
                    fontFamily: AssetStrings.lotoRegularStyle,
                    fontSize: 15.0,
                    height: 1.2
                ),
              ),
            ),
            new Container(
              margin: new EdgeInsets.only(
                  left: 40.0, right: 20.0, top: 35.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(5.0),
                border: new Border.all(
                    color: Colors.grey.withOpacity(0.6),
                    width: INPUT_BOX_BORDER_WIDTH),
              ),
              padding: new EdgeInsets.symmetric(
                  horizontal: 11.0, vertical: 1.0),
              child: new Row(
                children: <Widget>[
                  new SizedBox(
                    width: 10.0,
                  ),
                  new Icon(
                    Icons.visibility_off, color: Colors.black, size: 18,),


                  new SizedBox(
                    width: 10.0,
                  ),

                  Expanded(child: new Text(
                    "Hide project on my profile", style: new TextStyle(
                      fontFamily: AssetStrings.lotoRegularStyle,
                      fontSize: 15),)),


                  StreamBuilder<bool>(
                    stream: checkBox.stream,
                    builder: (context, snapshot) {
                      return Checkbox(

                        value: snapshot.hasData ? snapshot.data : false,

                        onChanged: (bool value) {
                          checkBox.add(value);
                        },
                      );
                    },
                  ),

                ],
              ),
            ),


            new Container(
              height: 50.0,

            ),


          ],
        ),
      ),
    );
  }
}