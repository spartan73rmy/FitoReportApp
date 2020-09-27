import 'package:LikeApp/CommonWidgets/loadingScreen.dart';
import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Report/selectEnfermedad.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/plagaService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPlaga extends StatefulWidget {
  final ReportData data;
  SelectPlaga({this.data});
  @override
  _SelectPlagaState createState() => _SelectPlagaState();
}

class _SelectPlagaState extends State<SelectPlaga> {
  ReportData data;
  bool _isLoading = true;

  PlagaService get service => GetIt.I<PlagaService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<Plaga>> res;

  final _saved = List<Plaga>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: UniqueKey(),
        appBar: AppBar(title: Text('Plagas'), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.navigate_next),
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
          if (_isLoading) {
            return LoadingScreen();
          }

          if (res.error ?? false) {
            return Center(child: Text(res.errorMessage));
          }

          return Container(
              child: ListView.builder(
                  itemCount: res.data.length,
                  padding: EdgeInsets.all(16.0),
                  itemBuilder: (context, i) {
                    return _buildRow(res.data[i]);
                  }));
        }));
  }

  @override
  void initState() {
    _fetchPlaga();
    data = widget.data;
    super.initState();
  }

  _fetchPlaga() async {
    _showLoading();

    _sharedPreferences = await _prefs;
    String authToken = Auth.getToken(_sharedPreferences);
    var resp = await service.getListPlaga(authToken);

    setState(() {
      res = resp;
    });
    _hideLoading();
  }

  Widget _buildRow(Plaga plaga) {
    final alreadySaved = _saved.contains(plaga);
    return ListTile(
      trailing: Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.red : null,
      ),
      title: Text(
        plaga.nombre,
        style: TextStyle(fontSize: 18.0),
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
      data.plaga = _saved;
    });
  }
}
