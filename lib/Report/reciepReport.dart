import 'package:LikeApp/Home/homePage.dart';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/producto.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'createDialog.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  final ReportData data;
  ReciepReport({this.data, Key key}) : super(key: key);

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
            await getGeoLocation();
            await saveData();
            await saveToLocal();
            Navigator.of(context).popUntil((route) => route.isFirst);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage("FitoReport")),
            );
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

  Future<void> getGeoLocation() async {
    print("GPS...");
    bool isEnabled = await isLocationServiceEnabled();
    if (isEnabled) {
      LocationPermission permission = await checkPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        permission = await requestPermission();
      } else {
        final Position position =
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          data.latitude = position.latitude;
          data.longitud = position.longitude;
        });
      }
    }
  }

  Future<void> saveData() async {
    setState(() {
      data.producto = products;
    });
  }

  Future<void> saveToLocal() async {
    LocalStorage localS = LocalStorage(FileName().report);
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
        lugar: "Periban de ramos",
        productor: "Jose Alberto Espinoza Morelos 3",
        latitude: data.latitude,
        longitud: data.longitud,
        ubicacion: "Periban de ramos",
        predio: "El pedregal III",
        cultivo: "Aguacate",
        etapaFenologica: "EtapaF",
        observaciones: "Muchas observaciones al respecto",
        litros: 100,
        enfermedad: enfer,
        plaga: plag,
        producto: prod));
  }
}
