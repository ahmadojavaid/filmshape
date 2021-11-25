import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:new_flutter_mar/Utils/AssetStrings.dart';
import 'package:new_flutter_mar/Utils/UniversalFunctions.dart';

class SearchView extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<SearchView> {
  final ScrollController _scrollController = ScrollController();
  List<String> list = new List();

  @override
  void initState() {
    // TODO: implement initState
    list.add("afsaf");
    list.add("afsaf");
    list.add("afsaf");
    list.add("afsaf");
    list.add("afsaf");
    list.add("afsaf");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screensize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            margin: new EdgeInsets.only(left: 35.0, right: 35.0),
            child: Column(
              children: <Widget>[
                getText("People"),
                new Container(
                    margin: new EdgeInsets.only(top: 20.0),
                    child: new Wrap(
                      children: actorWidgets.toList(),
                    )),
                new SizedBox(
                  height: 20.0,
                ),
                getText("Projects"),
                Container(
                    margin: new EdgeInsets.only(top: 10.0),
                    child: new Wrap(
                      children: projectWidgets.toList(),
                    ))
                /*
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
                Container(
                    margin: new EdgeInsets.only(left: 15.0,right: 15.0),
                    child: new Wrap(children: actorWidgets.toList(),))*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: new EdgeInsets.only(top: 20.0),
      child: new Text(
        text,
        style: new TextStyle(
            color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget stackItem(int index) {
    return Positioned(
      child: new Image.asset(
        AssetStrings.imageProduction,
        width: 30.0,
        height: 30.0,
        fit: BoxFit.fill,
      ),
    );
  }

  /* buildStackList() {
    return Container(
      child: new ListView.builder(
        padding: new EdgeInsets.all(0.0),
        scrollDirection: Axis.horizontal,
        itemBuilder: (BuildContext context, int index) {
          return stackItem(index);
        },
        itemCount: 5,
      ),
    );
  }*/

  Widget buildItem() {
    return Container(
      child: Container(
        margin: new EdgeInsets.only(top: 10.0),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  child: IntrinsicHeight(
                    child: new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            new Container(
                                width: 40.0,
                                height: 40.0,
                                decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: Colors.transparent, width: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: getCachedNetworkImage(
                                      url:
                                          "file:///home/avinash/Downloads/savour%20apps%20images%20and%20icons/image1.png",
                                      fit: BoxFit.cover),
                                )),
                            Positioned(
                              bottom: 0.0,
                              right: 0.0,
                              child: new Container(
                                width: 13.0,
                                height: 13.0,
                                decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.greenAccent,
                                    border: new Border.all(
                                        color: Colors.white, width: 1.3)),
                              ),
                            )
                          ],
                        ),
                        new SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Container(
                            padding: new EdgeInsets.symmetric(
                                vertical: 3.0, horizontal: 5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                new Text(
                                  "Aaron Klein",
                                  style: new TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                new SizedBox(
                                  height: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: new EdgeInsets.only(right: 35.0),
                                    child: new Text(
                                      "Beautiful! can't wait for your next masterpiece checked it",
                                      style: new TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.0),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItemProjects() {
    return Container(
      margin: new EdgeInsets.only(top: 10.0),
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: new EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: Column(
            children: <Widget>[
              Container(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
/*
                    Expanded(
                      child: Container(
                        width: 40.0,
                        height: 40.0,
                        child:  buildStackList(),
                      ),
                    ),*/
                  ]
                    ..add(Expanded(
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: new Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[]
                            // todo: make dynamic
                            ..addAll(new List.generate(5, (index) {
                              return new Padding(
                                padding: new EdgeInsets.only(
                                  right: index *
                                      (28.0), // give left and remove alignment for reverse type
                                ),
                                child: new Container(
                                  width: 40,
                                  height: 40,
                                  decoration: new BoxDecoration(
                                    color: Colors.green[400],
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      width: 1.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: getCachedNetworkImage(
                                        url:
                                            "https://i.ytimg.com/vi/sCZzhsd_NNY/maxresdefault.jpg",
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              );
                            })),
                        ),
                      ),
                    ))
                    ..add(
                      Container(
                        padding: new EdgeInsets.only(bottom: 5.0),
                        margin: new EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: <Widget>[
                            new Icon(
                              Icons.favorite,
                              size: 16.0,
                              color: Colors.red,
                            ),
                            new SizedBox(
                              width: 5.0,
                            ),
                            new Text(
                              "100",
                              style: new TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                ),
              ),
              new SizedBox(
                height: 13.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "Aaron Klein",
                  style: new TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              new SizedBox(
                height: 5.0,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: new Text(
                  "London, UK",
                  style: new TextStyle(color: Colors.black54, fontSize: 12.0),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Iterable<Widget> get actorWidgets sync* {
    for (String data in list) {
      yield buildItem();
    }
  }

  Iterable<Widget> get projectWidgets sync* {
    for (String data in list) {
      yield buildItemProjects();
    }
  }
}
