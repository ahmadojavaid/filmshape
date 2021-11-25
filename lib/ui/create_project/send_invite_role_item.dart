import 'package:Filmshape/Model/add_a_credit/Add_a_Credit.dart';
import 'package:Filmshape/Model/create_profile/media/get_roles_details_response.dart';
import 'package:Filmshape/Model/create_project/add_role_tab/save_role_data.dart';
import 'package:Filmshape/Model/create_project_model/DataModeCountl.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendInviteRoleItem extends StatefulWidget {
  final String projectID;
  final String roleID;
  final String title;
  final String userId;
  final AddRoleDetails addRoleDetails;

  SendInviteRoleItem(
      this.projectID, this.roleID, this.title, this.userId, this.addRoleDetails,
      {Key key})
      : super(key: key);

  @override
  SendInviteRoleItemState createState() => SendInviteRoleItemState();
}

class SendInviteRoleItemState extends State<SendInviteRoleItem> {
  List<DataModel> list = new List();

  JoinProjectProvider providers;

  TextEditingController _BioController = new TextEditingController();
  TextEditingController _HeightController = new TextEditingController();
  TextEditingController _WeightController = new TextEditingController();
  TextEditingController _FullNameController = new TextEditingController();
  TextEditingController _SalaryController = new TextEditingController();
  TextEditingController _GenreController = new TextEditingController();
  TextEditingController _GenderController = new TextEditingController();
  TextEditingController _EthicityController = new TextEditingController();

  TextEditingController _MessageController = new TextEditingController();

  ValueNotifier<bool> paidUnpaidNotifier = new ValueNotifier(true);

  ValueNotifier<bool> hideSalaryChangeNotifier = new ValueNotifier(false);


  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  FocusNode _BioField = new FocusNode();
  FocusNode _MessageField = new FocusNode();
  FocusNode _SallaryField = new FocusNode();

  String ethicity;
  String genre;

  @override
  void initState() {
    super.initState();

    if (widget.addRoleDetails != null) {
      _BioController.text = widget.addRoleDetails.description != null
          ? widget.addRoleDetails.description
          : "";
      _HeightController.text = widget.addRoleDetails.height != null
          ? widget.addRoleDetails.height.toString()
          : "";
      _WeightController.text = widget.addRoleDetails.weight != null
          ? widget.addRoleDetails.weight.toString()
          : "";
      _FullNameController.text = widget.addRoleDetails.name != null
          ? widget.addRoleDetails.name.toString()
          : "";
      _SalaryController.text = widget.addRoleDetails.salary != null
          ? widget.addRoleDetails.salary.toString()
          : "";
      genre = widget.addRoleDetails.genre != null
          ? widget.addRoleDetails.genre.name.toString()
          : null;
      _GenderController.text = widget.addRoleDetails.gender != null
          ? widget.addRoleDetails.gender.name.toString()
          : "";
      ethicity = widget.addRoleDetails.ethnicity != null
          ? widget.addRoleDetails.ethnicity.name.toString()
          : null;


      paidUnpaidNotifier.value = widget.addRoleDetails.expensesPaid ?? false;


      hideSalaryChangeNotifier.value =
          widget.addRoleDetails.hideSalary ?? false;

    }

    Future.delayed(const Duration(milliseconds: 300), () {
      if (widget.projectID != null) {
        hitCommonApi(0);
      }
    });
  }

  hitCommonApi(int type) async {
    var response;

    switch (type) {
      case 0:
        response = await providers.getCommonData(context, 4, "Ethnicity/",
            isCreating: true);
        response = await providers.getCommonData(context, 2, "ProjectGenre/",
            isCreating: true);

        break;
      case 1:
        response = await providers.getCommonData(context, 4, "Ethnicity/",
            isCreating: true);
        break;
      case 2:
        response = await providers.getCommonData(context, 2, "ProjectGenre/",
            isCreating: true);
        break;
    }

    providers.hideLoader();
  }

  String getMessageText() {
    return _MessageController.text;
  }

