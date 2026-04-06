import 'dart:io';
import 'Login/Login.dart';
import 'Services/syncData.dart';
import 'Services/auth.dart';
import 'Services/conectionService.dart';
import 'Services/enfermedadService.dart';
import 'Services/etapaFService.dart';
import 'Services/plagaService.dart';
import 'Services/reportService.dart';
import 'Services/UserService.dart';
import 'Storage/HiveService.dart';
import 'Storage/localStorage.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

String _title = "FitoReport";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await HiveService.init();
  instanceGetIt();

  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  GetIt.I.registerSingleton(LocalStorage());
  GetIt.I.registerSingleton(Ping());
  GetIt.I.registerSingleton(ReportService());
  GetIt.I.registerSingleton(UserService());
  GetIt.I.registerSingleton(PlagaService());
  GetIt.I.registerSingleton(EtapaFService());
  GetIt.I.registerSingleton(EnfermedadService());
  GetIt.I.registerSingleton(Auth());
  GetIt.I.registerSingleton(SyncData());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
