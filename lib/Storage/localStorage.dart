import 'dart:convert';
import 'dart:io';
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

  Future<void> clearFile() async {
    final file = await _localFile;
    if (file.existsSync()) {
      print("File exist to clear");
      String jsonData = jsonEncode({"reportes": []});
      writeJsonToFile(jsonData);
    }
  }

  Future<void> addReport(ReportData reporte) async {
    final file = await _localFile;
    List<ReportData> lista;

    if (file.existsSync()) {
      print("File Exist- add element");
      lista = ReportDataList.fromJSON(json.decode(file.readAsStringSync()))
          .reportes;
      lista.add(reporte);
    } else {
      print("Create new File");
      lista = new List<ReportData>();
      lista.add(reporte);
    }

    String jsonData =
        jsonEncode({"reportes": lista}); // this will automatically call toJson
    writeJsonToFile(jsonData);
  }

  Future<List<ReportData>> readReports() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      var reportes = ReportDataList.fromJSON(json.decode(contents)).reportes;
      return reportes;
    } catch (e) {
      print(e);
      print("File corrupt");
      await clearFile();
      return new List<ReportData>();
    }
  }
}
