import 'package:LikeApp/TempReports/listTempReport.dart';
import 'package:flutter/material.dart';
import '../Report/addReport.dart';
import "dataSearch.dart";

class HomePage extends StatelessWidget {
  HomePage(this.title, {Key key}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: Icon(Icons.landscape),
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch());
            },
          )
        ],
      ),
      body: ListTempReport(),
      persistentFooterButtons: <Widget>[
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          backgroundColor: Color(Colors.green.value),
          foregroundColor: Color(Colors.black.value),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddReport()),
            );
          },
          label: Text("Agregar Reporte"),
        )
      ],
    );
  }
}
