import '../CommonWidgets/alert.dart';
import '../CommonWidgets/deleteDialog.dart';
import '../CommonWidgets/etapaDialog.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Models/APIResponse.dart';
import '../Models/etapaFenologica.dart';
import '../Models/reportData.dart';
import '../Report/selectPlaga.dart';
import '../Services/auth.dart';
import '../Services/conectionService.dart';
import '../Services/etapaFService.dart';
import '../Services/syncData.dart';
import '../Storage/files.dart';
import '../Storage/localStorage.dart';
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
  bool needFetch = true;

  Ping get ping => GetIt.I<Ping>();
  EtapaFService get service => GetIt.I<EtapaFService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<EtapaFenologica>> res;

  final selected = List<EtapaFenologica>();
  @override
  void initState() {
    data = widget.data;
    fetchEtapaFenologicas();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Etapas Fenologicas'), actions: <Widget>[
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
        if (isOnline && res != null && res.error ?? false) {
          return Center(child: Text(res.errorMessage));
        }

        if (needFetch) {
          return Center(
              child: IconButton(
            icon: Icon(Icons.sync),
            iconSize: 64,
            onPressed: () async {
              isOnline = await ping.ping() ?? false;
              bool finished = false;
              if (isOnline) {
                SyncData s = new SyncData();
                finished = await s.syncData();
                if (finished) await fetchEtapaFenologicas();
              }
              if (!finished) {
                await alertDiag(context, "Error",
                    "No pudieron sincronizarse los datos , revise su conexion a internet");
              }
            },
          ));
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
          heroTag: null,
          icon: Icon(Icons.add),
          label: Text("Agregar Etapa Fenologica"),
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

  fetchEtapaFenologicas() async {
    LocalStorage localS = LocalStorage(FileName().etapa);
    _showLoading();
    List<EtapaFenologica> resp = await localS.readEtapas();
    needFetch = false;

    if (resp.length == 0) {
      await alertDiag(context, "Error",
          "No hay datos para cargar, favor de syncronizar los datos");
      needFetch = true;
    } else
      setState(() {
        res = APIResponse<List<EtapaFenologica>>(
            data: resp, error: false, errorMessage: null);
      });
    _hideLoading();
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
