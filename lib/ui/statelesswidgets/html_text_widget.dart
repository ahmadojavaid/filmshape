import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlTextWidget extends StatelessWidget {
  String message;
  HtmlTextWidget(this.message);
  @override
  Widget build(BuildContext context) {
    return Html(
      shrinkToFit: false,
      data: "$message",
      defaultTextStyle: TextStyle(fontSize: 16),
    );
  }
}
