import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends HttpModel {
  static String url = "Cuenta";

  Future<APIResponse<dynamic>> authenticateUser(String email, String password) {
    var uri = HttpModel.getUrl() + url + "/Ingresar";
    return http
        .post(
          uri,
          body: json.encode({
            'nombreUsuario': email.toString().trim(),
            'password': password.toString()
          }),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            return APIResponse<dynamic>(data: jsonData);
          }
          if (data.statusCode == 403) {
            final jsonData = json.decode(data.body);
            return APIResponse<bool>(
                data: false,
                error: true,
                errorMessage: jsonData["error"]); //TODO probar exceptions
          }
          return APIResponse<bool>(
              data: false,
              error: true,
              errorMessage:
                  "No se encuentra el usuario y/o contraseña incorrecta,revisa tus datos");
        })
        .catchError((error) => APIResponse<bool>(
            data: false,
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet" + error.toString()));
  }

  Future<APIResponse<dynamic>> createUser(User user) {
    var uri = HttpModel.getUrl() + url + "/CreateUser";
    return http
        .post(
          uri,
          body: json.encode(user.toJson()),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            print(jsonData);
            return APIResponse<dynamic>(data: jsonData);
          }
          if (data.statusCode == 400) {
            final jsonData = json.decode(data.body);
            print(jsonData);
            return APIResponse<bool>(
                data: false,
                error: true,
                errorMessage:
                    "El usuario y/o email ya fueron registrados, revisa tu informacion");
          }

          return APIResponse<bool>(
              data: false,
              error: true,
              errorMessage: "Datos inconsistentes, revisa tus datos");
        })
        .catchError((error) => APIResponse<bool>(
            data: false,
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet" + error.toString()));
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'Estas desconectado de internet'),
    ));
  }

  fetch(var authToken, var endPoint) async {
    var uri = HttpModel.getUrl() + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': "Bearer " + authToken},
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'Error de red';
      } else {
        return null;
      }
    }
  }
}
