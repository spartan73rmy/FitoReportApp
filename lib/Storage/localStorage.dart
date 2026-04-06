import 'dart:io';
import '../Models/reportData.dart';
import '../Models/enfermedad.dart';
import '../Models/etapaFenologica.dart';
import '../Models/plaga.dart';
import 'HiveService.dart';

class LocalStorage {
  final HiveService _hiveService = HiveService();

  Future<int> addReport(ReportData reporte) async {
    return await _hiveService.addReport(reporte);
  }

  Future<List<ReportData>> readReports() async {
    return _hiveService.getAllReports();
  }

  Future<List<ReportData>> readReportsImages() async {
    return await _hiveService.getAllReportsWithImages();
  }

  Future<List<ReportData>> deleteReport(int key) async {
    await _hiveService.deleteReport(key);
    return _hiveService.getAllReports();
  }

  Future<void> refreshReportes(List<ReportData> lista) async {
    await _hiveService.clearReportFile();
    for (var report in lista) {
      await _hiveService.reportBoxInstance.add(report);
    }
  }

  Future<void> clearReportFile() async {
    await _hiveService.clearReportFile();
  }

  Future<List<EtapaFenologica>> readEtapas() async {
    return _hiveService.getAllEtapas();
  }

  Future<void> refreshEtapas(List<EtapaFenologica> lista) async {
    await _hiveService.refreshEtapas(lista);
  }

  Future<void> clearEtapasFile() async {
    await _hiveService.clearEtapasFile();
  }

  Future<List<Plaga>> readPlagas() async {
    return _hiveService.getAllPlagas();
  }

  Future<void> refreshPlagas(List<Plaga> lista) async {
    await _hiveService.refreshPlagas(lista);
  }

  Future<void> clearPlagasFile() async {
    await _hiveService.clearPlagasFile();
  }

  Future<List<Enfermedad>> readEnfermedades() async {
    return _hiveService.getAllEnfermedades();
  }

  Future<void> refreshEnfermedades(List<Enfermedad> lista) async {
    await _hiveService.refreshEnfermedades(lista);
  }

  Future<void> clearEnfermedadesFile() async {
    await _hiveService.clearEnfermedadesFile();
  }

  Future<void> deleteImages(int id) async {
    await _hiveService.deleteImages(id);
  }

  Future<List<File>> readImages(int id) async {
    return await _hiveService.readImages(id);
  }

  Future<void> writeImages(List<File>? images, int id) async {
    await _hiveService.writeImages(images, id);
  }

  Future<Directory> imagesDir(int idReport) async {
    return await _hiveService.imagesDir(idReport);
  }

  Future<void> deleteAllImages() async {
    await _hiveService.deleteAllImages();
  }
}
