import 'dart:convert';
import '../Models/APIResponse.dart';
import '../Models/HttpModel.dart';
import '../Models/user.dart';
import 'package:http/http.dart' as http;

class UserService extends HttpModel {
  static String url = "Cuenta/";
  static String urlU = "Usuarios/";

  Future<APIResponse<dynamic>> authenticateUser(String email, String password) {
    var uri = HttpModel.getUrl + url + "Ingresar";
    return http
        .post(
          Uri.parse(uri),
          body: json.encode({
            'nombreUsuario': email.toString().trim(),
            'password': password.toString()
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 5))
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
    var uri = HttpModel.getUrl + url + "CreateUser";
    return http
        .post(
          Uri.parse(uri),
          body: json.encode(user.toJson()),
          headers: {
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15))
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

  Future<APIResponse<bool>> deleteUser(String userName, String authToken) {
    var uri = HttpModel.getUrl + urlU + "DeleteUser/$userName";
    return http
        .delete(
          Uri.parse(uri),
          headers: {
            'Authorization': "Bearer " + authToken,
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15))
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

  Future<APIResponse<bool>> aproveUser(String userName, String authToken) {
    var uri = HttpModel.getUrl + urlU + "AproveUser/$userName";
    return http
        .put(
          Uri.parse(uri),
          body: json.encode({}),
          headers: {
            'Authorization': "Bearer " + authToken,
            'Content-Type': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 15))
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

  Future<APIResponse<List<User>>> getListUser(String authToken) {
    return http
        .get(
          Uri.parse(HttpModel.getUrl + urlU + "GetAll"),
          headers: {'Authorization': "Bearer " + authToken},
        )
        .timeout(const Duration(seconds: 15))
        .then((data) {
          if (data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final userList = UserList.fromJSON(jsonData);
            return APIResponse<List<User>>(data: userList.usuarios ?? []);
          }
          return APIResponse<List<User>>(
              data: <User>[],
              error: true,
              errorMessage: "La sesion ha caducado, reinicie sesion");
        })
        .catchError((error) => APIResponse<List<User>>(
            data: <User>[],
            error: true,
            errorMessage:
                "Ocurrio un error al conectar a internet " + error.toString()));
  }
}
