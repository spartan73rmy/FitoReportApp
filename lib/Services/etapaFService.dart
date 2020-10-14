import 'dart:convert';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:http/http.dart' as http;

class EtapaFService extends HttpModel {
  String url = "EtapaFenologica/";

  Future<APIResponse<List<EtapaFenologica>>> getListEtapas(authToken) {
    return http
        .get(
          HttpModel.getUrl() + url + "GetAllEtapas",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final etapasList = EtapaFList.fromJSON(jsonData);
            return APIResponse<List<EtapaFenologica>>(data: etapasList.etapas);
          }
          return APIResponse<List<EtapaFenologica>>(
              data: new List<EtapaFenologica>(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<EtapaFenologica>>(
            data: new List<EtapaFenologica>(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }
}
