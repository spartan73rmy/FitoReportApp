import 'dart:convert';
import 'dart:io';
import '../Models/enfermedad.dart';
import '../Models/etapaFenologica.dart';
import '../Models/plaga.dart';
import '../Models/reportData.dart';
import '../Storage/randomIntId.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class LocalStorage {
  LocalStorage(this.fileName);

  String fileName;
  bool fileExists = false;

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  Future<File> createFile(var data) async {
    final file = await _localFile;
    var dataToWrite = json.encode(data);
    file.createSync();
    fileExists = true;

    // Write the file.
    return file.writeAsString(dataToWrite);
  }

  void writeToFile(var data) async {
    final file = await _localFile;

    if (file.existsSync()) {
      // print("File exists");
      Map<String, String> jsonFileContent =
          json.decode(file.readAsStringSync());
      jsonFileContent.addAll(data);
      file.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      // print("File does not exist!");
      createFile(data);
    }
  }

  Future<File> createJsonFile(var data) async {
    final file = await _localFile;
    file.createSync();
    fileExists = true;

    // Write the file.
    return file.writeAsString(data);
  }

  void writeJsonToFile(var jsonData) async {
    final file = await _localFile;

    if (file.existsSync()) {
      file.writeAsStringSync(jsonData);
    } else {
      createJsonFile(jsonData);
    }
  }

  Future<void> clearReportFile() async {
    String jsonData =
        jsonEncode(ReportDataList(reportes: new List<ReportData>()));
    writeJsonToFile(jsonData);
  }

  Future<void> clearEtapasFile() async {
    String jsonData = jsonEncode(
        new EtapaFList(etapas: new List<EtapaFenologica>()).toJson());
    writeJsonToFile(jsonData);
  }

  Future<void> clearPlagasFile() async {
    String jsonData =
        jsonEncode(new PlagaList(plagas: new List<Plaga>()).toJson());
    // print("Clear this $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> clearEnfermedadesFile() async {
    String jsonData = jsonEncode(
        new EnfermedadList(enfermedades: new List<Enfermedad>()).toJson());
    writeJsonToFile(jsonData);
  }

  Future<void> refreshEtapas(List<EtapaFenologica> lista) async {
    await clearEtapasFile();
    EtapaFList etapas = new EtapaFList(etapas: lista);

    String jsonData = jsonEncode(etapas.toJson());
    writeJsonToFile(jsonData);
  }

  Future<void> refreshPlagas(List<Plaga> lista) async {
    await clearPlagasFile();
    String jsonData = jsonEncode(new PlagaList(plagas: lista).toJson());
    // print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> refreshEnfermedades(List<Enfermedad> lista) async {
    await clearEnfermedadesFile();
    String jsonData =
        jsonEncode(new EnfermedadList(enfermedades: lista).toJson());
    // print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> refreshReportes(List<ReportData> lista) async {
    await clearReportFile();
    String jsonData = jsonEncode(new ReportDataList(reportes: lista).toJson());
    // print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> addReport(ReportData reporte) async {
    reporte.id = IdGen.getId(); //Get Temp ID to save report and its own images
    final file = await _localFile;
    List<ReportData> lista;

    if (file.existsSync()) {
      String contents = await file.readAsString();
      lista = ReportDataList.fromJSON(json.decode(contents)).reportes;
      lista.add(reporte);
    } else {
      lista = new List<ReportData>();
      lista.add(reporte);
    }
    //Save Images with IdReport
    await writeImages(reporte.images, reporte.id);

    String jsonData = jsonEncode(new ReportDataList(reportes: lista)
        .toJson()); // this will automatically call toJson
    writeJsonToFile(jsonData);
  }

  Future<List<ReportData>> deleteReport(int index) async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = ReportDataList.fromJSON(json.decode(contents)).reportes;
      if (lista.length > index && lista.length > 0 && index >= 0) {
        //Delete Images in the index of report
        deleteImages(lista[index].id);
        lista.removeAt(index);
        refreshReportes(lista);
      }
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<ReportData>();
    }
  }

  Future<List<ReportData>> readReports() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = ReportDataList.fromJSON(json.decode(contents)).reportes;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<ReportData>();
    }
  }

  Future<List<ReportData>> readReportsImages() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = ReportDataList.fromJSON(json.decode(contents)).reportes;

      //Set images from directory and set to report data
      for (int i = 0; i < lista.length; i++)
        lista[i].images = await readImages(lista[i].id);

      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<ReportData>();
    }
  }

  Future<List<EtapaFenologica>> readEtapas() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = EtapaFList.fromJSON(json.decode(contents)).etapas;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearEtapasFile();
      return new List<EtapaFenologica>();
    }
  }

  Future<List<Plaga>> readPlagas() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = PlagaList.fromJSON(json.decode(contents)).plagas;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearPlagasFile();
      return new List<Plaga>();
    }
  }

  Future<List<Enfermedad>> readEnfermedades() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var lista = EnfermedadList.fromJSON(json.decode(contents)).enfermedades;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearEnfermedadesFile();
      return new List<Enfermedad>();
    }
  }

  Future<void> deleteAllImages() async {
    final path = await _localPath;
    Directory dir = Directory('$path/images/');
    if (dir.existsSync()) await dir.delete(recursive: true);
    print('All images are deleted');
  }

  Future<void> deleteImages(int id) async {
    Directory dir = await imagesDir(id);
    if (dir.existsSync()) await dir.delete(recursive: true);
    print('Imagenes en $id eliminadas');
  }

  Future<List<File>> readImages(int id) async {
    var filesList = new List<File>();
    Directory dir = await imagesDir(id);
    dir.listSync(recursive: true).forEach((element) {
      if (element is File) {
        filesList.add(element);
      }
    });
    return filesList;
  }

  Future<void> writeImages(List<File> images, int id) async {
    if (images == null) return;
    String route = (await imagesDir(id)).path;
    for (int i = 0; i < images.length; i++) {
      String newPath = path.join(route, '$i.jpg');
      print(newPath);
      images[i] = await File(images[i].path).copy(newPath);
    }
  }

  Future<Directory> imagesDir(int idReport) async {
    final path = await _localPath;
    Directory imagesDir = Directory('$path/images/$idReport/');
    bool exist = await imagesDir.exists();
    print(exist);
    if (exist) {
      return imagesDir;
    } else {
      imagesDir = await imagesDir.create(recursive: true);
      return imagesDir;
    }
  }
}
