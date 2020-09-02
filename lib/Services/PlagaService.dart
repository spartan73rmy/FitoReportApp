import 'dart:convert';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:http/http.dart' as http;

class PlagaService extends HttpModel {
  String url = "/Plaga";

  Future<APIResponse<List<Plaga>>> getListPlaga() {
    return http.get(api() + url, headers: header()).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        final plagaList = PlagaList.fromJSON(jsonData);
        return APIResponse<List<Plaga>>(data: plagaList.plagas);
      }
      return APIResponse(
          error: true, errorMessage: "Ocurrio un error al conectar a internet");
    }).catchError((_) => APIResponse(
        error: true, errorMessage: "Ocurrio un error al conectar a internet"));
  }
}
