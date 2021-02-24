import 'dart:io';
import 'package:LikeApp/Login/Login.dart';
import 'package:LikeApp/Services/SyncData.dart';
import 'package:LikeApp/Services/auth.dart';
import 'package:LikeApp/Services/conectionService.dart';
import 'package:LikeApp/Services/enfermedadService.dart';
import 'package:LikeApp/Services/etapaFService.dart';
import 'package:LikeApp/Services/plagaService.dart';
import 'package:LikeApp/Services/reportService.dart';
import 'package:LikeApp/Services/userService.dart';
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
        primaryColor: Colors.teal,
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Login(_title),
    );
  }
}

void instanceGetIt() {
  GetIt.I.registerLazySingleton(() => UserService());
  GetIt.I.registerLazySingleton(() => Ping());
  GetIt.I.registerLazySingleton(() => ReportService());
  GetIt.I.registerLazySingleton(() => PlagaService());
  GetIt.I.registerLazySingleton(() => EtapaFService());
  GetIt.I.registerLazySingleton(() => EnfermedadService());
  GetIt.I.registerLazySingleton(() => Auth());
  GetIt.I.registerLazySingleton(() => SyncData());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
