import 'package:flutter/material.dart';
import 'addReportBody.dart';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => new _AddReportState();
}

class _AddReportState extends State<AddReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Reporte'),
      ),
      body: StepperBody(),
    );
  }
}
