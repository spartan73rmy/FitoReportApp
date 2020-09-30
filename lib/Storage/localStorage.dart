import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:path_provider/path_provider.dart';

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
      print("File exists");
      Map<String, String> jsonFileContent =
          json.decode(file.readAsStringSync());
      jsonFileContent.addAll(data);
      file.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print("File does not exist!");
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
    print("Clear this $jsonData");
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
    print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> refreshEnfermedades(List<Enfermedad> lista) async {
    await clearEnfermedadesFile();
    String jsonData =
        jsonEncode(new EnfermedadList(enfermedades: lista).toJson());
    print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<void> addReport(ReportData reporte) async {
    final file = await _localFile;
    List<ReportData> lista;

    if (file.existsSync()) {
      print("File Exist- add element");
      String contents = await file.readAsString();
      lista = ReportDataList.fromJSON(json.decode(contents)).reportes;
      lista.add(reporte);
    } else {
      print("Create new File");
      lista = new List<ReportData>();
      lista.add(reporte);
    }
    for (var item in lista) {
      print(
          "------------------------------------------------------------------");
      print(item.toJson());
    }

    String jsonData = jsonEncode(new ReportDataList(reportes: lista)
        .toJson()); // this will automatically call toJson
    print("Guarda $jsonData");
    writeJsonToFile(jsonData);
  }

  Future<List<ReportData>> readReports() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      // print("Read $contents");
      var lista = ReportDataList.fromJSON(json.decode(contents)).reportes;
      for (var item in lista) {
        print(
            "------------------------------------------------------------------");
        print(item.toJson());
      }
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
      print("Read $contents");
      var lista = EtapaFList.fromJSON(json.decode(contents)).etapas;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<EtapaFenologica>();
    }
  }

  Future<List<Plaga>> readPlagas() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      print("Read $contents");
      var lista = PlagaList.fromJSON(json.decode(contents)).plagas;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<Plaga>();
    }
  }

  Future<List<Enfermedad>> readEnfermedades() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      print("Read $contents");
      var lista = EnfermedadList.fromJSON(json.decode(contents)).enfermedades;
      return lista;
    } catch (e) {
      print("File corrupt -> $e");
      await clearReportFile();
      return new List<Enfermedad>();
    }
  }
}
