import 'package:LikeApp/CommonWidgets/emailField.dart';
import 'package:LikeApp/CommonWidgets/loginButton.dart';
import 'package:LikeApp/CommonWidgets/passField.dart';
import 'package:LikeApp/Home/homePage.dart';
import 'package:LikeApp/Report/addReport.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:LikeApp/Services/UserService.dart';

class Login extends StatefulWidget {
  final String title;

  Login(this.title, {Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState(this.title);
}

class _LoginState extends State<Login> {
  final String title;
  _LoginState(this.title);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  bool _obscureText = true;

  TextEditingController _userNameController, _passwordController;
  String _emailError, _passwordError;

  UserService get userService => GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
    _userNameController = new TextEditingController();
    _passwordController = new TextEditingController();
  }

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    if (authToken != null) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage(title)),
      // );
    }
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

  alert(title, text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(text),
              actions: [
                FlatButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: Text("Cerrar"))
              ],
            ));
  }

  _authenticateUser() async {
    _showLoading();
    if (_isValid()) {
      var res = await userService.authenticateUser2(
          _userNameController.text, _passwordController.text);
      _hideLoading();

      if (res.data != null && !res.error) {
        _sharedPreferences = await _prefs;

        Auth.insertDetails(_sharedPreferences, res.data);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage(title)),
        );
      }
      if (res.error) {
        alert("Error", res.errorMessage);
      }
    } else {
      _hideLoading();
    }
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

  Widget _loginScreen() {
    return new Container(
      child: new ListView(
        padding: const EdgeInsets.only(top: 100.0, left: 16.0, right: 16.0),
        children: <Widget>[
          new EmailField(
              emailController: _userNameController, emailError: _emailError),
          new PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          new LoginButton(onPressed: _authenticateUser)
        ],
      ),
    );
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _loadingScreen() {
    return new Container(
        margin: const EdgeInsets.only(top: 100.0),
        child: new Center(
            child: new Column(
          children: <Widget>[
            new CircularProgressIndicator(strokeWidth: 4.0),
            new Container(
              padding: const EdgeInsets.all(8.0),
              child: new Text(
                'Espere',
                style:
                    new TextStyle(color: Colors.grey.shade500, fontSize: 16.0),
              ),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        body: _isLoading ? _loadingScreen() : _loginScreen());
  }
}
