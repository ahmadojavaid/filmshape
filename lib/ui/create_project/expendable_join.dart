import 'package:Filmshape/Model/chatuser/add_role_data.dart';
import 'package:Filmshape/Model/get_roles/GetRolesResponse.dart';
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:Filmshape/notifier_provide_model/create_profile.dart';
import 'package:Filmshape/ui/statelesswidgets/bottom_sheet_purchase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SampleExpendableAddRole extends StatefulWidget {
  ValueSetter<List<String>> roleSelectedCallBack;
  VoidCallback callBackPaymentScreen;
  final int totalRoleSlectedCount;
  int type;

  SampleExpendableAddRole({this.type, this.roleSelectedCallBack,this.callBackPaymentScreen,this.totalRoleSlectedCount});

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SampleExpendableAddRole> {
  final ScrollController _scrollController = ScrollController();

  CreateProfileProvider provider;

  int type = 4;


  VoidCallback callback() {
    widget.callBackPaymentScreen();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("type is $type");
    Future.delayed(const Duration(milliseconds: 200), () {
      provider.list.clear();
      provider.listAllRolesItem.clear();
     // provider.roldIdList.clear();
      provider.rolesList.clear();
    });

  }

  //unpaid user role selected

  void _purchasePlanBottomSheet() {
    showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(7.0), topRight: Radius.circular(7.0)),
        ),
        builder: (BuildContext bc) {
          return PurchaseBottomSheet(callback);
        });
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<CreateProfileProvider>(context);
    return SafeArea(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              margin: new EdgeInsets.only(left: 25.0, right: 25.0, top: 20.0),
              child: new ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: provider.rolesList.length,
                controller: _scrollController,
                itemBuilder: (context, i) {
                  return new ExpansionTile(
                    key: Key(provider.rolesList[i].category.isExpend != null
                        ? provider.rolesList[i].category.isExpend.toString()
                        : "false"),
                    initiallyExpanded:
                        provider.rolesList[i].category.isExpend != null
                            ? provider.rolesList[i].category.isExpend
                            : false,
                    title: Row(
                      children: <Widget>[
                        getSvgNetworkImage(
                            url: provider.rolesList[i].category.iconUrl,
                            size: 24),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Text(
                            provider.rolesList[i].category.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: AppCustomTheme.roleHeadingStyle,
                          ),
                        ),
                      ],
                    ),
                    onExpansionChanged: (expension) {
                      provider.rolesList[i].category.isExpend = expension;
                      setState(() {});
                    },
                    trailing: provider.rolesList[i].category.isExpend != null
                        ? Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 28.0,
                          )
                        : Icon(
                            Icons.arrow_right,
                            color: Colors.black,
                            size: 28.0,
                          ),
                    children: <Widget>[
                      _buildContestList(provider.rolesList[i].roles, i),
                    ],
                  );
                },
              ),
            ),
            new SizedBox(
              height: 15.0,
            ),
            new Container(
              color: Colors.grey.withOpacity(0.5),
              height: 1.0,
            ),
            new SizedBox(
              height: 15.0,
            ),
            Offstage(
              offstage: widget.type == 3 || widget.type == 1 ? true : false,
              child: Container(
                  child: new Wrap(
                runSpacing: 5.0,
                spacing: 5.0,
                children: actorWidgets.toList(),
              )),
            )
          ],
        ),
      ),
    );
  }

  void removeData(String data) {
    for (GetRolesResponse list in provider.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data) {
          childItem.isChecked = false;
          provider.listId.remove(childItem.id);
          provider.setRoleList(provider.listId);
          //(provider.listId);
          AddRoleModel addmodel = new AddRoleModel(
              title: childItem.category.name,
              iconurl: childItem.iconUrl,
              list: childItem.name);
          removedRoleData(addmodel);

          // create project add role
          if (widget.roleSelectedCallBack != null && widget.type == 3) {
            widget.roleSelectedCallBack(null);
          }

          //(list);
          break;
        }
      }
    }
  }

  void addData(String data) {
    for (GetRolesResponse list in provider.rolesList) {
      List<RolesData> rolesItem = list.roles;

      for (RolesData childItem in rolesItem) {
        if (childItem.name == data) {
          childItem.isChecked = false;
          provider.listId.add(childItem.id);
          provider.setRoleList(provider.listId);
          //(provider.listId);
          //(list);
          break;
        }
      }
    }
  }

  void addRoleData(AddRoleModel model) {
    provider.addRoleBottomData(model);
  }

  void removedRoleData(AddRoleModel model) {
    provider.removeRoleBottomData(model);
  }


  Widget buildItem(RolesData item, int childPos, int parentPos) {

    return GestureDetector(
        onTap: () {
          item.isChecked = !item.isChecked;
          print("status ${item.isChecked}");

          if (item.isChecked) {
            //("list size ${provider.list}");

            if (isProUser() || widget.totalRoleSlectedCount < ROLE_SELECT_COUNT_CHECK) {
              provider.list.add(item.name);
              provider.listId.add(item.id);
              AddRoleModel addmodel = new AddRoleModel(
                  title: item.category.name,
                  iconurl: item.iconUrl,
                  list: item.name);
              addRoleData(addmodel);
              if (widget.roleSelectedCallBack != null && widget.type == 3) {
                var list = List<String>();
                list.add(item.id.toString());
                list.add(item.name.toString());
                widget.roleSelectedCallBack(list);
              }
            } else {
              _purchasePlanBottomSheet();

              item.isChecked = !item.isChecked;
            }

            setState(() {});
          } else {
            if (provider.list.contains(item.name)) {
              ("removeid ${provider.listId}");
              provider.list.remove(item.name);
              provider.listId.remove(item.id);
              AddRoleModel addmodel = new AddRoleModel(
                  title: item.category.name,
                  iconurl: item.iconUrl,
                  list: item.name);
              removedRoleData(addmodel);

              if (widget.roleSelectedCallBack != null && widget.type == 3) {
                widget.roleSelectedCallBack(null);
              }
              //("remove");
            } else {
              //("remove not");
            }
            setState(() {});
          }
          /*List<int> result = LinkedHashSet<int>.from( provider.listId).toList();

          provider.setRoleList(result);*/

          provider.setRoleList(provider.listId);
          //("id ${provider.listId}");
          //(provider.list);

          // create project add role
          if (widget.roleSelectedCallBack != null) widget.roleSelectedCallBack(provider.list);

        },
        child: Container(
          color: Colors.white,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: new Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  style: (item.isChecked)
                      ? AppCustomTheme.roleSubHeadingSelectedStyle
                      : AppCustomTheme.roleSubHeadingNoteSelectedStyle,
                ),
              ),
              Container(
                padding: new EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        item.isChecked = !item.isChecked;

                        if (item.isChecked) {
                          if (isProUser() || widget.totalRoleSlectedCount < ROLE_SELECT_COUNT_CHECK) {
                            provider.list.add(item.name);
                            provider.listId.add(item.id);
                            AddRoleModel addmodel = new AddRoleModel(
                                title: item.category.name,
                                iconurl: item.iconUrl,
                                list: item.name);
                            addRoleData(addmodel);
                            if (widget.roleSelectedCallBack != null &&
                                widget.type == 3) {
                              var list = List<String>();
                              list.add(item.id.toString());
                              list.add(item.name.toString());
                              widget.roleSelectedCallBack(list);
                            }

                            //(item.name);
                            //(item.category.name);
                            //(item.iconUrl);
                          } else {
                            /* showAlert(
                              context: context,
                              titleText: "ERROR",
                              message: "Can't select upto 10 roles",
                              actionCallbacks: {
                                "OK": () {
                                  _settingModalBottomSheet();
                                }
                              },
                            );*/

                            _purchasePlanBottomSheet();

                            item.isChecked = !item.isChecked;
                          }
                          setState(() {});
                        } else {
                          if (provider.list.contains(item.name)) {
                            provider.list.remove(item.name);
                            provider.listId.remove(item.id);
                            //(item.name);
                            //(item.category.name);
                            //(item.iconUrl);

                            AddRoleModel addmodel = new AddRoleModel(
                                title: item.category.name,
                                iconurl: item.iconUrl,
                                list: item.name);
                            removedRoleData(addmodel);
                            if (widget.roleSelectedCallBack != null &&
                                widget.type == 3) {
                              widget.roleSelectedCallBack(null);
                            }
                          }
                          setState(() {});
                        }
                        /*   List<int> result = LinkedHashSet<int>.from( provider.listId).toList();

                    provider.setRoleList(result);*/

                        //  provider.setRoleList(provider.listId);

                        //(provider.listId);
                        //(provider.list);

                        // create project add role
                      },
                      child: Icon(
                        item.isChecked
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: item.isChecked ? Colors.black54 : Colors.grey,
                      ),
                    ),
                    new SizedBox(
                      width: 5.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Iterable<Widget> get actorWidgets sync* {
    for (String data in provider.list) {
      yield Container(
        height: 35.0,
        margin: new EdgeInsets.symmetric(vertical: 5.0, horizontal: 6.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(color: AppColors.dividerColor, width: 1.0),
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Chip(
          backgroundColor: Colors.white,
          label: Text(
            data,
            style: new TextStyle(color: AppColors.topNavColor),
          ),
          deleteIcon: Icon(
            Icons.clear,
            size: 15.0,
            color: AppColors.topNavColor,
          ),
          onDeleted: () {
            provider.list.remove(data);
            removeData(data);

            setState(() {});
          },
        ),
      );
    }
  }

  _buildContestList(
    List<RolesData> list,
    int parentPos,
  ) {
    return Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
      child: new ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        padding: new EdgeInsets.all(0.0),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return buildItem(list[index], index, parentPos);
        },
        itemCount: list.length,
      ),
    );
  }
}
