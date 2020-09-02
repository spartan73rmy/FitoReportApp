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
  List<Producto> products = <Producto>[
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 20,
        ingredienteActivo: "Calcio",
        concentracion: "80",
        intervaloSeguridad: "10"),
    new Producto(
        nombre: "Cal",
        cantidad: 10000,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      body: ListTempReportBody(products),
    );
  }
}
