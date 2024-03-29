import '../CommonWidgets/alert.dart';
import '../CommonWidgets/inputField.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../CommonWidgets/passField.dart';
import '../Models/APIResponse.dart';
import '../Models/user.dart';
import '../Models/userType.dart';
import '../Services/userService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Register extends StatefulWidget {
  Register({Key key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  bool _obscureText = true;
  APIResponse<dynamic> res;
  TextEditingController _userNameController,
      _emailController,
      _passwordController,
      _nombreController,
      _aPaternoController,
      _aMaternoController;
  String _emailError,
      _passwordError,
      _userError,
      _nombreError,
      _aPaternoError,
      _aMaternoError;
  String _selectedPermission;

  UserService get userService => GetIt.I<UserService>();

  @override
  void initState() {
    super.initState();
    _userNameController = new TextEditingController();
    _passwordController = new TextEditingController();
    _emailController = new TextEditingController();
    _nombreController = new TextEditingController();
    _aPaternoController = new TextEditingController();
    _aMaternoController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('Registrar'),
          actions: <Widget>[],
        ),
        body: _isLoading ? LoadingScreen() : registerScreen());
  }

  Widget registerScreen() {
    return new Container(
      child: new ListView(
        padding:
            const EdgeInsets.only(top: 2, left: 16.0, right: 16.0, bottom: 30),
        children: <Widget>[
          new InputField("Nombre", _nombreController, _nombreError,
              TextInputType.emailAddress),
          new InputField("Apellido Paterno", _aPaternoController,
              _aPaternoError, TextInputType.emailAddress),
          new InputField("Apellido Materno", _aMaternoController,
              _aMaternoError, TextInputType.emailAddress),
          new InputField("Usuario", _userNameController, _userError,
              TextInputType.emailAddress),
          new InputField("E-mail", _emailController, _emailError,
              TextInputType.emailAddress),
          new PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          DropdownButton(
            hint: _selectedPermission == null
                ? Text('Selecciona una opcion')
                : Text(
                    _selectedPermission,
                    style: TextStyle(color: Colors.black),
                  ),
            isExpanded: true,
            iconSize: 30.0,
            style: TextStyle(color: Colors.blue),
            items: [UserType.admin, UserType.user].map(
              (val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Text(val),
                );
              },
            ).toList(),
            onChanged: (val) {
              setState(
                () {
                  _selectedPermission = val;
                },
              );
            },
          ),
          FloatingActionButton.extended(
            icon: Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              if (_isValid()) {
                await saveData();
              }
            },
            label: Text("Registrar"),
          )
        ],
      ),
    );
  }

  _isValid() {
    bool valid = true;
    if (_selectedPermission == null) {
      valid = false;
    }
    if (_userNameController.text.isEmpty) {
      valid = false;
      setState(() {
        _userError = "Tu nombre de usuario, debe ser facil de recordar";
      });
    }
    if (_passwordController.text.isEmpty) {
      valid = false;
      setState(() {
        _passwordError = "Introduce una contraseña";
      });
    } else if (_passwordController.text.length < 6) {
      valid = false;
      setState(() {
        _passwordError = "Minimo 6 caracteres";
      });
    }
    if (_emailController.text.isEmpty) {
      valid = false;
      setState(() {
        _emailError = "Introduce un correo electronico";
      });
    }
    if (_nombreController.text.isEmpty) {
      valid = false;
      setState(() {
        _nombreError = "Introduce tu nombre";
      });
    }
    if (_aPaternoController.text.isEmpty) {
      valid = false;
      setState(() {
        _aPaternoError = "Introduce tu apellido paterno";
      });
    }
    if (_aMaternoController.text.isEmpty) {
      valid = false;
      setState(() {
        _aMaternoError = "Introduce tu apellido materno";
      });
    }
    return valid;
  }

  _togglePassword() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> saveData() async {
    _showLoading();
    print(_selectedPermission);
    User user = new User(
        email: _emailController.text,
        userName: _userNameController.text,
        pass: _passwordController.text,
        aMaterno: _aMaternoController.text,
        aPaterno: _aPaternoController.text,
        nombre: _nombreController.text,
        type: (_selectedPermission == UserType.admin)
            ? UserType.adminT
            : UserType.userT);

    var resp = await userService.createUser(user);

    setState(() {
      res = resp;
    });

    if (res.error != true) {
      alertDiag(context, "Registrado",
          "El usuario fue registrado, espere la aprobacion del administrador para poder ingresar");
    }

    if (res.error) {
      alertDiag(context, "Error", res.errorMessage);
    }

    _hideLoading();
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
}
