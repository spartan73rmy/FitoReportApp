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
  HomePage(this.title, {super.key});
  final String title;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool? isAdmin;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  ReportService get service => GetIt.I<ReportService>();
  Ping get ping => GetIt.I<Ping>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _sharedPreferences;
  APIResponse<bool> res = APIResponse<bool>();
  List<DataSearch> busqueda = [];
  bool isOnline = false;

  @override
  void initState() {
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
            icon: isOnline ? const Icon(Icons.cloud_upload) : const Icon(Icons.cloud_off),
            onPressed: () async {
              await uploadData();
            },
          ),
          IconButton(
            icon: isOnline ? const Icon(Icons.search) : const Icon(Icons.search_off),
            onPressed: () async {
              bool search = await getDataSearch();
              if (search && context.mounted)
                showSearch(context: context, delegate: Search(busqueda));
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return LoadingScreen();
        }
        return const ListTempReport();
      }),
      persistentFooterButtons: <Widget>[
        FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddReport()),
            );
          },
          label: const Text("Agregar Reporte"),
        )
      ],
    );
  }

  Future<bool> getDataSearch() async {
    showLoading();
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);
    String authToken = Auth.getToken(_sharedPreferences) ?? '';
    isOnline = await ping.ping();

    if (isOnline) {
      if (isNotLogged) toLogIn();
      var resp = await service.getDataSearch(authToken);

      if (res.error) {
        alertDiag(context, "Error", res.errorMessage ?? '');
        hideLoading();
        return false;
      }

      setState(() {
        busqueda = resp.data ?? [];
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
    isOnline = await ping.ping();
    _sharedPreferences = await _prefs;
    bool isNotLogged = !Auth.isLogged(_sharedPreferences);

    if (isOnline) {
      if (isNotLogged) toLogIn();

      showLoading();
      String authToken = Auth.getToken(_sharedPreferences) ?? '';

      LocalStorage localStorage = LocalStorage(FileName().report);
      List<ReportData> tempReports = await localStorage.readReports();

      if (tempReports.isNotEmpty) {
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

      if (res.error) alertDiag(context, "Error", res.errorMessage ?? '');

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
      MaterialPageRoute(builder: (context) => const Login("FitoReport")),
    );
  }

  isConnected() async {
    bool l = await ping.ping();
    setState(() {
      isOnline = l;
    });
    if (scaffoldKey.currentState != null) {
      isOnline
          ? showSnackBar("Conexion con el servidor")
          : showSnackBar("Modo sin conexion");
    }
  }

  void showSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  void showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  void hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
