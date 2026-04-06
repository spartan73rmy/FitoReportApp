import 'dart:convert';
import '../Models/HttpModel.dart';
import '../Models/apiResponse.dart';
import '../Models/enfermedad.dart';
import 'package:http/http.dart' as http;

class EnfermedadService extends HttpModel {
  String url = "Enfermedad/";

  Future<APIResponse<List<Enfermedad>>> getListEnfermedad(String authToken) {
    return http
        .get(
          Uri.parse(HttpModel.getUrl + url + "GetEnfermedades"),
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(const Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final enfermedadList = EnfermedadList.fromJSON(jsonData);
            return APIResponse<List<Enfermedad>>(
                data: enfermedadList.enfermedades ?? []);
          }
          return APIResponse<List<Enfermedad>>(
              data: <Enfermedad>[],
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<Enfermedad>>(
            data: <Enfermedad>[],
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }

  Future<APIResponse<bool>> deleteEnfermedad(int idEnfermedad, String authToken) {
    return http
        .delete(Uri.parse(HttpModel.getUrl + url + "Delete/$idEnfermedad"), headers: {
          'Authorization': "Bearer " + authToken,
          'Content-Type': 'application/json'
        })
        .timeout(const Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            return APIResponse<bool>(data: true);
          }
          if (data.statusCode == 404) {
            return APIResponse<bool>(
                data: false,
                error: true,
                errorMessage: "No se encuentra el elemento");
          }
          return APIResponse<bool>(
              data: false,
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<bool>(
            data: false,
            error: true,
            errorMessage: "Ocurrio un error al conectar a internet \n" +
                error.toString()));
  }
}
