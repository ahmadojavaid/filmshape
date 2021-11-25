import 'package:flutter/material.dart';
import 'package:youtube_api/youtube_api.dart';

class YoutubeGetData extends StatefulWidget {
  @override
  _YState createState() => _YState();
}

class _YState extends State<YoutubeGetData> {
  static String key =
      "AIzaSyCspLTZ3C3244EtFnTQdqqXa4_lPjIXfb0"; // ** ENTER YOUTUBE API KEY HERE **

  YoutubeAPI ytApi = new YoutubeAPI(key);
  List<YT_API> ytResult = [];

  callAPI() async {
    print('UI callled');
    String query = "FLUTTER";
    ytResult = await ytApi.search("flutter");
    setState(() {
      print('UI Updated');
    });
  }

  @override
  void initState() {
    super.initState();
    callAPI();
    print('hello');
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: Text('Youtube API'),
          ),
          body: new Container(
            child: ListView.builder(
                itemCount: ytResult.length,
                itemBuilder: (_, int index) => listItem(index)),
          )),
    );
  }

  Widget listItem(index) {
    return new Card(
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 7.0),
        padding: EdgeInsets.all(12.0),
        child: new Row(
          children: <Widget>[
            new Image.network(
              ytResult[index].thumbnail['default']['url'],
            ),
            new Padding(padding: EdgeInsets.only(right: 20.0)),
            new Expanded(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  new Text(
                    ytResult[index].title,
                    softWrap: true,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 1.5)),
                  new Text(
                    ytResult[index].channelTitle,
                    softWrap: true,
                  ),
                  new Padding(padding: EdgeInsets.only(bottom: 3.0)),
                  new Text(
                    ytResult[index].url,
                    softWrap: true,
                  ),
                ]))
          ],
        ),
      ),
    );
  }
}
