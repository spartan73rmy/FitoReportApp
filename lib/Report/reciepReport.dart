import '../CommonWidgets/alertInput.dart';
import '../Home/homePage.dart';
import '../Models/reportData.dart';
import '../Models/producto.dart';
import '../Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_it/get_it.dart';
import '../CommonWidgets/productDialog.dart';
import 'reciepReportBody.dart';

class ReciepReport extends StatefulWidget {
  final ReportData data;
  const ReciepReport({super.key, required this.data});

  @override
  _ReciepReportState createState() {
    return new _ReciepReportState();
  }
}

class _ReciepReportState extends State<ReciepReport> {
  late ReportData data;
  List<Producto> products = [];
  bool typing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: UniqueKey(),
      appBar: AppBar(title: Text('Recomendacion'), actions: <Widget>[
        TextButton(
          onPressed: () {
            alertInputDiag(context, "Litros", "Cantidad", "Introduce un numero")
                .then((result) {
              int? l = int.tryParse(result ?? '');
              if (l != null && l >= 0) {
                setState(() {
                  data.litros = l;
                });
              }
            });
          },
          child: Center(child: Text("${data.litros} L agua")),
        ),
        IconButton(
          icon: const Icon(Icons.save),
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
        child: const Icon(Icons.add),
        onPressed: () {
          addEditProductDialog(context).then((value) {
            if (value == null) return;
            bool isValidProduct = value.nombre.isNotEmpty &&
                value.cantidad > 0 &&
                value.unidad.isNotEmpty;
            if (isValidProduct) addProduct(value);
          });
        },
      ),
    );
  }

  @override
  void initState() {
    data = widget.data;
    data.litros = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addProduct(Producto product) {
    setState(() {
      products.add(product);
    });
  }

  Future<void> getGeoLocation() async {
    print("GPS...");
    bool isEnabled = await Geolocator.isLocationServiceEnabled();
    if (isEnabled) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission != LocationPermission.always &&
          permission != LocationPermission.whileInUse) {
        permission = await Geolocator.requestPermission();
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        setState(() {
          data.latitude = position.latitude;
          data.longitud = position.longitude;
        });
      } else {
        final Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);
        setState(() {
          data.latitude = position.latitude;
          data.longitud = position.longitude;
        });
      }
    }
  }

  Future<void> saveData() async {
    setState(() {
      data.productoJson = products.map((p) => p.toJson()).toList();
    });
  }

  Future<void> saveToLocal() async {
    LocalStorage localS = GetIt.I<LocalStorage>();
    await localS.addReport(this.data);
  }
}
