import 'dart:core';

import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/AssetStrings.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/Constants/Const.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DropDownButtonWidget extends StatelessWidget {
  ValueChanged<String> callBack;
  String title;
  List<String> list;
  String image;
  String hint;
  final GlobalKey dropdownKey = GlobalKey();
  bool paddingContent;



  DropDownButtonWidget(
      {this.title, this.list, this.image, this.hint, this.callBack, this.paddingContent});

  @override
  Widget build(BuildContext context) {
     return Container(

       margin: new EdgeInsets.only(
           left: paddingContent != null && paddingContent
               ? 15
               : MARGIN_LEFT_RIGHT,
           right: paddingContent != null && paddingContent
               ? 15
               : MARGIN_LEFT_RIGHT),
      child: FormField<String>(

        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              border: new OutlineInputBorder(),
              labelText: (title==null)?"":hint??"",

              hintStyle: paddingContent != null && paddingContent
                  ? AppCustomTheme.labelEdiTextRegularCustom
                  : AppCustomTheme.labelEdiTextRegular,
              labelStyle: paddingContent != null && paddingContent
                  ? AppCustomTheme.labelEdiTextRegularCustom
                  : AppCustomTheme.labelEdiTextRegular,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey, width: INPUT_BOX_BORDER_WIDTH),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColors.creatreProfileBordercolor,
                    width: INPUT_BOX_BORDER_WIDTH),
              ),
              contentPadding: paddingContent != null && paddingContent
                  ? new EdgeInsets.only(top: 0, bottom: 0, right: 15, left: 15)
                  : null,

              prefixIcon: (image != null) ? Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15),
                child: SvgPicture.asset(
                  image,

                ),
              ) : null,


            ),
            child: Container(
              height: 20,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  key: dropdownKey,
                  value: title,
                  isDense: false,
                  isExpanded: true,
                  hint: paddingContent != null && paddingContent ? new Text(
                      hint ?? "", style: new TextStyle(
                    color: AppColors.kActiveFontcolor,
                    fontFamily: AssetStrings.lotoRegularStyle,)) : new Text(
                      hint) ?? "",
                  onChanged: (String newValue) {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    //(newValue);
                    title = newValue;
                    state.didChange(newValue);
                    callBack(newValue);
                  },
                  items: list.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontFamily: AssetStrings.lotoRegularStyle,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
