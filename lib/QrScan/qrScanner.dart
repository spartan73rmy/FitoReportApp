import 'dart:async';
import 'dart:typed_data';

import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/Pdf/pdfPrinter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QrScaner extends StatefulWidget {
  @override
  _QrScanerState createState() => _QrScanerState();
}

class _QrScanerState extends State<QrScaner> {
  Uint8List bytes = Uint8List(0);
  String url;
  @override
  initState() {
    url = "http://192.168.43.141:8080/details/";
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Escaner QR"),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[],
            );
          },
        ),
        persistentFooterButtons: [
          FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.photo),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {_scanPhoto()},
              label: Text("Galeria")),
          FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.qr_code_scanner),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {_scan()},
              label: Text("Camara"))
        ]);
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    if (barcode != null) {
      int id = parseUrl(barcode);
      navigateToPdfPrint(id);
    }
  }

  Future _scanPhoto() async {
    String barcode = await scanner.scanPhoto();
    int id = parseUrl(barcode);
    navigateToPdfPrint(id);
  }

  navigateToPdfPrint(int id) {
    if (id == 0) {
      alertDiag(context, "Error", "El Qr escaneado no se leyo correctamente");
    } else {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PDFPrinterShare(idReport: id)),
      );
    }
  }

  int parseUrl(String urlImage) {
    urlImage = urlImage.replaceAll(url, "");
    int id = 0;
    try {
      id = int.parse(urlImage);
    } catch (e) {
      print(e);
    }
    return id;
  }
}
