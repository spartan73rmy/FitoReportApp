import 'package:LikeApp/Home/drawerContent.dart';
import 'package:flutter/material.dart';
import '../Report/addReport.dart';
import "dataSearch.dart";

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: new Drawer(
      //   child: drawerContent(context),
      // ),
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: Column(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReport()),
          );
        },
      ),
    );
  }
}
