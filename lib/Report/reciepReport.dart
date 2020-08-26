import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/product.dart';
import 'package:flutter/material.dart';
import 'createDialog.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  static ReportData data;
  ReciepReport(ReportData data, {Key key}) : super(key: key);

  @override
  _ReciepReportState createState() => _ReciepReportState();
}

class _ReciepReportState extends State<ReciepReport> {
  List<Product> products = <Product>[
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 10,
        ingredienteActivo: "Calcio",
        concentracion: "10",
        intervaloSeguridad: "10"),
    new Product(
        nombre: "Cal",
        cantidad: 20,
        ingredienteActivo: "Calcio",
        concentracion: "80",
        intervaloSeguridad: "10"),
    new Product(
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
      appBar: AppBar(title: Text('Productos'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        )
      ]),
      body: ReciepReportBody(products),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          createDialog(context).then((value) {
            addProduct(value);
          });
        },
      ),
    );
  }

  addProduct(Product product) {
    setState(() {
      products.add(product);
      print(product.cantidad);
    });
  }
}

// @override
//   Widget build(BuildContext ctxt) {
//     return StreamBuilder(
//       stream: Firestore.instance.collection('baby').snapshots(),
//       builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
//         var documents = snapshot.data?.documents ?? [];
//         var baby =
//             documents.map((snapshot) => BabyData.from(snapshot)).toList();
//         return BabyPage(baby);
//       },
//     );
//   }
