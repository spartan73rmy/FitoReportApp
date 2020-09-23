import 'dart:convert';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:http/http.dart' as http;

class EnfermedadService extends HttpModel {
  String url = "Enfermedad";

  Future<APIResponse<List<Enfermedad>>> getListEnfermedad(authToken) {
    return http
        .get(
          HttpModel.getUrl() + url,
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final enfermedadList = EnfermedadList.fromJSON(jsonData);
            return APIResponse<List<Enfermedad>>(
                data: enfermedadList.enfermedades);
          }
          return APIResponse<List<Enfermedad>>(
              data: new List<Enfermedad>(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<Enfermedad>>(
            data: new List<Enfermedad>(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }
}
