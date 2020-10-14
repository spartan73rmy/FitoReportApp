import 'dart:convert';
import 'dart:io';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/HttpModel.dart';
import 'package:LikeApp/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserService extends HttpModel {
  static String url = "Cuenta/";
  static String urlU = "Usuarios/";

  Future<APIResponse<dynamic>> authenticateUser(String email, String password) {
    var uri = HttpModel.getUrl() + url + "Ingresar";
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
                data: false, error: true, errorMessage: jsonData["error"]);
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
    var uri = HttpModel.getUrl() + url + "CreateUser";
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
            return APIResponse<dynamic>(data: jsonData);
          }
          if (data.statusCode == 400) {
            final jsonData = json.decode(data.body);
            return APIResponse<bool>(
                data: false,
                error: true,
                errorMessage:
                    "El usuario y/o email ya fueron registrados, revisa tu informacion\n$jsonData");
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

  Future<APIResponse<bool>> deleteUser(String userName, authToken) {
    var uri = HttpModel.getUrl() + urlU + "DeleteUser/$userName";
    return http
        .delete(
          uri,
          headers: {
            'Authorization': "Bearer " + authToken,
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            return APIResponse<bool>(data: true);
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

  Future<APIResponse<bool>> aproveUser(String userName, authToken) {
    var uri = HttpModel.getUrl() + urlU + "AproveUser/$userName";
    return http
        .put(
          uri,
          body: json.encode({}),
          headers: {
            'Authorization': "Bearer " + authToken,
            HttpHeaders.contentTypeHeader: 'application/json',
          },
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            return APIResponse<bool>(data: true);
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

  Future<APIResponse<List<User>>> getListUser(authToken) {
    return http
        .get(
          HttpModel.getUrl() + urlU + "GetAll",
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final userList = UserList.fromJSON(jsonData);
            return APIResponse<List<User>>(data: userList.usuarios);
          }
          return APIResponse<List<User>>(
              data: new List<User>(),
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<User>>(
            data: new List<User>(),
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }

  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'Estas desconectado de internet'),
    ));
  }
}
