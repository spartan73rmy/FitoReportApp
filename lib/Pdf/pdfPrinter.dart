import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Pdf/pdfPreview.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/reportService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFPrinterShare extends StatefulWidget {
  final int idReport;
  PDFPrinterShare({this.idReport});

  @override
  _PDFPrinterShareState createState() => _PDFPrinterShareState();
}

class _PDFPrinterShareState extends State<PDFPrinterShare> {
  Ping get ping => GetIt.I<Ping>();
  ReportService get service => GetIt.I<ReportService>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  String directory;
  bool _isLoading = false;
  ReportData report;
  String url = "http://192.168.43.141:8080/details/";
  String qrPath;

  @override
  void initState() {
    super.initState();
    loadReport();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte"),
        actions: <Widget>[
          _isLoading
              ? Icon(Icons.cake)
              : IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => {_onShare(context)},
                )
        ],
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return LoadingScreen();
        }
        return Column();
      }),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PdfPreview(
                              path: directory,
                            )));
              },
              child: Icon(Icons.book),
            ),
    );
  }

  Future<bool> getReport() async {
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);
    String authToken = Auth.getToken(_sharedPreferences);
    var isOnline = await ping.ping();

    if (isOnline) {
      if (isNotLogged) toLogIn();
      var resp = await service.getReport(authToken, widget.idReport);

      if (resp.error) {
        alertDiag(context, "Error", resp.errorMessage);
        return false;
      }

      setState(() {
        report = resp.data;
      });

      return true;
    } else {
      alertDiag(
          context, "Error", "Favor de conectarse a internet e iniciar sesion");
      return false;
    }
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();
    List<String> archivos = new List<String>();
    archivos.add(directory);
    String text = "Archivos";
    String sub = "Reporte";
    if (directory.isNotEmpty) {
      await Share.shareFiles(archivos,
          text: text,
          subject: sub,
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          // subject: {subject, Rect.zero},
          sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    }
  }

  toLogIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login("FitoReport")),
    );
  }

  void loadReport() async {
    _showLoading();
    bool isValid = await getReport();
    if (isValid) {
      await setQR();
      String path = await savePdf(report);
      setState(() {
        directory = path;
      });
    }
    _hideLoading();
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  setQR() async {
    ByteData byteData = await QrPainter(
        data: "$url${widget.idReport}",
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        // embeddedImage: ,
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: Size(20, 20),
        )).toImageData(400, format: ImageByteFormat.png);

    Uint8List pngBytes = byteData.buffer.asUint8List();

    final tempDir = await getTemporaryDirectory();
    final path = "${tempDir.path}/qr.png";
    final file = await new File(path).create();
    await file.writeAsBytes(pngBytes);

    setState(() {
      qrPath = path;
    });
  }

  imageToBase64(String pathImage) async {
    if (pathImage.isEmpty) return;
    ByteData bytes = await rootBundle.load(pathImage);
    var buffer = bytes.buffer;
    return base64.encode(Uint8List.view(buffer));
  }

  Future<String> savePdf(ReportData r) async {
    String uni = await imageToBase64("assets/icon/uni.png");
    String cuidaPlaneta = await imageToBase64("assets/icon/cuida.jpg");
    print(uni);
    String plagas = "";
    String enfermedades = "";
    String productos = "";
    r.plaga.forEach((plaga) {
      plagas += "${plaga.nombre.toString()}, ";
    });
    r.enfermedad.forEach((enfermedad) {
      enfermedades += "${enfermedad.nombre.toString()}, ";
    });
    r.producto.forEach((p) {
      productos +=
          "<tr><td>${p.cantidad}</td><td>${p.nombre}</td><td>${p.ingredienteActivo}</td><td>${p.concentracion}</td><td>${p.intervaloSeguridad}</td></tr>";
    });

    var htmlContent = """
    <!DOCTYPE html>
<html>
  <head>
    <style>
      table {
        border-collapse: separate;
        border-spacing: 10;
        border: 1px solid black;
        border-radius: 15px;
        -moz-border-radius: 20px;
      }
      td {
        text-align: center;
        border-top: solid black 1px;
      }
      th {
        border-top: none;
      }
      .trleft {
        text-align: left;
      }
      .tdleft {
        text-align: left;
      }
      h1 {
        text-align: center;
      }
      h2 {
        text-align: center;
      }
      h3 {
        text-align: center;
      }
      h4 {
        text-align: center;
      }
      h5 {
        text-align: center;
      }
      div {
        text-align: center;
      }
      p {
        text-align: left;
      }
    </style>
  </head>

  <body>
        <img
      style="float: right"
      width="100"
      height="100"
      src="data:image/png;base64,$uni"
      alt="Universidad"
    />
    <img
      style="float: left"
      width="150"
      height="100"
      src="data:image/jpeg;base64,$cuidaPlaneta"
      alt="Planeta"
    />
    <h1>AGROQUIMICOS "GUERRERO"</h1>
    <h3>ING. ELVIN MISAEL GALVAN GUERRERO</h3>
    <h5>
      LIC. ANTONIO CASTRO NO.9 COL SANTA ROSA C.P. 60360 LOS REYES DE SALGADO,
      MICH
    </h5>
    <h2><b>REPORTE FITOSANITARIO</b></h2>

    <table style="width: 100%">
      <tr>
        <td style="border-top: none; text-align: left">Lugar y Fecha: ${r.lugar} ${DateTime.now().toLocal()}</td>
      </tr>
      <tr>
        <td style="text-align: left">Nombre del produtor: ${r.productor}</td>
      </tr>
      <tr>
        <td style="text-align: left">Ubicacion: ${r.ubicacion}</td>
      </tr>
      <tr>
        <td style="text-align: left">Nombre del predio: ${r.predio}</td>
      </tr>
      <tr>
        <td style="text-align: left">Cultivo: ${r.cultivo}</td>
      </tr>
      <tr>
        <td style="text-align: left">Etapa Fenologica: ${r.etapaFenologica}</td>
      </tr>
      <tr>
        <td style="text-align: left">Enfermedades: $enfermedades</td>
      </tr>
      <tr>
        <td style="text-align: left">Plagas: $plagas</td>
      </tr>
    </table>
    <br />
    <table style="width: 100%">
      <tr>
        <td style="border-top: none; text-align: left">Observaciones: ${r.observaciones}</td>
      </tr>
    </table>

    <h2>Aspersión Foliar</h2>
    <p style="text-align: left">
      RECOMENDACION: Para cada ( 100 ) Litros de agua
    </p>

    <table style="width: 100%">
      <tr>
        <th>Cantidad</th>
        <th>Producto</th>
        <th>Ingrediente Activo</th>
        <th>Concentracion %</th>
        <th>Intervalo de Seguridad</th>
      </tr>
        $productos
    </table>
        <br />
            <a href="$url${widget.idReport}" style="float: right">Clic para ver reporte</a>
    <h3>ELVIN MISAEL GALVAN GUERRERO</h3>
    <h4>Ingeniero Agronomo Fruticultor</h4>
    <p><b>No. De CEDULA:</b></p>
    <p><b>354 110 2486</b></p>
        <img
      style="float: right"
      width="150"
      height="150"
      src="file://$qrPath"
      alt="QR"
    />
  </body>
</html>
      """;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "Reporte ${r.productor}";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);
    return generatedPdfFile.path;
  }
}
