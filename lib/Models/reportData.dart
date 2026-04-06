import 'dart:io';
import 'package:hive/hive.dart';

part 'reportData.g.dart';

@HiveType(typeId: 4)
class ReportData extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? serverId;

  @HiveField(2)
  String? lugar;

  @HiveField(3)
  String? productor;

  @HiveField(4)
  double latitude;

  @HiveField(5)
  double longitud;

  @HiveField(6)
  String? ubicacion;

  @HiveField(7)
  String? predio;

  @HiveField(8)
  String? cultivo;

  @HiveField(9)
  String? observaciones;

  @HiveField(10)
  int litros;

  @HiveField(11)
  DateTime created;

  @HiveField(12)
  List<String> imagesHash;

  @HiveField(13)
  List<Map<String, dynamic>> enfermedadJson;

  @HiveField(14)
  List<Map<String, dynamic>> productoJson;

  @HiveField(15)
  List<Map<String, dynamic>> plagaJson;

  @HiveField(16)
  List<Map<String, dynamic>> etapaFenologicaJson;

  List<File>? images;

  ReportData({
    this.id,
    this.serverId,
    this.lugar,
    this.productor,
    this.latitude = 0,
    this.longitud = 0,
    this.ubicacion,
    this.predio,
    this.cultivo,
    this.observaciones,
    this.litros = 0,
    required this.created,
    this.imagesHash = const [],
    this.images,
    this.enfermedadJson = const [],
    this.productoJson = const [],
    this.plagaJson = const [],
    this.etapaFenologicaJson = const [],
  });

  factory ReportData.fromJSON(Map<String, dynamic> item) {
    final report = ReportData(
      serverId: item["id"],
      lugar: item["lugar"],
      productor: item["productor"],
      latitude: (item["latitude"] ?? 0).toDouble(),
      longitud: (item["longitud"] ?? 0).toDouble(),
      ubicacion: item["ubicacion"],
      predio: item["predio"],
      cultivo: item["cultivo"],
      observaciones: item["observaciones"],
      litros: item["litros"] ?? 0,
      created:
          DateTime.parse(item["created"] ?? DateTime.now().toIso8601String())
              .toUtc(),
      imagesHash: item['imagesHash'] != null
          ? List<String>.from(item['imagesHash'])
          : [],
    );

    report.etapaFenologicaJson = item['etapaFenologica'] != null
        ? List<Map<String, dynamic>>.from(item['etapaFenologica'])
        : [];
    report.enfermedadJson = item['enfermedades'] != null
        ? List<Map<String, dynamic>>.from(item['enfermedades'])
        : [];
    report.plagaJson = item['plagas'] != null
        ? List<Map<String, dynamic>>.from(item['plagas'])
        : [];
    report.productoJson = item['productos'] != null
        ? List<Map<String, dynamic>>.from(item['productos'])
        : [];

    return report;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": serverId,
      "lugar": lugar,
      "productor": productor,
      "latitude": latitude,
      "longitud": longitud,
      "ubicacion": ubicacion,
      "predio": predio,
      "cultivo": cultivo,
      "observaciones": observaciones,
      "litros": litros,
      "created": created.toIso8601String(),
      "imagesHash": imagesHash,
      "etapaFenologica": etapaFenologicaJson,
      "enfermedades": enfermedadJson,
      "plagas": plagaJson,
      "productos": productoJson,
    };
  }
}

class ReportDataList {
  List<ReportData>? reportes;

  ReportDataList({this.reportes});

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? reportes = this.reportes != null
        ? this.reportes!.map((i) => i.toJson()).toList()
        : [];

    return {
      "reportes": reportes,
    };
  }

  factory ReportDataList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson["reportes"] as List;
    List<ReportData> lista = list
        .map((i) => ReportData.fromJSON(i as Map<String, dynamic>))
        .toList();
    return ReportDataList(reportes: lista);
  }
}
