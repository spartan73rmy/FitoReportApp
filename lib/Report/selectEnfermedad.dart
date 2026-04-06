import '../CommonWidgets/alert.dart';
import '../CommonWidgets/deleteDialog.dart';
import '../CommonWidgets/enfermedadDialog.dart';
import '../CommonWidgets/loadingScreen.dart';
import '../Models/APIResponse.dart';
import '../Models/enfermedad.dart';
import '../Models/reportData.dart';
import '../Report/reciepReport.dart';
import '../Services/auth.dart';
import '../Services/conectionService.dart';
import '../Services/enfermedadService.dart';
import '../Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectEnfermedad extends StatefulWidget {
  final ReportData data;
  const SelectEnfermedad({super.key, required this.data});
  @override
  _SelectEnfermedadState createState() => _SelectEnfermedadState();
}

class _SelectEnfermedadState extends State<SelectEnfermedad> {
  late ReportData data;
  bool _isLoading = true;
  bool isOnline = true;

  Ping get ping => GetIt.I<Ping>();
  EnfermedadService get service => GetIt.I<EnfermedadService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late SharedPreferences _sharedPreferences;
  APIResponse<List<Enfermedad>>? res;

  final selected = <Enfermedad>[];
  @override
  void initState() {
    data = widget.data;
    fetchEnfermedades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enfermedades'), actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(10.0),
          ),
          child: const Row(
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

        if (isOnline && res?.error == true) {
          return Center(child: Text(res?.errorMessage ?? ''));
        }

        return ListView.builder(
            itemCount: res?.data?.length ?? 0,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: /*1*/ (context, i) {
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
                      await deleteEnfermedad(res!.data![i]);
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
            });
      }),
      persistentFooterButtons: [
        FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Agregar Enfermedad"),
          onPressed: () {
            addEditEnfermedadDialog(context).then((value) {
              if (value == null) return;
              bool isValid = value.nombre != null;
              if (isValid)
                setState(() {
                  res?.data?.add(value);
                });
            });
          },
        ),
      ],
    );
  }

  deleteEnfermedad(Enfermedad enfermedad) async {
    isOnline = await ping.ping();
    bool isNotLocal = enfermedad.id != null;

    if (isNotLocal && isOnline) {
      _sharedPreferences = await _prefs;
      String authToken = Auth.getToken(_sharedPreferences) ?? '';
      var resp = await service.deleteEnfermedad(enfermedad.id!, authToken);
      if (resp.error)
        await alertDiag(context, "Error", resp.errorMessage ?? '');
      else if (selected.contains(enfermedad)) selected.remove(enfermedad);
      if (res?.data?.contains(enfermedad) == true)
        res?.data?.remove(enfermedad);
    } else {
      if (selected.contains(enfermedad)) selected.remove(enfermedad);
      if (res?.data?.contains(enfermedad) == true)
        res?.data?.remove(enfermedad);
    }
  }

  fetchEnfermedades() async {
    LocalStorage localS = GetIt.I<LocalStorage>();

    _showLoading();
    List<Enfermedad> resp = await localS.readEnfermedades();
    if (resp.isEmpty)
      await alertDiag(context, "Error",
          "No hay datos para cargar, favor de conectarse a internet");

    setState(() {
      res = APIResponse<List<Enfermedad>>(
          data: resp, error: false, errorMessage: '');
    });
    _hideLoading();
  }

  Widget buildRow(Enfermedad enfermedad) {
    final alreadySaved = selected.contains(enfermedad);
    return ListTile(
      title: Text(
        enfermedad.nombre ?? '',
        style: const TextStyle(fontSize: 18.0),
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
      data.enfermedadJson = selected.map((e) => e.toJson()).toList();
    });
  }
}
