import '../CommonWidgets/alert.dart';
import '../CommonWidgets/inputField.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../CommonWidgets/passField.dart';
import '../Home/homePage.dart';
import '../Models/apiResponse.dart';
import '../Services/auth.dart';
import '../Services/conectionService.dart';
import '../User/register.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Services/userService.dart';

class Login extends StatefulWidget {
  final String title;

  Login(this.title, {Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences sharedPreferences;
  bool _isLoading = false;
  bool _obscureText = true;
  APIResponse<dynamic> response;
  TextEditingController _userNameController, _passwordController;
  String _emailError, _passwordError;

  UserService get userService => GetIt.I<UserService>();
  Ping get ping => GetIt.I<Ping>();

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  Widget _loginScreen() {
    return Container(
      child: ListView(
        padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
        children: <Widget>[
          Icon(
            Icons.weekend,
            size: 80,
          ),
          Center(
              child: Text(
            "Inicio de Sesion",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          )),
          InputField("Usuario", _userNameController, _emailError,
              TextInputType.emailAddress),
          PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          FloatingActionButton.extended(
              icon: Icon(Icons.supervised_user_circle_sharp),
              backgroundColor: Theme.of(context).primaryColor,
              label: Text("Iniciar Sesion", style: TextStyle(fontSize: 20)),
              onPressed: () => {_authenticateUser(false)}),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: TextButton(
                  child: Text("Iniciar Sin Conexion",
                      style: TextStyle(fontSize: 20)),
                  onPressed: () async => {_authenticateUser(true)})),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: <Widget>[
          FlatButton(
            padding: EdgeInsets.all(10.0),
            child: Row(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Center(
                  child:
                      Text("Registrar", style: TextStyle(color: Colors.white)),
                ),
                Icon(
                  Icons.account_box,
                  color: Colors.white,
                ),
              ],
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
          )
        ]),
        key: _scaffoldKey,
        body: _isLoading ? LoadingScreen() : _loginScreen());
  }

  _showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _authenticateUser(bool offline) async {
    _showLoading();
    sharedPreferences = await _prefs;

    if (offline) {
      await Auth.logoutUser(sharedPreferences);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(widget.title)),
      );
    }

    var isOnline = await ping.ping();
    if (isOnline) {
      if (_isValid()) {
        var res = await userService.authenticateUser(
            _userNameController.text, _passwordController.text);

        if (res.data != null && !res.error) {
          await Auth.insertDetails(sharedPreferences, res.data);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage(widget.title)),
          );
        }

        if (res.error) {
          alertDiag(context, "Error", res.errorMessage);
        }
        _hideLoading();
      }
    }
    _hideLoading();
  }

  _isValid() {
    bool valid = true;

    if (_userNameController.text.isEmpty) {
      valid = false;
      setState(() {
        _emailError = "No puede quedar vacio";
      });
    }
    if (_passwordController.text.isEmpty) {
      valid = false;
      setState(() {
        _passwordError = "Introduce una contraseña";
      });
    }
    // else if (_passwordController.text.length < 6) {
    //   valid = false;
    //   _passwordError = "Password is invalid!";
    // }

    return valid;
  }
}
