import 'dart:io';
import 'enfermedad.dart';
import 'etapaFenologica.dart';
import 'plaga.dart';
import 'producto.dart';

class ReportData {
  int? id;
  String? lugar;
  String? productor;
  double latitude = 0;
  double longitud = 0;
  String? ubicacion;
  String? predio;
  String? cultivo;
  String? observaciones;
  int litros = 0;
  DateTime created = DateTime.now();
  List<Enfermedad>? enfermedad;
  List<Producto>? producto;
  List<Plaga>? plaga;
  List<EtapaFenologica>? etapaFenologica;
  List<File>? images;
  List<String>? imagesHash;

  ReportData(
      {this.id,
      this.lugar,
      this.productor,
      this.latitude = 0,
      this.longitud = 0,
      this.ubicacion,
      this.predio,
      this.cultivo,
      this.etapaFenologica,
      this.observaciones,
      this.litros = 0,
      this.enfermedad,
      this.producto,
      this.plaga,
      this.images,
      required this.created,
      this.imagesHash});

  factory ReportData.fromJSON(Map<String, dynamic> item) {
    return ReportData(
        id: item["id"],
        lugar: item["lugar"],
        productor: item["productor"],
        latitude: (item["latitude"] ?? 0).toDouble(),
        longitud: (item["longitud"] ?? 0).toDouble(),
        ubicacion: item["ubicacion"],
        predio: item["predio"],
        cultivo: item["cultivo"],
        observaciones: item["observaciones"],
        litros: item["litros"] ?? 0,
        created: DateTime.parse(item["created"] ?? DateTime.now().toIso8601String()).toUtc(),
        imagesHash: item['imagesHash'] != null
            ? List<String>.from(item['imagesHash'])
            : null,
        etapaFenologica: EtapaFList.fromJSON(item).etapas,
        enfermedad: EnfermedadList.fromJSON(item).enfermedades,
        plaga: PlagaList.fromJSON(item).plagas,
        producto: ProductoList.fromJSON(item).productos);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? productos = this.producto != null
        ? this.producto!.map((i) => i.toJson()).toList()
        : null;
    List<Map<String, dynamic>>? enfermedad = this.enfermedad != null
        ? this.enfermedad!.map((i) => i.toJson()).toList()
        : null;
    List<Map<String, dynamic>>? plaga =
        this.plaga != null ? this.plaga!.map((i) => i.toJson()).toList() : null;
    DateTime createdDate = created;
    return {
      "id": id,
      "lugar": lugar,
      "productor": productor,
      "latitude": latitude,
      "longitud": longitud,
      "ubicacion": ubicacion,
      "predio": predio,
      "cultivo": cultivo,
      "observaciones": observaciones,
      "litros": litros,
      "created": createdDate.toIso8601String(),
      "etapaFenologica": etapaFenologica,
      "enfermedades": enfermedad,
      "plagas": plaga,
      "productos": productos,
    };
  }
}

class ReportDataList {
  List<ReportData>? reportes;

  ReportDataList({this.reportes});

  List<ReportData> toList(ReportDataList lista) {
    return lista.reportes ?? [];
  }

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
    List<ReportData> lista = list.map((i) => ReportData.fromJSON(i as Map<String, dynamic>)).toList();
    return ReportDataList(reportes: lista);
  }
}
