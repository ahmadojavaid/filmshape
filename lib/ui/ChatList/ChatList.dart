
import 'package:Filmshape/Utils/AppColors.dart';
import 'package:Filmshape/Utils/ReusableWidgets.dart';
import 'package:Filmshape/Utils/UniversalFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Chat/Chat.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  // Controllers
  TextEditingController _queryTextController = new TextEditingController();

  // Focus nodes
  FocusNode _queryFieldFocusNode = new FocusNode();

  // UI props
  bool _isSearching = false;

  // Getters

  // Returns search bar
  get _getSearchBar {
    return new Container(
      margin: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 2.0),
      decoration: const BoxDecoration(
          border: const Border(
              bottom: const BorderSide(width: 0.5, color: Colors.grey))),
      child: new TextField(
        controller: _queryTextController,
        focusNode: _queryFieldFocusNode,
        onChanged: (searchString) {
          if (searchString.length >= 1) {
            _isSearching = true;
          } else if (searchString.isEmpty) {
            _isSearching = false;
          }
        },
        decoration: new InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: new IconButton(
            icon: new Icon(Icons.clear),
            onPressed: () {
              if (_queryTextController.text.isNotEmpty) {
                _queryTextController.clear();
                _isSearching = false;
              }
            },
          ),
          labelText: "Search",
          errorStyle: TextStyle(color: Colors.black),
          labelStyle: TextStyle(color: Colors.black),
          fillColor: Colors.black,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        style: new TextStyle(color: Colors.black),
      ),
    );
  }

  // Returns chat list
  get _getChatList {
    return new ListView.builder(
      padding: EdgeInsets.only(
        bottom: getScreenSize(context: context).width * 0.06,
      ),
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return new InkWell(
          onTap: () {
            Navigator.push(context,
                new CupertinoPageRoute(builder: (BuildContext context) {
              return new Chat();
            }));
          },
          child: new Column(
            children: <Widget>[
              new Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width: getScreenSize(context: context).width * 0.20,
                      height: getScreenSize(context: context).width * 0.20,
                      padding: const EdgeInsets.all(16.0),
                      child: new ClipOval(
                        child: new Container(
                          color: Colors.grey,
                          child: new Image.network(
                            "https://d3cy9zhslanhfa.cloudfront.net/media/F94DB5BD-96A1-4321-997F3A8F38B43424/24C298A0-84C7-4A24-AEF73C99CEDCBE6A/webimage-E441719B-0949-4907-B0CFFA66A4090997.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    new Expanded(
                      child: new Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: new Column(
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "User $index",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Todo: time format
                                new Text(
                                  "10:00 AM",
                                  style: new TextStyle(
                                    fontSize: 12.0,
                                    color: index.isEven
                                        ? AppColors.kAppBlue
                                        : Colors.grey.shade500,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            getSpacer(
                              height: 4.0,
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Expanded(
                                  child: new Text(
                                    "User $index",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Todo: time format
                                index.isEven
                                    ? new Material(
                                        color: AppColors.kAppBlue,
                                        shape: StadiumBorder(),
                                        child: new Center(
                                          child: new Padding(
                                            padding: const EdgeInsets.only(
                                              left: 4.2,
                                              right: 3.9,
                                              top: 2.0,
                                              bottom: 1.0,
                                            ),
                                            child: new Container(
//                                          color: Colors.cyanAccent,
                                              child: new Text(
                                                "${index + 1}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : new Container(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 0.5,
                color: Colors.grey,
                margin: new EdgeInsets.only(
                  left: getScreenSize(context: context).width * 0.20 + 8.0,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  // Builds screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: getAppbar("Chat List"),
      body: new SafeArea(
        top: false,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _getSearchBar,
            new Expanded(
              child: _getChatList,
            ),
          ],
        ),
      ),
    );
  }
}
