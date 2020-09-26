import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Login/login.dart';
import 'package:LikeApp/Models/apiResponse.dart';
import 'package:LikeApp/Models/dataSearch.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Services/auth.dart';
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
  bool _isLoading = false;

  ReportService get service => GetIt.I<ReportService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<bool> res;
  List<DataSearch> busqueda;

  @override
  void initState() {
    res = new APIResponse<bool>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              await logOut();
            },
          ),
          IconButton(
            icon: Icon(Icons.cloud_upload),
            onPressed: () async {
              await saveData();
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await getDataSearch();
              showSearch(context: context, delegate: Search(busqueda));
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
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
              MaterialPageRoute(builder: (context) => AddReport()),
            );
          },
          label: Text("Agregar Reporte"),
        )
      ],
    );
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

  Future<void> getDataSearch() async {
    _showLoading();
    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    var resp = await service.getDataSearch(authToken);
    busqueda = resp.data;

    if (res.error) {
      alertDiag(context, "Error", res.errorMessage);
    }

    _hideLoading();
  }

  Future<void> saveData() async {
    _showLoading();
    _sharedPreferences = await _prefs;
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
        await localStorage.clearFile();
      }
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
