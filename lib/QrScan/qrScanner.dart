import 'dart:async';
import 'dart:typed_data';

import '../CommonWidgets/alert.dart';
import '../Pdf/pdfPrinter.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScaner extends StatefulWidget {
  @override
  _QrScanerState createState() => _QrScanerState();
}

class _QrScanerState extends State<QrScaner> {
  Uint8List bytes = Uint8List(0);
  String url = "http://192.168.43.141:8080/details/";
  MobileScannerController? controller;

  @override
  void initState() {
    super.initState();
    controller = MobileScannerController();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Escaner QR"),
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
              icon: const Icon(Icons.photo),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {_scanPhoto()},
              label: const Text("Galeria")),
          FloatingActionButton.extended(
              heroTag: null,
              icon: const Icon(Icons.qr_code_scanner),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () => {_scan()},
              label: const Text("Camara"))
        ]);
  }

  Future<void> _scan() async {
    controller?.barcodes;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escanear QR'),
        content: SizedBox(
          width: 300,
          height: 300,
          child: MobileScanner(
            controller: controller,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  Navigator.of(context).pop();
                  int id = parseUrl(barcode.rawValue!);
                  navigateToPdfPrint(id);
                  return;
                }
              }
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _scanPhoto() async {
    if (controller == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar QR'),
        content: const Text('Use la camara para escanear'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void navigateToPdfPrint(int id) {
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
