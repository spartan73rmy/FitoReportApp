import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class LocalStorage {
  String fileName = "myJSONFile.json";
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

  Future<dynamic> readCounter() async {
    try {
      final file = await _localFile;
      // Read the file.
      String contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      // If encountering an error, return 0.
      return e;
    }
  }
}
