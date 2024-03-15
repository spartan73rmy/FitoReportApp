import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import '../Models/apiResponse.dart';
import '../Models/HttpModel.dart';
import '../Models/fileHash.dart';
import '../Models/tokenDescarga.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class UserFilesService extends HttpModel {
  String url = "Archivos/";

  Future<APIResponse<String>> uploadFile(
      File image, int idReporte, authToken) async {
    Map<String, String> headers = {
      'Authorization': "Bearer $authToken",
      'Content-Type': 'application/json'
    };
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(HttpModel.getUrl + url + "AgregarArchivo"),
    );
    request.headers.addAll(headers);

    request.files.add(http.MultipartFile(
      'file',
      image.readAsBytes().asStream(),
      image.lengthSync(),
      filename: "Archivo.jpeg",
      contentType: MediaType('image', 'jpeg'),
    ));

    request.fields.addAll({"idReporte": "$idReporte"});
    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        return APIResponse<String>(
            data: FileHash.fromJson(jsonDecode(response.body)).hash);
      }
      return APIResponse<String>(
          data: null,
          error: true,
          errorMessage: "La sesion ha caducado, reinicie sesion");
    } catch (error) {
      return APIResponse<String>(
          data: null,
          error: true,
          errorMessage:
              "Ocurrio un error al conectar a internet " + error.toString());
    }
  }

  Future<APIResponse<TokenHashDescarga>> getTokenFile(
      authToken, String hashArchivo) {
    return http
        .post(
          HttpModel.getUrl + url + "GeneraTokenDescarga",
          body: jsonEncode(TokenDescarga(hashArchivo).toJson()),
          headers: {
            'Authorization': "Bearer " + authToken,
            'Content-Type': 'application/json'
          },
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            var tokenHash = TokenHashDescarga.fromJson(jsonData);
            tokenHash.hash = hashArchivo;
            return APIResponse<TokenHashDescarga>(data: tokenHash);
          }
          if (data.statusCode == 401) {
            return APIResponse<TokenHashDescarga>(
                data: new TokenHashDescarga(""),
                error: true,
                errorMessage: "No tiene permiso para acceder");
          }
          return APIResponse<TokenHashDescarga>(
              data: new TokenHashDescarga(""),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<TokenHashDescarga>(
            data: new TokenHashDescarga(""),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }

  downloadFile(String url, TokenHashDescarga tokenHash) async {
    var httpClient = http.Client();
    var request = new http.Request(
        'GET',
        Uri.parse(
            HttpModel.getUrl + url + "DescargarArchivo/" + tokenHash.hash));

    request.headers.addAll({'Content-Type': 'application/json'});
    request.headers.addAll(tokenHash.toJson());

    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;

    List<List<int>> chunks = new List();
    int downloaded = 0;

    response.asStream().listen((http.StreamedResponse r) {
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');

        // Save the file
        File file = new File('$dir/archivo');
        final Uint8List bytes = Uint8List(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        return file;
      });
    });
  }
}
