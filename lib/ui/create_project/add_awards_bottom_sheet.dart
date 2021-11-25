import 'package:Filmshape/Model/Network/APIError.dart';
import 'package:Filmshape/Model/awards/add_awards_request.dart';
import 'package:Filmshape/Model/feed/feed_response.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/Utils/ValidatorFunctions.dart';
import 'package:Filmshape/notifier_provide_model/home_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class AddAwardsBottomSheet extends StatefulWidget {
  final String projectID;
  final Award award;
  bool saveAward;
  AddAwardsBottomSheet(this.projectID, {this.award,this.saveAward=true});

  @override
  _JoinPrpjectDetailsState createState() => _JoinPrpjectDetailsState();
}

class _JoinPrpjectDetailsState extends State<AddAwardsBottomSheet> {
  TextEditingController _TitleController = new TextEditingController();
  TextEditingController _DescriptionConrroller = new TextEditingController();
  TextEditingController _linkController = new TextEditingController();
  TextEditingController _awardInstitutionController =
      new TextEditingController();

  FocusNode _TitleField = new FocusNode();
  FocusNode _DescriptionField = new FocusNode();
  FocusNode _LinkField = new FocusNode();
  FocusNode _AwardInstitutionField = new FocusNode();

  HomeListProvider providers;
  GlobalKey<FormState> _fieldKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.award != null) {
      _TitleController.text = widget.award.title ?? "";
      _DescriptionConrroller.text = widget.award.description ?? "";
      _linkController.text = widget.award.url ?? "";
      _awardInstitutionController.text = widget.award.awardInstitution ?? "";
    }

  }

  Future<void> addAdwards() async {
    if (_fieldKey.currentState.validate()) {
      providers.setLoading();
      ProjectsAwards projects =
          new ProjectsAwards(type: "Project", id: widget.projectID);

      AddAwardsRequest request = new AddAwardsRequest(
          project: projects,
          title: _TitleController.text,
          description: _DescriptionConrroller.text,
          url: _linkController.text,
          awardInstitution: _awardInstitutionController.text
      );

      var response;
      if(widget.award==null) //add new award
       response = await providers.addAward(context, request);
      else
      //update award
       response = await providers.updateAward(context, request,widget.award.id.toString());


      providers.hideLoader();

      if (response is Award) {
        //reset the values
        _TitleController.text = "";
        _DescriptionConrroller.text = "";
        _linkController.text = "";
        _awardInstitutionController.text="";
        Navigator.pop(context, response);
      } else {
        APIError apiError = response;

        showInSnackBar(apiError.error??"");
      }
    }
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    providers = Provider.of<HomeListProvider>(context);

    return Stack(
      children: <Widget>[
        Container(
          margin: new EdgeInsets.only(
              left: 30.0, right: 15.0, top: 15.0, bottom: 15),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Icon(Icons.keyboard_arrow_left, size: 29.0)),
              new SizedBox(
                width: 4.0,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: new Text(
                  "Back",
                  style: new TextStyle(color: Colors.black, fontSize: 16.0),
                ),
              ),
              Expanded(
                child: new SizedBox(
                  width: 55.0,
                ),
              ),
              Offstage(
                offstage: !widget.saveAward,
                child: InkWell(
                  onTap: () {
                    addAdwards();
                  },
                  child: new Container(
                    padding:
                        new EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                    decoration: new BoxDecoration(
                        border: new Border.all(
                            color: AppColors.delete_save_border, width: 1.0),
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
                          (widget.award==null)? "Save":"Update",
                          style:
                              new TextStyle(color: Colors.black, fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        new Container(
          height: 1.0,
          margin: new EdgeInsets.only(top: 60.0),
          color: AppColors.dividerColor,
        ),
        Container(
          margin: new EdgeInsets.only(top: 70.0),
          child: SingleChildScrollView(
            child: new Flex(
              direction: Axis.vertical,
              children: <Widget>[getPager()],
            ),
          ),
        ),
        new Center(
          child: getHalfScreenProviderLoader(
            status: providers.getLoading(),
            context: context,
          ),
        )
      ],
    );
  }

  Widget getPager() {
    return Container(
      child: Form(
        key: _fieldKey,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new SizedBox(
              height: 35.0,
            ),
            new Container(
              child: getTextField(
                  validatorAwardTitle,
                  "Award title",
                  _TitleController,
                  _TitleField,
                  _DescriptionField,
                  false,
                  TextInputType.text,
                  enable: true),
            ),
            new SizedBox(
              height: 30.0,
            ),
            Container(
              child: getTextField(
                  null,
                  "Reference Link",
                  _linkController,
                  _LinkField,
                  _AwardInstitutionField,
                  false,
                  TextInputType.text,
                  maxlines: 1,
                  enable: true),
            ),
            new SizedBox(
              height: 30.0,
            ),
            Container(
              child: getTextField(
                  validatorAwardingInstitution,
                  "Awarding Institution",
                  _awardInstitutionController,
                  _AwardInstitutionField,
                  _AwardInstitutionField,
                  false,
                  TextInputType.text,
                  maxlines: 1,
                  enable: true),
            ),
            new SizedBox(
              height: 30.0,
            ),
            Container(
              child: getTextField(
                  null,
                  "Description",
                  _DescriptionConrroller,
                  _DescriptionField,
                  _LinkField,
                  false,
                  TextInputType.text,
                  maxlines: 6,
                  enable: true),
            ),
            new SizedBox(
              height: 30.0,
            ),

          ],
        ),
      ),
    );
  }
}
