class Producto {
  double cantidad = 0.0;
  String unidad = "";
  String nombre = '';
  String ingredienteActivo = '';
  String concentracion = '';
  String intervaloSeguridad = '';

  Producto(
      {this.nombre,
      this.cantidad,
      this.unidad,
      this.ingredienteActivo,
      this.concentracion,
      this.intervaloSeguridad});

  factory Producto.fromJSON(Map<String, dynamic> item) {
    return Producto(
      cantidad: item["cantidad"],
      unidad: item["unidad"],
      nombre: item["nombre"],
      ingredienteActivo: item["ingredienteActivo"],
      concentracion: item["concentracion"],
      intervaloSeguridad: item["intervaloSeguridad"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "cantidad": this.cantidad,
      "nombre": this.nombre,
      "ingredienteActivo": this.ingredienteActivo,
      "concentracion": this.concentracion,
      "intervaloSeguridad": this.intervaloSeguridad,
      "unidad": this.unidad
    };
  }
}

class ProductoList {
  List<Producto> productos;

  ProductoList({this.productos});

  factory ProductoList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['productos'] as List;
    List<Producto> productos = list.map((i) => Producto.fromJSON(i)).toList();

    return ProductoList(productos: productos);
  }
}
