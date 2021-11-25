import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Webview extends StatefulWidget {
  final String url;
  final String title;

  Webview({@required this.url, @required this.title});

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview> {
  final flutterWebviewPlugin = FlutterWebviewPlugin();

  bool offstage = false;

  @override
  void initState() {
    print("purchase url ${widget.url}");

    flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type == WebViewState.finishLoad) {
        print("aviiiii");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
        url: widget.url,

        /* appBar: new AppBar(
        elevation: 4.0,
        title: new Text(widget.title,style: new TextStyle(color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,),),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
          size: 25.0,
        ),
        centerTitle: true,
      ),
*/

        appBar: new AppBar(
          title: new Text(
            widget.title,
            style: new TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          backgroundColor: Colors.white,
          leading: new IconButton(
            icon: new Icon(
              Icons.keyboard_backspace,
              color: Colors.black,
              size: 25.0,
            ),
            onPressed: () => {Navigator.pop(context)},
          ),
          centerTitle: true,
        ),
        withZoom: true,
        hidden: true,
        withJavascript: true,
        withLocalStorage: true);
  }
}
