import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/add_role_tab.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/Utils/memory_management.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:provider/provider.dart';

class AddRoleQuantityInProject extends StatefulWidget {
  final AddRoleTabResponse request;

  const AddRoleQuantityInProject(this.request, {Key key}) : super(key: key);

  @override
  AddRoleQuantityInProjectState createState() =>
      AddRoleQuantityInProjectState();
}

class AddRoleQuantityInProjectState extends State<AddRoleQuantityInProject> {
  FocusNode _BioField = new FocusNode();
  FocusNode _SallaryField = new FocusNode();

  TextEditingController _BioController = new TextEditingController();
  TextEditingController _SalaryController = new TextEditingController();

  ValueNotifier<bool> paidUnpaidNotifier = new ValueNotifier(true);

  bool paid = true;
  bool unpaid = false;

  CreateProfileProvider provider;
  String gender;
  String ethinics;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      hitGenderApi();
      hitEthicsApi();
    });
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
                    margin: new EdgeInsets.only(top: 30.0),
                    child: attributeHeading(
                        "Search Filmshape users", AssetStrings.search),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child:
                        attributeHeading("Share via email", AssetStrings.email),
                  ),
                  Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child: attributeHeading(
                        "Get shareable link", AssetStrings.email),
                  ),
                  new Container(
                    height: 50.0,
                    child: new Text("  "),
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget attributeHeading(String text, String image) {
    return InkWell(
      onTap: () {},
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

            new SvgPicture.asset(
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

  Widget videoLinkView(String text, String image, Color color) {
    return InkWell(
      onTap: () {
        quickAccessVideoLinkBottomSheet();
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
          new SizedBox(
            height: 32.0,
          ),
          videoLinkView(
              "Invite user to role", AssetStrings.send, AppColors.kPrimaryBlue),
          new SizedBox(
            height: 20.0,
          ),
          videoLinkView("Assign myself to role", AssetStrings.personMyProfile,
              Colors.black),

          sizeBox,

          getDropdownItem(gender,
              provider.genderList != null ? provider.genderList : null, 1),

          sizeBox,

          getDropdownItem(ethinics, provider.ethicityList, 2),

          sizeBox,

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
          getTextField(
            validatorSalary,
            "Salary (£)",
            _SalaryController,
            _SallaryField,
            _SallaryField,
            false,
            TextInputType.number,
          ),
          sizeBox,
          //getHideSalary(checkNotifier),
          sizeBox,
          sizeBox,
          InkWell(
            onTap: () {
//                list.removeAt(_currentPage);
//                slideList.removeAt(_currentPage);
//                listProjectId.removeAt(_currentPage);
//
//                setState(() {
//
//
//                });
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
          sizeBox,
          sizeBox,
        ],
      ),
    );
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

    savedatarequest.assignee =
        RolesCreateProfile(type: "User", id: int.parse(id));

    savedatarequest.description = _BioController.text;

    if(_SalaryController.text.length>0)
      savedatarequest.salary =int.parse(_SalaryController.text);

    return savedatarequest;

  }
}
