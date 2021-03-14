import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:latlong/latlong.dart';
import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/deleteDialog.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Map/map.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Models/tokenDescarga.dart';
import 'package:LikeApp/Pdf/pdfPreview.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/reportService.dart';
import 'package:LikeApp/Services/userFileService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:LikeApp/Image/zoom.dart';

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
  bool _isLoading = false, addImages = false;
  ReportData report;
  String url = "http://192.168.43.141:8080/details/";
  String qrPath;
  List<File> images;
  @override
  void initState() {
    super.initState();
    loadReport();
    images = new List<File>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reporte"),
        actions: <Widget>[
          Center(child: Text("Imagenes")),
          IconButton(
            icon: Icon(
              addImages ? Icons.check_box : Icons.check_box_outline_blank,
              color: addImages ? Colors.white70 : null,
            ),
            onPressed: () {
              setState(() {
                addImages = !addImages;
                loadReport();
              });
            },
          ),
          _isLoading
              ? Icon(Icons.cake)
              : IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () => {onShare(context)},
                ),
        ],
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return LoadingScreen();
        }
        return Card(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _isLoading
                  ? LoadingScreen()
                  : MapArea(LatLng(report.latitude, report.longitud)),
              images.isNotEmpty
                  ? listPreviewImages()
                  : Text("Marque la opcion imagenes para mostrar las imagenes")
            ],
          ),
        );
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

  Widget listPreviewImages() {
    return Container(
      alignment: Alignment.bottomCenter,
      height: MediaQuery.of(context).size.height * 0.50,
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          // shrinkWrap: true,
          itemCount: images.length,
          itemBuilder: (BuildContext context, int i) {
            return Padding(
                padding: EdgeInsets.all(5),
                child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      setState(() {
                        images.removeAt(i);
                      });
                      loadReport();
                    },
                    confirmDismiss: (direction) async {
                      final bool delete = await showDialog(
                              context: context,
                              builder: (_) => DeleteDialog()) ??
                          false;
                      return delete;
                    },
                    background: Container(
                      color: Colors.blue,
                      padding: EdgeInsets.only(left: 16),
                      child: Align(
                        child: Icon(Icons.delete, color: Colors.white),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ZoomImage(images[i])),
                              );
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.file(
                                  images[i],
                                  fit: BoxFit.cover,
                                )),
                          )
                        ]))));
          }),
    );
  }

  Future<File> downloadFile(
      TokenHashDescarga tokenHash, String hash, String authToken) async {
    http.Client client = new http.Client();

    var req = await client.get(
        Uri.parse(
            HttpModel.getUrl + "Archivos/DescargarArchivo/${tokenHash.hash}"),
        headers: {
          'Authorization': "Bearer " + authToken,
          'hashArchivo': tokenHash.hash,
          'tokenDescarga': tokenHash.tokenDescarga
        });

    print(req.headers);

    var bytes = req.bodyBytes;
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$hash.jpeg');
    await file.writeAsBytes(bytes);
    return file;
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

  downloadImages(List<String> hashes) async {
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);
    String authToken = Auth.getToken(_sharedPreferences);
    var isOnline = await ping.ping();

//There is images loaded is not downloaded needed
    if (images != null && images.isNotEmpty) {
      return;
    }

    if (isOnline) {
      if (isNotLogged) toLogIn();
      UserFilesService u = new UserFilesService();
      if (hashes != null)
        for (String hash in hashes) {
          var respToken = await u.getTokenFile(authToken, hash);
          if (!respToken.error) {
            //If all images are downloaded skip download process
            if (addImages && images.length < hashes.length) {
              File file = await downloadFile(respToken.data, hash, authToken);
              if (file != null) {
                setState(() {
                  images.add(file);
                });
              }
            }
          }
        }
      return true;
    } else {
      alertDiag(
          context, "Error", "Favor de conectarse a internet e iniciar sesion");
      return false;
    }
  }

  onShare(BuildContext context) async {
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
    DateTime initial = DateTime.now();
    _showLoading();
    if (report == null) {
      await getReport();
    }
    if (report != null) {
      if (addImages) {
        await downloadImages(report.imagesHash);
      }
      await setQR();
      String path = await savePdf(report);
      setState(() {
        directory = path;
      });
    }
    _hideLoading();

    DateTime after = DateTime.now();
    var time = after.difference(initial);
    print(
        'timestamp: ${initial.hour}:${initial.minute}:${initial.second}.${initial.millisecond}');
    print(
        'timestamp: ${after.hour}:${after.minute}:${after.second}.${after.millisecond}');
    print(time.inMilliseconds);
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
    //If qr is loaded rendered is not necessary
    if (qrPath != null && qrPath.isNotEmpty) {
      return;
    }
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
    final file = await File(path).create();
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
    String imgs64 = "";
    String plagas = "";
    String enfermedades = "";
    String productos = "";
    String etapas = "";
    DateTime today = r.created;

    if (addImages) {
      imgs64 += """<br /><br /><br /><br />
        <br /><br /><br /><br />
        <br /><br /><br /><br />
        <br /><br /><br /><br />
        <br /><br /><br /><br />""";

      imgs64 += """<table><tbody><th>Adjuntos:</th>""";

      for (File image in images) {
        String img64 = base64.encode(await image.readAsBytes());

        imgs64 +=
            """<tr><td><img style="float: right" width="800" height="800" src="data:image/jpeg;base64,$img64"/></td></tr>""";
      }

      imgs64 += """</tbody></table>""";
    }

    String fecha =
        "${today.day.toString().padLeft(2, '0')}/${today.month.toString().padLeft(2, '0')}/${today.year.toString()}";
    r.plaga.forEach((plaga) {
      plagas += "${plaga.nombre.toString()}, ";
    });
    r.enfermedad.forEach((enfermedad) {
      enfermedades += "${enfermedad.nombre.toString()}, ";
    });
    r.etapaFenologica.forEach((etapaFenologica) {
      etapas += "${etapaFenologica.nombre.toString()}, ";
    });
    r.producto.forEach((p) {
      productos +=
          "<tr><td>${p.cantidad} ${p.unidad}</td><td>${p.nombre}</td><td>${p.ingredienteActivo}</td><td>${p.concentracion}</td><td>${p.intervaloSeguridad}</td></tr>";
    });

    var htmlContent = """
    <!DOCTYPE html>
<html>
  <head>
    <style>
      table {
        border-collapse: separate;
        border-spacing: 2;
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
      width="90"
      height="90"
      src="data:image/png;base64,$uni"
      alt="Universidad"
    />
    <img
      style="float: left"
      width="140"
      height="90"
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
        <td style="border-top: none; text-align: left">Lugar y Fecha: ${r.lugar} $fecha</td>
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
        <td style="text-align: left">Etapa Fenologica: $etapas</td>
      </tr>
      <tr>
        <td style="text-align: left">Enfermedades: $enfermedades</td>
      </tr>
      <tr>
        <td style="text-align: left">Plagas: $plagas</td>
      </tr>
      <tr>
        <td style="text-align: left">Observaciones: ${r.observaciones}</td>
      </tr>
    </table>

    <h2>Aspersión Foliar</h2>
    <p style="text-align: left">
      RECOMENDACION: Para cada ( ${r.litros} ) Litros de agua
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
            <a href="$url${widget.idReport}" style="float: right">Clic para ver reporte</a>
    <br/>
    <h4>ELVIN MISAEL GALVAN GUERRERO</43>
    <h5>Ingeniero Agronomo Fruticultor</h5>
    <p><b>No. De CEDULA:</b></p>
    <p><b>354 110 2486</b></p>
        <img style="float: right"
      width="100"
      height="100"
      src="file://$qrPath"
      alt="QR"/>    
      <br/>      
          $imgs64

  </body>
</html>
      """;

    Directory appDocDir = await getApplicationDocumentsDirectory();
    var targetPath = appDocDir.path;
    var targetFileName = "Reporte ${r.productor} ${r.created}";

    var generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
        htmlContent, targetPath, targetFileName);

    return generatedPdfFile.path;
  }
}
