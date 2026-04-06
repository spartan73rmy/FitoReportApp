import '../TempReports/listTempReportBody.dart';
import 'package:flutter/material.dart';

class ListTempReport extends StatefulWidget {
  const ListTempReport({super.key});

  @override
  _ListTempReportState createState() => _ListTempReportState();
}

class _ListTempReportState extends State<ListTempReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const ListTempReportBody(),
    );
  }
}
