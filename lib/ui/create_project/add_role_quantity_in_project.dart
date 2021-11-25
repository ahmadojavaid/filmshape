import 'dart:convert';

import 'package:Filmshape/Model/Login/LoginResponse.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Utils/APIs.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/ui/search_for_talent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AddRoleQuantityInProject extends StatefulWidget {
  final AddRoleTabResponse addedRoleResponse;
  final ValueSetter<int> callBackAssignRole;
  final AddRoleDetails response;
  final String title;


  const AddRoleQuantityInProject(this.addedRoleResponse, this.callBackAssignRole, this.response,
      this.title,
      {Key key})
      : super(key: key);

  @override
  AddRoleQuantityInProjectState createState() =>
      AddRoleQuantityInProjectState();
}

class AddRoleQuantityInProjectState extends State<AddRoleQuantityInProject>
    with AutomaticKeepAliveClientMixin<AddRoleQuantityInProject>
{
  FocusNode _HeightField = new FocusNode();
  FocusNode _WeightField = new FocusNode();
  FocusNode _BioField = new FocusNode();
  FocusNode _SearchField = new FocusNode();
  FocusNode _SallaryField = new FocusNode();
  FocusNode _NameField = new FocusNode();

  TextEditingController _BioController = new TextEditingController();
  TextEditingController _HeightController = new TextEditingController();
  TextEditingController _WeightController = new TextEditingController();
  TextEditingController _FullNameController = new TextEditingController();
  TextEditingController _SalaryController = new TextEditingController();

  ValueNotifier<bool> paidUnpaidNotifier = new ValueNotifier(true);

  ValueNotifier<bool> hideSalaryChangeNotifier=new ValueNotifier(false);

  CreateProfileProvider provider;
  String gender;
  String ethinics;
  String name;
  String thumburl;
  bool offstageAssign = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check if already assigned
    if(widget.response!=null&&widget.response.assignee!=null)
      {
        offstageAssign=!offstageAssign;
      }

    var userData = MemoryManagement.getUserData();
    if (userData != null) {
      Map<String, dynamic> data = jsonDecode(userData);
      LoginResponse userResponse = LoginResponse.fromJson(data);
      name = userResponse.user.fullName ?? "";
      thumburl = userResponse.user.thumbnailUrl ?? "";
    }
    //only when role is non actor
    if(widget.title == "Actor" || widget.title == "Actor (Extra)")
      Future.delayed(const Duration(milliseconds: 300), () {
        hitGenderApi();
        hitEthicsApi();
      });

    if (widget.response != null) {
      _HeightController.text =
      (widget.response.height != null)
          ? widget.response.height.toString()
          : "0";
      _WeightController.text = (widget.response.weight != null)
          ? widget.response.weight.toString()
          : "0";
      _FullNameController.text =
      widget.response.name != null ? widget.response.name.toString() : "";
      _SalaryController.text = (widget.response.salary != null)
          ? widget.response.salary.toString()
          : "0";
      _BioController.text =
      widget.response.description != null ? widget.response.description
          .toString() : "";

      paidUnpaidNotifier.value = widget.response.expensesPaid ?? false;

      if (widget.response.gender != null) {
        gender = widget.response.gender.name;
      }

      hideSalaryChangeNotifier.value = widget.response.hideSalary ?? false;


      if (widget.response.ethnicity != null) {
        ethinics = widget.response.ethnicity.name;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  hitEthicsApi() async {
    var response = await provider.getEthicity(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  hitGenderApi() async {
    var response = await provider.getGender(context);

    if ((response is APIError)) {
      showInSnackBar(response.error);
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  void quickAccessVideoLinkBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  Container(
                    margin:
                    new EdgeInsets.only(left: 30.0, right: 30.0, top: 17.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Row(
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
                          ),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 55.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  new Container(
                    height: 1,
                    color: AppColors.dividerColor,
                    margin: new EdgeInsets.only(top: 17.0),
                  ),
                  Container(
                    margin:
                    new EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
                    child: new Text(
                      "Invite user to role",
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 22.0),
                    ),
                  ),
                  Container(
                    margin:
                    new EdgeInsets.only(left: 40.0, right: 40.0, top: 5.0),
                    child: new Text(
                      "Invite a user whether they use Filmshape or not.",
                      style: new TextStyle(
                          color: AppColors.introBodyColor,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 16.0),
                    ),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child: attributeHeading(
                        "Search Filmshape users", AssetStrings.search_new, 1),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 15.0),
                    child:
                    attributeHeading(
                        "Share via email", AssetStrings.shareEmail, 2),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 15.0),
                    child: attributeHeading(
                        "Get shareable link", AssetStrings.shareLink, 3),
                  ),
                  new Container(
                    height: 20.0,
                    child: new Text("  "),
                  )
                ],
              ),
            ),
          );
        });
  }


  Widget attributeHeading(String text, String image, int type) {
    String projectName=MemoryManagement.getCurrentProjectName();
    return InkWell(
      onTap: () {
        //search for talent
        if (type == 1) {
          Navigator.pop(context);
          Navigator.push(
              context,
              new CupertinoPageRoute(builder: (BuildContext context) {
                return new SearchForTalent(previousTabHeading:projectName ,showBackButton: true,);
              }));
        }
        //share via email
        else if (type == 2) {
          launchUrl("mailto:smith@example.org?subject=News&body=New%20plugin");
        }
        //get shareable link
        else if (type == 3) {
          launchUrl("mailto:smith@example.org?subject=News&body=New%20plugin");
        }

      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.circular(5.0),
            border: new Border.all(
                color: AppColors.creatreProfileBordercolor,
                width: INPUT_BOX_BORDER_WIDTH),
            color: Colors.white),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 13.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // new Image.asset(image,width: 18.0,height: 18.0),

            new Image.asset(
              image,
              width: 15.0,
              height: 15.0,
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
      ),
    );
  }

  Widget getDropdownItem(String title, List<String> list, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          if (provider.genderList.length == 0) {
            provider.setLoading();
            hitGenderApi();
          }
        } else if (type == 2) {
          if (provider.ethicityList.length == 0) {
            provider.setLoading();
            hitEthicsApi();
          }
        }
      },
      child: Container(
        margin: new EdgeInsets.only(
            left: MARGIN_LEFT_RIGHT, right: MARGIN_LEFT_RIGHT),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(
              color: AppColors.creatreProfileBordercolor,
              width: INPUT_BOX_BORDER_WIDTH),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 3.0),
        child: FormField<String>(
          builder: (FormFieldState<String> state) {
            return InputDecorator(
              decoration: InputDecoration.collapsed(hintText: ""),
              isEmpty: title == '',
              child: Container(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: title,
                    isDense: true,
                    isExpanded: true,
                    hint: new Text(type == 1 ? "Gender" : "Ethnicity"),
                    onChanged: (String newValue) {
                      print(newValue);
                      title = newValue;
                      state.didChange(newValue);
                      if (type == 1) {
                        gender = newValue;
                      } else {
                        ethinics = newValue;
                      }
                      setState(() {});
                    },
                    items: list.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppCustomTheme.ediTextStyle,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget videoLinkView(String text, String image, Color color, int type) {
    return InkWell(
      onTap: () {
        if (type == 1) {
          quickAccessVideoLinkBottomSheet();
        }
        else { //assign role to self
          if (widget.addedRoleResponse != null)
            widget.callBackAssignRole(widget.addedRoleResponse.id);
          else
            widget.callBackAssignRole(widget.response.id);
        }
      },
      child: new Container(
        margin: new EdgeInsets.only(left: 40.0, right: 40.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(5.0),
          border: new Border.all(color: color, width: INPUT_BOX_BORDER_WIDTH),
        ),
        padding: new EdgeInsets.symmetric(horizontal: 7.0, vertical: 12.0),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new SizedBox(
              width: 12.0,
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: new Text(
                  text,
                  style: new TextStyle(
                      fontSize: 15,
                      fontFamily: AssetStrings.lotoRegularStyle,
                      color: color),
                ),
              ),
            ),
            new SvgPicture.asset(
              image,
              width: 20.0,
              height: 20.0,
              color: color,
            ),
            new SizedBox(
              width: 12.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);

    return Container(
      child: new ListView(
        children: <Widget>[
          new Container(
            height: 1,
            color: AppColors.dividerColor,
          ),
          Offstage(
            offstage: !offstageAssign,
            child: new SizedBox(
              height: 32.0,
            ),
          ),
          Offstage(
            offstage: !offstageAssign,
            child: videoLinkView(
                "Invite user to role", AssetStrings.send,
                AppColors.kPrimaryBlue,
                1),
          ),
          Offstage(
            offstage: !offstageAssign,
            child: new SizedBox(
              height: 20.0,
            ),
          ),
          Offstage(
            offstage: !offstageAssign,
            child: videoLinkView(
                "Assign myself to role", AssetStrings.personMyProfile,
                Colors.black, 2),
          ),
          new SizedBox(
            height: 10.0,
          ),
          new Offstage(
            offstage: offstageAssign,
            child: assignMyRole(),
          ),

          Offstage(
            offstage: offstageAssign,
            child: new SizedBox(
              height: 30.0,
            ),
          ),

          new Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,
            child: getTextField(
              validatorName,
              "Character Name",
              _FullNameController,
              _NameField,
              _BioField,
              false,
              TextInputType.text,
            ),
          ),

           sizeBox,

          getTextField(validatorBio, "Description", _BioController, _BioField,
              _HeightField, false, TextInputType.text,
              maxlines: 6),

          new Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,
            child: sizeBox,
          ),


          Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,

            child: getDropdownItem(gender,
                provider.genderList != null ? provider.genderList : null, 1),
          ),

          new Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,
            child: sizeBox,
          ),


          Offstage(
              offstage: widget.title == "Actor" ||
                  widget.title == "Actor (Extra)" ? false : true,

              child: getDropdownItem(ethinics, provider.ethicityList, 2)),

          new Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,
            child: sizeBox,
          ),


          Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,

            child: getHeightWeightTextField(
                false,
                validatorHeight,
                "Height",
                _HeightController,
                _HeightField,
                _WeightField,
                false,
                "cm",
                TextInputType.text),
          ),

          new Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,
            child: sizeBox,
          ),

          Offstage(
            offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                ? false
                : true,

            child: getHeightWeightTextField(
                false,
                validatorWeight,
                "Weight",
                _WeightController,
                _WeightField,
                _SearchField,
                false,
                "kg",
                TextInputType.text),
          ),

          new SizedBox(
            height: 30.0,
          ),
          Container(
            margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT, top: 20.0),
            child: new Text(
              "Expenses",
              style: AppCustomTheme.createProfileSubTitle,
            ),
          ),
          sizeBox,
          InkWell(
            onTap: () {
              paidUnpaidNotifier.value = !paidUnpaidNotifier.value;
              setState(() {

              });
            },
            child: ValueListenableBuilder(
              valueListenable: paidUnpaidNotifier,
              builder: (context, value, _) {
                return new Container(
                  margin: new EdgeInsets.only(left: MARGIN_LEFT_RIGHT),
                  child: new Row(
                    children: <Widget>[
                      paidUnPaidWidget("Paid", value),
                      new SizedBox(
                        width: 15.0,
                      ),
                      paidUnPaidWidget("Unpaid", !value)
                    ],
                  ),
                );
              },
            ),
          ),
          new SizedBox(
            height: 30.0,
          ),
          Offstage(
            offstage: !paidUnpaidNotifier.value,
            child: getTextField(
              validatorSalary,
              "Salary (£)",
              _SalaryController,
              _SallaryField,
              _SallaryField,
              false,
              TextInputType.number,
            ),
          ),

          new Offstage(
            offstage: !paidUnpaidNotifier.value,
            child: sizeBox,
          )
          ,

          Offstage(
              offstage: !paidUnpaidNotifier.value,
              child: getHideSalary(hideSalaryChangeNotifier)),

          sizeBox,
          Offstage(
            offstage: !offstageAssign,
            child: InkWell(
              onTap: () {
                widget.callBackAssignRole(0);
              },
              child: Container(
                  height: 40.0,
                  alignment: Alignment.center,
                  margin: new EdgeInsets.only(left: 40.0, right: 40.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.circular(5.0),
                    border: new Border.all(
                        color: AppColors.heartColor,
                        width: INPUT_BOX_BORDER_WIDTH),
                  ),
                  padding:
                  new EdgeInsets.symmetric(horizontal: 11.0, vertical: 1.0),
                  child: new Text(
                    "Delete individual role",
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoRegularStyle,
                        color: AppColors.kBlack,
                        fontSize: 15),
                  )),
            ),
          ),
          Offstage(
            offstage: !offstageAssign,
            child: Column(children: <Widget>[
              sizeBox,
              sizeBox,
            ],),
          )

        ],
      ),
    );
  }

  void removeUserFromRole() {
    widget.callBackAssignRole(-1);
  }


  Widget assignMyRole() {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new SizedBox(
            height: 10.0,
          ),
          Container(
            margin: new EdgeInsets.only(
                left: MARGIN_LEFT_RIGHT, right: 30.0),
            child: Row(
              children: <Widget>[
                new Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: new BoxDecoration(
                      border: new Border.all(
                          color: Colors.transparent, width: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: getCachedNetworkImage(
                          url: "${APIs.imageBaseUrl}$thumburl",
                          fit: BoxFit.cover),
                    )),
                new SizedBox(
                  width: 8.0,
                ),
                Expanded(
                  child: new Text(
                    name != null ? name : "",
                    style: new TextStyle(
                        fontFamily: AssetStrings.lotoSemiboldStyle,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
                new SizedBox(
                  width: 5.0,
                ),
                Offstage(
                  offstage: true,
                  child: new Icon(
                    Icons.more_vert,
                    size: 20.0,
                  ),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              removeUserFromRole();
            },
            child: Container(
                height: 45.0,
                alignment: Alignment.center,
                margin: new EdgeInsets.only(
                    left: 40.0, right: 30.0, top: 20.0),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(5.0),
                  color: AppColors.buttonBackground,
                  border: new Border.all(
                      color: AppColors.buttonBorderRed,
                      width: INPUT_BOX_BORDER_WIDTH),
                ),
                padding: new EdgeInsets.symmetric(
                    horizontal: 11.0, vertical: 1.0),
                child: new Text(
                  "Remove user from role",
                  style: new TextStyle(
                      fontFamily: AssetStrings.lotoRegularStyle,
                      color: AppColors.kBlack,
                      fontSize: 15),
                )),
          ),
        ],
      ),
    );
  }

  //when assign to myself hide the widgets
  void showHide() {
    offstageAssign = !offstageAssign;

    setState(() {

    });
  }


  SaveRoleCallRequest getRoleInformation() {
    var id = MemoryManagement.getuserId();
    provider.setLoading();
    //create request body
    SaveRoleCallRequest savedatarequest = new SaveRoleCallRequest();

    //for gender
    if (provider.genderResponse.data != null) {
      for (var data in provider.genderResponse.data) {
        if (data.name == gender) {
          savedatarequest.gender =
              RolesCreateProfile(type: "Gender", id: data.id);
          break;
        }
      }
    }
    //for ethencticity
    if (provider.ethicityResponse.data != null) {
      for (var data in provider.ethicityResponse.data) {
        if (data.name == ethinics) {
          savedatarequest.ethnicity =
              RolesCreateProfile(type: "Ethnicity", id: data.id);
          break;
        }
      }
    }

//    savedatarequest.assignee =
//        RolesCreateProfile(type: "User", id: int.parse(id));


    savedatarequest.description = _BioController.text;
    savedatarequest.expensesPaid = paidUnpaidNotifier.value;
    savedatarequest.name = _FullNameController.text;
    savedatarequest.hideSalary = hideSalaryChangeNotifier.value;

    if (_HeightController.text.length > 0) {
      savedatarequest.height =
          int.tryParse(_HeightController.text.toString()) ?? 0;
    }

    if (_WeightController.text.length > 0) {
      savedatarequest.weight =
          int.tryParse(_WeightController.text.toString()) ?? 0;
    }
    if(_SalaryController.text.length>0)
      savedatarequest.salary =int.parse(_SalaryController.text);


    return savedatarequest;
  }


  Widget getHideSalary(ValueNotifier<bool> changeNotifier) {
    return new Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0),
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(5.0),
        border: new Border.all(
            color: AppColors.kPrimaryBlue, width: INPUT_BOX_BORDER_WIDTH),
      ),
      padding: new EdgeInsets.symmetric(horizontal: 11.0, vertical: 1.0),
      child: new Row(
        children: <Widget>[
          new SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: new Text(
                "Hide salary until position filled",
                style: new TextStyle(
                    fontFamily: AssetStrings.lotoRegularStyle,
                    color: AppColors.kPrimaryBlue,
                    fontSize: 15),
              )),

          ValueListenableBuilder(
            valueListenable: changeNotifier,
            builder: (context, value, _) {
              return new
              Checkbox(
                value: changeNotifier.value,
                activeColor: AppColors.kPrimaryBlue,
                onChanged: (bool value) {
                  changeNotifier.value = value;
                  setState(() {});
                },
              );
            },
          ),

        ],
      ),
    );
  }



  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
