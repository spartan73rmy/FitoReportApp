import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:LikeApp/Services/PlagaService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPlaga extends StatefulWidget {
  // final ReportData data;
  // SelectPlaga(this.data);

  @override
  _SelectPlagaState createState() => _SelectPlagaState();
}

class _SelectPlagaState extends State<SelectPlaga> {
  bool _isLoading = true;
  double padValue = 0;
  bool isVisible = true;

  PlagaService get service => GetIt.I<PlagaService>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  APIResponse<List<Plaga>> res;

  final _saved = <Plaga>{};

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Plagas')),
            body: Builder(builder: (context) {
              if (_isLoading) {
                return Center(child: CircularProgressIndicator());
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
            })));
  }

  @override
  void initState() {
    _fetchPlaga();
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

  // #docregion _buildRow
  Widget _buildRow(Plaga plaga) {
    final alreadySaved = _saved.contains(plaga);
    return ListTile(
      title: Text(
        plaga.nombre,
        style: TextStyle(fontSize: 18.0),
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
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
  // #enddocregion _buildRow

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
