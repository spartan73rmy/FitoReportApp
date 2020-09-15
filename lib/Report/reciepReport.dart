import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/producto.dart';
import 'package:flutter/material.dart';
import 'createDialog.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  final ReportData data;
  ReciepReport({this.data});

  @override
  _ReciepReportState createState() {
    return new _ReciepReportState();
  }
}

class _ReciepReportState extends State<ReciepReport> {
  ReportData data;
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
            saveData();
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

  @override
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  addProduct(Producto product) {
    setState(() {
      products.add(product);
      print(product.cantidad);
    });
  }

  void saveData() {
    setState(() {
      data.producto = products;
    });

    // for (var i in data.plaga) {
    //   print(i.nombre);
    // }
    // for (var i in data.enfermedad) {
    //   print(i.nombre);
    // }
    // for (var i in data.producto) {
    //   print(i.nombre);
    // }
  }
}
