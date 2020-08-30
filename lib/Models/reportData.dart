import 'package:LikeApp/Models/enfermedad.dart';
import 'package:LikeApp/Models/plaga.dart';
import 'package:LikeApp/Models/product.dart';

class ReportData {
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
  List<Product> producto;
  List<Plaga> plaga;

  ReportData(
      {this.lugar,
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
}
