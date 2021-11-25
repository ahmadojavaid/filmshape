import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';

import '../model/slide.dart';

class SlideItem extends StatelessWidget {
  final int index;

  SlideItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Flex(
        direction: Axis.vertical,

        children: <Widget>[

          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, top: 25, bottom: 40),
              child: Center(
                child: Container(
                 // width: getScreenSize(context: context).width - 60.0,
                //  height: (getScreenSize(context: context).height*40) / 100,
                  child: new SvgPicture.asset(
                    slideList[index].imageUrl, fit: BoxFit.contain,),),
              ),
            ),
          ),

          Container(
            alignment: Alignment.center,
            child: Text(
              slideList[index].title,
              style: AppCustomTheme.headlineBold24,
            ),
          ),
          Container(
            margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 15.0,bottom: 50),
            child: Text(
                slideList[index].description,
                textAlign: TextAlign.center,
                style: AppCustomTheme.descriptionIntro
            ),
          ),


        ],
      ),
    );
  }
}
