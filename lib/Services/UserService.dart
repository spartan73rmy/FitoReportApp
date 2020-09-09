import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  static logoutUser(BuildContext context, SharedPreferences prefs) {
    prefs.setString(Auth.authTokenKey, null);
    prefs.setString(Auth.refToken, null);
    prefs.setString(Auth.refToken, null);

    // prefs.setInt(Auth.userIdKey, null);
    // prefs.setString(Auth.nameKey, null);
    // prefs.setInt(Auth.roleKey, null);
    Navigator.of(context).pushReplacementNamed('/');
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'You are offline'),
    ));
  }

  fetch(var authToken, var endPoint) async {
    var uri = HttpModel.getUrl() + endPoint;

    try {
      final response = await http.get(
        uri,
        headers: {'Authorization': authToken},
      );

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
}
