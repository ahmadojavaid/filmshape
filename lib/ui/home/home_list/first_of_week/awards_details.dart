import 'package:flutter/material.dart';
import 'package:Filmshape/Utils/Constants/AppCustomTheme.dart';

class AwardsDetails extends StatefulWidget {
  @override
  _AwardsDetailsState createState() => _AwardsDetailsState();
}

class _AwardsDetailsState extends State<AwardsDetails> {
  Widget getTextFieldBottomSheet(
      String labelText,
      TextEditingController controller,
      FocusNode focusNodeCurrent,
      FocusNode focusNodeNext,
      TextInputType textInputType,
      int max) {
    return Container(
      margin: new EdgeInsets.only(left: 40.0, right: 40.0, top: 30.0),
      child: new TextFormField(
        controller: controller,
        focusNode: focusNodeCurrent,
        maxLines: max,
        enabled: false,
        style: AppCustomTheme.ediTextStyle,
        decoration: new InputDecoration(
            border: new OutlineInputBorder(),
            contentPadding: new EdgeInsets.only(
                top: 14.0, bottom: 14.0, left: 14.0, right: 10.0),
            labelText: labelText,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black26, width: 1.0),
            ),
            focusColor: Colors.brown),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _EmailController = new TextEditingController();
    TextEditingController _PasswordController = new TextEditingController();
    FocusNode _EmailField = new FocusNode();
    FocusNode _PasswordField = new FocusNode();
    return Scaffold(
        body: Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Form(
        child: Container(
          child: new Wrap(
            children: <Widget>[
              Container(
                margin: new EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: new Icon(Icons.keyboard_arrow_down, size: 29.0)),
                    new SizedBox(
                      width: 4.0,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: new Text(
                        "Close",
                        style:
                            new TextStyle(color: Colors.black, fontSize: 16.0),
                      ),
                    ),
                    new SizedBox(
                      width: 55.0,
                    ),
                  ],
                ),
              ),
              Container(
                margin: new EdgeInsets.only(top: 30.0),
                child: getTextFieldBottomSheet("Award title", _EmailController,
                    _EmailField, _PasswordField, TextInputType.emailAddress, 1),
              ),
              getTextFieldBottomSheet("Description", _PasswordController,
                  _PasswordField, _PasswordField, TextInputType.text, 6),
              new Container(
                height: 50.0,
                child: new Text("  "),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
