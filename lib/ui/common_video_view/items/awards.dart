import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/awards/add_awards_request.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:Filmshape/ui/common_video_view/items/award_details.dart';
import 'package:Filmshape/ui/create_project/add_awards_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class AwardsTab extends StatefulWidget {
  final List<Award> list;
  bool saveAward;

  AwardsTab({this.list, this.saveAward = true});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<AwardsTab>
    with AutomaticKeepAliveClientMixin<AwardsTab> {
  HomeListProvider providers;

  TextEditingController _TitleController = new TextEditingController();
  TextEditingController _DescriptionConrroller = new TextEditingController();
  FocusNode _EmailField = new FocusNode();
  FocusNode _PasswordField = new FocusNode();


  addAdwards(String id) async {
    providers.setLoading();

    ProjectsAwards projects = new ProjectsAwards(type: "Project", id: id);

    AddAwardsRequest request = new AddAwardsRequest(
        project: projects,
        title: _TitleController.text,
        description: _DescriptionConrroller.text,
        url: "http.filshape.com");

    var response = await providers.addAward(context, request);

    providers.hideLoader();
    if (response is Award) {
      Navigator.pop(context);
      setState(() {});
    } else {
      APIError apiError = response;
      print(apiError.messag[0]);
      showInSnackBar(apiError.messag[0]);
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  Widget getTextFieldBottomSheet(
      String labelText,
      TextEditingController controller,
      FocusNode focusNodeCurrent,
      FocusNode focusNodeNext,
      TextInputType textInputType,
      int max,
      {bool enabled = true}) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      child: new TextFormField(
        controller: controller,
        focusNode: focusNodeCurrent,
        maxLines: max,
        enabled: enabled,
        style: AppCustomTheme.ediTextStyle,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(),
            contentPadding: new EdgeInsets.only(
                top: 14.0, bottom: 14.0, left: 14.0, right: 10.0),
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26, width: 1.0),
            ),
            focusColor: Colors.brown),
      ),
    );
  }

