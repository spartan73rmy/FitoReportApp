import 'dart:io';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:http/http.dart' as http;

class Ping extends HttpModel {
  static String url = "Cuenta/";

  Future<bool> ping() async {
    try {
      var uri = HttpModel.getUrl + url + "Ping";
      print(uri);
      return http
          .head(
            uri,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            },
          )
          .timeout(Duration(seconds: 3))
          .then((data) {
            if (data.statusCode == 200) {
              return true;
            }
            return false;
          })
          .catchError((error) => false);
    } on SocketException catch (_) {
      return false;
    }
  }
}
