import 'dart:convert';

import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:http/http.dart' as http;

class ReportService extends HttpModel {
  String url = "Reporte";

  Future<APIResponse<bool>> createReport(List<ReportData> reportes, authToken) {
    ReportDataList lista = ReportDataList(reportes: reportes);
    print(json.encode(lista.toJson()));
    return http
        .post(HttpModel.getUrl() + url,
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
}
