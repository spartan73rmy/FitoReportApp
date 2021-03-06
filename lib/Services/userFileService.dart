import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/fileHash.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

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
}
