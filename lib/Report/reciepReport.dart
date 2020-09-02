import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/producto.dart';
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
  List<Producto> products = <Producto>[
    new Producto(
        nombre: "Cal",
        cantidad: 100,
        ingredienteActivo: "Calcio",
        concentracion: "50",
        intervaloSeguridad: "10")
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

  addProduct(Producto product) {
    setState(() {
      products.add(product);
      print(product.cantidad);
    });
  }
}
