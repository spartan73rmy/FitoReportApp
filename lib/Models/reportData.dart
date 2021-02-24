import 'dart:io';
import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/etapaFenologica.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/producto.dart';

class ReportData {
  int id;
  String lugar;
  String productor;
  double latitude;
  double longitud;
  String ubicacion;
  String predio;
  String cultivo;
  String observaciones;
  int litros;
  DateTime created;
  List<Enfermedad> enfermedad;
  List<Producto> producto;
  List<Plaga> plaga;
  List<EtapaFenologica> etapaFenologica;
  List<File> images;

  ReportData(
      {this.id,
      this.lugar,
      this.productor,
      this.latitude,
      this.longitud,
      this.ubicacion,
      this.predio,
      this.cultivo,
      this.etapaFenologica,
      this.observaciones,
      this.litros,
      this.enfermedad,
      this.producto,
      this.plaga,
      this.images,
      this.created});

  factory ReportData.fromJSON(Map<String, dynamic> item) {
    return ReportData(
        id: item["id"],
        lugar: item["lugar"],
        productor: item["productor"],
        latitude: item["latitude"],
        longitud: item["longitud"],
        ubicacion: item["ubicacion"],
        predio: item["predio"],
        cultivo: item["cultivo"],
        observaciones: item["observaciones"],
        litros: item["litros"],
        created: DateTime.parse(item["created"]).toUtc(),
        etapaFenologica: EtapaFList.fromJSON(item).etapas,
        enfermedad: EnfermedadList.fromJSON(item).enfermedades,
        plaga: PlagaList.fromJSON(item).plagas,
        producto: ProductoList.fromJSON(item).productos);
  }

  Map<String, dynamic> toJson() {
    List<Map> productos = this.producto != null
        ? this.producto.map((i) => i.toJson()).toList()
        : null;
    List<Map> enfermedad = this.enfermedad != null
        ? this.enfermedad.map((i) => i.toJson()).toList()
        : null;
    List<Map> plaga =
        this.plaga != null ? this.plaga.map((i) => i.toJson()).toList() : null;
    DateTime createdDate = created ?? DateTime.now();
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
  List<ReportData> reportes;

  ReportDataList({this.reportes});

  List<ReportData> toList(ReportDataList lista) {
    return lista.reportes;
  }

  Map<String, dynamic> toJson() {
    List<Map> reportes = this.reportes != null
        ? this.reportes.map((i) => i.toJson()).toList()
        : [];

    return {
      "reportes": reportes,
    };
  }

  factory ReportDataList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson["reportes"] as List;
    List<ReportData> lista = list.map((i) => ReportData.fromJSON(i)).toList();
    return ReportDataList(reportes: lista);
  }
}
