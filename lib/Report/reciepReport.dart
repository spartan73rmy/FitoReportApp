import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/producto.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  List<Producto> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: Text('Productos'), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.save),
          onPressed: () async {
            print("Im here");
            await saveData();
            print("Save data");
            await saveToLocal();
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
    products = new List<Producto>();
    data = widget.data;
    super.initState();
  }

  addProduct(Producto product) {
    setState(() {
      products.add(product);
      print(product.cantidad);
    });
  }

  void saveData() async {
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.latitude);
    print(position.longitude);
    setState(() {
      data.producto = products;
      data.coordX = position.latitude;
      data.coordY = position.longitude;
      print(data.coordX);
    });
  }

  void saveToLocal() async {
    LocalStorage localS = LocalStorage();
    List<Enfermedad> enfer = new List<Enfermedad>();
    enfer.add(Enfermedad(id: 1, nombre: "Enfermedad"));
    List<Plaga> plag = new List<Plaga>();
    plag.add(Plaga(id: 1, nombre: "Enfermedad"));
    List<Producto> prod = new List<Producto>();
    prod.add(Producto(
        nombre: "Enfermedad",
        cantidad: 12,
        ingredienteActivo: "Ingrediente Activo",
        concentracion: "12%",
        intervaloSeguridad: "12 Dias"));

    await localS.addReport(new ReportData(
        id: 0,
        lugar: "Lugar",
        productor: "Porductor",
        coordX: data.coordX,
        coordY: data.coordY,
        ubicacion: "Ubicacion",
        predio: "Predio",
        cultivo: "cultivo",
        etapaFenologica: "EtapaF",
        observaciones: "Muchas observaciones al respecto",
        litros: 100,
        enfermedad: enfer,
        plaga: plag,
        producto: prod));

    // localS.addReport(data);
  }
}
