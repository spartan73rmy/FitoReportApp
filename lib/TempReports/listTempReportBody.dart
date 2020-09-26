import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:LikeApp/TempReports/listTempReportCard.dart';
import 'package:flutter/material.dart';

class ListTempReportBody extends StatefulWidget {
  ListTempReportBody();

  @override
  _ListTempReportBodyState createState() => _ListTempReportBodyState();
}

class _ListTempReportBodyState extends State<ListTempReportBody> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<List<ReportData>> getData() async {
    LocalStorage localStorage = new LocalStorage(FileName().report);
    var tempReports = await localStorage.readReports();
    return tempReports;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Container();
            case ConnectionState.waiting:
              return LoadingScreen();
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTempReportCard(snapshot.data[index]);
                    });
              }
          }
        });
  }
}
