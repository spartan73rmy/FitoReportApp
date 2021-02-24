import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/deleteDialog.dart';
import 'package:LikeApp/CommonWidgets/enfermedadDialog.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Report/reciepReport.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/enfermedadService.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectEnfermedad extends StatefulWidget {
  final ReportData data;
  SelectEnfermedad({this.data});
  @override
  _SelectEnfermedadState createState() => _SelectEnfermedadState();
}

class _SelectEnfermedadState extends State<SelectEnfermedad> {
  ReportData data;
  bool _isLoading = true;
  bool isOnline = true;

  Ping get ping => GetIt.I<Ping>();
  EnfermedadService get service => GetIt.I<EnfermedadService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<Enfermedad>> res;

  final selected = List<Enfermedad>();
  @override
  void initState() {
    data = widget.data;
    fetchEnfermedades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enfermedades'), actions: <Widget>[
        FlatButton(
          padding: EdgeInsets.all(10.0),
          child: Row(
            // Replace with a Row for horizontal icon + text
            children: <Widget>[
              Center(
                child: Text("Siguiente", style: TextStyle(color: Colors.white)),
              ),
              Icon(
                Icons.navigate_next,
                color: Colors.white,
              ),
            ],
          ),
          onPressed: () {
            saveData();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReciepReport(data: data)),
            );
          },
        )
      ]),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return LoadingScreen();
        }

        if (isOnline && res.error ?? false) {
          return Center(child: Text(res.errorMessage));
        }

        return ListView.builder(
            itemCount: res.data.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
              return Dismissible(
                  key: ValueKey(res.data[i].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction) {},
                  confirmDismiss: (direction) async {
                    final result = await showDialog(
                            context: context, builder: (_) => DeleteDialog()) ??
                        false;
                    //If delete is confirmed delete from list and selected list if exist
                    if (result) {
                      await deleteEnfermedad(res.data[i]);
                    }
                    return result;
                  },
                  background: Container(
                    color: Colors.blue,
                    padding: EdgeInsets.only(left: 16),
                    child: Align(
                      child: Icon(Icons.delete, color: Colors.white),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  child: buildRow(res.data[i]));
            });
      }),
      persistentFooterButtons: [
        FloatingActionButton.extended(
          icon: Icon(Icons.add),
          label: Text("Agregar Enfermedad"),
          onPressed: () {
            //If is valid add to list else return
            addEditEnfermedadDialog(context).then((value) {
              if (value == null) return;
              bool isValid = value.nombre != null;
              if (isValid)
                setState(() {
                  res.data.add(value);
                });
            });
          },
        ),
      ],
    );
  }

  deleteEnfermedad(Enfermedad enfermedad) async {
    isOnline = await ping.ping() ?? false;
    bool isNotLocal = enfermedad.id != null;

    if (isNotLocal && isOnline) {
      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences);
      var resp = await service.deleteEnfermedad(enfermedad.id, authToken);
      if (resp.error)
        await alertDiag(context, "Error", resp.errorMessage);
      else if (selected.contains(enfermedad)) selected.remove(enfermedad);
      if (res.data.contains(enfermedad)) res.data.remove(enfermedad);
    } else {
      //Remove from local
      if (selected.contains(enfermedad)) selected.remove(enfermedad);
      if (res.data.contains(enfermedad)) res.data.remove(enfermedad);
    }
  }

  fetchEnfermedades() async {
    LocalStorage localS = LocalStorage(FileName().enfermedad);

    _showLoading();
    List<Enfermedad> resp = await localS.readEnfermedades();
    if (resp.length == 0)
      await alertDiag(context, "Error",
          "No hay datos para cargar, favor de conectarse a internet");

    setState(() {
      res = APIResponse<List<Enfermedad>>(
          data: resp, error: false, errorMessage: null);
    });
    _hideLoading();
  }

  Widget buildRow(Enfermedad enfermedad) {
    final alreadySaved = selected.contains(enfermedad);
    return ListTile(
      title: Text(
        enfermedad.nombre,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            selected.remove(enfermedad);
          } else {
            selected.add(enfermedad);
          }
        });
      },
    );
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

  void saveData() {
    setState(() {
      data.enfermedad = selected;
    });
  }
}
