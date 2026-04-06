import 'package:hive/hive.dart';

part 'producto.g.dart';

@HiveType(typeId: 3)
class Producto extends HiveObject {
  @HiveField(0)
  double cantidad = 0.0;

  @HiveField(1)
  String unidad = "";

  @HiveField(2)
  String nombre = '';

  @HiveField(3)
  String ingredienteActivo = '';

  @HiveField(4)
  String concentracion = '';

  @HiveField(5)
  String intervaloSeguridad = '';

  Producto({
    this.nombre = '',
    this.cantidad = 0.0,
    this.unidad = '',
    this.ingredienteActivo = '',
    this.concentracion = '',
    this.intervaloSeguridad = '',
  });

  factory Producto.fromJSON(Map<String, dynamic> item) {
    return Producto(
      cantidad: (item["cantidad"] ?? 0).toDouble(),
      unidad: item["unidad"] ?? '',
      nombre: item["nombre"] ?? '',
      ingredienteActivo: item["ingredienteActivo"] ?? '',
      concentracion: item["concentracion"] ?? '',
      intervaloSeguridad: item["intervaloSeguridad"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "cantidad": cantidad,
      "nombre": nombre,
      "ingredienteActivo": ingredienteActivo,
      "concentracion": concentracion,
      "intervaloSeguridad": intervaloSeguridad,
      "unidad": unidad
    };
  }
}
