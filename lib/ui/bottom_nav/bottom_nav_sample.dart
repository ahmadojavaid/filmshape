import 'package:flutter/material.dart';

class CustomBottomNavNew extends StatefulWidget {
  @override
  _CustomBottomNavState createState() => _CustomBottomNavState();
}

class _CustomBottomNavState extends State<CustomBottomNavNew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 20),
        child: SizedBox(
          height: 70,
          width: 70,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {},
            child: Container(
              height: 75,
              width: 75,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4),
                  shape: BoxShape.circle,
                  color: Colors.red),
              child: Icon(Icons.add, size: 40),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new Container(
        height: 80.0,
        color: Colors.white,
        padding: new EdgeInsets.only(top: 20.0),
        child: new Theme(
          data: Theme.of(context).copyWith(
              // sets the background color of the `BottomNavigationBar`
              canvasColor: Colors.white,
              // sets the active color of the `BottomNavigationBar` if `Brightness` is light
              primaryColor: Colors.red,
              bottomAppBarColor: Colors.green,
              textTheme: Theme.of(context)
                  .textTheme
                  .copyWith(caption: new TextStyle(color: Colors.grey))),
          // sets the inactive color of the `BottomNavigationBar`
          child: new BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 0,
              items: [
                BottomNavigationBarItem(
                    icon: new Icon(Icons.home),
                    title: new Text('Home'),
                    backgroundColor: Colors.black),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.search),
                  title: new Text('Search'),
                ),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.bookmark_border,
                      color: Colors.transparent,
                    ),
                    title: Text('Center')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.perm_identity), title: Text('Person')),
                BottomNavigationBarItem(
                    icon: Icon(Icons.more_horiz), title: Text('More')),
              ]),
        ),
      ),
    );
  }
}
