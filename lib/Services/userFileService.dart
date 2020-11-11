import 'dart:io';
import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserFilesService extends HttpModel {
  String url = "Archivos/";

  Future<APIResponse<bool>> uploadFile(File image) async {
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      Uri.parse(HttpModel.getUrl + url + "AgregarArchivo"),
    );

    // Attach the file in the request
    final file = await http.MultipartFile.fromPath('Archivo', image.path,
        contentType: new MediaType('image', 'jpeg'));

    imageUploadRequest.files.add(file);
    imageUploadRequest.fields['Nombre'] = "Example";

    try {
      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode != 200) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: "La sesion ha caducado, reinicie sesion");
    } catch (error) {
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage:
              "Ocurrio un error al conectar a internet " + error.toString());
    }
  }
}
