import 'dart:io';
import 'package:LikeApp/Login/Login.dart';
import 'package:LikeApp/Report/selectEnfermedad.dart';
import 'package:LikeApp/Services/Auth.dart';
import 'package:LikeApp/Services/EnfermedadService.dart';
import 'package:LikeApp/Services/PlagaService.dart';
import 'package:LikeApp/Services/UserService.dart';
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
      // home: HomePage(title: _title),
      home: Login(_title),
      // home: SelectEnfermedad(),
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
