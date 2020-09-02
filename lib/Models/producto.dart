class Producto {
  int cantidad = 0;
  String nombre = '';
  String ingredienteActivo = '';
  String concentracion = '';
  String intervaloSeguridad = '';

  Producto(
      {this.nombre,
      this.cantidad,
      this.ingredienteActivo,
      this.concentracion,
      this.intervaloSeguridad});

  factory Producto.fromJSON(Map<String, dynamic> item) {
    return Producto(
      cantidad: item["cantidad"],
      nombre: item["nombre"],
      ingredienteActivo: item["ingredienteActivo"],
      concentracion: item["concentracion"],
      intervaloSeguridad: item["intervaloSeguridad"],
    );
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
