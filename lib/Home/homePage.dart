import 'package:LikeApp/Models/tempReport.dart';
import 'package:LikeApp/CommonWidgets/localStorage.dart';
import 'package:LikeApp/CommonWidgets/drawerContent.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/TempReports/listTempReport.dart';
import 'package:flutter/material.dart';
import '../Report/addReport.dart';
import "dataSearch.dart";

class HomePage extends StatelessWidget {
  HomePage({Key key, this.title}) : super(key: key);
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
      body: ListTempReport(new ReportData()),
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
      // floatingActionButton:
    );
  }
}
