import 'package:LikeApp/Models/APIResponse.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:LikeApp/Services/PlagaService.dart';
import 'package:LikeApp/Services/UserService.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectPlaga extends StatefulWidget {
  final ReportData data;
  SelectPlaga(this.data);

  @override
  _SelectPlagaState createState() => _SelectPlagaState(data);
}

class _SelectPlagaState extends State<SelectPlaga> {
  final ReportData data;
  _SelectPlagaState(this.data);

  bool isLoading = false;
  double padValue = 0;
  PlagaService get service => GetIt.I<PlagaService>();
  UserService get auth => GetIt.I<UserService>();

  APIResponse<List<Plaga>> apiResponse;
  List<PlagaDTO> plagas;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  SharedPreferences _sharedPreferences;

  _fetchSessionAndNavigate() async {
    _sharedPreferences = await _prefs;
    // String authToken = Auth.getToken(_sharedPreferences);
    // // var id = _sharedPreferences..getString(Auth.userIdKey);
    // // var name = _sharedPreferences.getString(Auth.nameKey);

    // print(authToken);

    // setState(() {
    //   _authToken = authToken;
    //   // _id = id;
    //   // _name = name;
    // });

    // if (_authToken == null) {
    //   _logout();
    // }
  }

  // _logout() {
  //   UserService.logoutUser(context, _sharedPreferences);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
      body: Builder(builder: (_) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (apiResponse.error) {
          return Center(child: Text(apiResponse.errorMessage));
        }

        return ListView(
          children: List.generate(plagas.length, (index) {
            return ListTile(
              onTap: () {
                setState(() {
                  plagas[index].selected = !plagas[index].selected;
                });
              },
              selected: plagas[index].selected,
              leading: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {},
              ),
              title: Text(plagas[index].title),
              trailing: (plagas[index].selected)
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
            );
          }),
        );
      }),
    ));
  }

  @override
  void initState() {
    _fetchSessionAndNavigate();
    fetchPlaga();
    super.initState();
  }

  void fetchPlaga() {
    setState(() {
      isLoading = true;
    });

    setState(() async {
      apiResponse = await service
          .getListPlaga(Auth.getToken(_sharedPreferences))
          .whenComplete(() => apiResponse.data.forEach((element) {
                plagas.add(PlagaDTO.fromPlaga(element));
              }));
    });

    setState(() {
      isLoading = false;
    });
  }
}

class PlagaDTO {
  final int id;
  final String title;
  bool selected = false;

  PlagaDTO(this.id, this.title);

  factory PlagaDTO.fromPlaga(Plaga item) {
    return PlagaDTO(item.id, item.nombre);
  }
}
