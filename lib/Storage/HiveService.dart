import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../Models/reportData.dart';
import '../Models/enfermedad.dart';
import '../Models/etapaFenologica.dart';
import '../Models/plaga.dart';
import '../Models/producto.dart';

class HiveService {
  static const String reportBox = 'reports';
  static const String enfermedadBox = 'enfermedades';
  static const String etapaBox = 'etapas';
  static const String plagaBox = 'plagas';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(ReportDataAdapter());
    Hive.registerAdapter(EnfermedadAdapter());
    Hive.registerAdapter(EtapaFenologicaAdapter());
    Hive.registerAdapter(PlagaAdapter());
    Hive.registerAdapter(ProductoAdapter());

    await Hive.openBox<ReportData>(reportBox);
    await Hive.openBox<Enfermedad>(enfermedadBox);
    await Hive.openBox<EtapaFenologica>(etapaBox);
    await Hive.openBox<Plaga>(plagaBox);
  }

  Box<ReportData> get reportBoxInstance => Hive.box<ReportData>(reportBox);
  Box<Enfermedad> get enfermedadBoxInstance =>
      Hive.box<Enfermedad>(enfermedadBox);
  Box<EtapaFenologica> get etapaBoxInstance =>
      Hive.box<EtapaFenologica>(etapaBox);
  Box<Plaga> get plagaBoxInstance => Hive.box<Plaga>(plagaBox);

  Future<int> addReport(ReportData reporte) async {
    await writeImages(reporte.images, reporte.id ?? 0);
    final key = await reportBoxInstance.add(reporte);
    reporte.id = key;
    await reporte.save();
    return key;
  }

  List<ReportData> getAllReports() {
    final reports = reportBoxInstance.values.toList();
    for (var report in reports) {
      report.id = report.key;
    }
    return reports;
  }

  Future<List<ReportData>> getAllReportsWithImages() async {
    final reports = reportBoxInstance.values.toList();
    for (var report in reports) {
      report.images = await readImages(report.key);
    }
    return reports;
  }

  Future<void> updateReports(List<ReportData> lista) async {
    await reportBoxInstance.clear();
    for (var report in lista) {
      await reportBoxInstance.add(report);
    }
  }

  Future<void> deleteReport(int key) async {
    await deleteImages(key);
    await reportBoxInstance.delete(key);
  }

  List<EtapaFenologica> getAllEtapas() {
    return etapaBoxInstance.values.toList();
  }

  Future<void> refreshEtapas(List<EtapaFenologica> lista) async {
    await etapaBoxInstance.clear();
    for (var etapa in lista) {
      await etapaBoxInstance.add(etapa);
    }
  }

  List<Plaga> getAllPlagas() {
    return plagaBoxInstance.values.toList();
  }

  Future<void> refreshPlagas(List<Plaga> lista) async {
    await plagaBoxInstance.clear();
    for (var plaga in lista) {
      await plagaBoxInstance.add(plaga);
    }
  }

  List<Enfermedad> getAllEnfermedades() {
    return enfermedadBoxInstance.values.toList();
  }

  Future<void> refreshEnfermedades(List<Enfermedad> lista) async {
    await enfermedadBoxInstance.clear();
    for (var enfermedad in lista) {
      await enfermedadBoxInstance.add(enfermedad);
    }
  }

  Future<void> writeImages(List<File>? images, int id) async {
    if (images == null) return;
    String route = (await imagesDir(id)).path;
    for (int i = 0; i < images.length; i++) {
      String newPath = path.join(route, '$i.jpg');
      print(newPath);
      await File(images[i].path).copy(newPath);
    }
  }

  Future<List<File>> readImages(int id) async {
    var filesList = <File>[];
    Directory dir = await imagesDir(id);
    dir.listSync(recursive: true).forEach((element) {
      if (element is File) {
        filesList.add(element);
      }
    });
    return filesList;
  }

  Future<Directory> imagesDir(int idReport) async {
    final dir = await getApplicationDocumentsDirectory();
    Directory imagesDir = Directory('${dir.path}/images/$idReport/');
    bool exist = await imagesDir.exists();
    print(exist);
    if (!exist) {
      imagesDir = await imagesDir.create(recursive: true);
    }
    return imagesDir;
  }

  Future<void> deleteImages(int id) async {
    Directory dir = await imagesDir(id);
    if (dir.existsSync()) await dir.delete(recursive: true);
    print('Imagenes en $id eliminadas');
  }

  Future<void> deleteAllImages() async {
    final dir = await getApplicationDocumentsDirectory();
    Directory dirImages = Directory('${dir.path}/images/');
    if (dirImages.existsSync()) await dirImages.delete(recursive: true);
    print('All images are deleted');
  }

  Future<void> clearReportFile() async {
    await reportBoxInstance.clear();
  }

  Future<void> clearEtapasFile() async {
    await etapaBoxInstance.clear();
  }

  Future<void> clearPlagasFile() async {
    await plagaBoxInstance.clear();
  }

  Future<void> clearEnfermedadesFile() async {
    await enfermedadBoxInstance.clear();
  }
}
