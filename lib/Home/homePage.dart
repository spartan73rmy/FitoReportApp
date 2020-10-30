import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/drawerContent.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/dataSearch.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Report/pickImage.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/reportService.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:LikeApp/TempReports/listTempReport.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Report/addReport.dart';
import "dataSearch.dart";

class HomePage extends StatefulWidget {
  HomePage(this.title, {Key key}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading;
  bool isAdmin;

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  ReportService get service => GetIt.I<ReportService>();
  Ping get ping => GetIt.I<Ping>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<bool> res;
  List<DataSearch> busqueda;
  bool isOnline;
  @override
  void initState() {
    res = new APIResponse<bool>();
    isLoading = false;
    isOnline = false;

    super.initState();
    isAdm();
    isConnected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      drawer: DrawerContent(
        isAdmin: isAdmin,
      ),
      appBar: AppBar(
        title: Text(this.widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              await saveData();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              bool search = await getDataSearch();
              if (search)
                showSearch(context: context, delegate: Search(busqueda));
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return LoadingScreen();
        }
        return ListTempReport();
      }),
      persistentFooterButtons: <Widget>[
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              // MaterialPageRoute(builder: (context) => ImagenPicker()),
              MaterialPageRoute(builder: (context) => AddReport()),
            );
          },
          label: Text("Agregar Reporte"),
        )
      ],
    );
  }

  Future<bool> getDataSearch() async {
    showLoading();
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);
    String authToken = Auth.getToken(_sharedPreferences);
    isOnline = await ping.ping();

    if (isOnline) {
      if (isNotLogged) toLogIn();
      var resp = await service.getDataSearch(authToken);

      if (res.error) {
        alertDiag(context, "Error", res.errorMessage);
        hideLoading();
        return false;
      }

      setState(() {
        busqueda = resp.data;
      });

      hideLoading();
      return true;
    } else {
      alertDiag(
          context, "Error", "Favor de conectarse a internet e iniciar sesion");
      hideLoading();
      return false;
    }
  }

  Future<void> saveData() async {
    isOnline = await ping.ping() ?? false;
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);

    if (isOnline) {
      if (isNotLogged) toLogIn();

      showLoading();
      String authToken = Auth.getToken(_sharedPreferences);

      LocalStorage localStorage = new LocalStorage(FileName().report);
      List<ReportData> tempReports = await localStorage.readReports();

      if (tempReports.length > 0) {
        var resp = await service.createReport(tempReports, authToken);
        setState(() {
          res = resp;
        });

        if (res.error != true) {
          alertDiag(context, "Finalizado",
              "Los reportes fueron sincronizados con la nube ");
          await localStorage.clearReportFile();
        }
      }

      if (res.error) alertDiag(context, "Error", res.errorMessage);

      hideLoading();
    } else {
      alertDiag(
          context, "Error", "Favor de conectarse a Internet e iniciar sesion");
    }
  }

  Future<void> isAdm() async {
    _sharedPreferences = await _prefs;

    setState(() {
      isAdmin = Auth.isAdmin(_sharedPreferences);
    });
  }

  toLogIn() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login("FitoReport")),
    );
  }

  isConnected() async {
    bool l = await ping.ping();
    setState(() {
      isOnline = l;
    });
    isOnline
        ? showSnackBar("Conectado a internet")
        : showSnackBar("Modo sin conexion");
  }

  void showSnackBar(String value) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
