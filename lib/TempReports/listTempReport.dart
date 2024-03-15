import '../TempReports/listTempReportBody.dart';
import 'package:flutter/material.dart';

class ListTempReport extends StatefulWidget {
  ListTempReport({Key key}) : super(key: key);

  @override
  _ListTempReportState createState() => _ListTempReportState();
}

class _ListTempReportState extends State<ListTempReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListTempReportBody(),
    );
  }
}
