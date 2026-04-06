import '../CommonWidgets/alert.dart';
import '../CommonWidgets/inputField.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../CommonWidgets/passField.dart';
import '../Models/APIResponse.dart';
import '../Models/user.dart';
import '../Models/userType.dart';
import '../Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  bool _obscureText = true;
  late APIResponse<dynamic> res;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _nombreController;
  late TextEditingController _aPaternoController;
  late TextEditingController _aMaternoController;
  String? _emailError;
  String? _passwordError;
  String? _userError;
  String? _nombreError;
  String? _aPaternoError;
  String? _aMaternoError;
  String? _selectedPermission;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registrar'),
          actions: const <Widget>[],
        ),
        body: _isLoading ? LoadingScreen() : registerScreen());
  }

  Widget registerScreen() {
    return Container(
      child: ListView(
        padding:
            const EdgeInsets.only(top: 2, left: 16.0, right: 16.0, bottom: 30),
        children: <Widget>[
          InputField(
              "Nombre", _nombreController, _nombreError, TextInputType.text),
          InputField("Apellido Paterno", _aPaternoController, _aPaternoError,
              TextInputType.text),
          InputField("Apellido Materno", _aMaternoController, _aMaternoError,
              TextInputType.text),
          InputField(
              "Usuario", _userNameController, _userError, TextInputType.text),
          InputField("E-mail", _emailController, _emailError,
              TextInputType.emailAddress),
          PasswordField(
            passwordController: _passwordController,
            obscureText: _obscureText,
            passwordError: _passwordError,
            togglePassword: _togglePassword,
          ),
          DropdownButton<String>(
            value: _selectedPermission,
            hint: const Text('Selecciona una opcion'),
            isExpanded: true,
            iconSize: 30.0,
            style: const TextStyle(color: Colors.blue),
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
            icon: const Icon(Icons.add),
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              if (_isValid()) {
                await saveData();
              }
            },
            label: const Text("Registrar"),
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

    if (res.error == true) {
      alertDiag(context, "Error", res.errorMessage ?? 'Error');
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
