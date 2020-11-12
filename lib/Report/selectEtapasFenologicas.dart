import 'package:LikeApp/CommonWidgets/alert.dart';
import 'package:LikeApp/CommonWidgets/deleteDialog.dart';
import 'package:LikeApp/CommonWidgets/etapaDialog.dart';
import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Report/selectPlaga.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:LikeApp/Storage/files.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectEtapa extends StatefulWidget {
  final ReportData data;
  SelectEtapa({this.data});
  @override
  _SelectEtapaState createState() => _SelectEtapaState();
}

class _SelectEtapaState extends State<SelectEtapa> {
  ReportData data;
  bool _isLoading = true;
  bool isOnline = true;

  Ping get ping => GetIt.I<Ping>();
  EtapaFService get service => GetIt.I<EtapaFService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<EtapaFenologica>> res;

  final selected = List<EtapaFenologica>();
  @override
  void initState() {
    data = widget.data;
    fetchEtapaFenologicaes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('EtapaFenologicaes'), actions: <Widget>[
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
              MaterialPageRoute(builder: (context) => SelectPlaga(data: data)),
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
                      await deleteEtapaFenologica(res.data[i]);
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
          label: Text("Agregar EtapaFenologica"),
          onPressed: () {
            //If is valid add to list else return
            addEditEtapaFenologicaDialog(context).then((value) {
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

  deleteEtapaFenologica(EtapaFenologica etapaFenologica) async {
    isOnline = await ping.ping() ?? false;
    bool isNotLocal = etapaFenologica.id != null;

    if (isNotLocal && isOnline) {
      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences);
      var resp = await service.deleteEtapa(etapaFenologica.id, authToken);
      if (resp.error)
        await alertDiag(context, "Error", resp.errorMessage);
      else if (selected.contains(etapaFenologica))
        selected.remove(etapaFenologica);
      if (res.data.contains(etapaFenologica)) res.data.remove(etapaFenologica);
    } else {
      //Remove from local
      if (selected.contains(etapaFenologica)) selected.remove(etapaFenologica);
      if (res.data.contains(etapaFenologica)) res.data.remove(etapaFenologica);
    }
  }

  fetchEtapaFenologicaes() async {
    isOnline = await ping.ping() ?? false;
    LocalStorage localS = LocalStorage(FileName().etapa);
    if (isOnline) {
      _showLoading();

      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences);
      var resp = await service.getListEtapas(authToken);

      setState(() {
        res = resp;
      });

      if (resp.error)
        await alertDiag(context, "Error", res.errorMessage);
      else
        //En ada peticion con internet se actualizan los datos localmente
        await localS.refreshEtapas(resp.data);

      _hideLoading();
    } else {
      _showLoading();
      List<EtapaFenologica> resp = await localS.readEtapas();
      if (resp.length == 0)
        await alertDiag(context, "Error",
            "No hay datos para cargar, favor de conectarse a internet");

      setState(() {
        res = APIResponse<List<EtapaFenologica>>(
            data: resp, error: false, errorMessage: null);
      });
      _hideLoading();
    }
  }

  Widget buildRow(EtapaFenologica etapaFenologica) {
    final alreadySaved = selected.contains(etapaFenologica);
    return ListTile(
      title: Text(
        etapaFenologica.nombre,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            selected.remove(etapaFenologica);
          } else {
            selected.add(etapaFenologica);
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
      data.etapaFenologica = selected;
    });
  }
}
