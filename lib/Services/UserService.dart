import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends HttpModel {
  static String url = "Cuenta/Ingresar";

  Future<APIResponse<dynamic>> authenticateUser(String email, String password) {
    var uri = HttpModel.getUrl() + url;
    return http.post(
      uri,
      body: json.encode({
        'nombreUsuario': email.toString().trim(),
        'password': password.toString()
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    ).then((data) {
      if (data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        // print(jsonData);
        return APIResponse<dynamic>(data: jsonData);
      }
      return APIResponse<bool>(
          data: false,
          error: true,
          errorMessage:
              "No se encuentra el usuario y/o contraseña incorrecta,revisa tus datos");
    }).catchError((error) => APIResponse<bool>(
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
