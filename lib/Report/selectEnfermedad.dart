import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Report/reciepReport.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/enfermedadService.dart';
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

  EnfermedadService get service => GetIt.I<EnfermedadService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<Enfermedad>> res;

  final _saved = List<Enfermedad>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Enfermedades'), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              saveData();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReciepReport(data: data)),
              );
            },
          )
        ]),
        body: Builder(builder: (context) {
          if (_isLoading) {
            return LoadingScreen();
          }

          if (res.error ?? false) {
            return Center(child: Text(res.errorMessage));
          }

          return ListView.builder(
              itemCount: res.data.length,
              padding: EdgeInsets.all(16.0),
              itemBuilder: /*1*/ (context, i) {
                return _buildRow(res.data[i]);
              });
        }));
  }

  @override
  void initState() {
    data = widget.data;
    _fetchPlaga();
    super.initState();
  }

  _fetchPlaga() async {
    _showLoading();

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    var resp = await service.getListEnfermedad(authToken);

    setState(() {
      res = resp;
    });
    _hideLoading();
  }

  Widget _buildRow(Enfermedad plaga) {
    final alreadySaved = _saved.contains(plaga);
    return ListTile(
      title: Text(
        plaga.nombre,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(plaga);
          } else {
            _saved.add(plaga);
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
      data.enfermedad = _saved;
    });
  }
}