//  void _settingModalBottomSheet(String id) {
//    GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();
//
//    showModalBottomSheet<void>(
//        isScrollControlled: true,
//        context: context,
//        shape: RoundedRectangleBorder(
//          borderRadius: BorderRadius.only(
//              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
//        ),
//        builder: (BuildContext bc) {
//          return Padding(
//            padding: MediaQuery.of(context).viewInsets,
//            child: Form(
//              key: _fieldKey,
//              child: Container(
//                height: getScreenSize(context: context).height / 2.0,
//                child: SingleChildScrollView(
//                  child: Stack(
//                    children: <Widget>[
//                      new Column(
//                        children: <Widget>[
//                          Container(
//                            margin: new EdgeInsets.only(
//                                left: 30.0, right: 20.0, top: 10.0),
//                            child: new Row(
//                              crossAxisAlignment: CrossAxisAlignment.center,
//                              children: <Widget>[
//                                InkWell(
//                                    onTap: () {
//                                      Navigator.pop(context);
//                                    },
//                                    child: new Icon(Icons.keyboard_arrow_down,
//                                        size: 29.0)),
//                                new SizedBox(
//                                  width: 4.0,
//                                ),
//                                InkWell(
//                                  onTap: () {
//                                    Navigator.pop(context);
//                                  },
//                                  child: new Text(
//                                    "Close",
//                                    style: new TextStyle(
//                                        color: Colors.black, fontSize: 16.0),
//                                  ),
//                                ),
//                                Expanded(
//                                  child: new SizedBox(
//                                    width: 55.0,
//                                  ),
//                                ),
//                                Offstage(
//                                  offstage: !widget.saveAward,
//                                  child: InkWell(
//                                    onTap: () {
//                                      addAdwards(id);
//                                    },
//                                    child: new Container(
//                                      padding: new EdgeInsets.symmetric(
//                                          vertical: 6.0, horizontal: 13.0),
//                                      decoration: new BoxDecoration(
//                                          border: new Border.all(
//                                              color:
//                                                  AppColors.delete_save_border,
//                                              width: 1.0),
//                                          borderRadius:
//                                              new BorderRadius.circular(16.0),
//                                          color:
//                                              AppColors.delete_save_background),
//                                      child: new Row(
//                                        children: <Widget>[
//                                          new Icon(
//                                            Icons.save,
//                                            color: Colors.black45,
//                                            size: 17.0,
//                                          ),
//                                          new SizedBox(
//                                            width: 5.0,
//                                          ),
//                                          new Text(
//                                            "Save",
//                                            style: new TextStyle(
//                                                color: Colors.black,
//                                                fontSize: 15.0),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
//                          Container(
//                            margin: new EdgeInsets.only(top: 30.0),
//                            child: getTextFieldBottomSheet(
//                                "Award title",
//                                _TitleController,
//                                _EmailField,
//                                _PasswordField,
//                                TextInputType.emailAddress,
//                                1,
//                                enabled: false),
//                          ),
//                          new Container(
//                            height: 20.0,
//                            child: new Text(""),
//                          ),
//                          getTextFieldBottomSheet(
//                              "Description",
//                              _DescriptionConrroller,
//                              _PasswordField,
//                              _PasswordField,
//                              TextInputType.text,
//                              6,
//                              enabled: false),
//                          new Container(
//                            height: 20.0,
//                            child: new Text("  "),
//                          )
//                        ],
//                      ),
//                      new Center(
//                          child: getHalfScreenProviderLoader(
//                        status: providers.getLoading(),
//                        context: context,
//                      )),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          );
//        });
//  }

  Iterable<Widget> get awardsWidgets sync* {
    if (widget.list != null) {
      if (widget.list.length <= 3) {
        for (Award data in widget.list) {
          yield getListTileItem(data.title ?? "The big film festival", data, 0);
        }

      }
      else {
        for (int i = 0; i < widget.list.length; i++) {
          if (i == 3) {
            break;
          }

          yield getListTileItem(
              widget.list[i].title ?? "The big film festival", widget.list[i],
              i);
        }
      }
    }
  }



  void showAwardBottomSheet(String projectIDs, Award award) async {
    var response = await showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddAwardsBottomSheet(
                projectIDs,
                award: award,
                saveAward: widget.saveAward,
              ),
            ),
          );
        });
    if (response is Award) {
      for (var data in widget.list) {
        if (data.id == response.id) {
          data.title = response.title;
          data.url = response.url;
          data.awardInstitution = response.awardInstitution;
          data.description = response.description;

          break;
        }
      }

      showInSnackBar("Award updated");
      setState(() {});
    }
  }

  Widget getListTileItem(String title, Award award, int index) {
    return InkWell(
      onTap: () {
        if (_TitleController.text.length == 0) {
          _TitleController.text = award.title;
        }
        if (_DescriptionConrroller.text.length == 0) {
          _DescriptionConrroller.text = award.description;
        }

        showAwardBottomSheet(award.id.toString(), award);
        //_settingModalBottomSheet(award.id.toString());
      },
      child: Column(
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 30.0, right: 30.0),
            padding: new EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            child: new Row(
              children: <Widget>[
                new SvgPicture.asset(
                  AssetStrings.imgStar,
                  width: 20.0,
                  height: 20.0,
                ),
                new SizedBox(
                  width: 14.0,
                ),
                Expanded(
                  child: Container(
                      child: Text(
                    title,
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoRegularStyle,
                        fontSize: 16),
                  )),
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                  size: 28.0,
                ),
              ],
            ),
          ),
          getDivider(),


          InkWell(
            onTap: () {
              Navigator.push(
                context,
                new CupertinoPageRoute(builder: (BuildContext context) {
                  return new AwardDetails(
                    roleCalls: widget.list, saveAward: widget.saveAward,);
                }),
              );
            },
            child: Offstage(
              offstage: index == 2 && widget.list != null &&
                  widget.list.length > 3 ? false : true,
              child: Container(
                margin: new EdgeInsets.only(top: 15.0),
                child: new Center(
                    child: new Text(
                      "Show more", style: new TextStyle(
                        color: AppColors.kPrimaryBlue,
                        fontSize: 15.0,
                        fontFamily: AssetStrings.lotoBoldStyle),)
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDivider() {
    return new Container(
      height: 1.0,
      color: Colors.grey.withOpacity(0.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    providers = Provider.of<HomeListProvider>(context);

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          color: Colors.white,
          child: widget.list != null && widget.list.length > 0
              ? new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getDivider(),
              new Container(
                  child: new Wrap(
                    children: awardsWidgets.toList(),
                  )),
            ],
          )
              : Container(
              height: TAB_ITEM_HEIGHT,
              color: Colors.white,
              child: new Center(
                  child: new Text(
                    "No Award Found",
                    style: new TextStyle(
                        color: AppColors.kPrimaryBlue,
                        fontSize: 15.0,
                        fontFamily: AssetStrings.lotoBoldStyle),
                  ))),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
