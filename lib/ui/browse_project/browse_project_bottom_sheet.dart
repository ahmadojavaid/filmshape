import 'package:Filmshape/Model/browser_project/browse_all_project_filter_request.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/join_project.dart';
import 'package:Filmshape/ui/browse_project/data_model.dart';
import 'package:Filmshape/ui/statelesswidgets/drop_down_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BrowseProjectBottomSheet extends StatefulWidget {

  @override
  _JoinPrpjectDetailsState createState() => _JoinPrpjectDetailsState();
}

class _JoinPrpjectDetailsState extends State<BrowseProjectBottomSheet>
    with AutomaticKeepAliveClientMixin<BrowseProjectBottomSheet>
{
  JoinProjectProvider provider;

  List<String> projectCreatedList = new List();

  @override
  void initState() {
    super.initState();

    projectCreatedList.add("Any");
    projectCreatedList.add("Anytime");
    projectCreatedList.add("Today");
    projectCreatedList.add("This week");
    projectCreatedList.add("This month");
    projectCreatedList.add("This year");

    Future.delayed(const Duration(milliseconds: 300), () {
      if(!(provider.projectTypeList.length>0&&provider.genreList.length>0))
      hitCommonApi(0);
    });
  }

  void showInSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  hitCommonApi(int type) async {
    var response;

    switch (type) {
      case 0:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        response = await provider.getCommonData(context, 2, "ProjectGenre/");

        break;
      case 1:
        response = await provider.getCommonData(context, 1, "ProjectType/");
        break;
      case 2:
        response = await provider.getCommonData(context, 2, "ProjectGenre/");
        break;
    }
  }

  get sizeBox {
    return new SizedBox(
      height: 20.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<JoinProjectProvider>(context);
    return Stack(
      children: <Widget>[
        Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:
                        new EdgeInsets.only(left: 30.0, right: 15.0, top: 15.0),
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: new Icon(Icons.keyboard_arrow_left,
                                size: 29.0)),
                        new SizedBox(
                          width: 4.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: new Text(
                            "Back",
                            style: new TextStyle(
                                color: Colors.black, fontSize: 16.0),
                          ),
                        ),
                        Expanded(
                          child: new SizedBox(
                            width: 55.0,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                           _clearFilters();
                          },
                          child: new Container(
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
                                  Icons.delete_sweep,
                                  color: Colors.black,
                                  size: 17.0,
                                ),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Clear",
                                  style: new TextStyle(
                                      color: Colors.black, fontSize: 15.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            _filterProjects();
                          },
                          child: new Container(
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
                                  Icons.check_circle,
                                  color: AppColors.kPrimaryBlue,
                                  size: 17.0,
                                ),
                                new SizedBox(
                                  width: 5.0,
                                ),
                                new Text(
                                  "Apply",
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
                    height: 1.0,
                    margin: new EdgeInsets.only(top: 15.0),
                    color: AppColors.dividerColor,
                  ),
                  Container(
                    margin:
                        new EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0),
                    child: new Text(
                      "Filters",
                      style: new TextStyle(
                          color: Colors.black,
                          fontFamily: AssetStrings.lotoRegularStyle,
                          fontSize: 21.0),
                    ),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  getDropdownItem(
                      provider.browseProjectFilter.projectType,
                      provider.projectTypeList,
                      1,
                      AssetStrings.ploject_type,
                      "Project type",
                      projectTypeCallBack),
                  sizeBox,
                  getDropdownItem(provider.browseProjectFilter.projectGenre, provider.genreList, 2,
                      AssetStrings.paint, "Genre", projectGenreCallBack),
                  sizeBox,
                  getDropdownItem(
                      provider.browseProjectFilter.created,
                      projectCreatedList,
                      2,
                      AssetStrings.dateRange,
                      "Created",
                      projectUploadCallBack),
                  sizeBox,
                ],
              ),
            ),
          ),
        ),
        new Center(
          child: getHalfScreenProviderLoader(
            status: provider.getLoading(),
            context: context,
          ),
        ),
      ],
    );
  }

  Widget getDropdownItem(String title, List<String> list, int type,
      String image, String hint, ValueChanged<String> valueChanged) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (type == 1) {
            if (provider.projectTypeList.length == 0) {
              provider.setLoading();
              hitCommonApi(1);
            }
          } else if (type == 2) {
            if (provider.genreList.length == 0) {
              provider.setLoading();
              hitCommonApi(2);
            }
          } else if (type == 3) {
            if (provider.statusList.length == 0) {
              provider.setLoading();
              hitCommonApi(3);
            }
          }
        },
        child: DropDownButtonWidget(
            title: title,
            list: list,
            image: image,
            hint: hint,
            callBack: valueChanged));
  }

  ValueChanged<String> projectTypeCallBack(String value) {
    provider.browseProjectFilter.. projectType = value;
  }

  ValueChanged<String> projectGenreCallBack(String value) {
    provider.browseProjectFilter.projectGenre = value;
  }

  ValueChanged<String> projectUploadCallBack(String value) {
    provider.browseProjectFilter.created = value;
  }

  void _clearFilters()
  {
    //clear filter model data
    provider.browseProjectFilter= new DataModelFilter();
    //clear request model
    provider.browseAllProjectFilterRequest=new BrowseAllProjectFilterRequest();
    Navigator.pop(context,2);
  }

  void _filterProjects() {

    //project type
    if (provider.projectTypeDataResponse.data != null) {
      for (var data in provider.projectTypeDataResponse.data) {
        if (data.name == provider.browseProjectFilter.projectType) {
          provider.browseAllProjectFilterRequest.projectType=ProjectType(type: "ProjectType",id: data.id);
          break;
        }
      }
    }
    //for genere list
    if (provider.projectGenreDataResponse.data != null) {
      for (var data in provider.projectGenreDataResponse.data) {
        if (data.name == provider.browseProjectFilter.projectGenre) {
          provider.browseAllProjectFilterRequest.genre=ProjectType(type: "ProjectGenre",id: data.id);
          break;
        }
      }
    }
    //for date selected
      for (var data in projectCreatedList) {
        if (data == provider.browseProjectFilter.created) {
          provider.browseAllProjectFilterRequest.createdIcontains="2020";
        }
      }

      Navigator.pop(context,1);
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
