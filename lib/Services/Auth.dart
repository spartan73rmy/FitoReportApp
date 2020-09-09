import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  // Keys to store and fetch data from SharedPreferences
  static final String authTokenKey = 'token';
  static final String refToken = 'refreshToken';
  static final String expDate = 'expirationDate';
  static final String userIdKey = 'idUsuario';
  static final String nameKey = 'nombreUsuario';
  static final String roleKey = 'tipoUsuario';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static insertDetails(SharedPreferences prefs, var response) {
    prefs.setString(authTokenKey, response['token']);
    prefs.setString(refToken, response['refreshToken']);
    prefs.setString(expDate, response['expirationDate']);

    var user = response['user'];
    prefs.setInt(userIdKey, user['idUsuario']);
    prefs.setString(nameKey, user['nombreUsuario']);
    prefs.setInt(roleKey, user['tipoUsuario']);
  }
}
