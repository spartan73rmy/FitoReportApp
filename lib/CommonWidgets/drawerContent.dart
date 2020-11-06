import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/User/listUsers.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerContent extends StatefulWidget {
  final bool isAdmin;
  DrawerContent({this.isAdmin, key}) : super(key: key);

  @override
  _DrawerContentState createState() => _DrawerContentState();
}

class _DrawerContentState extends State<DrawerContent> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return drawerContent(context);
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

  Future<void> logOut() async {
    _showLoading();
    _sharedPreferences = await _prefs;
    await Auth.logoutUser(_sharedPreferences);
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login("FitoReport")),
    );
    _hideLoading();
  }

  Drawer drawerContent(BuildContext context) {
    if (_isLoading) {
      return Drawer(child: LoadingScreen());
    }
    return Drawer(
        child: Column(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Text(
            'Hola\nJose Alberto Espinoza Morelos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.account_circle),
          title: Text('Perfil'),
        ),
        ListTile(
          enabled: widget.isAdmin,
          leading: Icon(Icons.supervised_user_circle),
          title: Text('Usuarios'),
          subtitle: Text.rich(
            TextSpan(
                text: "Aprobar usuarios nuevos",
                style:
                    TextStyle(color: Color(Colors.black.value), fontSize: 15)),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListUsers()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.work),
          title: Text('Catalogos'),
          subtitle: Text.rich(
            TextSpan(
                text: "Plagas,Enfermedades, Etapa Fenologica",
                style:
                    TextStyle(color: Color(Colors.black.value), fontSize: 15)),
          ),
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => PDFPrinterShare()),
            // );
          },
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Configuracion'),
          onTap: () async {},
        ),
        ListTile(
          leading: Icon(Icons.cloud_download),
          title: Text('Sincronizar Catalogos'),
          onTap: () async {},
        ),
        Expanded(
            child: Align(
          alignment: Alignment.bottomCenter,
          child: ListTile(
            leading: Icon(Icons.close),
            title: Text('Cerrar Sesion'),
            onTap: () async {
              await logOut();
            },
          ),
        ))
      ],
    ));
  }
}
