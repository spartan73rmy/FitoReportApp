import 'dart:convert';
import 'dart:io';
import '../Models/apiResponse.dart';
import '../Models/HttpModel.dart';
import '../Models/dataSearch.dart';
import '../Models/idReporte.dart';
import '../Models/reportData.dart';
import '../Services/userFileService.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
import 'package:http/http.dart' as http;

class ReportService extends HttpModel {
  String url = "Reporte/";

  Future<APIResponse<bool>> createReport(
      List<ReportData> reportes, authToken) async {
    ReportDataList lista = ReportDataList(reportes: reportes);
    print(json.encode(lista.toJson()));
    return http
        .post(HttpModel.getUrl + url + "Agregar",
            headers: {
              'Authorization': "Bearer " + authToken,
              'Content-Type': 'application/json'
            },
            body: json.encode(lista.toJson()))
        .timeout(Duration(seconds: 25))
        .then((data) async {
      if (data.statusCode == 200) {
        List<int> idsReporte = IdReporte.fromJson(jsonDecode(data.body)).id;
        bool complete =
            await uploadFiles(lista.reportes, idsReporte, authToken);

        return APIResponse<bool>(data: complete);
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

  Future<bool> uploadFiles(
      List<ReportData> lista, List<int> id, String authToken) async {
    UserFilesService userFilesService = new UserFilesService();
    LocalStorage localStorage = new LocalStorage(FileName().images);
    List<String> hashes = new List<String>();
    int index = 0;
    bool allComplete = true;
    for (var i in lista) {
      List<File> images = await localStorage.readImages(i.id);
      int idReporte = id[index];

      if (images != null)
        for (File image in images) {
          var response =
              await userFilesService.uploadFile(image, idReporte, authToken);
          allComplete &= !response.error;
          if (!response.error) {
            hashes.add(response.data);
          }
        }
    }
    return allComplete;
  }

  Future<APIResponse<ReportData>> getReport(authToken, int idReport) {
    return http
        .get(
          HttpModel.getUrl + url + "Get/$idReport",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 25))
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
        .catchError((error) {
          print(error);
          return APIResponse<ReportData>(
              data: new ReportData(),
              error: true,
              errorMessage: "Ocurrio un error al conectar a internet " +
                  error.toString());
        });
  }

  Future<APIResponse<List<DataSearch>>> getDataSearch(authToken) {
    return http
        .get(
          HttpModel.getUrl + url + "GetSearchList",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 30))
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
