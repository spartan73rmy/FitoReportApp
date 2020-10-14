import 'dart:convert';
import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/dataSearch.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:http/http.dart' as http;

class ReportService extends HttpModel {
  String url = "Reporte/";

  Future<APIResponse<bool>> createReport(List<ReportData> reportes, authToken) {
    ReportDataList lista = ReportDataList(reportes: reportes);
    print(json.encode(lista.toJson()));
    return http
        .post(HttpModel.getUrl() + url + "Agregar",
            headers: {
              'Authorization': "Bearer " + authToken,
              'Content-Type': 'application/json'
            },
            body: json.encode(lista.toJson()))
        .timeout(Duration(seconds: 15))
        .then((data) {
      if (data.statusCode == 200) {
        return APIResponse<bool>(data: true);
      }
      print(data.statusCode);
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage: "La sesion ha caducado, reinicie sesion");
    }).catchError((error) => APIResponse<bool>(
            data: false,
            error: true,
            errorMessage: "Ocurrio un error al conectar a internet \n" +
                error.toString()));
  }

  Future<APIResponse<ReportData>> getReport(authToken, int idReport) {
    return http
        .get(
          HttpModel.getUrl() + url + "Get/$idReport",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final report = ReportData.fromJSON(jsonData);
            return APIResponse<ReportData>(data: report);
          }
          if (data.statusCode == 401) {
            return APIResponse<ReportData>(
                data: new ReportData(),
                error: true,
                errorMessage: "No tiene permiso para acceder");
          }
          return APIResponse<ReportData>(
              data: new ReportData(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<ReportData>(
            data: new ReportData(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }

  Future<APIResponse<List<DataSearch>>> getDataSearch(authToken) {
    return http
        .get(
          HttpModel.getUrl() + url + "GetSearchList",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final dataSearchList = DataSearchList.fromJSON(jsonData);
            return APIResponse<List<DataSearch>>(data: dataSearchList.busqueda);
          }
          return APIResponse<List<DataSearch>>(
              data: new List<DataSearch>(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<DataSearch>>(
            data: new List<DataSearch>(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }
}