  SaveRoleCallRequest getRoleInformation() {
    var isSuccess = false;

    SaveRoleCallRequest savedatarequest = new SaveRoleCallRequest();

    savedatarequest.role =
        RolesCreateProfile(type: "Role", id: int.parse(widget.roleID));

    savedatarequest.project =
        RolesCreateProfile(type: "Project", id: int.parse(widget.projectID));

    if (providers.projectGenreDataResponse.data != null) {
      for (var data in providers.projectGenreDataResponse.data) {
        if (data.name == genre) {
          savedatarequest.gender =
              RolesCreateProfile(type: "Genre", id: data.id);
          break;
        }
      }
    }
    //for ethencticity
    if (providers.ethicityDataResponse.data != null) {
      for (var data in providers.ethicityDataResponse.data) {
        if (data.name == ethicity) {
          savedatarequest.ethnicity =
              RolesCreateProfile(type: "Ethnicity", id: data.id);
          break;
        }
      }
    }

//    savedatarequest.assignee =
//        RolesCreateProfile(type: "User", id: int.parse(id));

    savedatarequest.description = _BioController.text;
    /*   savedatarequest.expensesPaid = paidUnpaidNotifier.value;*/
    savedatarequest.name = _FullNameController.text;
    /*  savedatarequest.hideSalary = hideSalaryChangeNotifier.value;*/

    if (_HeightController.text.length > 0) {
      savedatarequest.height =
          int.tryParse(_HeightController.text.toString()) ?? 0;
    }

    if (_WeightController.text.length > 0) {
      savedatarequest.weight =
          int.tryParse(_WeightController.text.toString()) ?? 0;
    }
    if (_SalaryController.text.length > 0)
      savedatarequest.salary = int.parse(_SalaryController.text);

    return savedatarequest;
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    // FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
    return InkWell(
        onTap: () {
          if (type == 1) {
            if (providers.ethicityList.length == 0) {
              providers.setLoading();
              hitCommonApi(1);
            }
          } else if (type == 2) {
            if (providers.genreList.length == 0) {
              providers.setLoading();
              hitCommonApi(2);
            }
          }
        },
        child: DropDownButtonWidget(
            title: title, list: list, hint: hint, callBack: valueChanged));
  }

  ValueChanged<String> projectTypeCallBack(String value) {
    ethicity = value;
  }

  ValueChanged<String> projectGenreCallBack(String value) {
    genre = value;
  }


  String validatorSalary(String value) {
    if (value.isEmpty) {
      return 'Please enter your salary';
    }
  }



  @override
  Widget build(BuildContext context) {
    providers = Provider.of<JoinProjectProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new SizedBox(
                  height: 35.0,
                ),
                new Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: getTextField(
                      null,
                      "Character Name",
                      _FullNameController,
                      null,
                      null,
                      false,
                      TextInputType.text,
                      enable: true),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: new SizedBox(
                    height: 30.0,
                  ),
                ),
                getTextField(
                    null,
                    "Description",
                    _BioController,
                    _BioField,
                    _BioField,
                    false,
                    TextInputType.text,
                    maxlines: 6,
                    enable: true),
                new SizedBox(
                  height: 30.0,
                ),
                new Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: getDropdownItem(genre, providers.genreList, 2,
                      AssetStrings.paint, "Genre", projectGenreCallBack),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: new SizedBox(
                    height: 30.0,
                  ),
                ),
                new Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: getDropdownItem(
                      ethicity,
                      providers.ethicityList,
                      1,
                      AssetStrings.ploject_type,
                      "Ethnicity",
                      projectTypeCallBack),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: new SizedBox(
                    height: 30.0,
                  ),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: getHeightWeightTextField(
                      false,
                      null,
                      "Height",
                      _HeightController,
                      null,
                      null,
                      false,
                      "cm",
                      TextInputType.text,
                      enable: true),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: new SizedBox(
                    height: 30.0,
                  ),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: getHeightWeightTextField(
                      false,
                      null,
                      "Weight",
                      _WeightController,
                      null,
                      null,
                      false,
                      "kg",
                      TextInputType.text,
                      enable: true),
                ),
                Offstage(
                  offstage:
                  widget.title == "Actor" || widget.title == "Actor (Extra)"
                      ? false
                      : true,
                  child: new SizedBox(
                    height: 30.0,
                  ),
                ),


                Container(
                  margin: new EdgeInsets.only(
                      left: MARGIN_LEFT_RIGHT, top: 20.0),
                  child: new Text(
                    "Expenses",
                    style: AppCustomTheme.createProfileSubTitle,
                  ),
                ),
                new SizedBox(
                  height: 30.0,
                ),
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
                  child: new SizedBox(
                    height: 30.0,
                  ),
                )
                ,

                  Offstage(
                    offstage: widget.title == "Actor" || widget.title == "Actor (Extra)"
                        ? false
                        : true,
                    child: new SizedBox(
                      height: 30.0,
                    ),
                  ),

                Container(
                  margin: new EdgeInsets.only(top: 10.0, left: 40.0),
                  child: new Text(
                    "Attach a personal message",
                    style: AppCustomTheme.createProfileSubTitle,
                  ),
                ),
                new SizedBox(
                  height: 28.0,
                ),
                getTextField(
                    null,
                    "Message",
                    _MessageController,
                    _MessageField,
                    _MessageField,
                    false,
                    TextInputType.text,
                    maxlines: 6,
                    enable: true),


                new SizedBox(
                  height: 28.0,
                ),
              ],
            ),
          ),
          new Center(
            child: getHalfScreenProviderLoader(
              status: providers.getLoading(),
              context: context,
            ),
          ),
        ],
      ),
    );
  }
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
              },
            );
          },
        ),

      ],
    ),
  );
}


