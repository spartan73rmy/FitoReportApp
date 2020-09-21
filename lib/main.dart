import 'dart:io';
import 'package:LikeApp/Login/Login.dart';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/reportData.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/enfermedadService.dart';
import 'package:LikeApp/Services/plagaService.dart';
import 'package:LikeApp/Services/userService.dart';
import 'package:LikeApp/Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

String _title = "FitoReport";

void main() {
  instanceGetIt();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(_title),
    );
  }
}

void instanceGetIt() {
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => PlagaService());
  GetIt.I.registerLazySingleton(() => EnfermedadService());
  GetIt.I.registerLazySingleton(() => Auth());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
