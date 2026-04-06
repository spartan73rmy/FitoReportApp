import 'dart:convert';
import '../Models/APIResponse.dart';
import '../Models/HttpModel.dart';
import '../Models/etapaFenologica.dart';
import 'package:http/http.dart' as http;

class EtapaFService extends HttpModel {
  String url = "EtapaFenologica/";

  Future<APIResponse<List<EtapaFenologica>>> getListEtapas(String authToken) {
    return http
        .get(
          Uri.parse(HttpModel.getUrl + url + "GetAllEtapas"),
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(const Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final etapasList = EtapaFList.fromJSON(jsonData);
            return APIResponse<List<EtapaFenologica>>(data: etapasList.etapas ?? []);
          }
          return APIResponse<List<EtapaFenologica>>(
            
              data: <EtapaFenologica>[],
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) {
          
          final r= APIResponse<List<EtapaFenologica>>(
            data: <EtapaFenologica>[],
            error: true,
            errorMessage: error.toString());
          return r;
                }
                );

  }

  Future<APIResponse<bool>> deleteEtapa(int idEtapa, String authToken) {
    return http
        .delete(Uri.parse(HttpModel.getUrl + url + "Delete/$idEtapa"), headers: {
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
