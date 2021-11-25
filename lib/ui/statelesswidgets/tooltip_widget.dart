import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TooltipText extends StatelessWidget {
  final String text;
  final String tooltip;
  final Widget childWidget;

  TooltipText({Key key, this.tooltip, this.text,this.childWidget});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: childWidget,
    );
  }
}