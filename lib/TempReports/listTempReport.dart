import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:LikeApp/TempReports/listTempReportBody.dart';
import 'package:flutter/material.dart';

class ListTempReport extends StatefulWidget {
  static ReportData data;
  ListTempReport(ReportData data, {Key key}) : super(key: key);

  @override
  _ListTempReportState createState() => _ListTempReportState();
}

class _ListTempReportState extends State<ListTempReport> {
  List<Product> products = <Product>[
    new Product(
        name: "Cal",
        cantity: 100,
        iActive: "Calcio",
        concentration: "50",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 10,
        iActive: "Calcio",
        concentration: "10",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 20,
        iActive: "Calcio",
        concentration: "80",
        securityInterval: "10"),
    new Product(
        name: "Cal",
        cantity: 10000,
        iActive: "Calcio",
        concentration: "10",
        securityInterval: "10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: ListTempReportBody(products),
    );
  }
}
