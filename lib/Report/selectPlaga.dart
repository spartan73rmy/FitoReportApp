import '../CommonWidgets/alert.dart';
import '../CommonWidgets/deleteDialog.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../CommonWidgets/plagaDialog.dart';
import '../Models/APIResponse.dart';
import '../Models/plaga.dart';
import '../Models/reportData.dart';
import '../Report/selectEnfermedad.dart';
import '../Services/auth.dart';
import '../Services/conectionService.dart';
import '../Services/plagaService.dart';
import '../Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPlaga extends StatefulWidget {
  final ReportData data;
  const SelectPlaga({super.key, required this.data});
  @override
  _SelectPlagaState createState() => _SelectPlagaState();
}

class _SelectPlagaState extends State<SelectPlaga> {
  late ReportData data;
  bool isLoading = true;
  bool isOnline = true;

  Ping get ping => GetIt.I<Ping>();
  PlagaService get service => GetIt.I<PlagaService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _sharedPreferences;
  APIResponse<List<Plaga>>? res;
  final selected = <Plaga>[];

  @override
  void initState() {
    fetchPlaga();
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(title: const Text('Plagas'), actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(10.0),
            ),
            child: const Row(
              children: <Widget>[
                Center(
                  child:
                      Text("Siguiente", style: TextStyle(color: Colors.white)),
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
                MaterialPageRoute(
                    builder: (context) => SelectEnfermedad(data: data)),
              );
            },
          )
        ]),
        body: Builder(builder: (context) {
          if (isLoading) {
            return LoadingScreen();
          }

          if (isOnline && res?.error == true) {
            return Center(child: Text(res?.errorMessage ?? ''));
          }
          return Container(
              child: ListView.builder(
                  itemCount: res?.data?.length ?? 0,
                  padding: const EdgeInsets.all(16.0),
                  itemBuilder: (context, i) {
                    return Dismissible(
                        key: ValueKey(res?.data?[i].id),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {},
                        confirmDismiss: (direction) async {
                          final result = await showDialog(
                                  context: context,
                                  builder: (_) => const DeleteDialog()) ??
                              false;
                          if (result) {
                            await deletePlaga(res!.data![i]);
                          }
                          return result;
                        },
                        background: Container(
                          color: Colors.blue,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Align(
                            child: Icon(Icons.delete, color: Colors.white),
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                        child: buildRow(res!.data![i]));
                  }));
        }),
        persistentFooterButtons: [
          FloatingActionButton.extended(
            icon: const Icon(Icons.add),
            label: const Text("Agregar Plaga"),
            onPressed: () {
              addEditPlagaDialog(context).then((value) {
                if (value == null) return;
                bool isValid = value.nombre != null;
                if (isValid)
                  setState(() {
                    res?.data?.add(value);
                  });
              });
            },
          ),
        ]);
  }

  deletePlaga(Plaga plaga) async {
    isOnline = await ping.ping();
    bool isNotLocal = plaga.id != null;

    if (isNotLocal && isOnline) {
      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences) ?? '';
      var resp = await service.deletePlaga(plaga.id!, authToken);
      if (resp.error)
        await alertDiag(context, "Error", resp.errorMessage ?? '');
      else if (selected.contains(plaga)) selected.remove(plaga);
      if (res?.data?.contains(plaga) == true) res?.data?.remove(plaga);
    } else {
      if (selected.contains(plaga)) selected.remove(plaga);
      if (res?.data?.contains(plaga) == true) res?.data?.remove(plaga);
    }
  }

  fetchPlaga() async {
    LocalStorage localS = GetIt.I<LocalStorage>();

    _showLoading();
    List<Plaga> resp = await localS.readPlagas();
    if (resp.isEmpty) {
      await alertDiag(context, "Error",
          "No hay datos para cargar, favor de conectarse a internet");
    }

    setState(() {
      res =
          APIResponse<List<Plaga>>(data: resp, error: false, errorMessage: '');
    });
    _hideLoading();
  }

  Widget buildRow(Plaga plaga) {
    final alreadySaved = selected.contains(plaga);
    return ListTile(
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.blue : null,
      ),
      title: Text(
        plaga.nombre ?? '',
        style: const TextStyle(fontSize: 18.0),
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            selected.remove(plaga);
          } else {
            selected.add(plaga);
          }
        });
      },
    );
  }

  void saveData() {
    setState(() {
      data.plagaJson = selected.map((e) => e.toJson()).toList();
    });
  }

  _showLoading() {
    setState(() {
      isLoading = true;
    });
  }

  _hideLoading() {
    setState(() {
      isLoading = false;
    });
  }
}
