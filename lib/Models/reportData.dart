import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/producto.dart';

class ReportData {
  int id;
  String lugar;
  String productor;
  double coordX;
  double coordY;
  String ubicacion;
  String predio;
  String cultivo;
  String etapaFenologica;
  String observaciones;
  int litros;

  List<Enfermedad> enfermedad;
  List<Producto> producto;
  List<Plaga> plaga;

  ReportData(
      {this.id,
      this.lugar,
      this.productor,
      this.coordX,
      this.coordY,
      this.ubicacion,
      this.predio,
      this.cultivo,
      this.etapaFenologica,
      this.observaciones,
      this.litros,
      this.enfermedad,
      this.producto,
      this.plaga});

  factory ReportData.fromJSON(Map<String, dynamic> item) {
    return ReportData(
      id: item["id"],
      lugar: item["lugar"],
      productor: item["productor"],
      coordX: item["coordX"],
      coordY: item["coordY"],
      ubicacion: item["ubicacion"],
      predio: item["predio"],
      cultivo: item["cultivo"],
      etapaFenologica: item["etapaFenologica"],
      observaciones: item["observaciones"],
      litros: item["litros"],
    );
  }
}
