import 'dart:convert';
import '../Models/HttpModel.dart';
import '../Models/apiResponse.dart';
import '../Models/plaga.dart';
import 'package:http/http.dart' as http;

class PlagaService extends HttpModel {
  String url = "Plaga/";

  Future<APIResponse<List<Plaga>>> getListPlaga(authToken) {
    return http
        .get(
          HttpModel.getUrl + url + "GetPlagas",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final plagaList = PlagaList.fromJSON(jsonData);
            return APIResponse<List<Plaga>>(data: plagaList.plagas);
          }
          return APIResponse<List<Plaga>>(
              data: new List<Plaga>(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<Plaga>>(
            data: new List<Plaga>(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }

  Future<APIResponse<bool>> deletePlaga(int idPlaga, authToken) {
    return http
        .delete(HttpModel.getUrl + url + "Delete/$idPlaga", headers: {
          'Authorization': "Bearer " + authToken,
          'Content-Type': 'application/json'
        })
        .timeout(Duration(seconds: 15))
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
