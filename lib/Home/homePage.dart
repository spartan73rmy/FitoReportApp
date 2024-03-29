import '../CommonWidgets/alert.dart';
import '../CommonWidgets/drawerContent.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Login/login.dart';
import '../Models/apiResponse.dart';
import '../Models/dataSearch.dart';
import '../Models/reportData.dart';
import '../Services/auth.dart';
import '../Services/conectionService.dart';
import '../Services/reportService.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
import '../TempReports/listTempReport.dart';
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
            icon: isOnline ? Icon(Icons.cloud_upload) : Icon(Icons.cloud_off),
            onPressed: () async {
              await uploadData();
            },
          ),
          IconButton(
            icon: isOnline ? Icon(Icons.search) : Icon(Icons.search_off),
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

  Future<void> uploadData() async {
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
          await localStorage.deleteAllImages();
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
        ? showSnackBar("Conexion con el servidor")
        : showSnackBar("Modo sin conexion");
  }

  showSnackBar(String value) {
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
