import '../Models/userType.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  static final String authTokenKey = 'token';
  static final String refToken = 'refreshToken';
  static final String expDate = 'expirationDate';
  static final String userIdKey = 'idUsuario';
  static final String nameKey = 'nombreUsuario';
  static final String roleKey = 'tipoUsuario';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static bool isAdmin(SharedPreferences prefs) {
    return (prefs.getInt(roleKey) ?? -1) == UserType.adminT; //See value
  }

  static bool isLogged(SharedPreferences prefs) {
    print(getExpDate(prefs).compareTo(DateTime.now()) >= 0);
    return getExpDate(prefs).compareTo(DateTime.now()) >= 0;
  }

  static DateTime getExpDate(SharedPreferences prefs) {
    DateTime date = DateTime.tryParse(prefs.getString(expDate));
    date ?? DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);
    print(date);
    return date;
  }

  static logoutUser(SharedPreferences prefs) {
    prefs.setString(Auth.authTokenKey, null);
    prefs.setString(Auth.refToken, null);
    prefs.setString(Auth.expDate,
        DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true).toString());
    prefs.setString(Auth.userIdKey, null);
    prefs.setString(Auth.nameKey, null);
    prefs.setString(Auth.roleKey, null);
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
